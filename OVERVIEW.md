# LF Engineering System Overview

Languages: [EN-US](OVERVIEW.md) | [PT-BR](locales/pt-BR/public-docs/OVERVIEW.md)

Published baseline: 1.5.0
Status: first public stable release `v1.5.0` published 2026-11-03
Last Updated: 2026-11-03

## Purpose

This document records the current state and public baseline of the LF Engineering System, the publication decisions that shape the repository, and the context for a future graph-based interface.

The LF Engineering System is an AI-assisted software engineering framework composed of:

- Engineering principles and governance.
- Shared knowledge modules.
- Specialized engineering agents.
- Workflows and handoffs.
- Artifact contracts and schemas.
- Project bootstrap templates.
- Vendor-neutral project bootstrap with optional CLI adapters.
- EN-US source documentation and PT-BR translation packs.
- Continuous improvement through project knowledge extraction.

The Framework remains the canonical source of truth. External tools and AI agents are assistants, not authorities.

The first public release, `v1.5.0`, includes the Framework snapshot and the four
maintenance changes made after `v1.4.0` in the predecessor private repository.
That earlier repository's history, branches, tags and assets were not migrated;
`v1.4.0` is historical context and has no tag in this public repository. The
`generic` adapter remains the default, while named CLI adapters remain optional
and contain platform-specific integration only.

## Current State

The repository contains the canonical Framework, specialized agents, knowledge
modules, workflows, protocols, schemas, the vendor-neutral `PROJECT_TEMPLATE/`,
native bootstrap scripts, language packs and optional adapters. `.opencode/` is
Framework-side compatibility source and includes an optional GitHub MCP
configuration that is disabled by default; it is not copied by the bootstrap.
Active public release-context documents and all four approved optional
supplemental Knowledge modules have PT-BR mirrors in the current checkout. The
supplemental mirrors are checked separately for presence, version parity,
approved-optional status and structural parity; they remain outside the mandatory dependency
graph. Approval does not authorize external-tool installation or integration.
The public repository is `LeandroFernandess/LF-Engineering-Framework`; it starts
from one clean root commit on `main`, without the predecessor repository's Git
history, branches or tags.
The independent Goldfish evaluation of the motion-design pilot passed
comprehension with qualifications, while critic and implementation-readiness
checks did not pass; the pilot is not evidence of a successful readiness gate.

The default bootstrap now copies the vendor-neutral project base with native
macOS/Linux shell or Windows PowerShell commands. It accepts explicit `en-US` or
`pt-BR` language selection and defaults to the `generic` adapter. OpenCode
configuration is generated only when `--adapter opencode` is selected; existing
project files and configurations are preserved. The separate Framework-side
GitHub MCP server is disabled by default, pinned to a release, restricted to
read-only repository tools and requires explicit local enablement; it does not
change the client adapter or `generic` path.

The QA-Security Agent now includes a mandatory trust-boundary and prompt-injection gate, an applicability matrix for the requested security categories, and local-state/temporary-artifact privacy checks. These rules distinguish evidence from authority and do not invent vulnerabilities when a surface is absent. Web and visual projects also use `ENGINEERING_DESIGN_PERFORMANCE`, `PERFORMANCE_VALIDATION.md` and separate mobile/desktop acceptance evidence. The predecessor private repository's `v1.4.0` release added conditional `ENGINEERING_MOTION_DESIGN` guidance and a Motion Review for projects that include motion; this does not add a required phase or animation dependency.

Selected practices from the supplemental evaluations informed canonical guidance. This does not claim that each module or complete pilot was independently validated for effectiveness:

- Clarify the problem before generating a solution.
- Classify the demand and select the workflow before specialist execution.
- Require explicit scope, affected files, tests, acceptance criteria, risks and exclusions in non-trivial plans.
- Require human approval before implementation.
- Keep evidence, assumptions, limitations and handoffs explicit.
- Prefer test-first validation when automated tests are available.
- Validate consumer-visible behavior, not only isolated APIs or documentation.
- Keep all four supplemental modules optional; external-tool installation and integration require separate, explicit owner approval.

