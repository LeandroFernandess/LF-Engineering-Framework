from __future__ import annotations

import importlib.util
import json
import shutil
import subprocess
import sys
import tarfile
import tempfile
import unittest
import zipfile
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
SPEC = importlib.util.spec_from_file_location("package_installers", ROOT / "scripts/package_installers.py")
package_installers = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(package_installers)


class InstallerPackages(unittest.TestCase):
    def test_matrix_selects_only_requested_runtime_and_locale(self):
        mac_files = {path.relative_to(ROOT).as_posix() for path in package_installers.selected_files(ROOT, "macos", "en-US")}
        windows_files = {path.relative_to(ROOT).as_posix() for path in package_installers.selected_files(ROOT, "windows", "pt-BR")}

        self.assertIn("scripts/bootstrap.sh", mac_files)
        self.assertIn("setup.sh", mac_files)
        self.assertIn("docs/ADR.md", mac_files)
        self.assertIn("GET_STARTED.md", mac_files)
        self.assertIn("FIRST_PROMPT_TEMPLATE.md", mac_files)
        self.assertIn("START_PROJECTS.en-US.md", mac_files)
        self.assertIn("project-skills/en-US/lf-project-onboarding/SKILL.md", mac_files)
        self.assertIn("project-skills/en-US/lf-delivery-review/SKILL.md", mac_files)
        self.assertNotIn("scripts/bootstrap.ps1", mac_files)
        self.assertNotIn("setup.ps1", mac_files)
        self.assertFalse(any(path.startswith("locales/pt-BR/") for path in mac_files))

        self.assertIn("scripts/bootstrap.ps1", windows_files)
        self.assertIn("setup.ps1", windows_files)
        self.assertNotIn("scripts/bootstrap.sh", windows_files)
        self.assertNotIn("setup.sh", windows_files)
        self.assertIn("locales/pt-BR/PROJECT_TEMPLATE/AGENTS.md", windows_files)
        self.assertIn("locales/pt-BR/docs/ADR.md", windows_files)
        self.assertIn("locales/pt-BR/public-docs/GET_STARTED.md", windows_files)
        self.assertIn("locales/pt-BR/public-docs/FIRST_PROMPT_TEMPLATE.md", windows_files)
        self.assertIn("locales/pt-BR/public-docs/START_PROJECTS.md", windows_files)
        self.assertIn(
            "locales/pt-BR/project-skills/lf-project-onboarding/SKILL.md", windows_files
        )
        self.assertNotIn("project-skills/en-US/lf-project-onboarding/SKILL.md", windows_files)
        self.assertIn("PROJECT_TEMPLATE/AGENTS.md", windows_files)

    def test_archives_include_a_matching_manifest(self):
        with tempfile.TemporaryDirectory() as temporary:
            output = Path(temporary)
            archives = package_installers.build_matrix(ROOT, output, "v9.8.7")
            self.assertEqual(len(archives), 6)
            self.assertEqual(
                {archive.name for archive in archives},
                {
                    f"lf-engineering-framework-v9.8.7-{platform}-{language}.{extension}"
                    for platform in package_installers.PLATFORMS
                    for language in package_installers.LANGUAGES
                    for extension in (["zip"] if platform == "windows" else ["tar.gz"])
                },
            )
            posix_archive = next(path for path in archives if "-linux-en-US." in path.name)
            windows_en_archive = next(path for path in archives if "-windows-en-US." in path.name)
            windows_archive = next(path for path in archives if "-windows-pt-BR." in path.name)

            with tarfile.open(posix_archive, "r:gz") as archive:
                members = archive.getnames()
                manifest_member = archive.extractfile("lf-engineering-framework/framework-manifest.json")
                self.assertIsNotNone(manifest_member)
                posix_manifest = json.loads(manifest_member.read().decode("utf-8"))
            self.assertEqual(posix_manifest["target_platform"], "linux")
            self.assertEqual(posix_manifest["language"], "en-US")
            self.assertEqual(posix_manifest["framework_version"], "v9.8.7")
            self.assertTrue(all(name.startswith("lf-engineering-framework/") for name in members))
            self.assertFalse(any(name.endswith("bootstrap.ps1") for name in members))
            self.assertIn("lf-engineering-framework/GET_STARTED.md", members)
            self.assertIn("lf-engineering-framework/FIRST_PROMPT_TEMPLATE.md", members)
            self.assertIn("lf-engineering-framework/START_PROJECTS.en-US.md", members)
            self.assertIn(
                "lf-engineering-framework/project-skills/en-US/lf-project-onboarding/SKILL.md",
                members,
            )
            self.assertFalse(any("locales/pt-BR/project-skills/" in name for name in members))

            with zipfile.ZipFile(windows_en_archive) as archive:
                english_guide = archive.read("lf-engineering-framework/GET_STARTED.md").decode("utf-8")
                english_prompt = archive.read("lf-engineering-framework/FIRST_PROMPT_TEMPLATE.md").decode("utf-8")
                self.assertIn("/blob/v9.8.7/locales/pt-BR/public-docs/GET_STARTED.md", english_guide)
                self.assertIn("/blob/v9.8.7/locales/pt-BR/public-docs/FIRST_PROMPT_TEMPLATE.md", english_prompt)
                self.assertFalse(any(name.startswith("lf-engineering-framework/locales/pt-BR/") for name in archive.namelist()))

            with zipfile.ZipFile(windows_archive) as archive:
                members = archive.namelist()
                windows_manifest = json.loads(archive.read("lf-engineering-framework/framework-manifest.json"))
            self.assertEqual(windows_manifest["target_platform"], "windows")
            self.assertEqual(windows_manifest["language"], "pt-BR")
            self.assertEqual(windows_manifest["framework_version"], "v9.8.7")
            self.assertTrue(
                any(
                    name.endswith("/locales/pt-BR/project-skills/lf-project-onboarding/SKILL.md")
                    for name in members
                )
            )
            self.assertFalse(any("/project-skills/en-US/" in name for name in members))
            self.assertIn("lf-engineering-framework/locales/pt-BR/PROJECT_TEMPLATE/AGENTS.md", members)
            self.assertIn("lf-engineering-framework/locales/pt-BR/public-docs/GET_STARTED.md", members)
            self.assertIn("lf-engineering-framework/locales/pt-BR/public-docs/FIRST_PROMPT_TEMPLATE.md", members)
            self.assertIn("lf-engineering-framework/locales/pt-BR/public-docs/START_PROJECTS.md", members)
            self.assertFalse(any(name.endswith("bootstrap.sh") for name in members))

            adapters = ("codex", "claude", "gemini", "opencode")
            adapter_index = 0
            host_platform = {
                "win32": "windows",
                "darwin": "macos",
            }.get(sys.platform, "linux")
            for platform in package_installers.PLATFORMS:
                for language in package_installers.LANGUAGES:
                    archive_path = next(
                        path for path in archives
                        if f"-{platform}-{language}." in path.name
                    )
                    extract_root = output / f"extracted-{platform}-{language}"
                    extract_root.mkdir()
                    if platform == "windows":
                        with zipfile.ZipFile(archive_path) as archive:
                            archive.extractall(extract_root)
                    else:
                        with tarfile.open(archive_path, "r:gz") as archive:
                            archive.extractall(extract_root)
                    package_root = extract_root / "lf-engineering-framework"
                    target = output / f"project-{platform}-{language}"
                    adapter = adapters[adapter_index % len(adapters)]
                    adapter_index += 1

                    # Run each platform's installer on its native runner. The
                    # Windows shell cannot faithfully exercise POSIX bootstrap
                    # paths, and emulating a foreign platform hides path bugs.
                    if platform != host_platform:
                        continue

                    if platform == "windows":
                        powershell = shutil.which("pwsh") or shutil.which("powershell")
                        if not powershell:
                            continue
                        command = [
                            powershell,
                            "-NoLogo",
                            "-NoProfile",
                            "-File",
                            str(package_root / "scripts/bootstrap.ps1"),
                            "-FrameworkPath",
                            str(package_root),
                            "-TargetPath",
                            str(target),
                            "-Language",
                            language,
                            "-Adapter",
                            adapter,
                            "-Apply",
                        ]
                    else:
                        command = [
                            "sh",
                            str(package_root / "scripts/bootstrap.sh"),
                            "--framework-path",
                            str(package_root),
                            "--target",
                            str(target),
                            "--language",
                            language,
                            "--adapter",
                            adapter,
                            "--apply",
                        ]
                    result = subprocess.run(
                        command,
                        cwd=output,
                        text=True,
                        capture_output=True,
                        timeout=60,
                    )
                    self.assertEqual(result.returncode, 0, result.stderr)

                    record = (target / ".ai/framework-installation.md").read_text(encoding="utf-8")
                    guide = (target / "START_PROJECTS.md").read_text(encoding="utf-8")
                    self.assertIn("Framework source:", record)
                    self.assertIn("/tree/v9.8.7", record)
                    self.assertNotIn(str(package_root), record)
                    self.assertIn("/blob/v9.8.7/", guide)
                    self.assertNotIn(str(package_root), guide)
                    self.assertNotIn("file://", guide)
                    skill_root = ".claude/skills" if adapter == "claude" else ".agents/skills"
                    skill_files = sorted((target / skill_root).rglob("SKILL.md"))
                    self.assertEqual(len(skill_files), 4)
                    self.assertEqual(
                        {path.parent.name for path in skill_files},
                        {
                            "lf-project-onboarding",
                            "lf-project-planning",
                            "lf-approved-implementation",
                            "lf-delivery-review",
                        },
                    )
                    for skill_file in skill_files:
                        lines = skill_file.read_text(encoding="utf-8").splitlines()
                        self.assertEqual(lines[0], "---", skill_file)
                        metadata_end = lines.index("---", 1)
                        metadata = lines[1:metadata_end]
                        self.assertIn("name: " + skill_file.parent.name, metadata)
                        descriptions = [line.partition(":")[2].strip() for line in metadata if line.startswith("description:")]
                        self.assertEqual(len(descriptions), 1, skill_file)
                        self.assertTrue(descriptions[0], skill_file)
                        self.assertTrue("\n".join(lines[metadata_end + 1 :]).strip(), skill_file)
                    self.assertTrue((target / "AGENTS.md").is_file())
                    self.assertFalse((target / "knowledge").exists())
                    if adapter == "codex":
                        self.assertFalse((target / "CLAUDE.md").exists())
                        self.assertFalse((target / "GEMINI.md").exists())
                    elif adapter == "claude":
                        self.assertTrue((target / "CLAUDE.md").is_file())
                    elif adapter == "gemini":
                        self.assertTrue((target / "GEMINI.md").is_file())
                    else:
                        opencode_config = json.loads(
                            (target / "opencode.jsonc").read_text(encoding="utf-8")
                        )
                        self.assertEqual(
                            opencode_config["references"]["lf-engineering-framework"]["branch"],
                            "v9.8.7",
                        )
                        permission_entries = {
                            (item["action"], item["resource"], item["effect"])
                            for item in opencode_config["permissions"]
                        }
                        resource = "*/repos/github.com/LeandroFernandess/LF-Engineering-Framework/*"
                        self.assertTrue(
                            {
                                ("external_directory", resource, "allow"),
                                ("read", resource, "allow"),
                                ("edit", resource, "deny"),
                            }.issubset(permission_entries)
                        )
                    for document in target.rglob("*.md"):
                        content = document.read_text(encoding="utf-8")
                        self.assertNotIn(str(package_root), content, document)
                        self.assertNotIn("file://", content, document)

    def test_invalid_version_and_symbolic_links_are_rejected(self):
        with self.assertRaises(ValueError):
            package_installers.build_archive(ROOT, Path(tempfile.gettempdir()), "latest", "linux", "en-US")

        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            (root / "AGENTS.md").write_text("instructions", encoding="utf-8")
            (root / "LICENSE").write_text("license", encoding="utf-8")
            (root / "CHANGELOG.md").write_text("changes", encoding="utf-8")
            (root / "GET_STARTED.md").write_text("guide", encoding="utf-8")
            (root / "FIRST_PROMPT_TEMPLATE.md").write_text("prompt", encoding="utf-8")
            (root / "START_PROJECTS.en-US.md").write_text("manual", encoding="utf-8")
            (root / "docs/reference").mkdir(parents=True)
            (root / "docs/ADR.md").write_text("decisions", encoding="utf-8")
            (root / "docs/reference/LF_DESIGN_PERFORMANCE_GUIDE.md").write_text("reference", encoding="utf-8")
            for directory in package_installers.CORE_DIRECTORIES:
                (root / directory).mkdir(parents=True)
            (root / "scripts/i18n").mkdir(parents=True)
            (root / "scripts/i18n/setup.tsv").write_text("", encoding="utf-8")
            (root / "scripts/bootstrap.sh").write_text("", encoding="utf-8")
            (root / "setup.sh").write_text("", encoding="utf-8")
            (root / "project-skills/en-US/lf-project-onboarding").mkdir(parents=True)
            (root / "project-skills/en-US/lf-project-onboarding/SKILL.md").write_text(
                "skill", encoding="utf-8"
            )
            (root / "agents/link.md").symlink_to(root / "AGENTS.md")
            with self.assertRaises(ValueError):
                package_installers.selected_files(root, "linux", "en-US")


if __name__ == "__main__":
    unittest.main()
