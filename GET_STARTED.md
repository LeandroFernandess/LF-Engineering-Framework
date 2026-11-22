# LF Engineering Framework — Get Started

Language: [English](GET_STARTED.md) | [Português (Brasil)](locales/pt-BR/public-docs/GET_STARTED.md)

This guide installs the Framework library separately from the project that will
use it. The interactive installer asks for the operating system first and the
language second; those two prompts stay in English so the first screen is clear
before a language has been selected.

> **Package availability:** release `v1.5.0` predates the six platform/language
> packages. The installer works when the latest release includes the matching
> asset; if no matching package is available, use the
> [source-checkout fallback](#release-availability-and-source-checkout-fallback).

The package installer needs an internet connection, `curl`, `tar` and a SHA-256
utility (`shasum` on macOS, usually `sha256sum` on Linux). The source-checkout
fallback needs Git.

## Recommended install: macOS and Linux

Open a terminal and download the small launcher from the official repository:

```sh
curl -fsSL https://raw.githubusercontent.com/LeandroFernandess/LF-Engineering-Framework/main/setup.sh -o lf-framework-setup.sh
```

Run it with the system shell. `sh` works on macOS and Linux; no `chmod` step is
needed:

```sh
sh ./lf-framework-setup.sh
```

The launcher asks you to confirm the detected operating system, choose English
or Português (Brasil), select a new Framework library folder, and select the
project folder. It then requires a selection of Codex, Claude, Gemini or
OpenCode. The library and project folders must be separate and must not overlap.

The installer reads the latest release checksum list, shows the exact package
version and destination, and waits for confirmation before downloading the
platform/language archive. It verifies the archive checksum and manifest before
installing. It previews project changes before a separate, default-no apply
confirmation. Answer `y` in English or `s` in Português (Brasil); both
confirmations default to no. Existing project files are preserved.

Remove the temporary launcher when you are done:

```sh
rm -f ./lf-framework-setup.sh
```

Use `--no-animation` to disable the activity animation and `--no-color` to disable color:

```sh
sh ./lf-framework-setup.sh --no-animation --no-color
```

`NO_COLOR` is also respected. The header shows maintainer contact information and links.

## Recommended install: Windows PowerShell

Use Windows PowerShell 5.1 or PowerShell 7. `Invoke-WebRequest`, `Expand-Archive`
and `Get-FileHash` are built into the supported PowerShell installation.
Open PowerShell and download the launcher to the temporary directory:

```powershell
$installer = Join-Path $env:TEMP 'lf-framework-setup.ps1'
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/LeandroFernandess/LF-Engineering-Framework/main/setup.ps1' -OutFile $installer
```

Allow script execution only in the current PowerShell process, run the launcher,
and remove the temporary file even if setup exits with an error:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
try { & $installer } finally { Remove-Item -LiteralPath $installer -Force -ErrorAction SilentlyContinue }
```

This does not change the machine or user execution policy. Organization policy
may still block scripts. In that case, follow the administrator's approved
process rather than changing a broader policy scope. See Microsoft's
[execution policy reference](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-7.5).

The installer asks for the operating system, language, a new Framework library
folder and a separate project folder. It displays the package version and
destination before downloading, verifies the checksum and package manifest, then
previews project changes before asking whether to apply them. Answer `y` in
English or `s` in Português (Brasil); the default is no. Existing project files
are preserved.

For a static interface, add `-NoAnimation -NoColor` after the script path:

```powershell
try { & $installer -NoAnimation -NoColor } finally { Remove-Item -LiteralPath $installer -Force -ErrorAction SilentlyContinue }
```

## Release availability and source-checkout fallback

The platform/language installer requires a GitHub release containing
`SHA256SUMS` and the six matching assets: macOS, Linux and Windows, each in
`en-US` and `pt-BR`. The currently published `v1.5.0` predates these assets, so
the package flow becomes available when a later release is published with them.

Until then, use a full source checkout. Keep it outside the client project.

macOS/Linux:

```sh
git clone https://github.com/LeandroFernandess/LF-Engineering-Framework.git "$HOME/Documents/LF-Engineering-Framework"
cd "$HOME/Documents/LF-Engineering-Framework"
sh setup.sh
```

Windows PowerShell:

```powershell
git clone https://github.com/LeandroFernandess/LF-Engineering-Framework.git "$HOME\Documents\LF-Engineering-Framework"
Set-Location "$HOME\Documents\LF-Engineering-Framework"
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\setup.ps1
```

## What the prompts mean

The operating-system and language menus use English and show one option per
line. After a valid choice, a check mark highlights the selected value. Enter
`b` at any prompt to go back one step; earlier answers stay selected and the
steps after the one you revisit are asked again. The first system prompt says
there is no previous step. Going back never removes an installed Framework
library or changes project files. The final project application remains a
separate confirmation and defaults to no.

1. **Operating system:** choose the system running this terminal. The default
   is the detected host; a mismatched selection is rejected.
2. **Language:** choose `English` or `Português (Brasil)`. Enter selects English.
3. **Framework library:** in the download flow, choose a new directory where
   the reusable Framework files will live.
4. **Project:** choose the client project directory. It can be new or existing.
5. **Integration:** choose `codex`, `claude`, `gemini` or `opencode`. A choice
   is required; Enter does not select a default.
6. **Review:** inspect the dry-run output. Confirm only when the additions match
   what you expect. The default answer is no.

Use quotes around paths when typing them into a shell command. At the
interactive path prompts, enter the path directly; spaces are supported. If the
assistant reports an invalid directory, provide an absolute path or a path
relative to the directory from which you started the launcher.

## Manual and automation setup

For a full description of manual bootstrap flags, preservation behavior and
project verification, see [START_PROJECTS.en-US.md](START_PROJECTS.en-US.md).
The native bootstrap scripts remain noninteractive and default to dry-run:

```sh
sh scripts/bootstrap.sh --help
```

```powershell
Get-Help .\scripts\bootstrap.ps1
```

## Maintainer links

- [Leandro Fernandes — GitHub](https://github.com/LeandroFernandess)
- [Leandro Fernandes — LinkedIn](https://www.linkedin.com/in/leandro-fernandes-951ab3189)
- [Contact email](mailto:leandrofernandes1600@gmail.com)
