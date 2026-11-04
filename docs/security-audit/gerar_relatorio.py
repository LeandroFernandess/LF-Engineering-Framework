#!/usr/bin/env python3
"""Inspect a local project and render a dynamic, preliminary security report.

By default, the current working directory is inspected and the PDF at
``<project>/docs/security-audit/relatorio-auditoria-seguranca.pdf`` is replaced.
The scanner reads files only: it does not execute project code, use the network,
change permissions, or remove evidence. Results are indicators for human review,
not a complete QA-Security audit or a security approval.

Usage:
    python3 /path/to/LF-Engineering-Framework/docs/security-audit/gerar_relatorio.py
    python3 /path/to/LF-Engineering-Framework/docs/security-audit/gerar_relatorio.py --project /path/to/project
    python3 /path/to/LF-Engineering-Framework/docs/security-audit/gerar_relatorio.py --project . --output report.pdf
"""

from __future__ import annotations

import argparse
import os
import re
import stat
import textwrap
from collections import Counter
from dataclasses import dataclass, field
from datetime import datetime
from pathlib import Path
from typing import Iterable


PAGE_WIDTH = 595.28
PAGE_HEIGHT = 841.89
LEFT = 48.0
RIGHT = 48.0
TOP = 56.0
BOTTOM = 54.0
CONTENT_WIDTH = PAGE_WIDTH - LEFT - RIGHT
DEFAULT_OUTPUT = Path("docs/security-audit/relatorio-auditoria-seguranca.pdf")

NAVY = (0.09, 0.20, 0.30)
BLUE = (0.11, 0.44, 0.65)
TEAL = (0.11, 0.54, 0.56)
ORANGE = (0.77, 0.48, 0.10)
RED = (0.70, 0.29, 0.24)
GRAY = (0.36, 0.40, 0.44)
DARK = (0.13, 0.15, 0.17)
LIGHT_GRAY = (0.95, 0.96, 0.97)
GRID = (0.81, 0.84, 0.86)

SKIPPED_DIRECTORIES = {
    ".git",
    ".hg",
    ".svn",
    ".venv",
    "venv",
    "node_modules",
    "vendor",
    "dist",
    "build",
    "target",
    "coverage",
    "__pycache__",
    ".pytest_cache",
    ".mypy_cache",
    ".ruff_cache",
    ".tox",
    ".next",
    ".nuxt",
    ".terraform",
    ".gradle",
}

SOURCE_EXTENSIONS = {
    ".c", ".cc", ".cpp", ".cs", ".go", ".h", ".hpp", ".java", ".js",
    ".jsx", ".kt", ".php", ".py", ".rb", ".rs", ".scala", ".sh", ".swift",
    ".ts", ".tsx", ".vue", ".svelte", ".ps1", ".sql",
}
DOCUMENTATION_EXTENSIONS = {".md", ".mdx", ".rst", ".adoc", ".txt"}
WEB_EXTENSIONS = {
    ".html", ".htm", ".css", ".scss", ".sass", ".less", ".js", ".jsx",
    ".ts", ".tsx", ".vue", ".svelte", ".php", ".erb", ".ejs", ".hbs",
}
MANIFEST_NAMES = {
    "package.json", "pyproject.toml", "requirements.txt", "Pipfile", "poetry.lock",
    "go.mod", "Cargo.toml", "pom.xml", "build.gradle", "build.gradle.kts",
    "Gemfile", "composer.json", "*.csproj", "*.sln",
}
CONFIG_NAMES = {
    "Dockerfile", "docker-compose.yml", "docker-compose.yaml", "compose.yml",
    "compose.yaml", "Makefile", "Jenkinsfile", "Procfile", "vercel.json",
    "netlify.toml", "serverless.yml", "serverless.yaml",
}
AI_ENTRY_NAMES = {
    "AGENTS.md", "CLAUDE.md", "GEMINI.md", "COPILOT_INSTRUCTIONS.md",
}
STATE_DIRECTORY_NAMES = {
    ".ai/state", "workflow-graph", "logs", "log", "memories", "snapshots",
    "cache", "caches", "tmp", "temp",
}
SENSITIVE_FILE_NAMES = {
    ".env", ".env.local", ".npmrc", ".pypirc", "id_rsa", "id_ed25519",
    "credentials", "credentials.json",
}
SENSITIVE_SUFFIXES = {".pem", ".key", ".p12", ".pfx", ".sqlite", ".sqlite3", ".db"}
EXAMPLE_SUFFIXES = (".example", ".sample", ".template", ".dist")
BINARY_SUFFIXES = {
    ".7z", ".bmp", ".class", ".dll", ".doc", ".docx", ".dylib", ".exe",
    ".gif", ".gz", ".ico", ".jar", ".jpeg", ".jpg", ".mp3", ".mp4",
    ".o", ".pdf", ".png", ".pyc", ".so", ".tar", ".wasm", ".webp", ".zip",
}

