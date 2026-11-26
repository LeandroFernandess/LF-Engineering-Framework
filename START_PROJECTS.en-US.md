# LF Engineering System Getting Started — EN-US

This guide explains how to download the Framework and install its documentation
into a new or existing project. The vendor-neutral project base is installed
with one explicitly selected CLI adapter: Codex, Claude, Gemini or OpenCode.
The native bootstrap does not depend on Node.js, Python or plugins.

For the prioritized first-run package installer, use [GET_STARTED.md](GET_STARTED.md).
This guide remains the detailed source-checkout, manual setup and automation
reference. A full source checkout is also the fallback until a release publishes
the new platform/language package assets.

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

## Recommended local assistant

After downloading/cloning, run `sh setup.sh` on macOS/Linux or `.\setup.ps1`
on Windows PowerShell from the Framework root. Choose the language, external
project directory and integration; review the file and permission preview and confirm.
Confirmation defaults to no. EOF or cancellation before application does not change
project files. If application fails or is interrupted, correct the cause and run
again: newly written files can remain and will be preserved.

The assistant requires interactive input/output and does not run in CI.
Use `--no-animation`/`--no-color` or PowerShell `-NoAnimation`/`-NoColor`.
`NO_COLOR` disables colors; basic or narrow terminals use a static signature.
The OS and language menus use English and list one option per line. A check mark
highlights each accepted choice. Enter `b` at any prompt to return exactly one
step; earlier answers stay selected and later steps are asked again. The first
prompt explains that there is no previous step. Going back never removes an
installed Framework library or changes project files. The final apply prompt
remains separate and defaults to no.

The brief 2D LF opening animation runs once (up to 600 ms). During bootstrap, a
compact one-line indicator appears; the aligned preview follows without a large
blank gap or estimated percentages.

Selection changes assistant messages and new documents. It does not translate
existing files or change references to the external canonical library.
The previous installation record is preserved; language/integration differences
produce a warning. Reconcile preserved instructions and configuration manually.
The following sections document noninteractive commands for automation;
their technical output remains in English for compatibility.

## 2. Choose language and adapter

The options are independent:

| Option | Values | Default |
| --- | --- | --- |
| Language | `en-US`, `pt-BR` | `en-US` |
| Adapter | `codex`, `claude`, `gemini`, `opencode` | Required |

`en-US` installs the technical source template. `pt-BR` installs the translated
project template. Translation coverage is tracked in
`locales/pt-BR/TRANSLATION_STATUS.md`.

The distribution retains both languages. All four optional supplemental modules and active public documents have PT-BR mirrors. Presence and structural parity do not certify semantic equivalence; consult `locales/pt-BR/TRANSLATION_STATUS.md` for reviewed scope.

Every adapter installs the shared vendor-neutral project files. The selected
adapter provides the CLI-specific entrypoint or configuration:

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
  --adapter codex \
  --dry-run
```

Apply it after review:

```sh
sh "$FRAMEWORK_PATH/scripts/bootstrap.sh" \
  --framework-path "$FRAMEWORK_PATH" \
  --target "$TARGET_PATH" \
  --language en-US \
  --adapter codex \
  --apply
```

Use `--target "$PWD"` for the current directory. For Portuguese, change
`en-US` to `pt-BR`. Set `--adapter` to the CLI integration you selected.

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
  -Adapter codex `
  -DryRun
```

Apply it after review:

```powershell
& (Join-Path $frameworkPath "scripts\bootstrap.ps1") `
  -FrameworkPath $frameworkPath `
  -TargetPath $targetPath `
  -Language en-US `
  -Adapter codex `
  -Apply
```

Use `-Language pt-BR` for Portuguese. `-Adapter` is required; select `codex`,
`claude`, `gemini` or `opencode`.

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

The installed project contains the local coordination base, the selected
adapter entrypoint, and localized copies of `START_PROJECTS.md` and
`FIRST_PROMPT_TEMPLATE.md`. It also receives six short project skills:
`lf-project-onboarding`, `lf-project-planning`, `lf-approved-implementation`,
`lf-delivery-review`, `lf-design` and `lf-security-review`. Claude stores them in `.claude/skills/`; Codex, Gemini and
OpenCode use `.agents/skills/`.

The skills route to canonical agents, knowledge, workflows, protocols and
schemas in the external library. Find its public source and version in
`.ai/framework-installation.md`; use the source repository to read
`knowledge/INDEX.md`, `knowledge/REGISTRY.md` and
`.ai/contracts.md`. The bootstrap does not copy `GET_STARTED.md`, the full
Framework directories or external skills into the project, and it preserves
existing files at the guide and skill destinations. The client project is the
only implementation location. For web or visual projects, mobile and desktop
validation remains conditional and separate.

For a copy-ready prompt to start discovery and planning with an AI assistant,
see [`FIRST_PROMPT_TEMPLATE.md`](FIRST_PROMPT_TEMPLATE.md). The template is
optional and does not replace this setup guide or the project's approval gates.

## 7. Verify the installation

After applying:

1. Confirm the language in `.ai/framework-installation.md`.
2. Read `LF_ENGINEERING.md` and `AGENTS.md`.
3. Confirm that `.ai/` and `docs/` exist.
4. Select the initial agent using `knowledge/REGISTRY.md`.
5. For a specific adapter, confirm its corresponding entrypoint file.

See the project's `README.md` for its local overview. The public Framework
source in `.ai/framework-installation.md` identifies the version that provides
canonical files and the Portuguese guide.