## Canonical Workflow

```text
User
  -> Engineering Manager
  -> Orchestrator
  -> Prompt Architect (conditional)
  -> Product Owner
  -> Design System Analyst (conditional)
  -> Software Architect
  -> Sprint Planner
  -> Plan approval
  -> Implementation and tests
  -> Code Reviewer
  -> QA/Security
  -> Documentation
  -> Tech Lead and manual validation
  -> Delivery
  -> Knowledge extraction and framework improvement
```

Conditional stages must be recorded explicitly. The Design System Analyst analyzes supplied visual references or prepares an initial direction only when the user/Product Owner explicitly requests it for a visual product without references. That proposal remains optional, is labeled `Proposed` and requires approval before adoption. The Prompt Architect runs when the initial context is raw, ambiguous, incomplete or must be preserved as `PROJECT_BRIEF.md`.

## Canonical Artifacts

```text
Original prompt
  -> PROJECT_BRIEF.md
  -> docs/PRD.md
  -> docs/DESIGN.md (when references exist or an initial direction is explicitly requested)
  -> docs/ARCHITECTURE.md
  -> docs/SPRINTS.md
  -> implementation and tests
  -> REVIEW.md
  -> docs/PERFORMANCE_VALIDATION_REPORT.md (when a web or visual interface exists)
  -> QA_SECURITY_REPORT.md
  -> documentation audit
  -> Tech Lead decision
  -> PROJECT_KNOWLEDGE.md
```

This chain is relative to a client project initialized from
`PROJECT_TEMPLATE/`; the Framework root does not need to contain those client
placeholders.

Each artifact has one owner and one purpose. Downstream artifacts may reference upstream decisions but must not silently redefine them.

## Publication Cleanup Status

### Empty root project artifacts

The root placeholder project artifacts were removed. The
`PROJECT_TEMPLATE/docs/` directory remains the source for client-project
`PRD.md`, `ARCHITECTURE.md` and `SPRINTS.md` files; the Framework root keeps
only real governance and audit documents.

The root `docs/ADR.md` was retained because it contains real Framework
decisions, including the publication-cleanup decision.

### Internal execution state

The root maintainer `.ai/` state and `workflow-graph/` execution data are not
part of the published Framework. The local root-level `workflow-graph/`
directory was removed from this checkout. Client workflow state remains in
`PROJECT_TEMPLATE/.ai/`; private maintainer history is not a runtime dependency
or a public source of truth.

### Continuation prompt

`CONTINUATION_PROMPT.md` was a session continuity artifact rather than a
Framework component and was removed from the publication surface because it
described only eight agents. Current public guidance is maintained in
`README.md`, `README.pt-BR.md`, `START_PROJECTS.en-US.md`,
`locales/pt-BR/public-docs/START_PROJECTS.md` and `OVERVIEW.md`.

### Local dependencies

`.opencode/node_modules/`, `package.json` and `package-lock.json` were local
adapter tooling and were removed from the publication surface. The canonical
`.opencode/` adapter documentation and agent files remain.

## Publication Documentation

### README

The public README is the concise entry point. Keep it current on:

- What the Framework is.
- Who should use it.
- How to bootstrap a client project.
- How agents and artifacts relate.
- What is mandatory, conditional or experimental.
- How the generic bootstrap and optional CLI adapters work.
- How to contribute and report issues.

The README should link to `OVERVIEW.md` for the full architectural and publication context.

### Release status and versioning

The first public `v1.5.0` distribution is published with archives and verified
checksums after exact-tag Ubuntu/macOS/Windows validation. It includes publisher
checkout/tag verification, bootstrap protection against linked parent
directories, owner-only `.ai/state` permissions, the preliminary local security
inspector, and the default Git ignore rule for local project state. The earlier
`v1.4.0` release belonged to the private predecessor repository; no earlier tag
or release assets are present here. Keep entries aligned with actual template,
agent and bootstrap behavior:

