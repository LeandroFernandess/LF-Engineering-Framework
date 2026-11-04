# LF Engineering System Getting Started — EN-US

This guide explains how to download the Framework and install its documentation
into a new or existing project. The `generic` mode is the default and does not
depend on OpenCode, Codex, Claude Code, Gemini, Node.js, Python or plugins.

## 1. Download the Framework

Choose a GitHub release or clone the repository into a directory separate from
the client project:

```sh
git clone https://github.com/LeandroFernandess/LF-Engineering-Framework.git LF-Engineering-Framework
cd LF-Engineering-Framework
```

The destination name is optional and can be different. The scripts derive the
Framework root from their own location; use the actual checkout directory and
run the commands below from its root. No command depends on the folder being
named `LF-Engineering-Framework`.

Keep the Framework external and read-only. The bootstrap copies the local
coordination base into the project while keeping `agents/`, `knowledge/`,
`workflows/`, `protocols/` and `schemas/` as the external canonical library.

The generated `.gitignore` excludes `/.ai/state/` so coordination state remains
local by default. Existing projects retain their `.gitignore` during bootstrap
and must add this rule manually if they want the same protection.

## 2. Choose language and adapter

The options are independent:

| Option | Values | Default |
| --- | --- | --- |
| Language | `en-US`, `pt-BR` | `en-US` |
| Adapter | `generic`, `codex`, `claude`, `gemini`, `opencode` | `generic` |

`en-US` installs the technical source template. `pt-BR` installs the translated
project template. Translation coverage is tracked in
`locales/pt-BR/TRANSLATION_STATUS.md`.

The public `v1.5.0` release contains both template packs, and selection happens
at bootstrap time. Translation coverage is not exhaustive across supplemental
modules and extended public documents; consult
`locales/pt-BR/TRANSLATION_STATUS.md` before treating PT-BR as equivalent to all
EN-US content.

The `generic` mode installs `LF_ENGINEERING.md`, `AGENTS.md`, `.ai/`, `docs/`,
`README.md` and `.gitignore`. Adapters add only CLI-specific integration:

- `codex` (OpenAI): uses the installed `AGENTS.md`.
- `claude` (Anthropic): adds `CLAUDE.md`.
- `gemini` (Google): adds `GEMINI.md`.
- `opencode`: adds `opencode.jsonc` and configures the read-only reference.

## 3. macOS and Linux

The native shell script requires no `rsync`, Node.js or Python. From the cloned
Framework root, it defaults to a dry-run so the result can be reviewed first:

```sh
FRAMEWORK_PATH="$(pwd)"
TARGET_PATH="$HOME/Projects/MyProject"

sh "$FRAMEWORK_PATH/scripts/bootstrap.sh" \
  --framework-path "$FRAMEWORK_PATH" \
  --target "$TARGET_PATH" \
  --language en-US \
  --adapter generic \
  --dry-run
```

Apply it after review:

```sh
sh "$FRAMEWORK_PATH/scripts/bootstrap.sh" \
  --framework-path "$FRAMEWORK_PATH" \
  --target "$TARGET_PATH" \
  --language en-US \
  --adapter generic \
  --apply
```

Use `--target "$PWD"` for the current directory. For Portuguese, change
`en-US` to `pt-BR`; for OpenCode, change `generic` to `opencode`.

Applying the bootstrap also restricts `.ai/state` directories/files to the
current user (0700/0600 on POSIX and owner-only ACLs on Windows). For an existing
project, the state contents remain unchanged while their permissions are
tightened.

## 4. Windows PowerShell

The script uses only PowerShell and .NET APIs. It also defaults to a dry-run:

```powershell
$frameworkPath = (Get-Location).Path # Run from the cloned Framework root.
$targetPath = "$HOME\Projects\MyProject"

& (Join-Path $frameworkPath "scripts\bootstrap.ps1") `
  -FrameworkPath $frameworkPath `
  -TargetPath $targetPath `
  -Language en-US `
  -Adapter generic `
  -DryRun
```

Apply it after review:

```powershell
& (Join-Path $frameworkPath "scripts\bootstrap.ps1") `
  -FrameworkPath $frameworkPath `
  -TargetPath $targetPath `
  -Language en-US `
  -Adapter generic `
  -Apply
```

Use `-Language pt-BR` for Portuguese and `-Adapter opencode` for OpenCode.

## 5. New and existing projects

The same command supports both scenarios:

- creates the target directory when it does not exist;
- copies only missing files;
- preserves code, documents, `.git/`, `.ai/`, `AGENTS.md`, `.gitignore`,
  `README.md` and existing configuration;
- never automatically merges conflicting `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`
  or `opencode.jsonc` files;
- records language and adapter in `.ai/framework-installation.md` only when it
  does not already exist;
- refuses to install into the Framework or one of its subdirectories.

Review all `ADD` and `PRESERVE` lines from the dry-run before using `--apply`.
Merge configuration conflicts manually because an automatic merge could alter
project rules.

## 6. Consumption model

The installed project contains only the local coordination base. The AI
assistant should consult the external library according to `LF_ENGINEERING.md`
and `AGENTS.md`, starting with `knowledge/INDEX.md` and `.ai/contracts.md`.

The Framework is the canonical source for agents, knowledge, workflows,
protocols and schemas. The client project is the only implementation location.
For web or visual projects, mobile and desktop validation remains conditional
and separate.

## 7. Verify the installation

After applying:

1. Confirm the language in `.ai/framework-installation.md`.
2. Read `LF_ENGINEERING.md` and `AGENTS.md`.
3. Confirm that `.ai/` and `docs/` exist.
4. Select the initial agent using `knowledge/REGISTRY.md`.
5. For a specific adapter, confirm its corresponding entrypoint file.

See `README.md` for the English overview and
`locales/pt-BR/public-docs/START_PROJECTS.md` for the Portuguese guide.
