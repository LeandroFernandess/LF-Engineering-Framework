"""Behavior tests; Python is a maintainer/CI dependency, never a setup dependency."""

import os
import hashlib
import json
import re
from pathlib import Path
import shutil
import signal
import subprocess
import sys
import tempfile
import time
import unittest
import zipfile

ROOT = Path(__file__).resolve().parents[2]
PERSONAL_PATH = re.compile(r"(?:/Users/|/home/)[^/\s`]+/|\b[A-Za-z]:[\\/](?:Users|Documents and Settings)[\\/][^\\/\s`]+[\\/]", re.IGNORECASE)


class BootstrapSafety(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="lf-setup-tests-")
        self.base = Path(self.temp.name)
        self.framework = self.base / "framework"
        self.framework.mkdir()
        for name in ("PROJECT_TEMPLATE", "locales", "adapters", "scripts", "project-skills"):
            shutil.copytree(
                ROOT / name,
                self.framework / name,
                ignore=shutil.ignore_patterns("__pycache__"),
            )
        for name in ("START_PROJECTS.en-US.md", "FIRST_PROMPT_TEMPLATE.md", "GET_STARTED.md"):
            shutil.copy2(ROOT / name, self.framework / name)
        self.target = self.base / "ação project"

    def tearDown(self):
        self.temp.cleanup()

    def run_backend(
        self, backend, target=None, language="pt-BR", adapter="codex", apply=True
    ):
        target = target or self.target
        script = self.framework / "scripts" / ("bootstrap." + backend)
        if backend == "sh":
            args = [
                "sh",
                str(script),
                "--target",
                str(target),
                "--language",
                language,
            ]
            if adapter is not None:
                args.extend(["--adapter", adapter])
            args.append("--apply" if apply else "--dry-run")
        else:
            args = [
                "pwsh",
                "-NoLogo",
                "-NoProfile",
                "-File",
                str(script),
                "-TargetPath",
                str(target),
                "-Language",
                language,
            ]
            if adapter is not None:
                args.extend(["-Adapter", adapter])
            args.append("-Apply" if apply else "-DryRun")
        return subprocess.run(
            args, cwd=self.base, text=True, capture_output=True, timeout=30
        )

    def backends(self):
        return (["sh"] if os.name != "nt" else []) + (
            ["ps1"] if shutil.which("pwsh") else []
        )

    def test_invalid_target_leaves_no_directory(self):
        for backend in self.backends():
            for target in (
                self.framework / "forbidden",
                self.base / "missing" / ".." / "framework" / "forbidden",
            ):
                with self.subTest(backend=backend, target=target):
                    result = self.run_backend(backend, target)
                    self.assertNotEqual(result.returncode, 0, result.stdout)
                    self.assertFalse((self.framework / "forbidden").exists())
                    self.assertFalse((self.base / "missing").exists())

    def test_missing_adapter_is_detected_before_writing(self):
        (self.framework / "adapters/opencode/opencode.jsonc").unlink()
        for backend in self.backends():
            result = self.run_backend(backend, adapter="opencode")
            self.assertNotEqual(result.returncode, 0)
            self.assertFalse(self.target.exists())

    def test_missing_adapter_placeholder_fails_before_writes(self):
        (self.framework / "adapters/opencode/opencode.jsonc").write_text("{}")
        for backend in self.backends():
            result = self.run_backend(backend, adapter="opencode")
            self.assertNotEqual(result.returncode, 0)
            self.assertFalse(self.target.exists())

    @unittest.skipIf(
        os.name == "nt", "Quotes are not valid Windows filename characters"
    )
    def test_quoted_framework_path_does_not_leak_into_portable_docs(self):
        import json

        new_path = self.base / 'framework "quoted"'
        self.framework.rename(new_path)
        self.framework = new_path
        for backend in self.backends():
            target = self.base / backend
            result = self.run_backend(backend, target=target, adapter="opencode")
            self.assertEqual(result.returncode, 0, result.stderr)
            config_text = (target / "opencode.jsonc").read_text(encoding="utf-8")
            config = json.loads(config_text)
            self.assertNotIn(str(new_path), config_text)
            self.assertNotIn("__LF_ENGINEERING_SYSTEM_REF__", config_text)
            self.assertEqual(
                config["references"]["lf-engineering-framework"]["repository"],
                "LeandroFernandess/LF-Engineering-Framework",
            )
            self.assertEqual(
                config["references"]["lf-engineering-framework"]["branch"], "main"
            )
            self.assertIn("agents/Engineering-Manager/SPECS.md", config_text)
            self.assertIn("workflows/NEW_PROJECT.md", config_text)
            self.assertIn("workflows/STANDARD_DEVELOPMENT.md", config_text)
            self.assertNotIn("/.opencode/", config_text)
            for document in target.rglob("*.md"):
                content = document.read_text(encoding="utf-8")
                self.assertNotIn(str(new_path), content, document)
                self.assertNotIn("file://", content, document)

    def test_missing_locale_is_detected_before_writing(self):
        shutil.rmtree(self.framework / "locales/pt-BR/PROJECT_TEMPLATE")
        for backend in self.backends():
            result = self.run_backend(backend)
            self.assertNotEqual(result.returncode, 0)
            self.assertFalse(self.target.exists())

    def test_existing_parent_file_fails_before_other_files_are_added(self):
        self.target.mkdir()
        (self.target / ".ai").write_text("owned by project")
        for backend in self.backends():
            result = self.run_backend(backend)
            self.assertNotEqual(result.returncode, 0)
            self.assertEqual(list(self.target.iterdir()), [self.target / ".ai"])

    def test_project_context_has_no_machine_path_placeholder(self):
        for template in (
            ROOT / "PROJECT_TEMPLATE/LF_ENGINEERING.md",
            ROOT / "locales/pt-BR/PROJECT_TEMPLATE/LF_ENGINEERING.md",
        ):
            with self.subTest(template=template):
                content = template.read_text(encoding="utf-8")
                self.assertNotIn("__LF_ENGINEERING_SYSTEM_PATH__", content)
                self.assertNotRegex(content, PERSONAL_PATH)

    def test_personal_path_detection_covers_common_platforms(self):
        for path in ("/Users/example/project", "/home/example/project", r"C:\Users\example\project"):
            with self.subTest(path=path):
                self.assertRegex(path, PERSONAL_PATH)
        self.assertNotRegex("https://example.org/docs/PROJECT_TEMPLATE", PERSONAL_PATH)

    def test_invalid_framework_manifest_version_fails_before_writes(self):
        (self.framework / "framework-manifest.json").write_text(
            '{"framework_version":"../../outside"}\n', encoding="utf-8"
        )
        for backend in self.backends():
            result = self.run_backend(backend)
            self.assertNotEqual(result.returncode, 0, result.stdout)
            self.assertFalse(self.target.exists())

    def test_adapter_is_required_and_generic_is_rejected_before_writes(self):
        for backend in self.backends():
            for adapter in (None, "generic"):
                with self.subTest(backend=backend, adapter=adapter):
                    target = self.base / (backend + str(adapter) + " target")
                    result = self.run_backend(
                        backend, target=target, adapter=adapter, apply=False
                    )
                    self.assertNotEqual(result.returncode, 0, result.stdout)
                    self.assertFalse(target.exists())

    def test_prd_template_sections_have_bilingual_dividers(self):
        english = (ROOT / "PROJECT_TEMPLATE/docs/PRD.md").read_text(encoding="utf-8")
        portuguese = (
            ROOT / "locales/pt-BR/PROJECT_TEMPLATE/docs/PRD.md"
        ).read_text(encoding="utf-8")
        for document in (english, portuguese):
            lines = document.splitlines()
            headings = [i for i, line in enumerate(lines) if line.startswith("## ")]
            self.assertGreater(len(headings), 1)
            self.assertEqual(
                sum(line == "---" for line in lines), len(headings) - 1
            )
            for heading_index in headings[1:]:
                self.assertEqual(lines[heading_index - 2], "---")
                self.assertEqual(lines[heading_index - 1], "")
        self.assertEqual(english.count("## "), portuguese.count("## "))

    def test_language_adapters_preview_and_repeat_preserve_content(self):
        for backend in self.backends():
            for language in ("en-US", "pt-BR"):
                for adapter in ("codex", "claude", "gemini", "opencode"):
                    with self.subTest(
                        backend=backend, language=language, adapter=adapter
                    ):
                        target = self.base / (backend + language + adapter + " ação")
                        result = self.run_backend(
                            backend, target, language, adapter, apply=False
                        )
                        self.assertEqual(result.returncode, 0, result.stderr)
                        self.assertFalse(target.exists())
                        additions = [
                            x
                            for x in result.stdout.splitlines()
                            if x.startswith("ADD ")
                        ]
                        self.assertEqual(len(additions), len(set(additions)))
                        expected_skill_root = ".claude/skills" if adapter == "claude" else ".agents/skills"
                        for guide in ("START_PROJECTS.md", "FIRST_PROMPT_TEMPLATE.md"):
                            self.assertIn("ADD " + guide, additions)
                        for skill in (
                            "lf-project-onboarding",
                            "lf-project-planning",
                            "lf-approved-implementation",
                            "lf-delivery-review",
                        ):
                            self.assertIn(
                                "ADD " + expected_skill_root + "/" + skill + "/SKILL.md",
                                additions,
                            )
                        result = self.run_backend(backend, target, language, adapter)
                        self.assertEqual(result.returncode, 0, result.stderr)
                        record = (target / ".ai/framework-installation.md").read_text(
                            encoding="utf-8"
                        )
                        self.assertIn("- Language: " + language, record)
                        self.assertIn(
                            "Instalação" if language == "pt-BR" else "Installation",
                            record,
                        )
                        self.assertIn(
                            "- Framework source: https://github.com/LeandroFernandess/LF-Engineering-Framework/tree/main",
                            record,
                        )
                        self.assertNotIn("Framework path:", record)
                        self.assertNotIn(str(self.framework), record)
                        required_project_files = (
                            "AGENTS.md",
                            "LF_ENGINEERING.md",
                            "README.md",
                            ".ai/workflow.md",
                            ".ai/handoff.md",
                            ".ai/decisions.md",
                            ".ai/tasks.md",
                            ".ai/artifacts.md",
                            ".ai/state/current-phase.md",
                            ".ai/state/current-agent.md",
                            ".ai/state/project-summary.md",
                            ".ai/state/next-actions.md",
                            ".ai/state/risks.md",
                            "docs/PRD.md",
                            "docs/ARCHITECTURE.md",
                            "docs/SPRINTS.md",
                            "docs/ADR.md",
                        )
                        for required in required_project_files:
                            self.assertTrue((target / required).is_file(), required)
                        for conditional in (
                            "PROJECT_BRIEF.md",
                            "docs/DESIGN.md",
                            "docs/PERFORMANCE_VALIDATION_REPORT.md",
                            "docs/TECH_DEBT_AUDIT.md",
                        ):
                            self.assertFalse((target / conditional).exists(), conditional)
                        guide = (target / "START_PROJECTS.md").read_text(encoding="utf-8")
                        prompt = (target / "FIRST_PROMPT_TEMPLATE.md").read_text(encoding="utf-8")
                        self.assertIn("FIRST_PROMPT_TEMPLATE.md)", guide)
                        self.assertIn("https://github.com/LeandroFernandess/LF-Engineering-Framework/blob/main/", guide)
                        self.assertIn("https://github.com/LeandroFernandess/LF-Engineering-Framework/blob/main/", prompt)
                        self.assertNotIn("file://", guide)
                        self.assertNotIn("file://", prompt)
                        self.assertNotIn(str(self.framework), guide)
                        self.assertNotIn(str(self.framework), prompt)
                        self.assertFalse((target / "GET_STARTED.md").exists())
                        for directory in ("agents", "knowledge", "workflows", "protocols", "schemas"):
                            self.assertFalse((target / directory).exists(), directory)
                        skill_files = sorted((target / expected_skill_root).rglob("SKILL.md"))
                        self.assertEqual(len(skill_files), 4)
                        self.assertFalse((target / "project-skills").exists())
                        localized_skills = [path.read_text(encoding="utf-8") for path in skill_files]
                        self.assertEqual(
                            {path.parent.name for path in skill_files},
                            {
                                "lf-project-onboarding",
                                "lf-project-planning",
                                "lf-approved-implementation",
                                "lf-delivery-review",
                            },
                        )
                        for skill_file, content in zip(skill_files, localized_skills):
                            skill_lines = content.splitlines()
                            self.assertEqual(skill_lines[0], "---", skill_file)
                            metadata_end = skill_lines.index("---", 1)
                            metadata = skill_lines[1:metadata_end]
                            self.assertIn(
                                "name: " + skill_file.parent.name,
                                metadata,
                                skill_file,
                            )
                            descriptions = [
                                line.partition(":")[2].strip()
                                for line in metadata
                                if line.startswith("description:")
                            ]
                            self.assertEqual(len(descriptions), 1, skill_file)
                            self.assertTrue(descriptions[0], skill_file)
                            self.assertTrue("\n".join(skill_lines[metadata_end + 1 :]).strip(), skill_file)
                        expected_titles = (
                            [
                                "# LF Approved Implementation",
                                "# LF Delivery Review",
                                "# LF Project Onboarding",
                                "# LF Project Planning",
                            ]
                            if language == "en-US"
                            else [
                                "# Implementação aprovada LF",
                                "# Revisão de entrega LF",
                                "# Integração inicial de projeto LF",
                                "# Planejamento de projeto LF",
                            ]
                        )
                        self.assertEqual(
                            [content.splitlines()[5] for content in localized_skills],
                            expected_titles,
                        )
                        before = {
                            p.relative_to(target): p.read_bytes()
                            for p in target.rglob("*")
                            if p.is_file()
                        }
                        result = self.run_backend(backend, target, language, adapter)
                        self.assertEqual(result.returncode, 0, result.stderr)
                        self.assertFalse(
                            any(line.startswith("ADD ") for line in result.stdout.splitlines()),
                            result.stdout,
                        )
                        self.assertEqual(
                            before,
                            {
                                p.relative_to(target): p.read_bytes()
                                for p in target.rglob("*")
                                if p.is_file()
                            },
                        )

    def test_project_guide_links_use_public_framework_urls_not_local_paths(self):
        framework_with_spaces = self.base / "framework with spaces"
        self.framework.rename(framework_with_spaces)
        self.framework = framework_with_spaces
        for backend in self.backends():
            for language in ("en-US", "pt-BR"):
                target = self.base / (backend + " guide " + language)
                result = self.run_backend(
                    backend, target=target, language=language, adapter="codex"
                )
                self.assertEqual(result.returncode, 0, result.stderr)
                guide = (target / "START_PROJECTS.md").read_text(encoding="utf-8")
                prompt = (target / "FIRST_PROMPT_TEMPLATE.md").read_text(encoding="utf-8")
                self.assertIn("https://github.com/LeandroFernandess/LF-Engineering-Framework/blob/main/", guide)
                self.assertIn("https://github.com/LeandroFernandess/LF-Engineering-Framework/blob/main/", prompt)
                self.assertNotIn("file://", guide)
                self.assertNotIn("file://", prompt)
                self.assertNotIn(str(framework_with_spaces), guide)
                self.assertNotIn(str(framework_with_spaces), prompt)
                self.assertIn("](FIRST_PROMPT_TEMPLATE.md)", guide)
                self.assertNotIn("](GET_STARTED.md)", guide)
                self.assertNotIn("](GET_STARTED.md)", prompt)
                self.assertNotIn("../../../START_PROJECTS.en-US.md)", guide)
                self.assertNotIn("../../../FIRST_PROMPT_TEMPLATE.md)", prompt)

    def test_manifest_version_pins_document_and_opencode_references(self):
        manifest_version = "v9.8.7"
        (self.framework / "framework-manifest.json").write_text(
            json.dumps(
                {
                    "framework_version": manifest_version,
                    "target_platform": "linux",
                    "language": "pt-BR",
                },
                indent=2,
            )
            + "\n",
            encoding="utf-8",
        )
        for backend in self.backends():
            target = self.base / (backend + " pinned reference")
            result = self.run_backend(
                backend, target=target, language="pt-BR", adapter="opencode"
            )
            self.assertEqual(result.returncode, 0, result.stderr)
            record = (target / ".ai/framework-installation.md").read_text(encoding="utf-8")
            guide = (target / "START_PROJECTS.md").read_text(encoding="utf-8")
            config = json.loads((target / "opencode.jsonc").read_text(encoding="utf-8"))
            self.assertIn(f"/tree/{manifest_version}", record)
            self.assertIn(f"/blob/{manifest_version}/", guide)
            self.assertEqual(
                config["references"]["lf-engineering-framework"]["branch"],
                manifest_version,
            )
            permission_entries = {
                (item["action"], item["resource"], item["effect"])
                for item in config["permissions"]
            }
            resource = "*/repos/github.com/LeandroFernandess/LF-Engineering-Framework/*"
            self.assertTrue(
                {
                    ("external_directory", resource, "allow"),
                    ("read", resource, "allow"),
                    ("edit", resource, "deny"),
                }.issubset(permission_entries)
            )

    def test_existing_project_guides_and_skill_files_are_preserved(self):
        for backend in self.backends():
            for adapter, skill_root in (
                ("codex", ".agents/skills"),
                ("claude", ".claude/skills"),
            ):
                target = self.base / (backend + " preserved " + adapter)
                skill_path = target / skill_root / "lf-project-onboarding/SKILL.md"
                skill_path.parent.mkdir(parents=True)
                (target / "START_PROJECTS.md").write_text("project guide\n", encoding="utf-8")
                (target / "FIRST_PROMPT_TEMPLATE.md").write_text("project prompt\n", encoding="utf-8")
                skill_path.write_text("project skill\n", encoding="utf-8")
                result = self.run_backend(
                    backend, target=target, language="pt-BR", adapter=adapter, apply=False
                )
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertIn("PRESERVE START_PROJECTS.md", result.stdout)
                self.assertIn("PRESERVE FIRST_PROMPT_TEMPLATE.md", result.stdout)
                normalized_skill_path = str(skill_path.relative_to(target)).replace("\\", "/")
                self.assertIn("PRESERVE " + normalized_skill_path, result.stdout.replace("\\", "/"))
                result = self.run_backend(
                    backend, target=target, language="pt-BR", adapter=adapter
                )
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertEqual((target / "START_PROJECTS.md").read_text(encoding="utf-8"), "project guide\n")
                self.assertEqual((target / "FIRST_PROMPT_TEMPLATE.md").read_text(encoding="utf-8"), "project prompt\n")
                self.assertEqual(skill_path.read_text(encoding="utf-8"), "project skill\n")


