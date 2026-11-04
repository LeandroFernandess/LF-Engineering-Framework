# Changelog

Languages: [EN-US](CHANGELOG.md) | [PT-BR](locales/pt-BR/public-docs/CHANGELOG.md)

All notable changes to the **LF Engineering Framework** are documented in this file.

This project follows a structured versioning strategy where every release represents a meaningful evolution of the engineering methodology.

Versions before `v1.5.0` below are historical records from the predecessor
private repository. Its Git history, branches, tags and release assets were not
migrated to this clean public repository.

---

# Version 1.5.0

Release Status

Stable; first public release, published 2026-11-03 after cross-platform validation

Release Type

Clean public snapshot and vendor-neutral Framework distribution

## Added

* Published the first clean public snapshot as `LeandroFernandess/LF-Engineering-Framework`.
  No commits, branches or tags from the predecessor private repository were
  imported; `v1.4.0` remains historical and is not a tag in this repository.
* Added a local, read-only preliminary security inspector with redaction and
  symlink regression tests; it does not replace QA-Security review.
* Added GitHub Private Vulnerability Reporting and an authorized public email
  contact to the security policy.

## Changed

* Added `/.ai/state/` to the generated project `.gitignore` so coordination
  state remains local by default. Existing project `.gitignore` files remain
  preserved and require manual adoption of the rule.
* Renamed release archives to `lf-engineering-framework-v<VERSION>` to match the
  public repository and Framework name.
* Updated clone instructions, publication metadata and EN-US/PT-BR release
  baselines for the public repository.

## Fixed

* Checked out the validated release tag in the least-privilege publish job before
  `gh release create --verify-tag`, and verified that its local commit matches
  the tested commit. This fixes publication failure when the job has no Git
  repository while preserving remote tag verification and tag-only triggering.
* Refused bootstrap writes through linked parent directories in a target project,
  preventing template files from being created outside the selected target; added
  shell and PowerShell regression coverage.
* Restricted bootstrap-managed `.ai/state` directories and files to the current
  user (0700/0600 on POSIX and owner-only ACLs on Windows), including existing
  state entries during `--apply` while preserving their contents.

---

# Version 1.4.0

Release Status

Historical predecessor-repository release; published 2026-11-01; no public tag or release assets were migrated

Release Type

Vendor-neutral distribution

## Added

* Added an opt-in, read-only technical debt audit workflow, schema and client
  report template with evidence, counter-evidence, effort and prioritization
  requirements.
* Added PT-BR mirrors for the technical-debt audit workflow, schema and client
  report template, and synchronized the affected project template, quality
  guidance, registries and agent knowledge.
* Added an optional, explicitly requested initial visual-direction proposal path
  to the existing Design System Analyst and DESIGN.md artifacts, with evidence
  classification, approval and existing-token safeguards.
* Added conditional `ENGINEERING_MOTION_DESIGN` guidance for motion intent,
  choreography, reduced-motion behavior, implementation neutrality and
  evidence-based review; updated the design handoff and performance report.
* Added synchronized PT-BR guidance for the optional visual-direction proposal
  path; no external catalogs were copied.
* Added conditional quality checks for AI workflows, resource-level
  authorization and confirmation of consequential external actions, plus a
  conditional API integration checklist in the existing Field Guide.
* Synchronized the new quality, QA-Security and API guidance in PT-BR; no new
  module, agent, dependency, CLI or mandatory workflow phase was added.
* Approved four supplemental Knowledge modules as optional references in the
  `v1.4.0` release, with explicit limits against mandatory adoption and
  external-tool installation or integration.
* Added the independent Elephant-Goldfish evaluation record: fresh-session
  comprehension passed with qualifications; critic and implementation-readiness
  checks did not pass. No successful-pilot or production-readiness claim is made.

## Changed

* Strengthened quality guidance for file-transforming tool operations and
  rendered visual artifact review; structural validation alone is not visual
  approval.
* Withdrew the proposed supplemental user-research module before release after
  a documentation-only simulation; no real-participant pilot was conducted.
