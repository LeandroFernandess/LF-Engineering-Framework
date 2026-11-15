# OpenCode Adapter

OpenCode is an optional adapter for the vendor-neutral LF Engineering System.
The project template does not require OpenCode. Select it through the shared
bootstrap workflow only when the project will be operated through OpenCode.

The generated `opencode.jsonc` points to the canonical Framework `AGENTS.md`,
agent specification and workflow documents. The Framework does not maintain a
second OpenCode-specific copy of its agents or orchestrator, and it does not
install a Framework-level MCP server configuration.

Existing project configuration is preserved by the bootstrap. The `generic`
adapter remains the default.