SECRET_PATTERNS = (
    (
        "SEC-SIG-01",
        "Private-key block marker",
        re.compile(r"-----BEGIN (?:RSA |EC |OPENSSH |DSA )?PRIVATE KEY-----"),
        "Alta",
        "A private-key marker is present in a readable project file.",
        "Remove the private key from the project, rotate it if it may have been exposed, and use an approved secret store.",
    ),
    (
        "SEC-SIG-02",
        "Cloud access-key identifier pattern",
        re.compile(r"\b(?:AKIA|ASIA)[0-9A-Z]{16}\b"),
        "Média",
        "A string matches a common cloud access-key identifier shape; validity was not tested.",
        "Confirm whether the value is real. If real or uncertain, revoke/rotate it and remove it from tracked files and history.",
    ),
    (
        "SEC-SIG-03",
        "GitHub token pattern",
        re.compile(r"\b(?:gh[pousr]_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,})\b"),
        "Alta",
        "A string matches a GitHub token format; validity and privileges were not tested.",
        "Verify the value without copying it into the report. Revoke/rotate it if real, then review repository history and access scope.",
    ),
)


def _redact_sensitive_text(value: str) -> str:
    redacted = value
    for _rule_id, _title, pattern, _severity, _impact, _recommendation in SECRET_PATTERNS:
        redacted = pattern.sub("[REDACTED]", redacted)
    return re.sub(
        r"-----BEGIN (?:RSA |EC |OPENSSH |DSA )?PRIVATE KEY-----",
        "[REDACTED PRIVATE KEY MARKER]",
        redacted,
    )


@dataclass(frozen=True)
class Finding:
    rule_id: str
    severity: str
    category: str
    title: str
    confidence: str
    path: str
    line: int | None
    impact: str
    recommendation: str


@dataclass
class Inspection:
    root: Path
    generated_at: str
    total_files: int = 0
    source_files: int = 0
    web_files: int = 0
    text_files_scanned: int = 0
    binary_files_skipped: int = 0
    unreadable_files: int = 0
    symlinks_skipped: int = 0
    output_files_skipped: int = 0
    directories_skipped: Counter[str] = field(default_factory=Counter)
    extensions: Counter[str] = field(default_factory=Counter)
    manifests: list[str] = field(default_factory=list)
    documentation_markers: list[str] = field(default_factory=list)
    configurations: list[str] = field(default_factory=list)
    ai_markers: list[str] = field(default_factory=list)
    web_markers: list[str] = field(default_factory=list)
    backend_markers: list[str] = field(default_factory=list)
    state_files: list[tuple[str, str, int]] = field(default_factory=list)
    findings: list[Finding] = field(default_factory=list)
    _finding_keys: set[tuple[str, str, int | None]] = field(default_factory=set)

    @property
    def project_name(self) -> str:
        return _redact_sensitive_text(self.root.name or self.root.anchor or "project")


def _is_example_file(name: str) -> bool:
    lowered = name.lower()
    return any(lowered.endswith(suffix) for suffix in EXAMPLE_SUFFIXES)