* Kept the default development sequence, Framework release version and
  vendor-neutral dependency surface unchanged. Recorded the selective adoption
  in ADR-006, the module withdrawal in ADR-007 and visual-direction guidance in
  ADR-008, AI workflow, authorization and API guidance in ADR-009, and the
  optional GitHub MCP boundary in ADR-011; motion design adoption is recorded in
  ADR-013. No CLI, runtime dependency, required external skill or mandatory
  workflow phase was added to the default `generic` path.
* Made canonical agent specifications and execution profiles model- and
  harness-neutral; platform-specific integration remains in optional adapters.
* Updated EN-US/PT-BR module status, indexes, registries and locale validation to
  reflect approved optional adoption while retaining the mandatory dependency
  graph, `generic` default and published `v1.3.0` unchanged.
* Versioned the updated Knowledge modules and added locale checks for matching
  versions on the four approved optional mirrors.
* Kept the Framework-side GitHub MCP configuration optional and disabled by
  default; when explicitly enabled, it uses a pinned image, a read-only
  MCP tool surface and a loopback OAuth callback. It is not copied to client
  projects.
* Separated PT-BR coverage of the published `v1.3.0` tag from translations of
  post-tag changes, and aligned the PowerShell validator with the `1.3.0`
  translation baseline.
* Updated Graphify identity and provenance evidence, including the official-site
  distinction for `graphiffy.com`; the module is approved optional, but
  source-to-build provenance remains unresolved and no further tool use is
  authorized.
* Hardened tagged releases with strict stable-tag validation, tested-commit
  verification, cross-platform CI gating, read-only packaging and least-privilege
  publication. By owner decision, publication does not use a GitHub Environment
  or manual reviewer gate: pushing a matching stable release tag publishes
  automatically after validation. The tag push requires separate owner
  authorization and is the workflow's only release trigger. Because this is a
  single-owner repository, branch/tag rulesets are not required; owner-only
  write/admin access and separate authorization before pushing a tag are the
  operational controls. Reassess if write access expands.
* Extended the Windows PowerShell bootstrap regression suite to verify that
  omitting `-Adapter` selects the `generic` default.
* Clarified that release archive generation is not exercised by local validators
  and is gated on the cross-platform checks for the tagged commit.
* Aligned setup examples and roadmap status with the published `v1.3.0` baseline.
* Identified the 2026-10-19 security audit PDF as historical evidence; its date
  and findings are not presented as a current audit.
* Aligned the historical security audit PDF cover status with the conclusion in
  its executive summary; the snapshot remains dated 2026-10-19.
* Defined translation scope and authority boundaries in ADR-012; added PT-BR
  mirrors for the active public overview, roadmap, changelog, ADR records and all
  four supplemental Knowledge modules. Dedicated locale checks require the
  supplemental mirrors and validate their approved-optional status and structure
  without adding them to the mandatory dependency graph.
* Grouped translated public documents under `locales/pt-BR/` and updated locale
  parity validation. Recorded the EN-US source and PT-BR mirror layout in
  ADR-015.
* Removed root-level PT-BR compatibility aliases and the superseded legacy
  framework manuscript. Moved the design/performance source guide to
  `docs/reference/` because canonical Knowledge cites its rationale; updated
  validators and the audit generator without rewriting the historical PDF.
* Kept a single release archive containing both language packs; the bootstrap
  continues to select the project language explicitly.

---

# Version 1.3.0

Release Status

Stable

Release Type

Vendor-neutral distribution

---

## Added

* Added native macOS/Linux and Windows PowerShell bootstrap scripts with safe
  dry-run and copy-missing-only behavior for new and existing projects.
* Added explicit `en-US`/`pt-BR` language selection and translation coverage
  metadata.
* Added optional `generic`, `codex`, `claude`, `gemini` and `opencode` adapters.
* Added the vendor-neutral `LF_ENGINEERING.md` project entrypoint and a
  translated PT-BR project template.
* Added native Framework/bootstrap validators, reproducible bootstrap tests and
  a GitHub Actions matrix for Ubuntu, macOS and Windows.
