# Dynamic Security Audit Inspector

The inspector reads a local project and renders a preliminary PDF using the
LF Engineering QA-Security categories. It is a small evidence collector, not a
complete security scanner or a QA approval.

## Run

From the project being inspected:

```sh
python3 /path/to/LF-Engineering-Framework/docs/security-audit/gerar_relatorio.py
```

Replace the example path with the actual Framework checkout path. The checkout
may be named `LF-Engineering-Framework` or anything else; the inspector does not
infer its location from the folder name.

The current directory is the default target. To inspect another directory:

```sh
python3 /path/to/LF-Engineering-Framework/docs/security-audit/gerar_relatorio.py \
  --project /path/to/project
```

By default, the report is written to
`<project>/docs/security-audit/relatorio-auditoria-seguranca.pdf`. Each run
overwrites that output. `--output PATH` selects another output; relative paths
are resolved inside the selected project. The report contains project-relative
evidence paths and the project directory name, not the absolute root path.

The inspector uses only the Python standard library. It does not execute project
code or commands, use the network, change permissions, or delete files. It skips
common dependency/build directories and does not follow symbolic links. High-
confidence credential-shaped strings are reported by type, path and line only;
the matched value is never copied into the PDF.

## Interpretation

The report dynamically inventories files, manifests, web/backend/configuration
indicators and local-state candidates. It checks a small set of credential
formats and flags potentially broad permissions on state-like files. Heuristic
absence is not proof of absence. Authentication/authorization, injection flows,
dependency vulnerabilities, deployment behavior, performance, accessibility,
observability and AI prompt-injection behavior still require project-specific
human review and tests.

The checked-in 2026-10-19 snapshot is historical evidence retained in this first
public snapshot; it is not a current audit. No predecessor repository tag was
imported. A local run writes a current dynamic report to the selected project.
