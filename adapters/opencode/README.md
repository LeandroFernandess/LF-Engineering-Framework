# OpenCode Adapter

OpenCode is an optional adapter for the vendor-neutral LF Engineering System.
The project template does not require OpenCode. Install this adapter only when
the project will be operated through OpenCode.

The compatibility configuration is in `opencode.jsonc`. The legacy
`.opencode/` directory remains the Framework-side source for the orchestration
and agent instruction files.

The GitHub MCP example in `.opencode/opencode.jsonc` is separate from this
client-project adapter. It is disabled by default, is not installed by the
bootstrap and must be enabled explicitly in the Framework repository.
