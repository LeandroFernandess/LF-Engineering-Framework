# Project Name

## Purpose

Describe the project objective, target users and primary outcome.

## Stack

Document the main technologies, runtime requirements and external services.

## Repository Structure

```text
.
├── AGENTS.md
├── LF_ENGINEERING.md
├── README.md
├── .ai/
└── docs/
```

The bootstrap records the selected language, adapter and external Framework path
in `.ai/framework-installation.md` when that file is absent.

## Engineering Process

This project uses the LF Engineering System for agent-assisted planning,
documentation, review and delivery validation. The Framework is CLI-neutral;
OpenCode, Codex, Claude Code, Gemini CLI and other compatible assistants can use
the same project documents through optional adapters. Web or visual projects
additionally use the design-performance module and validate mobile and desktop
separately before approval.