def _is_manifest(name: str) -> bool:
    if name in MANIFEST_NAMES:
        return True
    return any(pattern.startswith("*") and name.endswith(pattern[1:]) for pattern in MANIFEST_NAMES)


def _is_state_candidate(relative: Path) -> bool:
    lowered_parts = [part.lower() for part in relative.parts]
    normalized = "/".join(lowered_parts)
    name = relative.name.lower()
    if _is_example_file(name):
        return False
    if (
        name in SENSITIVE_FILE_NAMES
        or (name.startswith(".env.") and not _is_example_file(name))
        or relative.suffix.lower() in SENSITIVE_SUFFIXES
    ):
        return True
    if relative.suffix.lower() == ".log":
        return True
    return any(
        normalized == candidate or normalized.startswith(candidate + "/")
        for candidate in STATE_DIRECTORY_NAMES
    )


def _add_finding(inspection: Inspection, finding: Finding) -> None:
    key = (finding.rule_id, finding.path, finding.line)
    if key not in inspection._finding_keys:
        inspection._finding_keys.add(key)
        inspection.findings.append(finding)


def _safe_output_path(project_root: Path, output_arg: Path | None) -> Path:
    output = DEFAULT_OUTPUT if output_arg is None else output_arg
    if not output.is_absolute():
        output = project_root / output
    output = Path(os.path.abspath(output))

    probe = output
    while True:
        if probe.is_symlink():
            raise ValueError(f"Refusing to write through a symlink: {probe}")
        parent = probe.parent
        if parent == probe:
            break
        probe = parent
    return output