- Promoted workflow practices.
- Native multilingual bootstrap and optional CLI adapters.
- Canonical artifact-name corrections.
- Removed duplicate and obsolete references.
- Supplemental tools and named CLI adapters kept optional, with `generic` as the
  default.

The repository publishes one release archive containing both language packs.
The bootstrap selects the project language explicitly; separate language-only
archives are not part of the publication policy.

### Source-of-truth boundaries

The same guidance appears in the Framework, `AGENTS.md`, knowledge modules,
agent documents, adapters, workflows and the EN-US/PT-BR startup guides.

Use these boundaries to reduce future drift:

- `docs/reference/LF_DESIGN_PERFORMANCE_GUIDE.md`: detailed source/reference guide; only
  requirements explicitly adopted in canonical modules, protocols, schemas and
  decisions are operational.
- `knowledge/`: structured guidance for AI consumption.
- `agents/`: responsibilities and specialist behavior.
- `workflows/`: phase sequence and transitions.
- `protocols/`: update formats and handoff rules.
- `schemas/`: artifact structure.
- `adapters/`: optional CLI adapters; `.opencode/` is Framework-side OpenCode
  compatibility source only.
- `PROJECT_TEMPLATE/`: files copied into client projects.
- `README.md`: concise public explanation.

### Automated consistency validation

The repository now provides lightweight native validation commands that check:

- required Framework directories and publication files exist;
- the optional OpenCode adapter is isolated from `PROJECT_TEMPLATE/`;
- operational placeholders occur only in the two expected source files;
- EN-US and PT-BR project-template file sets match;
- template heading outlines, table separators, code fences and HTML comment
  boundaries retain structural parity;
- canonical agent, workflow, protocol, schema and stable Knowledge mirrors, as
  well as the four approved optional supplemental Knowledge mirrors, retain file and
  structural parity in their respective validation groups;
- the shell bootstrap has valid syntax and the optional OpenCode configuration
  parses when a JSON-capable runtime is available.
- the Framework-side GitHub MCP configuration parses and remains disabled by
  default, version-pinned, restricted to repository tools and configured
  read-only; validation does not start Docker or authenticate with GitHub.
- active public `OVERVIEW`, `ROADMAP`, `CHANGELOG` and ADR mirrors retain
  structural parity for heading outlines, tables, code fences and HTML comments.
- one release archive contains both language packs; language selection remains
  an explicit bootstrap choice.

The bootstrap test suites additionally cover dry-run behavior, copy-missing-only
adoption, hidden files, paths with spaces, adapter selection, invalid options,
Framework boundary protection including directory links, and OpenCode
placeholder replacement. Broader repository checks such as Markdown links,
agent structure, secret scanning and `git diff --check` remain release-review
checks rather than claims made by the native Framework validator.

This remains a small validation layer, not a new framework runtime.

## Publication Readiness Checklist

- [x] Decide which root `.ai/` state is public; archive maintainer state outside the root and retain `.ai/` in `PROJECT_TEMPLATE/`.
- [x] Remove empty root `docs/` client artifacts while preserving real ADRs and audit evidence.
- [x] Remove the outdated `CONTINUATION_PROMPT.md`.
- [x] Review `CHANGELOG.md` 1.2.0 against the final security, workflow, performance and cleanup scope.
- [x] Confirm `ROADMAP.md` matches the current version and future priorities.
- [x] Confirm license and author information; contribution policy remains open.
- [x] Add public issue templates for bugs and feature requests.
- [x] Add a pull request template with validation and documentation checks.
- [x] Initialize Git and inspect the complete first commit.
- [x] Confirm ignored local files are not included.
- [x] Validate a fresh project bootstrap on macOS/Linux shell.
- [x] Validate the documented bootstrap through PowerShell on the audit host.
- [x] Confirm the same PowerShell behavior on native Windows through the
  `windows-latest` GitHub Actions runner.
- [x] Validate existing-project adoption against projects with existing docs,
  `.ai/` state and CLI configuration conflicts.
