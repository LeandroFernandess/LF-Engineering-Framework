# Contributing to LF Engineering System

Languages: [EN-US](CONTRIBUTING.md) | [PT-BR](locales/pt-BR/public-docs/CONTRIBUTING.md)

Thank you for improving the Framework. English (EN-US) is the technical source
language; Portuguese (PT-BR) translations must record the source version and
retain structural parity.

## Before opening a change

1. Read `AGENTS.md`, `README.md` and the relevant `knowledge/INDEX.md` entry.
2. Keep the vendor-neutral core independent of any AI provider.
3. Use adapters for CLI-specific behavior instead of adding provider rules to
   `PROJECT_TEMPLATE/`.
4. Record architecture, scope or delivery-risk decisions in `docs/ADR.md`.

## Required validation

From the repository root, run:

```sh
./scripts/validate-framework.sh
./scripts/test-bootstrap.sh
python3 -m unittest discover -s docs/security-audit -p 'test_*.py' -v
```

On Windows PowerShell, run:

```powershell
.\scripts\validate-framework.ps1
.\scripts\test-bootstrap.ps1
python -m unittest discover -s docs/security-audit -p 'test_*.py' -v
```

The security-inspector regression suite requires Python 3.10+ and uses only the
standard library. The vendor-neutral bootstrap itself does not require Python.

Changes to translated files must also pass `scripts/check-locales.sh` or the
corresponding validation included above.

## Pull requests

Describe the user problem, affected files, validation evidence, risks,
compatibility impact and any intentionally deferred translation or release
work. Do not include local `.ai/` state, secrets, temporary files or generated
archives unless the change explicitly requires them.