def inspect_project(project_path: Path, output_path: Path) -> Inspection:
    root = project_path.expanduser().resolve(strict=True)
    if not root.is_dir():
        raise ValueError(f"Project path is not a directory: {project_path}")

    output_key = os.path.normcase(os.path.abspath(output_path))
    inspection = Inspection(root=root, generated_at=datetime.now().astimezone().isoformat(timespec="seconds"))

    def on_walk_error(_error: OSError) -> None:
        inspection.unreadable_files += 1

    for current, directory_names, file_names in os.walk(root, topdown=True, followlinks=False, onerror=on_walk_error):
        current_path = Path(current)
        kept_directories: list[str] = []
        for directory_name in sorted(directory_names):
            directory_path = current_path / directory_name
            if directory_name in SKIPPED_DIRECTORIES:
                inspection.directories_skipped[directory_name] += 1
            elif directory_path.is_symlink():
                inspection.symlinks_skipped += 1
            else:
                kept_directories.append(directory_name)
        directory_names[:] = kept_directories

        for file_name in sorted(file_names):
            path = current_path / file_name
            relative = path.relative_to(root)
            relative_text = relative.as_posix()
            display_path = _redact_sensitive_text(relative_text)
            if os.path.normcase(os.path.abspath(path)) == output_key:
                inspection.output_files_skipped += 1
                continue
            try:
                file_stat = path.lstat()
            except OSError:
                inspection.unreadable_files += 1
                continue
            if stat.S_ISLNK(file_stat.st_mode):
                inspection.symlinks_skipped += 1
                continue
            if not stat.S_ISREG(file_stat.st_mode):
                continue

            inspection.total_files += 1
            suffix = path.suffix.lower() or "(no extension)"
            inspection.extensions[suffix] += 1
            if suffix in SOURCE_EXTENSIONS:
                inspection.source_files += 1
            if suffix in WEB_EXTENSIONS:
                inspection.web_files += 1
                if len(inspection.web_markers) < 20:
                    inspection.web_markers.append(display_path)
            if _is_manifest(file_name) and len(inspection.manifests) < 50:
                inspection.manifests.append(display_path)
            lower_name = file_name.lower()
            is_named_document = (
                lower_name.startswith("readme")
                or Path(lower_name).stem in {
                    "brief", "project_brief", "prd", "architecture", "sprints",
                    "security", "testing", "contributing", "overview", "roadmap",
                    "changelog", "adr", "design", "requirements", "tech_debt_audit",
                }
            )
            is_in_docs_directory = any(part.lower() in {"docs", "documentation"} for part in relative.parts[:-1])
            if (
                path.suffix.lower() in DOCUMENTATION_EXTENSIONS
                and (is_named_document or is_in_docs_directory)
                and len(inspection.documentation_markers) < 100
            ):
                inspection.documentation_markers.append(display_path)
            if file_name in CONFIG_NAMES or ".github/workflows" in relative_text:
                if len(inspection.configurations) < 50:
                    inspection.configurations.append(display_path)
            if file_name in AI_ENTRY_NAMES or ".opencode/" in relative_text or relative_text.startswith(".opencode/"):
                if len(inspection.ai_markers) < 50:
                    inspection.ai_markers.append(display_path)
            if any(part.lower() in {"api", "routes", "route", "controllers", "controller", "handlers", "server"} for part in relative.parts):
                if len(inspection.backend_markers) < 20:
                    inspection.backend_markers.append(display_path)

            if _is_state_candidate(relative):
                mode = stat.S_IMODE(file_stat.st_mode)
                inspection.state_files.append((display_path, f"{mode:04o}" if os.name != "nt" else "não confiável no Windows", file_stat.st_size))
                if os.name != "nt" and mode & 0o077:
                    _add_finding(
                        inspection,
                        Finding(
                            rule_id="SEC-STATE-01",
                            severity="Média",
                            category="Segredos e estado local",
                            title="Arquivo candidato a estado sensível acessível a grupo/outros",
                            confidence="Alta para o modo observado; sensibilidade do conteúdo depende do contexto",
                            path=display_path,
                            line=None,
                            impact=f"O candidato tem modo {mode:04o}; dados locais podem ser legíveis por outros usuários do host.",
                            recommendation="Confirmar se o arquivo contém dados sensíveis e, se aplicável, restringir acesso (por exemplo, modo 0600), definir retenção e revisar publicação/backups. O inspetor não altera permissões.",
                        ),
                    )

            if suffix in BINARY_SUFFIXES:
                inspection.binary_files_skipped += 1
                continue
            try:
                with path.open("rb") as file_handle:
                    prefix = file_handle.read(8192)
                if b"\0" in prefix:
                    inspection.binary_files_skipped += 1
                    continue
                inspection.text_files_scanned += 1
                with path.open("r", encoding="utf-8", errors="replace") as file_handle:
                    for line_number, line in enumerate(file_handle, start=1):
                        for rule_id, title, pattern, severity, impact, recommendation in SECRET_PATTERNS:
                            if pattern.search(line):
                                _add_finding(
                                    inspection,
                                    Finding(
                                        rule_id=rule_id,
                                        severity=severity,
                                        category="Segredos e dados sensíveis",
                                        title=title,
                                        confidence="Alta para correspondência de formato; validade do segredo não verificada",
                                        path=display_path,
                                        line=line_number,
                                        impact=impact,
                                        recommendation=recommendation,
                                    ),
                                )
            except (OSError, UnicodeError):
                inspection.unreadable_files += 1

    inspection.findings.sort(key=lambda item: (item.severity, item.path, item.line or 0, item.rule_id))
    return inspection


def _surface_status(present: bool, surface: str) -> tuple[str, str]:
    if present:
        return "Não verificado", f"Foram detectados indicadores de {surface}; a análise automatizada não valida o fluxo de dados."
    return "Não aplicável (heurístico)", f"Nenhum indicador de {surface} foi detectado no inventário; isso não prova ausência da superfície."


