#!/usr/bin/env python3
"""Regression tests for the local, dynamic security-audit inspector."""

from __future__ import annotations

import contextlib
import io
import os
import sys
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

from gerar_relatorio import DEFAULT_OUTPUT, inspect_project, main


class InspectorTests(unittest.TestCase):
    def test_default_run_inspects_current_project_and_overwrites_its_report(self) -> None:
        with tempfile.TemporaryDirectory(prefix="lf-security-audit-") as temporary:
            project = Path(temporary) / "sample-project"
            (project / "src").mkdir(parents=True)
            (project / "node_modules" / "ignored-package").mkdir(parents=True)
            (project / "src" / "app.py").write_text(
                "API_TOKEN = 'ghp_" + ("A" * 32) + "'\n",
                encoding="utf-8",
            )
            path_secret = "ghp_" + ("D" * 32)
            (project / "src" / f"{path_secret}.py").write_text(
                "API_TOKEN = '" + path_secret + "'\n",
                encoding="utf-8",
            )
            (project / "docs").mkdir()
            (project / "docs" / "architecture.md").write_text("# Architecture\n", encoding="utf-8")
            (project / ".env").write_text(
                "AWS_ACCESS_KEY_ID=AKIA" + ("0" * 16) + "\n",
                encoding="utf-8",
            )
            if os.name != "nt":
                (project / ".env").chmod(0o600)
            state_file = project / ".ai" / "state" / "current-phase.md"
            state_file.parent.mkdir(parents=True)
            state_file.write_text("Current phase: test fixture\n", encoding="utf-8")
            if os.name != "nt":
                state_file.chmod(0o644)
            (project / "node_modules" / "ignored-package" / "bundle.js").write_text(
                "token = 'ghp_" + ("B" * 32) + "'\n",
                encoding="utf-8",
            )
            old_report = project / DEFAULT_OUTPUT
            old_report.parent.mkdir(parents=True)
            old_report.write_bytes(b"old report")

            stdout = io.StringIO()
            with patch.object(Path, "cwd", return_value=project):
                with patch.object(sys, "argv", ["gerar_relatorio.py"]):
                    with contextlib.redirect_stdout(stdout):
                        main()

            report = old_report.read_bytes()
            self.assertTrue(report.startswith(b"%PDF-1.4"))
            self.assertNotEqual(report, b"old report")
            self.assertIn(b"sample-project", report)
            self.assertIn(b"src/app.py", report)
            self.assertIn(b"docs/architecture.md", report)
            self.assertIn(b".ai/state/current-phase.md", report)
            self.assertIn(b"SEC-SIG-03", report)
            self.assertIn(b"SEC-SIG-02", report)
            if os.name != "nt":
                self.assertIn(b"SEC-STATE-01", report)
            self.assertNotIn(("ghp_" + "A" * 32).encode(), report)
            self.assertNotIn(path_secret.encode(), report)
            self.assertNotIn(("AKIA" + "0" * 16).encode(), report)
            self.assertNotIn(str(project).encode(), report)
            self.assertIn(b"src/[REDACTED].py", report)
            self.assertNotIn(b"ignored-package", report)
            expected_findings = 4 if os.name != "nt" else 3
            self.assertIn(f"achados potenciais: {expected_findings}", stdout.getvalue())

            (project / "docs" / "new-plan.md").write_text("# New plan\n", encoding="utf-8")
            (project / "src" / "app.py").write_text("# No credential-shaped value\n", encoding="utf-8")
            (project / "src" / f"{path_secret}.py").unlink()
            second_stdout = io.StringIO()
            with patch.object(Path, "cwd", return_value=project):
                with patch.object(sys, "argv", ["gerar_relatorio.py"]):
                    with contextlib.redirect_stdout(second_stdout):
                        main()

            updated_report = old_report.read_bytes()
            self.assertNotEqual(updated_report, report)
            self.assertIn(b"docs/new-plan.md", updated_report)
            self.assertNotIn(b"SEC-SIG-03", updated_report)
            self.assertNotIn(path_secret.encode(), updated_report)
            expected_updated_findings = 2 if os.name != "nt" else 1
            self.assertIn(
                f"achados potenciais: {expected_updated_findings}",
                second_stdout.getvalue(),
            )

    def test_symlinked_directories_are_not_traversed(self) -> None:
        with tempfile.TemporaryDirectory(prefix="lf-security-audit-link-") as temporary:
            root = Path(temporary)
            project = root / "project"
            outside = root / "outside"
            project.mkdir()
            outside.mkdir()
            (outside / "outside.py").write_text("token = 'ghp_" + ("C" * 32) + "'\n", encoding="utf-8")
            link = project / "external"
            try:
                link.symlink_to(outside, target_is_directory=True)
            except OSError:
                self.skipTest("Host does not permit creating a directory symlink")

            inspection = inspect_project(project, project / DEFAULT_OUTPUT)
            self.assertEqual(inspection.total_files, 0)
            self.assertEqual(inspection.findings, [])
            self.assertEqual(inspection.symlinks_skipped, 1)

    def test_output_symlink_is_rejected(self) -> None:
        with tempfile.TemporaryDirectory(prefix="lf-security-audit-output-") as temporary:
            root = Path(temporary)
            project = root / "project"
            project.mkdir()
            destination = root / "external.pdf"
            destination.write_bytes(b"preserve")
            link = project / "report.pdf"
            try:
                link.symlink_to(destination)
            except OSError:
                self.skipTest("Host does not permit creating a file symlink")

            with self.assertRaises(ValueError):
                main_with_project_and_output(project, link)
            self.assertEqual(destination.read_bytes(), b"preserve")


def main_with_project_and_output(project: Path, output: Path) -> None:
    stdout = io.StringIO()
    with patch.object(sys, "argv", ["gerar_relatorio.py", "--project", str(project), "--output", str(output)]):
        with contextlib.redirect_stdout(stdout):
            main()


if __name__ == "__main__":
    unittest.main()
