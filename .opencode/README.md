# OpenCode Integration

## Purpose

The `.opencode/` directory is the Framework-side compatibility source for using
the LF Engineering System with OpenCode. OpenCode is optional; the public
bootstrap defaults to the vendor-neutral `generic` mode.

These files do not replace the canonical framework, knowledge base or agent documentation. They point OpenCode agents to the correct source files and define how agents should collaborate during a project.

## Structure

```text
.opencode/
├── README.md
├── opencode.jsonc
├── orchestrator.md
└── agents/
    ├── orchestrator.md
    ├── engineering-manager.md
    ├── prompt-architect.md
    ├── product-owner.md
    ├── design-system-analyst.md
    ├── software-architect.md
    ├── sprint-planner.md
    ├── documentation.md
    ├── code-reviewer.md
    ├── qa-security.md
    ├── tech-lead.md
    └── engineering-knowledge-extractor.md
```

## Optional GitHub MCP Server

`.opencode/opencode.jsonc` defines an optional GitHub MCP server for this
Framework repository. It is disabled by default and is not copied to client
projects by the bootstrap. The configuration pins the server image, restricts
it to the `repos` toolset, enables the server's read-only mode, requests the
`public_repo` OAuth scope and binds the OAuth callback to loopback port `8085`
for the pinned upstream image `v2.0.3`.

