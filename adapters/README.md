# LF Engineering System Adapters

Adapters connect the vendor-neutral Framework to a specific AI assistant or
CLI. The bootstrap requires one adapter selection. The Framework's agents, knowledge, workflows, protocols,
schemas and project artifacts remain authoritative.

## Available Adapters

| Adapter | Project entrypoint | Status |
| --- | --- | --- |
| `codex` (OpenAI) | `AGENTS.md` | Supported compatibility entrypoint |
| `claude` (Anthropic) | `CLAUDE.md` | Initial adapter |
| `gemini` (Google) | `GEMINI.md` | Initial adapter |
| `opencode` | `AGENTS.md` and `opencode.jsonc` | Compatibility adapter |

Use the native bootstrap command with `--adapter` to install an adapter without
copying the complete Framework into the client project.
