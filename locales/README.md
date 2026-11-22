# Language Packs

The Framework uses EN-US as the technical source language. Canonical technical
modules remain at the repository root; PT-BR mirrors and translated public
documents are grouped under `pt-BR/`. The project template language is selected
explicitly during bootstrap.

Supported languages:

- `en-US`: source language and default.
- `pt-BR`: translated project template, mirrors of the canonical library,
  selected public documentation in `pt-BR/public-docs/` and `pt-BR/docs/`, plus
  the technical mirrors tracked in `pt-BR/TRANSLATION_STATUS.md`.

The canonical EN-US source is authored in root `agents/`, `knowledge/`,
`workflows/`, `protocols/`, `schemas/` and `PROJECT_TEMPLATE/`. Stable agents,
workflows, protocols, schemas and Knowledge modules have PT-BR mirrors. The conditional
`ENGINEERING_MOTION_DESIGN` module and its mirror are post-tag maintenance and do
not change the published `v1.3.0` baseline. The four approved optional
supplemental modules also have PT-BR mirrors in the current checkout and are
validated as a separate group; they remain outside the mandatory dependency
graph and agent knowledge. Their approval does not authorize external-tool
installation or integration.
Translated public documents are canonical under `pt-BR/public-docs/` and
`pt-BR/docs/`; former root-level PT-BR compatibility paths have been removed.
`README.pt-BR.md` remains the repository's PT-BR landing page.
`en-US/README.md` is an index, not a duplicate source tree.
Historical/reference documents are explicitly classified in the translation
status rather than counted as incomplete active translations.

Run `sh scripts/check-locales.sh` after changing locale content to verify
template file parity and structural parity for the stable library, approved
optional supplemental modules and active public-document mirrors.

The release retains full-source archives and adds six smaller installer
archives: macOS, Linux and Windows for each supported language. The installer
selects one matching archive after the user chooses the system and language.
The approved optional supplemental modules remain outside the mandatory stable
library even though their mirrors are required by the separate locale check.
