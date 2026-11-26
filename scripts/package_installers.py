#!/usr/bin/env python3
"""Build small, platform and language scoped Framework installer archives."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import shutil
import tarfile
import zipfile
from pathlib import Path


REPOSITORY_URL = "https://github.com/LeandroFernandess/LF-Engineering-Framework"
PLATFORMS = ("macos", "linux", "windows")
LANGUAGES = ("en-US", "pt-BR")
CORE_DIRECTORIES = (
    "PROJECT_TEMPLATE",
    "adapters",
    "agents",
    "knowledge",
    "protocols",
    "schemas",
    "workflows",
)
CORE_FILES = (
    "AGENTS.md",
    "LICENSE",
    "CHANGELOG.md",
    "docs/ADR.md",
    "docs/reference/LF_DESIGN_PERFORMANCE_GUIDE.md",
    "docs/reference/palettes/lf-default-palette.css",
    "docs/reference/palettes/lf-default-palette.csv",
    "docs/reference/palettes/lf-default-palette-source.png",
    "GET_STARTED.md",
    "FIRST_PROMPT_TEMPLATE.md",
    "START_PROJECTS.en-US.md",
    "PROJECT_TEMPLATE", *CORE_DIRECTORIES[1:],
)
LOCALIZED_PUBLIC_DOCS = {
    "GET_STARTED.md": "locales/pt-BR/public-docs/GET_STARTED.md",
    "FIRST_PROMPT_TEMPLATE.md": "locales/pt-BR/public-docs/FIRST_PROMPT_TEMPLATE.md",
    "START_PROJECTS.en-US.md": "locales/pt-BR/public-docs/START_PROJECTS.md",
}


def selected_files(root: Path, platform: str, language: str) -> list[Path]:
    if platform not in PLATFORMS:
        raise ValueError(f"Unsupported platform: {platform}")
    if language not in LANGUAGES:
        raise ValueError(f"Unsupported language: {language}")

    paths = [root / name for name in CORE_FILES]
    paths.extend(
        root / name
        for name in (
            "scripts/i18n/setup.tsv",
            f"scripts/bootstrap.{ 'ps1' if platform == 'windows' else 'sh' }",
            f"setup.{ 'ps1' if platform == 'windows' else 'sh' }",
        )
    )
    if language == "pt-BR":
        paths.extend(
            root / "locales/pt-BR" / name
            for name in ("PROJECT_TEMPLATE", "agents", "knowledge", "protocols", "schemas", "workflows")
        )
        paths.extend(
            root / name
            for name in (
                "locales/pt-BR/docs/ADR.md",
                "locales/pt-BR/public-docs/CHANGELOG.md",
                "locales/pt-BR/public-docs/GET_STARTED.md",
                "locales/pt-BR/public-docs/FIRST_PROMPT_TEMPLATE.md",
                "locales/pt-BR/public-docs/START_PROJECTS.md",
            )
        )
        paths.append(root / "locales/pt-BR/project-skills")
    else:
        paths.append(root / "project-skills/en-US")

    files: set[Path] = set()
    for path in paths:
        if not path.exists():
            raise FileNotFoundError(f"Required package input is missing: {path.relative_to(root)}")
        if path.is_symlink():
            raise ValueError(f"Symbolic links are not allowed in installer packages: {path.relative_to(root)}")
        candidates = [path] if path.is_file() else sorted(path.rglob("*"))
        for candidate in candidates:
            if candidate.is_symlink():
                raise ValueError(f"Symbolic links are not allowed in installer packages: {candidate.relative_to(root)}")
            if candidate.is_file():
                files.add(candidate)
    return sorted(files, key=lambda item: item.relative_to(root).as_posix())


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def copy_package_file(source: Path, destination: Path, version: str, language: str) -> None:
    shutil.copy2(source, destination)
    if language != "en-US":
        return
    localized_path = LOCALIZED_PUBLIC_DOCS.get(source.name)
    if localized_path is None:
        return
    content = destination.read_text(encoding="utf-8")
    localized_url = f"{REPOSITORY_URL}/blob/{version}/{localized_path}"
    content = content.replace(f"]({localized_path})", f"]({localized_url})")
    destination.write_text(content, encoding="utf-8")


def build_archive(root: Path, output: Path, version: str, platform: str, language: str) -> Path:
    if not re.fullmatch(r"v?(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)", version):
        raise ValueError("Version must be a semantic version, optionally prefixed with v")
    tag = version if version.startswith("v") else f"v{version}"
    root = root.resolve(strict=True)
    output.mkdir(parents=True, exist_ok=True)
    output = output.resolve(strict=True)
    extension = ".zip" if platform == "windows" else ".tar.gz"
    archive = output / f"lf-engineering-framework-{tag}-{platform}-{language}{extension}"
    prefix = "lf-engineering-framework"
    files = selected_files(root, platform, language)

    staging = output / f".package-{platform}-{language}"
    if staging.exists():
        shutil.rmtree(staging)
    staging.mkdir()
    try:
        for source in files:
            relative = source.relative_to(root)
            destination = staging / relative
            destination.parent.mkdir(parents=True, exist_ok=True)
            copy_package_file(source, destination, tag, language)

        manifest = {
            "format_version": 1,
            "framework_version": tag,
            "target_platform": platform,
            "language": language,
            "repository": REPOSITORY_URL,
            "files": [item.relative_to(staging).as_posix() for item in sorted(staging.rglob("*")) if item.is_file()],
        }
        (staging / "framework-manifest.json").write_text(
            json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
        )

        if archive.exists():
            archive.unlink()
        if platform == "windows":
            with zipfile.ZipFile(archive, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9) as bundle:
                for item in sorted(staging.rglob("*")):
                    if item.is_file():
                        name = f"{prefix}/{item.relative_to(staging).as_posix()}"
                        bundle.write(item, name)
        else:
            with tarfile.open(archive, "w:gz", compresslevel=9) as bundle:
                for item in sorted(staging.rglob("*")):
                    if item.is_file():
                        name = f"{prefix}/{item.relative_to(staging).as_posix()}"
                        bundle.add(item, arcname=name, recursive=False)
    finally:
        shutil.rmtree(staging, ignore_errors=True)
    return archive


def build_matrix(root: Path, output: Path, version: str) -> list[Path]:
    return [
        build_archive(root, output, version, platform, language)
        for platform in PLATFORMS
        for language in LANGUAGES
    ]


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=Path(__file__).resolve().parents[1])
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--version", required=True)
    args = parser.parse_args()
    for archive in build_matrix(args.root.resolve(), args.output.resolve(), args.version):
        print(f"Created: {archive}")
        print(f"SHA256: {sha256(archive)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