class Assistant(unittest.TestCase):
    def run_pty_session(self, command, steps, directory, env, timeout=30, columns=None):
        import fcntl
        import pty
        import select
        import struct
        import termios

        master, slave = pty.openpty()
        if columns is not None:
            fcntl.ioctl(
                slave,
                termios.TIOCSWINSZ,
                struct.pack("HHHH", 24, columns, 0, 0),
            )
        process = subprocess.Popen(
            command,
            stdin=slave,
            stdout=slave,
            stderr=slave,
            cwd=directory,
            env=env,
            start_new_session=True,
        )
        os.close(slave)
        output = b""
        cursor = 0
        pending = list(steps)
        deadline = time.monotonic() + timeout
        try:
            while time.monotonic() < deadline:
                if select.select([master], [], [], 0.1)[0]:
                    try:
                        chunk = os.read(master, 65536)
                    except OSError:
                        break
                    if not chunk:
                        break
                    output += chunk
                while True:
                    query = output.find(b"\x1b[6n", cursor)
                    if query < 0:
                        break
                    cursor = query + len(b"\x1b[6n")
                    os.write(master, b"\x1b[1;1R")
                while pending:
                    needle, answer = pending[0]
                    position = output.find(needle.encode(), cursor)
                    if position < 0:
                        break
                    cursor = position + len(needle.encode())
                    pending.pop(0)
                    if answer is None:
                        os.write(master, b"\x04")
                    else:
                        os.write(master, (answer + "\n").encode())
                if process.poll() is not None:
                    break
            self.assertFalse(pending, output.decode(errors="replace"))
            return_code = process.wait(timeout=3)
            return return_code, output
        finally:
            if process.poll() is None:
                os.killpg(process.pid, signal.SIGTERM)
                process.wait()
            os.close(master)

    def test_help_shows_creator_contact(self):
        commands = []
        if os.name != "nt":
            commands.append(["sh", str(ROOT / "setup.sh"), "--help"])
        if shutil.which("pwsh"):
            commands.append(
                [
                    "pwsh",
                    "-NoLogo",
                    "-NoProfile",
                    "-File",
                    str(ROOT / "setup.ps1"),
                    "-Help",
                ]
            )
        for command in commands:
            with self.subTest(command=command[0]):
                result = subprocess.run(
                    command,
                    text=True,
                    capture_output=True,
                    cwd=tempfile.gettempdir(),
                    timeout=15,
                )
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertIn("Leandro Fernandes", result.stdout)
                self.assertIn("leandrofernandes1600@gmail.com", result.stdout)
                self.assertIn("github.com/LeandroFernandess", result.stdout)
                self.assertIn(
                    "linkedin.com/in/leandro-fernandes-951ab3189", result.stdout
                )

    def test_redirected_input_is_rejected_without_prompt(self):
        commands = []
        if os.name != "nt":
            commands.append(["sh", str(ROOT / "setup.sh")])
        if shutil.which("pwsh"):
            commands.append(
                ["pwsh", "-NoLogo", "-NoProfile", "-File", str(ROOT / "setup.ps1")]
            )
        for cmd in commands:
            result = subprocess.run(
                cmd,
                input="",
                text=True,
                capture_output=True,
                cwd=tempfile.gettempdir(),
                timeout=15,
            )
            self.assertNotEqual(result.returncode, 0)
            self.assertRegex(
                (result.stdout + result.stderr).lower(), r"interactive|interativo"
            )

    @unittest.skipIf(
        os.name == "nt", "POSIX PTY test; native Windows backend tests run separately"
    )
    def test_terminal_sessions(self):
        import pty
        import select

        commands = [
            (["sh", str(ROOT / "setup.sh"), "--no-animation", "--no-color"], False),
            (["sh", str(ROOT / "setup.sh"), "--no-color"], True),
        ]
        if shutil.which("pwsh"):
            commands.append(
                (
                    [
                        "pwsh",
                        "-NoLogo",
                        "-NoProfile",
                        "-File",
                        str(ROOT / "setup.ps1"),
                        "-NoAnimation",
                        "-NoColor",
                    ],
                    False,
                )
            )
            commands.append(
                (
                    [
                        "pwsh",
                        "-NoLogo",
                        "-NoProfile",
                        "-File",
                        str(ROOT / "setup.ps1"),
                        "-NoColor",
                    ],
                    True,
                )
            )
        for command, animated in commands:
            for language, confirm in [("2", "n"), ("1", "y"), ("2", "s")]:
                with self.subTest(
                    command=command[0], language=language, confirm=confirm
                ), tempfile.TemporaryDirectory() as directory:
                    target = Path(directory) / "ação project"
                    if confirm == "s":
                        (target / ".ai").mkdir(parents=True)
                        (target / ".ai/framework-installation.md").write_text(
                            "- Language: en-US\n- Adapter: codex\n"
                        )
                    master, slave = pty.openpty()
                    env = dict(
                        os.environ,
                        TERM="xterm-256color" if animated else "dumb",
                        COLUMNS="80",
                        NO_COLOR="1",
                    )
                    env.pop("CI", None)
                    process = subprocess.Popen(
                        command,
                        stdin=slave,
                        stdout=slave,
                        stderr=slave,
                        cwd=directory,
                        env=env,
                        start_new_session=True,
                    )
                    os.close(slave)
                    output = b""
                    steps = [
                        ("Select operating system:", ""),
                        ("Select language:", language),
                        (
                            (
                                "Diretório do projeto"
                                if language == "2"
                                else "Project directory"
                            ),
                            str(target),
                        ),
                        (
                            (
                                "Escolha uma integração:"
                                if language == "2"
                                else "Choose an integration:"
                            ),
                            "",
                        ),
                        (
                            (
                                "Escolha uma integração:"
                                if language == "2"
                                else "Choose an integration:"
                            ),
                            "4",
                        ),
                        ("[s/N]" if language == "2" else "[y/N]", confirm),
                    ]
                    deadline = time.monotonic() + 30
                    try:
                        while time.monotonic() < deadline:
                            ready, _, _ = select.select([master], [], [], 0.1)
                            if ready:
                                try:
                                    chunk = os.read(master, 65536)
                                except OSError:
                                    break
                                if not chunk:
                                    break
                                output += chunk
                                if steps and steps[0][0].encode() in output:
                                    _, answer = steps.pop(0)
                                    os.write(master, (answer + "\n").encode())
                            if process.poll() is not None:
                                break
                        self.assertFalse(steps, output.decode(errors="replace"))
                        self.assertEqual(
                            process.wait(timeout=3), 0, output.decode(errors="replace")
                        )
                        self.assertNotIn(b"Leandro Fernandes", output)
                        self.assertIn(b"leandrofernandes1600@gmail.com", output)
                        self.assertIn(b"github.com/LeandroFernandess", output)
                        self.assertIn(
                            b"linkedin.com/in/leandro-fernandes-951ab3189", output
                        )
                        normalized_output = output.decode(errors="replace").replace(
                            "\r\n", "\n"
                        )
                        self.assertEqual(normalized_output.count("LF ENGINEERING FRAMEWORK"), 1)
                        self.assertNotRegex(normalized_output, r"Leandro Fernandes")
                        self.assertIn(
                            "C:/Users/name/Projects/app or ./my-project"
                            if language == "1"
                            else "C:/Users/nome/Projetos/app ou ./meu-projeto",
                            normalized_output,
                        )
                        self.assertIn(
                            ">>> b: back <<<"
                            if language == "1"
                            else ">>> b: voltar <<<",
                            normalized_output,
                        )
                        self.assertIn(">>> b) Back <<<", normalized_output)
                        self.assertIn("✓ System:", normalized_output)
                        self.assertIn(
                            "Select operating system:\n  1) macOS\n  2) Linux\n  3) Windows",
                            normalized_output,
                        )
                        self.assertIn(
                            "STATE" if language == "1" else "ESTADO",
                            normalized_output,
                        )
                        self.assertIn(
                            "PATH" if language == "1" else "CAMINHO",
                            normalized_output,
                        )
                        self.assertIn(
                            "Summary:" if language == "1" else "Resumo:",
                            normalized_output,
                        )
                        self.assertIn(
                            "Language: en-US" if language == "1" else "Idioma: pt-BR",
                            normalized_output,
                        )
                        self.assertIn(
                            "Choose an integration:\n  1) Codex\n  2) Claude\n  3) Gemini\n  4) OpenCode"
                            if language == "1"
                            else "Escolha uma integração:\n  1) Codex\n  2) Claude\n  3) Gemini\n  4) OpenCode",
                            normalized_output,
                        )
                        self.assertNotIn("Generic", normalized_output)
                        self.assertNotIn("Genérica", normalized_output)
                        self.assertIn(
                            "selection is required"
                            if language == "1"
                            else "é obrigatório selecionar",
                            normalized_output.lower(),
                        )
                        self.assertIn(
                            "Planned file changes" if language == "1" else "Alterações previstas",
                            normalized_output,
                        )
                        self.assertIn(
                            "Permissions and installation state"
                            if language == "1"
                            else "Permissões e estado da instalação",
                            normalized_output,
                        )
                        self.assertNotRegex(normalized_output, r"\n{9,}")
                        divider_lines = [
                            line for line in normalized_output.splitlines()
                            if line and set(line) == {"-"}
                        ]
                        self.assertTrue(divider_lines, normalized_output)
                        self.assertLessEqual(max(map(len, divider_lines)), 72)
                        self.assertNotIn("ADICIONARdocs", normalized_output)
                        self.assertNotIn("ADICIONARREADME", normalized_output)
                        if animated:
                            self.assertIn(b"\x1b[K", output)
                            self.assertNotIn(b"\x1b[36m", output)
                        else:
                            self.assertNotIn(b"\x1b[", output)
                        self.assertEqual(target.exists(), confirm != "n")
                        if language == "2":
                            self.assertIn("ADICIONAR".encode(), output)
                        if confirm == "s":
                            self.assertIn(
                                "registro de instalação difere".encode(), output
                            )
                            self.assertIn(
                                "- Language: en-US",
                                (target / ".ai/framework-installation.md").read_text(),
                            )
                            self.assertRegex(
                                normalized_output,
                                r"Registro da instalação\n\nESTADO\s+RÓTULO",
                            )
                    finally:
                        if process.poll() is None:
                            os.killpg(process.pid, signal.SIGTERM)
                            process.wait()
                        os.close(master)

    @unittest.skipIf(os.name == "nt", "POSIX PTY")
    def test_back_navigation_preserves_answers_and_cancels_before_project_writes(self):
        commands = [
            ["sh", str(ROOT / "setup.sh"), "--no-animation", "--no-color"]
        ]
        if shutil.which("pwsh"):
            commands.append(
                [
                    "pwsh",
                    "-NoLogo",
                    "-NoProfile",
                    "-File",
                    str(ROOT / "setup.ps1"),
                    "-NoAnimation",
                    "-NoColor",
                ]
            )
        for command in commands:
            with self.subTest(command=command[0]), tempfile.TemporaryDirectory() as directory:
                target = Path(directory) / "project with spaces"
                env = dict(os.environ, TERM="dumb", COLUMNS="100", NO_COLOR="1")
                env.pop("CI", None)
                steps = [
                    ("Select operating system:", "b"),
                    ("Select operating system:", ""),
                    ("Select language:", "b"),
                    ("Select operating system:", ""),
                    ("Select language:", "2"),
                    ("Diretório do projeto", "b"),
                    ("Select language:", "2"),
                    ("Diretório do projeto", str(target)),
                    ("Escolha uma integração:", "b"),
                    ("Diretório do projeto", str(target)),
                    ("Escolha uma integração:", ""),
                    ("Escolha uma integração:", "1"),
                    ("Aplicar estas alterações? [s/N]", "b"),
                    ("Escolha uma integração:", "4"),
                    ("Aplicar estas alterações? [s/N]", "n"),
                ]
                return_code, output = self.run_pty_session(
                    command, steps, directory, env
                )
                decoded = output.decode(errors="replace").replace("\r\n", "\n")
                self.assertEqual(return_code, 0, decoded)
                self.assertIn("There is no previous step.", decoded)
                self.assertIn("é obrigatório selecionar", decoded.lower())
                self.assertIn("✓ System:", decoded)
                self.assertIn("✓ Idioma: Português (Brasil)", decoded)
                self.assertIn("✓ Integração: Codex", decoded)
                self.assertIn("✓ Integração: OpenCode", decoded)
                self.assertIn("Resumo:", decoded)
                self.assertFalse(target.exists(), decoded)

    @unittest.skipIf(os.name == "nt", "POSIX PTY")
    def test_color_selection_and_preview_labels(self):
        commands = [["sh", str(ROOT / "setup.sh"), "--no-animation"]]
        if shutil.which("pwsh"):
            commands.append(
                ["pwsh", "-NoLogo", "-NoProfile", "-File", str(ROOT / "setup.ps1"), "-NoAnimation"]
            )
        for command in commands:
            with self.subTest(command=command[0]), tempfile.TemporaryDirectory() as directory:
                target = Path(directory) / "colored preview"
                env = dict(os.environ, TERM="xterm-256color", COLUMNS="100")
                env.pop("NO_COLOR", None)
                env.pop("CI", None)
                steps = [
                    ("Select operating system:", ""),
                    ("Select language:", "1"),
                    ("Project directory", str(target)),
                    ("Choose an integration:", "1"),
                    ("Apply these changes? [y/N]", "n"),
                ]
                return_code, output = self.run_pty_session(
                    command, steps, directory, env
                )
                decoded = output.decode(errors="replace").replace("\r\n", "\n")
                self.assertEqual(return_code, 0, decoded)
                self.assertIn("✓ System:", decoded)
                self.assertIn("✓ Language: English", decoded)
                self.assertIn("STATE", decoded)
                self.assertIn("Language: en-US", decoded)
                self.assertNotIn("ADDAGENTS", decoded)
                self.assertIn("\x1b[", decoded)
                self.assertFalse(target.exists(), decoded)

    @unittest.skipIf(os.name == "nt", "POSIX PTY")
    def test_interactive_adapter_numbers_select_each_named_integration(self):
        commands = [
            ["sh", str(ROOT / "setup.sh"), "--no-animation", "--no-color"]
        ]
        if shutil.which("pwsh"):
            commands.append(
                [
                    "pwsh",
                    "-NoLogo",
                    "-NoProfile",
                    "-File",
                    str(ROOT / "setup.ps1"),
                    "-NoAnimation",
                    "-NoColor",
                ]
            )
        for command in commands:
            for choice, adapter in enumerate(("Codex", "Claude", "Gemini", "OpenCode"), 1):
                with self.subTest(command=command[0], adapter=adapter), tempfile.TemporaryDirectory() as directory:
                    target = Path(directory) / (adapter.lower() + " project")
                    env = dict(os.environ, TERM="dumb", COLUMNS="100", NO_COLOR="1")
                    env.pop("CI", None)
                    steps = [
                        ("Select operating system:", ""),
                        ("Select language:", "1"),
                        ("Project directory", str(target)),
                        ("Choose an integration:", ""),
                        ("Choose an integration:", str(choice)),
                        ("Apply these changes? [y/N]", "n"),
                    ]
                    return_code, output = self.run_pty_session(
                        command, steps, directory, env
                    )
                    decoded = output.decode(errors="replace").replace("\r\n", "\n")
                    self.assertEqual(return_code, 0, decoded)
                    self.assertIn("A selection is required.", decoded)
                    self.assertIn(f"✓ Integration: {adapter}", decoded)
                    self.assertNotIn("Generic", decoded)
                    self.assertFalse(target.exists(), decoded)

    @unittest.skipIf(os.name == "nt", "POSIX PTY")
    def test_launcher_back_navigation_reaches_each_prompt_without_installing(self):
        with tempfile.TemporaryDirectory() as directory:
            base = Path(directory)
            launcher = base / "launcher"
            fake_bin = base / "fake-bin"
            launcher.mkdir()
            fake_bin.mkdir()
            shutil.copy2(ROOT / "setup.sh", launcher / "setup.sh")
            platform = "macos" if sys.platform == "darwin" else "linux"
            asset = f"lf-engineering-framework-v1.5.0-{platform}-en-US.tar.gz"
            sums = base / "SHA256SUMS"
            sums.write_text("a" * 64 + "  " + asset + "\n", encoding="utf-8")
            fake_curl = fake_bin / "curl"
            fake_curl.write_text(
                "#!/bin/sh\n"
                "output=\nurl=\n"
                "while [ \"$#\" -gt 0 ]; do\n"
                "  case \"$1\" in\n"
                "    -o) output=$2; shift 2 ;;\n"
                "    http*) url=$1; shift ;;\n"
                "    *) shift ;;\n"
                "  esac\n"
                "done\n"
                "case \"$url\" in */SHA256SUMS) cp \"$FIXTURE_SUMS\" \"$output\" ;; *) exit 9 ;; esac\n",
                encoding="utf-8",
            )
            fake_curl.chmod(0o755)
            framework = base / "framework-library"
            project = base / "client-project"
            env = dict(
                os.environ,
                TERM="dumb",
                COLUMNS="100",
                NO_COLOR="1",
                FIXTURE_SUMS=str(sums),
                PATH=str(fake_bin) + os.pathsep + os.environ.get("PATH", ""),
            )
            env.pop("CI", None)
            command = ["sh", str(launcher / "setup.sh"), "--no-animation", "--no-color"]
            steps = [
                ("Select operating system:", ""),
                ("Select language:", ""),
                ("Framework installation directory", "b"),
                ("Select language:", ""),
                ("Framework installation directory", str(framework)),
                ("Project directory", str(project)),
                ("Choose an integration:", "b"),
                ("Project directory", str(project)),
                ("Choose an integration:", ""),
                ("Choose an integration:", "1"),
                ("Download and install this package? [y/N]", "b"),
                ("Choose an integration:", "b"),
                ("Project directory", "b"),
                ("Framework installation directory", "b"),
                ("Select language:", "b"),
                ("Select operating system:", "b"),
                ("Select operating system:", None),
            ]
            return_code, output = self.run_pty_session(
                command, steps, directory, env
            )
            decoded = output.decode(errors="replace").replace("\r\n", "\n")
            self.assertIn("There is no previous step.", decoded)
            self.assertIn("Download and install this package?", decoded)
            self.assertIn("b: back", decoded)
            self.assertFalse(framework.exists(), decoded)
            self.assertFalse(project.exists(), decoded)

    @unittest.skipUnless(shutil.which("pwsh"), "PowerShell is not installed")
    @unittest.skipIf(os.name == "nt", "This fixture uses a POSIX PTY")
    def test_back_after_package_install_keeps_framework_library(self):
        with tempfile.TemporaryDirectory() as directory:
            base = Path(directory)
            launcher = base / "launcher"
            launcher.mkdir()
            setup_script = launcher / "setup.ps1"
            setup_text = (ROOT / "setup.ps1").read_text(encoding="utf-8-sig")
            setup_text = setup_text.replace(
                "if ($script:HostPlatform -eq 'unsupported') { throw 'This installer supports macOS, Linux and Windows terminals.' }",
                "$script:HostPlatform = 'windows'",
            )
            setup_script.write_text(setup_text, encoding="utf-8")
            framework_root = base / "installed-framework"
            target = base / "client-project"
            calls = base / "download-calls.txt"
            sums = base / "SHA256SUMS"
            archive = base / "package.zip"
            version = "v1.5.0"
            asset_name = f"lf-engineering-framework-{version}-windows-en-US.zip"

            with zipfile.ZipFile(archive, "w", compression=zipfile.ZIP_DEFLATED) as package:
                package.writestr(
                    "lf-engineering-framework/framework-manifest.json",
                    json.dumps(
                        {
                            "framework_version": version,
                            "target_platform": "windows",
                            "language": "en-US",
                        }
                    ),
                )
                package.writestr(
                    "lf-engineering-framework/PROJECT_TEMPLATE/AGENTS.md",
                    "fixture template\n",
                )
                package.writestr(
                    "lf-engineering-framework/scripts/bootstrap.ps1",
                    "param([string]$FrameworkPath,[string]$TargetPath,[string]$Language,[string]$Adapter,[switch]$Apply,[switch]$DryRun)\n"
                    "Write-Output 'ADD .ai/AGENTS.md'\n"
                    "Write-Output 'PRESERVE README.md'\n",
                )
                package.writestr(
                    "lf-engineering-framework/scripts/i18n/setup.tsv",
                    (ROOT / "scripts/i18n/setup.tsv").read_text(encoding="utf-8"),
                )
            digest = hashlib.sha256(archive.read_bytes()).hexdigest()
            sums.write_text(f"{digest}  {asset_name}\n", encoding="utf-8")
            wrapper = base / "launch-with-fixture.ps1"
            wrapper.write_text(
                "function Invoke-WebRequest {\n"
                "  param([string]$Uri, [string]$OutFile, [switch]$UseBasicParsing)\n"
                "  Add-Content -LiteralPath $env:FIXTURE_CALLS -Value $Uri\n"
                "  if ($Uri.EndsWith('/SHA256SUMS')) { Copy-Item -LiteralPath $env:FIXTURE_SUMS -Destination $OutFile }\n"
                "  else { Copy-Item -LiteralPath $env:FIXTURE_ARCHIVE -Destination $OutFile }\n"
                "}\n"
                ". $env:LF_SETUP_SCRIPT -NoAnimation -NoColor\n",
                encoding="utf-8",
            )
            env = dict(
                os.environ,
                TERM="dumb",
                COLUMNS="100",
                NO_COLOR="1",
                FIXTURE_SUMS=str(sums),
                FIXTURE_ARCHIVE=str(archive),
                FIXTURE_CALLS=str(calls),
                LF_SETUP_SCRIPT=str(setup_script),
            )
            env.pop("CI", None)
            command = [
                "pwsh",
                "-NoLogo",
                "-NoProfile",
                "-File",
                str(wrapper),
            ]
            steps = [
                ("Select operating system:", ""),
                ("Select language:", "1"),
                ("Framework installation directory", str(framework_root)),
                ("Project directory", str(target)),
                ("Choose an integration:", "1"),
                ("Download and install this package? [y/N]", "y"),
                ("Apply these changes? [y/N]", "b"),
                ("Choose an integration:", "2"),
                ("Apply these changes? [y/N]", "n"),
            ]
            return_code, output = self.run_pty_session(
                command, steps, directory, env, timeout=45
            )
            decoded = output.decode(errors="replace").replace("\r\n", "\n")
            self.assertEqual(return_code, 0, decoded)
            self.assertTrue(framework_root.is_dir(), decoded)
            self.assertTrue((framework_root / "framework-manifest.json").is_file())
            self.assertFalse(target.exists(), decoded)
            self.assertEqual(len(calls.read_text(encoding="utf-8").splitlines()), 2)

    @unittest.skipIf(os.name == "nt", "POSIX PTY")
    def test_narrow_terminal_uses_compact_header(self):
        commands = [["sh", str(ROOT / "setup.sh"), "--no-color"]]
        if shutil.which("pwsh"):
            commands.append(
                [
                    "pwsh",
                    "-NoLogo",
                    "-NoProfile",
                    "-File",
                    str(ROOT / "setup.ps1"),
                    "-NoColor",
                ]
            )
        for command in commands:
            with self.subTest(command=command[0]), tempfile.TemporaryDirectory() as directory:
                target = Path(directory) / "narrow project"
                env = dict(os.environ, TERM="dumb", COLUMNS="36", NO_COLOR="1")
                env.pop("CI", None)
                steps = [
                    ("Select operating system:", ""),
                    ("Select language:", "2"),
                    ("Diretório do projeto", str(target)),
                    ("Escolha uma integração:", "1"),
                    ("Aplicar estas alterações? [s/N]", "n"),
                ]
                return_code, output = self.run_pty_session(
                    command, steps, directory, env, columns=36
                )
                decoded = output.decode(errors="replace").replace("\r\n", "\n")
                self.assertEqual(return_code, 0, decoded)
                self.assertIn("LF ENGINEERING FRAMEWORK", decoded)
                self.assertIn("leandrofernandes1600@gmail.com", decoded)
                self.assertNotRegex(decoded, r"Leandro Fernandes")
                divider_lines = [
                    line for line in decoded.splitlines()
                    if line and set(line) == {"-"}
                ]
                self.assertTrue(divider_lines, decoded)
                self.assertLessEqual(max(map(len, divider_lines)), 36)
                self.assertIn("ESTADO / RÓTULO", decoded)
                self.assertIn("Caminho:", decoded)
                self.assertNotIn("\x1b[", decoded)
                self.assertFalse(target.exists(), decoded)

    @unittest.skipIf(os.name == "nt", "POSIX signals/PTY")
    def test_eof_and_interrupt_before_confirmation(self):
        import pty
        import select

        for interrupted in (False, True):
            with tempfile.TemporaryDirectory() as directory:
                master, slave = pty.openpty()
                env = dict(os.environ, TERM="xterm-256color")
                env.pop("CI", None)
                process = subprocess.Popen(
                    ["sh", str(ROOT / "setup.sh")],
                    stdin=slave,
                    stdout=slave,
                    stderr=slave,
                    cwd=directory,
                    env=env,
                    start_new_session=True,
                )
                os.close(slave)
                output = b""
                try:
                    deadline = time.monotonic() + 10
                    while (
                        b"Select operating system:" not in output
                        and time.monotonic() < deadline
                    ):
                        if select.select([master], [], [], 0.1)[0]:
                            output += os.read(master, 4096)
                    self.assertIn(b"Select operating system:", output)
                    if interrupted:
                        os.killpg(process.pid, signal.SIGINT)
                    else:
                        os.write(master, b"\x04")
                    self.assertIn(process.wait(timeout=5), (0, 1, 130))
                    self.assertEqual(list(Path(directory).iterdir()), [])
                finally:
                    if process.poll() is None:
                        os.killpg(process.pid, signal.SIGTERM)
                        process.wait()
                    os.close(master)


if __name__ == "__main__":
    unittest.main()