* Added contribution, security, issue and pull-request guidance in EN-US and
  PT-BR.
* Added bilingual testing documentation covering the local and CI test matrix.
* Added structural PT-BR template parity checks for heading outlines, tables,
  code fences and HTML comment boundaries.
* Added PT-BR translations for the canonical workflows, protocols and schemas,
  with structural parity validation.
* Added PT-BR translations for the canonical agent documentation and stable
  Knowledge modules, with mirrored file and structural parity validation.
* Updated GitHub Actions checkout steps to `actions/checkout@v5` for the Node.js
  24 runtime.
* Made placeholder validation deterministic across runner locales and hardened
  PowerShell boundary resolution at filesystem roots.
* Made the Windows bootstrap preservation assertion accept native path
  separators.
* Added symlink/junction boundary regression tests for the native bootstraps so
  Framework paths cannot be reached through directory links.
* Added a reproducible tagged-release workflow that creates archives and
  SHA-256 checksums.
* Refreshed the regenerable security audit for the vendor-neutral template,
  current OpenCode V2 adapter and copy-missing-only bootstrap.
* Removed maintainer-specific filesystem paths from published knowledge examples.

## Changed

* Made `generic` the default bootstrap mode; OpenCode is no longer required by
  `PROJECT_TEMPLATE/`.
* Documented EN-US as the technical source language and PT-BR as a synchronized
  translation.
* Aligned the canonical workflow and legacy playbook with
  `Implementation / selected CLI` instead of a provider-specific implementation.

## Scope note

The canonical `agents/` and stable `knowledge/` library now have mirrored PT-BR
translations. The four supplemental proposed Knowledge evaluations remain
outside the mandatory locale gate and are called out explicitly in the
translation status. Legacy Portuguese `SPECS.md` prompts are mirrored as
configuration artifacts rather than represented as English source translations.
Native Windows execution, authenticated repository/Actions verification and
release archives/checksums were confirmed for the stable `v1.3.0` release.

---

# Version 1.2.0

Release Status

Review

Release Type

Security, Workflow, Performance and Publication Cleanup

---

## Added

* QA-Security trust-boundary and prompt-injection gate.
* Security applicability matrix for injection, XSS, identity/access, secrets and deployment/configuration.
* Local-state, temporary-artifact, retention and filesystem-permission checks.
* ADR-001 documenting the Framework boundary, bootstrap and local-state decision.
* Conditional design-performance workflow for web and visual projects, with
  separate mobile/desktop validation and a reusable report protocol.

## Changed

* Migrated the client template from the deprecated V1 `permission` object to
  ordered OpenCode V2 `permissions` rules.
* Framework reads are allowed for client projects while Framework edits are
  denied by the template.
* macOS and PowerShell bootstrap now refuse non-empty targets, preserve hidden
  template files, escape paths, validate JSON and replace only generated config.
* Added root and template ignore rules for local workflow and validation caches.
* Restricted the current `workflow-graph/` state to owner-only Unix modes.
* Added `ENGINEERING_DESIGN_PERFORMANCE`,
  `PERFORMANCE_VALIDATION.md`, the performance report schema/template and
  route/profile acceptance checkpoints across the workflow.
* Cleaned the publication surface by removing root client placeholders,
  outdated continuity material, local OpenCode dependencies, generated Python
  cache and archived maintainer/workflow-graph state outside the root while
  preserving the client template and audit evidence.
* Added native macOS/Linux and Windows PowerShell dry-run and copy-missing-only
  adoption commands for existing projects; existing project files and OpenCode
  configuration are preserved.

## Notes

Existing client projects can use the safe adoption commands, but must still
migrate or manually merge an existing OpenCode configuration separately.
Native Windows execution remains a follow-up because validation used
cross-platform PowerShell on the audit host.

---

# Version 1.1.0

Release Status

Stable

Release Type

Minor Framework Evolution

---

## Added

### AI Agents

Added two new specialized engineering agents:

* Design System Analyst Agent
* Engineering Knowledge Extractor Agent

Each Agent includes:

