---
name: lf-project-onboarding
description: Use when initializing a client project or checking its LF Framework setup and required starter files.
---

# LF Project Onboarding

1. Read the project instructions and `.ai/contracts.md` when present. Use the
   official Framework source identified in `LF_ENGINEERING.md`.
2. Keep the Framework read-only. When its canonical repository is available,
   consult `knowledge/INDEX.md` and `knowledge/REGISTRY.md` before selecting
   knowledge or agents.
3. Follow `workflows/NEW_PROJECT.md` and the relevant canonical agent
   definitions when accessible. Load only the modules and artifacts the project
   needs; state when a source cannot be accessed.
4. Check the required project files and `.ai/state/` against the workflow and
   contracts. Record accepted exceptions in the project's decisions file.

Do not copy the full `agents/`, `knowledge/`, `workflows/`, `protocols/` or
`schemas/` directories into the client project. The installation record
identifies the Framework source and version; it does not contain a local
installation path.
