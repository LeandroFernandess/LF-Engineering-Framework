# Testing the LF Engineering System

Languages: [EN-US](TESTING.md) | [PT-BR](locales/pt-BR/public-docs/TESTING.md)

## Local validation

From the repository root on macOS/Linux. If the checkout directory has a custom
name such as `LF-Engineering-Framework`, `cd` into that directory first; the
scripts locate the Framework relative to themselves and do not require a fixed
folder name:

```sh
./scripts/validate-framework.sh
./scripts/test-bootstrap.sh
```

On Windows PowerShell:

```powershell
.\scripts\validate-framework.ps1
.\scripts\test-bootstrap.ps1
```

Run the dynamic inspector regression tests (Python 3.10+; standard library only):

```sh
python3 -m unittest discover -s docs/security-audit -p 'test_*.py' -v
```

In Windows PowerShell, use `python` instead of `python3` if that is the installed
launcher name.

To inspect the current directory and overwrite its report, run from that project
directory. To inspect another project, pass `--project`:

```sh
python3 /path/to/LF-Engineering-Framework/docs/security-audit/gerar_relatorio.py
python3 /path/to/LF-Engineering-Framework/docs/security-audit/gerar_relatorio.py --project /path/to/project
```

The output defaults to `<project>/docs/security-audit/relatorio-auditoria-seguranca.pdf`
and is overwritten on each run. This is a local, preliminary static inspection,
not a complete QA-Security audit. The checked-in 2026-10-19 PDF is historical
evidence retained in the first public snapshot; it is not a current audit and no
predecessor tag was imported. A local run generates a current report.

## Covered scenarios

- Both setup assistants display the maintainer contact in help and the 2D LF
  signature at startup; bootstrap activity frames are cleared on completion and
  interruption, and narrow/no-animation paths remain static.
- New project dry-run does not create the target directory.
- New project application copies the selected language template.
- PT-BR template and Framework path rendering.
- Generic, Codex, Claude, Gemini and OpenCode adapters.
- The Windows PowerShell suite omits `-Adapter` once and verifies that the
  default is `generic` without installing vendor-specific entrypoints.
- Existing README, AGENTS, `.gitignore`, `.ai/`, documentation and CLI
  configuration preservation.
- Hidden state files and paths containing spaces.
- OpenCode placeholder replacement and JSON parsing when the validator runtime
  is available.
- Framework-side GitHub MCP configuration parses and remains explicitly
  disabled, version-pinned and read-only; validation does not start Docker or
  authenticate with GitHub.
- Invalid language and adapter rejection.
- Refusal to operate inside the Framework directory.
- PT-BR template file and structural parity for headings, tables, code fences
  and HTML comments.
- Structural parity for the PT-BR mirrors of `OVERVIEW.md`, `ROADMAP.md`,
  `CHANGELOG.md` and `docs/ADR.md`.
- The four supplemental Knowledge modules retain `Approved Optional` status and
  matching EN-US/PT-BR versions;
  their PT-BR mirrors are required and structurally checked separately. They
  remain outside the mandatory dependency graph, and this status does not
  authorize external-tool installation or integration.
- Framework boundary rejection through directory symlinks/junctions, including
  nested linked directories that could redirect template writes outside the
  selected target.
- Dynamic inspector uses current project data, overwrites prior output, redacts
  credential-shaped values, reports documentation/state indicators and rejects
  symlinked paths.
- Bootstrap restricts local-state directories/files to owner-only access on
  `--apply`, leaves existing content intact, and does not change permissions in
  dry-run mode.

Release archive generation is not exercised by these local validators. The
release workflow runs `scripts/package-release.sh` only after the exact tagged
commit passes the cross-platform CI matrix; the packaging script requires a
clean checkout.

GitHub Actions repeats the validation on Ubuntu, macOS and Windows for every
push and pull request. The public `main` branch requires pull requests and the
three cross-platform validation checks. The release workflow also validates the exact tagged
commit on the same matrix before packaging. After successful validation and
packaging, the publish job runs automatically with `contents: write`; it does
not use a GitHub Environment or require a manual reviewer approval. A matching
stable tag push is the only release trigger and requires separate owner
authorization. The pull-request rule does not require an approving review so the
single maintainer can merge after checks pass. Restrict write/admin access and
reassess this policy before granting write access to another person. These access
controls remain separate from the workflow's validation gates.

## Assistant and documentation checks

```sh
python3 scripts/check-docs.py
python3 -m unittest discover -s scripts/tests -v
```

On Windows use `python` when that is the available launcher. Python is a
maintainer/CI dependency, not an assistant dependency. The CI matrix runs tests
on all three platforms. Pseudoterminal sessions run on POSIX; Windows runs native
bootstrap tests and redirected-input rejection tests. Before a release, manually
validate language selection, confirmation, cancellation, Ctrl+C, the 2D
signature and the static fallback in an interactive Windows Terminal. Check a
narrow POSIX terminal and a basic terminal with animation disabled as well.

Documentation checks cover local inline and reference links, headings and HTML
anchors outside fenced code. Literal template paths are not treated as links:
they refer to generated projects or the external library. External URLs are not
fetched. READMEs have different structures per language; their links and review
are checked without requiring heading parity.

`locales/translation-review.json` records reviewed-pair hashes. After changing
one, compare source and translation, record renewed review and update the SHA-256
hashes. Never refresh hashes solely to silence a failing check.