* README
* CONTEXT
* KNOWLEDGE
* CONFIGURATION
* SPECS
* CHANGELOG

### Design System Analyst Agent

* Analyzes visual references (screenshots, mockups, interfaces) and produces structured engineering documentation.
* Primary artifact: DESIGN.md.
* Positioned conditionally between Product Owner and Software Architect.
* Covers: visual identity, color palette, typography, spacing, layout, components, interactions, accessibility, design tokens, frontend implementation considerations.

### Engineering Knowledge Extractor Agent

* Transforms completed projects into reusable engineering knowledge.
* Primary artifact: PROJECT_KNOWLEDGE.md.
* Positioned after Tech Lead delivery approval.
* Covers: project summary, technical stack, engineering decisions, new technologies, new engineering knowledge, Framework improvement recommendations.

### Schemas

* DESIGN.schema.md
* PROJECT_KNOWLEDGE.schema.md

### OpenCode Adapters

* `.opencode/agents/design-system-analyst.md`
* `.opencode/agents/engineering-knowledge-extractor.md`

### Documentation Updates

* Updated AGENT_INTERACTION_MAP.md with both new agents, new pipeline, new handoff rules and new decision points.
* Updated knowledge/REGISTRY.md with both new agents.
* Updated knowledge/INDEX.md with new primary consumers.
* Updated .ai/contracts.md with DESIGN.md and PROJECT_KNOWLEDGE.md.
* Updated workflows/STANDARD_DEVELOPMENT.md with both new agents.
* Updated .opencode/orchestrator.md with both new agents and selection rules.
* Updated ROADMAP.md with v1.1 deliverables.

---

## Changed

None.

All changes are additive. No existing behavior has been altered.

---

## Removed

None.

---

## Notes

Version 1.1.0 introduces two new specialized agents while preserving full backward compatibility with v1.0.0.

The Design System Analyst is conditional — it runs only when visual references exist.

The Engineering Knowledge Extractor is post-delivery — it does not gate delivery and its recommendations require human review.

All existing agents, workflows, knowledge modules and governance rules remain unchanged.

---

# Future Releases

Subsequent versions should document only completed engineering changes.

Planned ideas belong in the `ROADMAP.md` document.

The CHANGELOG should remain a historical record of implemented improvements only.

---

# Version 1.0.0

Release Status

Stable

Release Type

Initial Framework Release

---

## Added

### Engineering Foundation

* Initial release of the LF Engineering Framework.
* Engineering philosophy and core principles.
* Standardized AI-assisted engineering workflow.
* Framework governance model.
* Versioning strategy.

### Knowledge System

* Complete Engineering Knowledge architecture.
* Engineering Foundations module.
* Engineering Workflow module.
* Engineering Standards module.
* Engineering Quality module.
* Engineering Decisions module.
* Engineering Artifacts module.
* Engineering Templates module.
* Engineering Continuous Improvement module.
* Engineering AI Collaboration module.
* Engineering Agent Guidelines module.
* Engineering Field Guide module.

### AI Agents

Added the first official specialized engineering agents:

* Prompt Architect Agent
* Product Owner Agent
* Software Architect Agent
* Sprint Planner Agent
* Code Reviewer Agent
* Quality Assurance & Security Agent
* Documentation & Technical Writer Agent
* Tech Lead Agent

Each Agent includes:

* README
* CONTEXT
* KNOWLEDGE
* CONFIGURATION
* CHANGELOG

### Documentation

* Root project documentation.
* Agent Interaction Map.
* Framework documentation.
* Roadmap.
* Repository organization.

---

## Changed

None.

This is the initial public release.

---

## Removed

None.

---

## Notes

Version 1.0.0 establishes the first complete implementation of the LF Engineering Framework.

This release focuses on creating a structured engineering methodology supported by specialized AI Agents and a shared engineering knowledge base.

Future versions will prioritize refinement over expansion, preserving the framework's simplicity and maintainability.

---

# Future Releases

Subsequent versions should document only completed engineering changes.

Planned ideas belong in the `ROADMAP.md` document.

The CHANGELOG should remain a historical record of implemented improvements only.