def applicability_matrix(inspection: Inspection) -> list[tuple[str, str, str]]:
    has_source = inspection.source_files > 0
    has_web = inspection.web_files > 0
    has_backend = bool(inspection.backend_markers)
    has_config = bool(inspection.configurations or inspection.manifests)
    has_ai = bool(inspection.ai_markers)
    has_code_or_automation = has_source or has_config
    has_secret_finding = any(item.category == "Segredos e dados sensíveis" for item in inspection.findings)

    injection_status, injection_evidence = _surface_status(has_source, "código-fonte")
    web_status, web_evidence = _surface_status(has_web, "interface web/HTML")
    auth_status, auth_evidence = _surface_status(has_backend, "rotas/handlers de backend")
    config_status, config_evidence = _surface_status(has_config, "manifestos ou configuração/deploy")
    ai_status, ai_evidence = _surface_status(has_ai, "instruções/adapters de workflow de IA")
    effects_status, effects_evidence = _surface_status(has_code_or_automation, "código ou automação")

    return [
        ("Injeção SQL/comandos", injection_status, injection_evidence),
        ("XSS/HTML", web_status, web_evidence),
        ("Autenticação/autorização/IDOR", auth_status, auth_evidence),
        (
            "Segredos/dados sensíveis",
            "Achado potencial" if has_secret_finding else "Não verificado",
            "Há correspondências de formato para revisão." if has_secret_finding else "Nenhuma assinatura de alta confiança encontrada; a busca é limitada e não prova ausência de segredos.",
        ),
        ("Deploy/configuração", config_status, config_evidence),
        ("Workflows de IA/uso de ferramentas", ai_status, ai_evidence),
        ("Efeitos externos", effects_status, effects_evidence),
    ]


def pdf_string(value: str) -> bytes:
    raw = value.replace("\r", " ").replace("\n", " ").encode("cp1252", errors="replace")
    escaped = raw.replace(b"\\", b"\\\\").replace(b"(", b"\\(").replace(b")", b"\\)")
    return b"(" + escaped + b")"


def _color(value: tuple[float, float, float]) -> str:
    return " ".join(f"{channel:.3f}" for channel in value)


class Page:
    def __init__(self) -> None:
        self.commands: list[bytes] = []

    def text(self, x: float, y_top: float, value: str, size: float, font: str, color: tuple[float, float, float]) -> None:
        baseline = PAGE_HEIGHT - y_top - size * 0.82
        command = (
            b"BT /" + font.encode() + b" " + f"{size:.2f}".encode() + b" Tf "
            + _color(color).encode() + b" rg 1 0 0 1 " + f"{x:.2f}".encode() + b" "
            + f"{baseline:.2f}".encode() + b" Tm " + pdf_string(value) + b" Tj ET\n"
        )
        self.commands.append(command)

    def line(self, x1: float, y1_top: float, x2: float, y2_top: float, color: tuple[float, float, float] = GRID) -> None:
        self.commands.append(
            f"q {_color(color)} RG 0.5 w {x1:.2f} {PAGE_HEIGHT-y1_top:.2f} m {x2:.2f} {PAGE_HEIGHT-y2_top:.2f} l S Q\n".encode()
        )

    def stream(self, page_number: int, total_pages: int, date_label: str) -> bytes:
        self.line(LEFT, 34, PAGE_WIDTH - RIGHT, 34)
        self.text(LEFT, 17, "INSPEÇÃO DE SEGURANÇA DO PROJETO", 7.4, "F2", NAVY)
        self.line(LEFT, PAGE_HEIGHT - 40, PAGE_WIDTH - RIGHT, PAGE_HEIGHT - 40)
        self.text(LEFT, PAGE_HEIGHT - 31, f"Gerado dinamicamente | {date_label}", 7.2, "F1", GRAY)
        self.text(PAGE_WIDTH - RIGHT - 55, PAGE_HEIGHT - 31, f"Página {page_number}/{total_pages}", 7.2, "F1", GRAY)
        return b"".join(self.commands)