- [x] Add native framework and bootstrap validators with Ubuntu/macOS/Windows CI.
- [x] Add a reproducible release archive/checksum workflow for tagged releases.
- [x] Add bilingual testing documentation and reproducible bootstrap scenarios.
- [x] Preserve the 2026-10-19 security audit as historical evidence and identify
  it as non-current; remove maintainer-specific paths from the public snapshot.
- [x] Translate canonical `workflows/`, `protocols/` and `schemas/` to PT-BR
  with source-version and structural parity checks.
- [x] Complete canonical `agents/` and stable `knowledge/` PT-BR translation
  with source-version and structural parity checks; approved optional
  supplemental modules remain explicitly outside the mandatory locale gate.
- [x] Generate and verify release archives and checksums from a clean clone.
- [x] Verify native Windows execution and the resulting GitHub Actions status.
- [x] Publish the tagged stable `v1.3.0` release after the external gates passed.
- [x] Publish the first clean public snapshot on `main` as `v1.5.0`, without
  migrating the predecessor repository's history, branches or tags.
- [x] Use a GitHub noreply commit identity and inspect the complete public
  snapshot for private paths, credentials and unapproved contact information.
- [x] Ignore client `.ai/state/` by default in generated projects while
  preserving existing projects' `.gitignore` files.
- [x] Enable GitHub Private Vulnerability Reporting and publish the owner-approved
  security contact in `SECURITY.md`.
- [x] Protect `main` with pull-request and cross-platform CI requirements.

## Future Graph Interface

The graph interface should visualize the Framework without becoming a competing source of truth. Markdown, schemas and project artifacts remain authoritative; the graph is a navigation, status and dependency view.

### Suggested graph entities

- Agent.
- Responsibility.
- Workflow.
- Phase.
- Artifact.
- Requirement.
- Task.
- Decision.
- Risk.
- Handoff.
- Acceptance criterion.
- Test.
- Evidence.

### Suggested relationships

```text
Agent --produces--> Artifact
Artifact --depends-on--> Artifact
Agent --hands-off-to--> Agent
Task --implements--> Requirement
Decision --affects--> Artifact
Risk --blocks--> Task
Evidence --validates--> Acceptance Criterion
Test --verifies--> Requirement
```

### Useful interface capabilities

- Display the end-to-end agent pipeline.
- Show the current project phase and active handoff.
- Identify blocked tasks and unresolved risks.
- Navigate from requirement to task, artifact, code, test and decision.
- Filter by agent, project, phase, status or risk.
- Show which rules are mandatory, conditional or proposed.
- Display provenance and validation evidence.
- Preserve an audit trail of changes and approvals.

### Implementation order

1. Stabilize the artifact and task schemas.
2. Define graph node and edge types.
3. Build a read-only graph projection from Markdown and structured files.
4. Add search, filters and dependency traversal.
5. Add status and risk views.
6. Add editing only after source-of-truth and conflict rules are proven.

Avoid starting with authentication, collaboration, semantic extraction, MCP or a large backend. A read-only local viewer is the smallest useful first product.

## Explicit Non-Goals

The following are not currently part of the mandatory Framework:

- Graphify installation or MCP integration.
- AGF as the only task or status system.
- RTK global hooks or telemetry.
- Automatic command rewriting without explicit controls.
- Model-backed semantic code indexing.
- A graph database as a replacement for project artifacts.
- A new agent for every external tool.

Any future adoption requires a scoped pilot, source and version pinning, security/privacy review, measurable value and an explicit Framework decision.

## Current Limitations

- The Framework is a documentation and bootstrap project, not an application;
  it has no product application test runner.
- Supplemental tool evaluations do not replace evidence from real client
  projects.
- The historical provenance of material supplied from `graphiffy.com` remains
  unverified. The official Graphify site states that the domain no longer
  resolves; it is not used as evidence for the approved optional module's tool,
  package or release identity.

## Suggested Next Session

1. Keep the public source-of-truth documents synchronized as the Framework
   evolves.
2. Treat any graph data model as a separate design task.
3. Build a read-only graph prototype only after the schemas are stable and a
   scoped need is approved.