To use it, review the GitHub access you intend to grant and explicitly change
`mcp.servers.github.disabled` to `false`. Docker must be installed and running;
the first tool use can start GitHub's OAuth flow. The read-only mode limits
the MCP tools exposed by the server, but the `public_repo` OAuth grant itself
is not read-only. Treat the authorization as access to public repositories and
enable the server only in a trusted environment. See the upstream
[OAuth](https://github.com/github/github-mcp-server/blob/v2.0.3/docs/oauth-login.md)
and [server configuration](https://github.com/github/github-mcp-server/blob/v2.0.3/docs/server-configuration.md)
guides for `v2.0.3`.

OpenCode watches project configuration and normally reloads changes
automatically. If the running session does not reflect a configuration change,
use `/reload`.

## Usage

1. Start with `.opencode/agents/engineering-manager.md` for raw user demand intake.
2. Generate a `MANAGER_BRIEF` for the Orchestrator.
3. Continue with `.opencode/orchestrator.md` to select workflow, agents and handoff order.
4. Consult `knowledge/REGISTRY.md` before selecting agents or handoff order.
5. Consult `.ai/contracts.md` inside the project before creating, updating or validating artifacts.
6. Select the adapter in `.opencode/agents/` that matches the current work phase.
7. Follow the adapter instructions to load the canonical files in `agents/<Agent>/`.
8. Consult `knowledge/INDEX.md` before loading specific knowledge modules.
9. When operating in a project repository, keep `.ai/workflow.md`, `.ai/handoff.md`, `.ai/decisions.md`, `.ai/tasks.md` and `.ai/artifacts.md` updated for agent communication.
10. Keep `.ai/state/` updated after each workflow step.
11. Use `.opencode/agents/design-system-analyst.md` for visual-reference analysis or an explicitly requested initial direction proposal without references; otherwise skip this optional step.
12. Use `.opencode/agents/engineering-knowledge-extractor.md` after Tech Lead approval to produce `PROJECT_KNOWLEDGE.md` for human review.

## Project Template

Use `PROJECT_TEMPLATE/` as the starting structure for new projects. It includes
vendor-neutral project documentation, agent coordination files and initial
document placeholders. Use `adapters/opencode/` only when a client project
explicitly selects OpenCode.

## Registry And Contracts

`knowledge/REGISTRY.md` is the operational map for choosing agents. It summarizes each agent's responsibility, when to use it, expected inputs, produced artifacts, recommended knowledge files, related workflows and likely next agent.

`PROJECT_TEMPLATE/.ai/contracts.md` defines the dependency chain between project artifacts. In client projects, the copied `.ai/contracts.md` should be checked before workflow selection, agent handoff, artifact creation, review, QA/security validation or Tech Lead governance.

The Engineering Manager is the intake layer before the Orchestrator. It classifies raw user demand, identifies scope, risks, ambiguities and constraints, and produces a `MANAGER_BRIEF`. It does not execute technical work or edit final project files.

## External Library Usage

LF-ENGINEERING-SYSTEM should normally be consumed as an external engineering library from a client project.

Recommended operating model:

1. Keep LF-ENGINEERING-SYSTEM in its own repository or directory.
2. Run the native bootstrap with the desired language and adapter.
3. If OpenCode is selected, configure the generated adapter to reference
   LF-ENGINEERING-SYSTEM files as read-only guidance.
4. Allow agents to edit only the client project by default.
5. Require explicit human confirmation before any change to LF-ENGINEERING-SYSTEM.

## New Project Setup

To start a client project:

1. Run the native bootstrap with `--adapter opencode`.
2. Review the dry-run and apply only missing files.
3. Fill `README.md`, `AGENTS.md` and the initial files in `docs/`.
4. Keep `.ai/` and `.ai/state/` in the project so agents can communicate.
5. Keep this LF-ENGINEERING-SYSTEM directory as the external Framework.

## opencode.jsonc Example

Place an `opencode.jsonc` file in the client project root and adapt paths to your machine:

```jsonc
{
  "$schema": "https://opencode.ai/config.json",

  "instructions": [
    "AGENTS.md",
    "LF_ENGINEERING.md",
    ".ai/workflow.md",
    ".ai/contracts.md",
    ".ai/state/project-summary.md",

    "/absolute/path/to/LF-ENGINEERING-FRAMEWORK/knowledge/INDEX.md",
    "/absolute/path/to/LF-ENGINEERING-FRAMEWORK/knowledge/REGISTRY.md",

    "/absolute/path/to/LF-ENGINEERING-FRAMEWORK/protocols/AGENT_HANDOFF.md",
    "/absolute/path/to/LF-ENGINEERING-FRAMEWORK/protocols/WORKFLOW_UPDATE.md",
    "/absolute/path/to/LF-ENGINEERING-FRAMEWORK/protocols/TASK_UPDATE.md",
    "/absolute/path/to/LF-ENGINEERING-FRAMEWORK/protocols/DECISION_RECORD.md",
    "/absolute/path/to/LF-ENGINEERING-FRAMEWORK/protocols/ARTIFACT_UPDATE.md",
    "/absolute/path/to/LF-ENGINEERING-FRAMEWORK/protocols/PERFORMANCE_VALIDATION.md",

    "/absolute/path/to/LF-ENGINEERING-FRAMEWORK/.opencode/agents/engineering-manager.md",
    "/absolute/path/to/LF-ENGINEERING-FRAMEWORK/.opencode/agents/orchestrator.md",
    "/absolute/path/to/LF-ENGINEERING-FRAMEWORK/.opencode/orchestrator.md"
  ],

  "references": {
    "lf-engineering-framework": {
      "path": "/absolute/path/to/LF-ENGINEERING-FRAMEWORK",
      "description": "Use as the external read-only LF Engineering System framework, including agents, workflows, protocols, schemas and knowledge."
    }
  },

  "permissions": [
    { "action": "edit", "resource": "*", "effect": "ask" },
    { "action": "shell", "resource": "*", "effect": "ask" },
    { "action": "external_directory", "resource": "*", "effect": "ask" },
    { "action": "external_directory", "resource": "/absolute/path/to/LF-ENGINEERING-FRAMEWORK/*", "effect": "allow" },
    { "action": "read", "resource": "/absolute/path/to/LF-ENGINEERING-FRAMEWORK/*", "effect": "allow" },
    { "action": "edit", "resource": "/absolute/path/to/LF-ENGINEERING-FRAMEWORK/*", "effect": "deny" }
  ]
}
```

The `permissions` array uses the OpenCode V2 ordered-rule format. The specific
framework rules come after the broad rules: framework reads are allowed, while
framework edits are denied. Project edits and shell commands remain subject to
confirmation. Do not replace `permissions` with the deprecated V1 `permission`
object when creating a new client project.

OpenCode watches project configuration and normally reloads changes automatically. If the running session does not reflect a configuration change, use `/reload`.

## Protecting The Framework

- Keep framework edits separate from client project work.
- Treat framework paths as references, not workspace targets.
- Put project-specific state only in the client project's `.ai/` directory.
- If an agent needs to change framework rules, stop project execution and request explicit approval.

## Communication Files

- `.ai/workflow.md` records current phase, active agent and next agent.
- `.ai/handoff.md` records transfer of context between agents.
- `.ai/decisions.md` records decisions that affect scope, architecture, quality or delivery.
- `.ai/tasks.md` records executable work and status.
- `.ai/artifacts.md` records generated or maintained project artifacts.
- `.ai/state/current-phase.md` records the current workflow phase.
- `.ai/state/current-agent.md` records active, previous and next agents.
- `.ai/state/project-summary.md` records the concise project state.
- `.ai/state/next-actions.md` records immediate next actions.
- `.ai/state/risks.md` records active risks and mitigations.