class Document:
    def __init__(self, date_label: str) -> None:
        self.pages = [Page()]
        self.cursor = TOP
        self.date_label = date_label

    @property
    def page(self) -> Page:
        return self.pages[-1]

    def page_break(self) -> None:
        self.pages.append(Page())
        self.cursor = TOP

    def _ensure(self, height: float) -> None:
        if self.cursor + height > PAGE_HEIGHT - BOTTOM:
            self.page_break()

    def paragraph(self, text: str, size: float = 9.0, leading: float = 12.0, color: tuple[float, float, float] = DARK, indent: float = 0.0) -> None:
        width_chars = max(30, int((CONTENT_WIDTH - indent) / (size * 0.53)))
        lines: list[str] = []
        for paragraph in text.split("\n"):
            lines.extend(textwrap.wrap(paragraph, width=width_chars, break_long_words=True, break_on_hyphens=False) or [""])
        for line in lines:
            self._ensure(leading)
            self.page.text(LEFT + indent, self.cursor, line, size, "F1", color)
            self.cursor += leading
        self.cursor += 3.0

    def heading(self, text: str, level: int = 1) -> None:
        size, leading, before, after = (16.0, 20.0, 5.0, 6.0) if level == 1 else (11.5, 15.0, 6.0, 4.0)
        self._ensure(before + leading + after)
        self.cursor += before
        self.page.text(LEFT, self.cursor, text, size, "F2", NAVY if level == 1 else DARK)
        self.cursor += leading + after

    def bullet(self, text: str) -> None:
        self.paragraph("• " + text, size=8.6, leading=11.2, indent=5.0)

    def label(self, label: str, value: str) -> None:
        self.paragraph(f"{label}: {value}", size=8.6, leading=11.2)


class PDFWriter:
    def __init__(self, document: Document) -> None:
        self.document = document
        self.objects: list[bytes | None] = []

    def add(self, value: bytes | None) -> int:
        self.objects.append(value)
        return len(self.objects)

    def set(self, object_id: int, value: bytes) -> None:
        self.objects[object_id - 1] = value

    def stream_object(self, content: bytes) -> bytes:
        return b"<< /Length " + str(len(content)).encode() + b" >>\nstream\n" + content + b"\nendstream"

    def write(self, output: Path) -> None:
        catalog_id = self.add(None)
        pages_id = self.add(None)
        font_regular = self.add(b"<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica /Encoding /WinAnsiEncoding >>")
        font_bold = self.add(b"<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica-Bold /Encoding /WinAnsiEncoding >>")
        page_ids: list[int] = []
        total = len(self.document.pages)
        for number_page, page in enumerate(self.document.pages, start=1):
            content_id = self.add(self.stream_object(page.stream(number_page, total, self.document.date_label)))
            page_id = self.add(
                (
                    f"<< /Type /Page /Parent {pages_id} 0 R /MediaBox [0 0 {PAGE_WIDTH:.2f} {PAGE_HEIGHT:.2f}] "
                    f"/Resources << /Font << /F1 {font_regular} 0 R /F2 {font_bold} 0 R >> >> "
                    f"/Contents {content_id} 0 R >>"
                ).encode()
            )
            page_ids.append(page_id)
        self.set(pages_id, ("<< /Type /Pages /Kids [" + " ".join(f"{item} 0 R" for item in page_ids) + f"] /Count {total} >>").encode())
        self.set(catalog_id, f"<< /Type /Catalog /Pages {pages_id} 0 R >>".encode())
        info_id = self.add(b"<< /Title (Inspecao dinamica de seguranca) /Author (LF Engineering System) /Subject (Inspecao estatica local; requer revisao humana) >>")
        output.parent.mkdir(parents=True, exist_ok=True)
        if output.is_symlink():
            raise ValueError(f"Refusing to overwrite a symlink: {output}")
        with output.open("wb") as handle:
            handle.write(b"%PDF-1.4\n%\xe2\xe3\xcf\xd3\n")
            offsets = [0]
            for object_id, value in enumerate(self.objects, start=1):
                assert value is not None
                offsets.append(handle.tell())
                handle.write(f"{object_id} 0 obj\n".encode())
                handle.write(value)
                handle.write(b"\nendobj\n")
            xref = handle.tell()
            handle.write(f"xref\n0 {len(self.objects) + 1}\n".encode())
            handle.write(b"0000000000 65535 f \n")
            for offset in offsets[1:]:
                handle.write(f"{offset:010d} 00000 n \n".encode())
            handle.write(f"trailer\n<< /Size {len(self.objects) + 1} /Root {catalog_id} 0 R /Info {info_id} 0 R >>\nstartxref\n{xref}\n%%EOF\n".encode())


