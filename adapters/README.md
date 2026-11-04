# LF Engineering System Adapters

Adapters connect the vendor-neutral Framework to a specific AI assistant or
CLI. They are optional. The Framework's agents, knowledge, workflows, protocols,
schemas and project artifacts remain authoritative.

## Available Adapters

| Adapter | Project entrypoint | Status |
| --- | --- | --- |
| `generic` | `LF_ENGINEERING.md` and project documents | Default |
| `codex` (OpenAI) | `AGENTS.md` | Supported compatibility entrypoint |
| `claude` (Anthropic) | `CLAUDE.md` | Initial adapter |
| `gemini` (Google) | `GEMINI.md` | Initial adapter |
| `opencode` | `AGENTS.md` and `opencode.jsonc` | Compatibility adapter |

Use the native bootstrap command with `--adapter` to install an adapter without
copying the complete Framework into the client project.