def _short_list(values: Iterable[str], limit: int = 12) -> str:
    items = list(values)
    if not items:
        return "Nenhum indicador encontrado."
    shown = ", ".join(items[:limit])
    extra = len(items) - limit
    return shown + (f" e mais {extra}" if extra > 0 else "")


def build_document(inspection: Inspection) -> Document:
    date_label = inspection.generated_at[:10]
    document = Document(date_label)
    document.heading("Relatório dinâmico de inspeção de segurança", 1)
    document.paragraph("Inspeção estática preliminar. Este PDF é regenerado a cada execução e substitui o relatório no caminho de saída escolhido.")
    document.heading("1. Status e identificação", 1)
    document.label("Status geral", "Revisão humana necessária; este inspetor não aprova nem reprova o projeto")
    document.label("Projeto", inspection.project_name)
    document.label("Raiz", "caminho absoluto omitido; evidências usam caminhos relativos")
    document.label("Gerado em", inspection.generated_at)
    document.label("Arquivos regulares inventariados", str(inspection.total_files))
    document.label("Arquivos-fonte por extensão", ", ".join(f"{key}: {value}" for key, value in sorted(inspection.extensions.items()) if key in SOURCE_EXTENSIONS) or "nenhum detectado")

    document.heading("2. Escopo e método", 1)
    for item in [
        "O inspetor lê arquivos locais e produz evidências de inventário e padrões de alta confiança; não executa código, testes do projeto ou comandos dentro do projeto.",
        "Não usa rede, não instala dependências, não altera permissões e não remove arquivos. O PDF de saída é sobrescrito em cada execução.",
        "Diretórios comuns de dependências/build e links simbólicos não são percorridos. Arquivos binários são ignorados; arquivos não legíveis são contados como não verificados.",
        "Segredos detectados são reportados somente por tipo, caminho e linha; o valor correspondente nunca é copiado para o relatório.",
        "A varredura não examina histórico Git, validade de credenciais, fluxo de dados, autorização real, execução dinâmica, dependências vulneráveis ou comportamento em produção.",
    ]:
        document.bullet(item)
    document.label("Arquivos de texto lidos", str(inspection.text_files_scanned))
    document.label("Arquivos binários ignorados", str(inspection.binary_files_skipped))
    document.label("Links simbólicos ignorados", str(inspection.symlinks_skipped))
    document.label("Arquivos/diretórios não legíveis", str(inspection.unreadable_files))
    document.label("Arquivo de saída excluído do scan", str(inspection.output_files_skipped))
    document.label("Diretórios ignorados", ", ".join(f"{key}: {value}" for key, value in sorted(inspection.directories_skipped.items())[:20]) or "nenhum")

    document.heading("3. Perfil observado do projeto", 1)
    document.label("Manifestos", _short_list(inspection.manifests))
    document.label("Documentação", _short_list(inspection.documentation_markers))
    document.label("Configuração/CI/deploy", _short_list(inspection.configurations))
    document.label("Indicadores de interface web", _short_list(inspection.web_markers))
    document.label("Indicadores de backend", _short_list(inspection.backend_markers))
    document.label("Indicadores de workflow de IA", _short_list(inspection.ai_markers))
    document.label("Arquivos candidatos a estado local", str(len(inspection.state_files)))
    for path, mode, size in inspection.state_files[:30]:
        document.bullet(f"{path} — modo {mode}, {size} bytes")
    if len(inspection.state_files) > 30:
        document.paragraph(f"Mais {len(inspection.state_files) - 30} arquivos candidatos estão inventariados, mas não listados individualmente nesta seção.")

    document.heading("4. Matriz de aplicabilidade de segurança", 1)
    document.paragraph("A aplicabilidade é inferida por indicadores de nomes/extensões; um resultado heurístico não substitui a leitura do projeto.")
    for category, status, evidence in applicability_matrix(inspection):
        document.label(category, status)
        document.paragraph(evidence, size=8.0, leading=10.0, color=GRAY, indent=10.0)

    document.heading("5. Categorias de QA-Security", 1)
    for category, status, rationale in [
        ("Performance", "Não verificado", "O inventário pode detectar arquivos web, mas não mede rotas, build de produção, mobile/desktop, Core Web Vitals ou orçamento."),
        ("Observabilidade", "Não verificado", "Logs e configurações podem ser inventariados; qualidade, cobertura e exposição de dados exigem revisão."),
        ("Código/manutenibilidade", "Não verificado", "A contagem de extensões não avalia arquitetura, correção, complexidade ou requisitos."),
        (
            "Documentação",
            "Indicadores inventariados" if inspection.documentation_markers else "Não localizado (heurístico)",
            _short_list(inspection.documentation_markers),
        ),
        ("Acessibilidade", "Não verificado", "Testes de teclado, foco, contraste, zoom, reflow e tecnologia assistiva não são executados."),
        ("Boas práticas", "Não verificado", "O inspetor não declara conformidade com SOLID, DRY, KISS, YAGNI ou Clean Architecture."),
    ]:
        document.label(category, status)
        document.paragraph(rationale, size=8.2, leading=10.5, indent=8.0)

    document.heading("6. Problemas encontrados", 1)
    if not inspection.findings:
        document.paragraph("Nenhum padrão de alta confiança ou problema de permissão foi detectado pelas verificações implementadas. Isso não significa ausência de vulnerabilidades; várias categorias permanecem não verificadas.")
    for index, finding in enumerate(inspection.findings, start=1):
        document.heading(f"{finding.rule_id}-{index:03d} — {finding.title}", 2)
        document.label("Severidade", finding.severity)
        document.label("Categoria", finding.category)
        document.label("Confiança", finding.confidence)
        document.label("Evidência", f"{finding.path}" + (f":{finding.line}" if finding.line is not None else ""))
        document.paragraph(f"Impacto: {finding.impact}")
        document.paragraph(f"Recomendação: {finding.recommendation}")
        document.paragraph("O inspetor não valida exploração, validade de credenciais ou impacto real; confirme com revisão humana.", size=8.0, leading=10.0, color=GRAY)

    document.heading("7. Limitações e checklist final", 1)
    for item in [
        "[ ] QA-Security revisou o escopo, as categorias e os indicadores de aplicabilidade.",
        "[ ] Cada achado potencial foi confirmado ou rejeitado com evidência do projeto.",
        "[ ] Segredos, permissões e estado local foram revisados sem copiar valores sensíveis para o relatório.",
        "[ ] Fluxos de autenticação/autorização, efeitos externos e workflows de IA foram testados quando aplicáveis.",
        "[ ] Interfaces foram validadas manualmente e com evidências mobile/desktop quando aplicável.",
        "[ ] Nenhum arquivo foi removido ou alterado automaticamente pelo inspetor.",
    ]:
        document.bullet(item)
    document.paragraph("Conclusão: este relatório é uma coleta dinâmica e limitada de evidências locais. A decisão técnica final pertence ao QA-Security e ao responsável pelo projeto.")
    return document


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--project", type=Path, default=Path.cwd(), help="Projeto a inspecionar (padrão: diretório atual).")
    parser.add_argument("--output", type=Path, default=None, help="PDF de saída. Caminho relativo é resolvido dentro do projeto; padrão sobrescreve docs/security-audit/relatorio-auditoria-seguranca.pdf.")
    args = parser.parse_args()

    project_root = args.project.expanduser().resolve(strict=True)
    output_path = _safe_output_path(project_root, args.output)
    inspection = inspect_project(project_root, output_path)
    PDFWriter(build_document(inspection)).write(output_path)
    print(f"Projeto inspecionado: {inspection.project_name}")
    print(f"Arquivos inventariados: {inspection.total_files}; achados potenciais: {len(inspection.findings)}")
    print(f"PDF gerado (sobrescrito se já existia): {output_path}")
    print("Aviso: inspeção estática preliminar; revisão humana QA-Security necessária.")


if __name__ == "__main__":
    main()
