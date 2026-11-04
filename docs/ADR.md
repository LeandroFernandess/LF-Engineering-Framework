# Architecture Decision Records

Languages: [EN-US](ADR.md) | [PT-BR](../locales/pt-BR/docs/ADR.md)

Public baseline: `v1.5.0`. ADR-001 through ADR-018 are retained as historical
decisions from the predecessor private repository; references to its releases
are archival context only, and no predecessor Git tags were imported.

## ADR Index

| ID | Title | Status | Date |
| -- | ----- | ------ | ---- |
| ADR-001 | Segurança de fronteira do Framework e estado local | Accepted | 2026-10-18 |
| ADR-002 | Gate de design e performance mobile/desktop | Accepted | 2026-10-18 |
| ADR-003 | Limpeza da superfície pública do Framework | Accepted | 2026-10-18 |
| ADR-004 | Adoção segura de projetos existentes | Accepted | 2026-10-18 |
| ADR-005 | Distribuição neutra, multilíngue e por adapters | Accepted | 2026-10-19 |
| ADR-006 | Adoção seletiva de práticas de qualidade e pesquisa com usuários | Accepted (partially superseded) | 2026-10-29 |
| ADR-007 | Retirada do módulo suplementar proposto de pesquisa com usuários | Accepted | 2026-10-31 |
| ADR-008 | Adoção seletiva de práticas de direção visual | Accepted | 2026-10-31 |
| ADR-009 | Adoção seletiva de controles de workflow de IA, autorização e APIs | Accepted | 2026-10-31 |
| ADR-010 | Especificações de agentes neutras e alinhamento da publicação | Accepted | 2026-10-31 |
| ADR-011 | Integração opcional e somente leitura do GitHub MCP no OpenCode | Accepted | 2026-11-01 |
| ADR-012 | Escopo de tradução e classificação de referências públicas | Accepted (partially superseded by ADR-014 and ADR-016) | 2026-11-01 |
| ADR-013 | Adoção seletiva de motion design e validação visual | Accepted | 2026-11-01 |
| ADR-014 | Adoção opcional dos quatro módulos suplementares | Accepted | 2026-11-01 |
| ADR-015 | Organização da fonte EN-US e dos documentos PT-BR | Accepted (compatibility policy superseded by ADR-016) | 2026-11-01 |
| ADR-016 | Remoção de referências legadas e caminhos de compatibilidade | Accepted | 2026-11-01 |
| ADR-017 | Publicação de releases sem GitHub Environment | Accepted (branch-protection policy superseded by ADR-019) | 2026-11-01 |
| ADR-018 | Inspeção dinâmica local e independência do nome do checkout | Accepted | 2026-11-01 |
| ADR-019 | Repositório público limpo e primeira release pública | Accepted | 2026-11-03 |
| ADR-020 | Estado `.ai/state/` local e ignorado por padrão | Accepted | 2026-11-03 |

## Records

## ADR-001 - Segurança de fronteira do Framework e estado local

### Status

Accepted

### Date

2026-10-18

### Context

The security audit found that the client template used the deprecated V1
permission object with an advisory `ask` rule for the external Framework,
Windows bootstrap substitution could produce invalid JSONC, bootstrap copying
could overwrite an existing project, and generated local workflow state was
world-readable. The audit also found that the QA-Security agent did not have an
explicit trust-boundary and prompt-injection gate.

### Decision

Use OpenCode V2 ordered permissions in the optional OpenCode adapter: allow the
client to read the external Framework and deny edits to it. Keep the default
bootstrap vendor-neutral, copy only missing files, escape platform-specific
paths and generate OpenCode configuration only when that adapter is selected.
Treat local workflow state as sensitive and require owner-only modes where
supported. Make the QA-Security trust-boundary, applicability and evidence gates
mandatory.

### Alternatives Considered

- Keep the V1 `permission` object and rely on interactive approval.
- Keep `ask` for Framework edits and document the boundary only.
- Add a destructive `--force` bootstrap option.
- Delete generated workflow state immediately after the audit.

### Consequences

New client projects receive a stronger read-only Framework boundary and a
non-destructive bootstrap, while existing client projects must migrate their
configuration separately. Local state remains available as evidence but is
protected from other local users where the host supports Unix modes. The
QA-Security agent can mark categories not applicable and must not elevate
instructions embedded in project content. Native Windows execution and
client-project migration remain validation follow-ups.

### Related Artifacts

- `adapters/opencode/opencode.jsonc`
- `locales/pt-BR/public-docs/START_PROJECTS.md`
- `.opencode/README.md`
- `agents/QA-Security/SPECS.md`
- `knowledge/ENGINEERING_QUALITY.md`
- `knowledge/ENGINEERING_AGENT_GRAPH_FLOW.md`
- `.gitignore`
- `PROJECT_TEMPLATE/.gitignore`
- `scripts/bootstrap.sh`, `scripts/bootstrap.ps1` and their regression tests
- `docs/security-audit/relatorio-auditoria-seguranca.pdf`

## ADR-002 - Gate de design e performance mobile/desktop

### Status

Accepted

### Date

2026-10-18

### Context

The supplied `docs/reference/LF_DESIGN_PERFORMANCE_GUIDE.md` defines design and performance
practices for web and visual systems. The existing workflow had a generic
performance gate but did not require route coverage, separate mobile and
desktop evidence, reproducible runs, budgets, responsive design handoff or a
field-data limitation decision.

### Decision

Adopt `knowledge/ENGINEERING_DESIGN_PERFORMANCE.md` as the conditional
knowledge module for web and visual projects. Add
`protocols/PERFORMANCE_VALIDATION.md`, its schema and the client report
template. Require the guide's checkpoints from product definition through Tech
Lead approval: critical routes, mobile/desktop profiles, candidate LCP,
budgets, five comparable valid runs, medians, journeys, manual accessibility
and explicit RUM/CrUX status. Use median Performance `>= 91` as the starting
minimum and `95` as the target, with traceable exceptions; do not claim a fixed
score or application-wide approval from incomplete evidence.

### Alternatives Considered

- Keep the generic performance gate and leave measurement to each project.
- Make PageSpeed 95 a universal hard block regardless of route or product.
- Measure only the home page or only the mobile profile.
- Require the protocol for APIs, CLIs and non-visual systems.

### Consequences

Future web and visual projects receive performance requirements before
implementation and a separate mobile/desktop delivery gate without selecting a
frontend framework or hosting provider. The process adds a conditional report
and five-run measurement cost. Projects may adjust budgets only with evidence,
owner, mitigation and review date. Non-visual projects record the skip instead
of inventing browser metrics.

### Related Artifacts

- `docs/reference/LF_DESIGN_PERFORMANCE_GUIDE.md`
- `knowledge/ENGINEERING_DESIGN_PERFORMANCE.md`
- `protocols/PERFORMANCE_VALIDATION.md`
- `schemas/PERFORMANCE_VALIDATION_REPORT.schema.md`
- `PROJECT_TEMPLATE/docs/PERFORMANCE_VALIDATION_REPORT.md`
- `workflows/NEW_PROJECT.md`
- `workflows/STANDARD_DEVELOPMENT.md`
- `knowledge/ENGINEERING_WORKFLOW.md`
- `knowledge/ENGINEERING_QUALITY.md`

## ADR-003 - Limpeza da superfície pública do Framework

### Status

Accepted

### Date

2026-10-18

### Context

The Framework root contained client-project placeholders (`docs/PRD.md`,
`docs/ARCHITECTURE.md` and `docs/SPRINTS.md`), an outdated continuity prompt,
local OpenCode dependency installation and generated workflow/Python cache
state. These files were not required by the canonical Framework workflow and
could confuse publication boundaries or expose local execution history.

### Decision

Prepare the root as a public Framework surface: preserve canonical agents,
knowledge, workflows, protocols, schemas, adapters, `PROJECT_TEMPLATE/`, real
Framework ADRs, the security-audit evidence and the design-performance source
guide. Archive the root maintainer `.ai/` state and `workflow-graph/` state in a
restricted external backup, then remove them from the publication root together
with the client placeholders, outdated continuity prompt, local OpenCode
dependency files/installation and generated Python cache. Keep the client
project `.ai/` state and all project placeholders inside `PROJECT_TEMPLATE/`.

### Alternatives Considered

- Publish the full root `.ai/` and workflow-graph history as dogfooding evidence.
- Delete generated state without an external archive.
- Keep root client placeholders and ask readers to distinguish them from the
  template manually.
- Remove the entire `.opencode/` adapter directory.

### Consequences

The public root becomes smaller and its source-of-truth boundaries are clearer;
client workflow state remains available through `PROJECT_TEMPLATE/`. The local
archive preserves recovery and audit traceability but is not part of the public
repository. A future clean bootstrap must be validated again, and local OpenCode
dependencies can be reinstalled from the adapter package metadata if that
metadata is retained or recreated by a maintainer.

### Related Artifacts

- `OVERVIEW.md`
- `README.md`
- `AGENTS.md`
- `PROJECT_TEMPLATE/`
- `.opencode/`
- `docs/security-audit/`
- `.gitignore`

## ADR-004 - Adoção segura de projetos existentes

### Status

Accepted

### Date

2026-10-18

### Context

The original bootstrap correctly refused non-empty directories to prevent
overwriting an existing project. That protection also meant a project with code,
documents or a `.git` directory could not adopt the Framework's missing
coordination files. Removing the preflight would create an unsafe merge path and
could replace project-owned `AGENTS.md`, documents or OpenCode configuration.

### Decision

Keep a single non-destructive native bootstrap for new and existing projects.
The macOS/Linux command uses portable shell file iteration; the Windows command
uses PowerShell file iteration. Both provide a dry-run, copy only missing files,
never replace existing project files, preserve existing `AGENTS.md`, `.gitignore`,
documents, `.ai/` state and CLI configuration, generate adapter files only when
absent, and refuse paths inside the Framework.

### Alternatives Considered

- Remove the non-empty-directory preflight and copy the template over the project.
- Automatically merge existing `opencode.jsonc` and `AGENTS.md`.
- Require users to copy individual files manually without a dry-run report.

### Consequences

New projects retain a non-destructive, reproducible bootstrap. Existing projects
can adopt missing Framework structure without losing project-owned files. Config
and agent-instruction conflicts remain an explicit manual migration task because
generic automatic merging cannot safely preserve arbitrary project settings.

### Related Artifacts

- `locales/pt-BR/public-docs/START_PROJECTS.md`
- `PROJECT_TEMPLATE/`
- `scripts/bootstrap.sh`
- `scripts/bootstrap.ps1`
- `AGENTS.md`

## ADR-005 — Distribuição neutra, multilíngue e por adapters

### Status

Accepted

### Date

2026-10-19

### Context

The Framework is intended for public download and must work for users who choose
different AI assistants, operating systems and human languages. Making OpenCode
the required bootstrap path would create an avoidable vendor dependency. Mixing
translated files without a selection contract would also make it unclear which
documentation a project received.

### Decision

Make `generic` the default adapter and keep the project template independent of
any AI vendor. Provide native shell and PowerShell bootstraps with explicit
`en-US`/`pt-BR` language selection and optional `codex`, `claude`, `gemini` and
`opencode` adapters. EN-US is the technical source language; PT-BR is a
versioned translation with coverage metadata. The bootstrap copies only missing
files, records the selected language and adapter when possible, and leaves the
canonical Framework external and read-only.

### Alternatives Considered

- Require OpenCode as the universal runtime.
- Install every vendor adapter into every project.
- Infer the language from the host or AI provider.
- Claim full PT-BR parity before translating the canonical library.

### Consequences

Users can download the repository or a release and start with a generic CLI
without runtime dependencies. Vendor-specific configuration is opt-in and can
be reviewed independently. Translation work requires source-version tracking
and structural parity checks. The canonical library remains external, so an AI
assistant must be given access to the Framework path or a future packaged
library copy.

### Related Artifacts

- `scripts/bootstrap.sh`
- `scripts/bootstrap.ps1`
- `PROJECT_TEMPLATE/LF_ENGINEERING.md`
- `adapters/`
- `locales/`
- `locales/pt-BR/public-docs/START_PROJECTS.md`
- `START_PROJECTS.en-US.md`

## ADR-006 - Adoção seletiva de práticas de qualidade e pesquisa com usuários

### Status

Accepted

### Date

2026-10-29

### Context

An individual review of 20 external Skills repositories identified useful
practices for technical-debt review, safe tool operations, visual artifact
verification and user research. Importing Skills, dependencies or entire
workflows would add vendor/tool coupling, duplicate existing Framework guidance
and make optional work appear mandatory. The Framework already covers code
knowledge graphs, design-first collaboration and web/visual performance in
separate modules.

### Decision

Adopt only the reusable principles that fit the existing Framework boundaries:

- Extend `ENGINEERING_QUALITY` with evidence-based verification for
  file-transforming operations and rendered visual artifacts.
- Add a separate, read-only technical-debt audit workflow, schema and optional
  client report template. Run it only on explicit request or approved
  maintenance; have Tech Lead prioritize findings before they become sprint
  work.
- Add `ENGINEERING_USER_RESEARCH` as a proposed supplemental module. Consider it
  only when consequential user uncertainty could change product decisions and
  existing evidence is insufficient. Reference evidence and limitations in
  existing PRD sections; do not add a mandatory research artifact or workflow
  gate.
- Keep EN-US as the source, synchronize PT-BR, install no Skills or external
  dependencies, and do not duplicate `ENGINEERING_GRAPHIFY`,
  `ENGINEERING_ELEPHANT_GOLDFISH` or `ENGINEERING_DESIGN_PERFORMANCE`.

### Alternatives Considered

- Import external Skills or add their runtime/tool dependencies to the
  vendor-neutral core.
- Make technical-debt audits or user research mandatory for every project.
- Add a required standalone user-research report.
- Duplicate existing graph, collaboration or design-performance guidance.
- Defer all changes despite specific, reusable quality gaps.

### Consequences

The default development sequence remains unchanged. Teams gain an opt-in,
traceable technical-debt audit and clearer evidence requirements for transformed
and visual artifacts. At the time, user-research guidance was Proposed,
supplemental and conditional until human review and a scoped pilot; a PT-BR
translation did not promote it into the stable dependency graph. The additions
created documentation and translation maintenance but no new runtime
dependencies. This decision was recorded as unreleased work and did not change
the Framework release version.
The proposed user-research module was later withdrawn before release by ADR-007;
the other decisions in this record remain in force.

### Related Artifacts

- `knowledge/ENGINEERING_QUALITY.md`
- `knowledge/ENGINEERING_ARTIFACTS.md`
- `knowledge/ENGINEERING_TEMPLATES.md`
- `knowledge/ENGINEERING_USER_RESEARCH.md`
- `knowledge/INDEX.md`
- `knowledge/REGISTRY.md`
- `workflows/TECH_DEBT_AUDIT.md`
- `schemas/TECH_DEBT_AUDIT.schema.md`
- `PROJECT_TEMPLATE/docs/TECH_DEBT_AUDIT.md`
- `PROJECT_TEMPLATE/.ai/contracts.md`
- `PROJECT_TEMPLATE/.ai/artifacts.md`
- `workflows/NEW_PROJECT.md`
- `workflows/STANDARD_DEVELOPMENT.md`
- `schemas/PRD.schema.md`
- `agents/`
- `locales/pt-BR/`

## ADR-007 - Retirada do módulo suplementar proposto de pesquisa com usuários

### Status

Accepted

### Date

2026-10-31

### Context

The proposed `ENGINEERING_USER_RESEARCH` module was exercised only through a
documentation-only simulation with a fictional scenario and synthetic fixtures.
The targeted process checks passed, but no participants were recruited and no
real user evidence or research outcomes were evaluated. The simulation therefore
did not satisfy the proposed pilot condition or justify retaining the module as
an active supplemental reference.

### Decision

- Withdraw the proposed user-research module before release and remove its EN-US
  and PT-BR files and active references from the Knowledge indexes, agent
  registry, Product Owner knowledge and workflows.
- Retain general PRD guidance to record the scope and limitations of evidence
  that informs product decisions, avoid identifying participant data, and not
  require a separate research report.
- Reconsider a dedicated module only through a new proposal and an appropriately
  scoped, approved pilot with real participants.

### Alternatives Considered

- Keep the module Proposed while awaiting a real-participant pilot.
- Promote it based on the synthetic workflow simulation.
- Remove all general PRD evidence-traceability guidance along with the module.

The first alternative would retain maintenance and active discovery for guidance
that has not completed its pilot. The second would overstate what synthetic
fixtures can validate. The third would unnecessarily remove useful, general PRD
traceability guidance.

### Consequences

The module is no longer available as an active Framework reference and is not
included in the release surface. Product teams may still record relevant user
evidence and its limitations in the PRD without treating research as a mandatory
phase or artifact. The user-research portion of ADR-006 is superseded; its other
decisions remain in force.

### Related Artifacts

- `knowledge/ENGINEERING_USER_RESEARCH.md` (withdrawn)
- `locales/pt-BR/knowledge/ENGINEERING_USER_RESEARCH.md` (withdrawn)
- `knowledge/INDEX.md`
- `knowledge/REGISTRY.md`
- `agents/Product-Owner/KNOWLEDGE.md`
- `workflows/NEW_PROJECT.md`
- `workflows/STANDARD_DEVELOPMENT.md`
- `schemas/PRD.schema.md`
- `PROJECT_TEMPLATE/docs/PRD.md`
- `CHANGELOG.md`

## ADR-008 - Adoção seletiva de práticas de direção visual

### Status

Accepted

### Date

2026-10-31

### Context

The Design System Analyst currently documents visual references, while some
visual products begin without screenshots or mockups. UI UX Pro Max v2.15.0
(`bf41cbc3ce63e30c922e58ef48741ba6133f9aa9`, 2026-10-31) demonstrates useful
practices for composing and governing design recommendations, but its catalogs
and heuristics do not establish the needs or preferences of a project's users.
The LF Framework already defines responsive behavior, accessibility, performance,
interaction states and design tokens; importing another full skill would
duplicate policy and add maintenance or runtime dependencies.

### Decision

- Extend the existing Knowledge module, Design System Analyst, workflows,
  contracts, schema and `DESIGN.md` template; do not create a new Knowledge
  module.
- Allow an initial visual direction without references only when the user or
  Product Owner explicitly requests it for a visual product. Keep it optional,
  separate from reference-based observations, classify it as `Proposed` and
  require approval before it becomes an implementation baseline.
- Classify design statements as `Observed`, `Derived`, `Proposed` or
  `Unverified`, state their basis and do not present heuristics as user research,
  preference, demand or usability validation.
- Preserve approved design tokens as the source of truth. Document page-specific
  overrides only when necessary, with scope, basis, rationale and approval.
- Keep accessibility, responsiveness, performance and functionality as existing
  gates. Do not add a CLI, dependency, copied external catalog or mandatory
  proposal step.
- Synchronize the affected EN-US and PT-BR documents.

### Alternatives Considered

- Import UI UX Pro Max and its CLI/catalogs into the Framework.
- Keep the Design System Analyst limited to references, even when an initial
  direction is explicitly requested.
- Generate a direction for every visual project without references by default.

The first option adds maintenance, stack-specific content and runtime surface
that the Framework does not need. The second prevents a useful, requested
handoff. The third turns a heuristic proposal into unnecessary default work and
risks implying evidence that does not exist.

### Consequences

Projects can request an initial visual direction without presenting it as
observed or user-validated design. Approved systems remain authoritative, and
exceptions stay scoped. This adds documentation and translation maintenance but
no runtime dependency. The Framework release version and default development
sequence remain unchanged.

### Related Artifacts

- `knowledge/ENGINEERING_DESIGN_PERFORMANCE.md`
- `knowledge/ENGINEERING_ARTIFACTS.md`
- `knowledge/REGISTRY.md`
- `agents/Design-System-Analyst/`
- `agents/AGENT_INTERACTION_MAP.md`
- `workflows/NEW_PROJECT.md`
- `workflows/STANDARD_DEVELOPMENT.md`
- `schemas/DESIGN.schema.md`
- `PROJECT_TEMPLATE/.ai/contracts.md`
- `PROJECT_TEMPLATE/docs/DESIGN.md`
- `.opencode/`
- `locales/pt-BR/`
- External reference: [UI UX Pro Max v2.15.0](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill/tree/bf41cbc3ce63e30c922e58ef48741ba6133f9aa9)
- `CHANGELOG.md`

## ADR-009 - Adoção seletiva de controles de workflow de IA, autorização e APIs

### Status

Accepted

### Date

2026-10-31

### Context

A review of ten external repositories identified reusable practices for
evaluating AI workflows, enforcing authorization at the resource boundary,
confirming consequential external actions and designing API integrations. The
Framework already has a conditional security and AI trust gate, a QA-Security
Agent and a practical engineering field guide. Importing complete products,
dependencies or CLIs, or making AI/API work a mandatory phase, would expand the
Framework beyond the approved scope and create unnecessary maintenance.

The review also found specific guidance for video, voice and OSINT use cases that
is not broadly applicable to the Framework. Fincept's licensing information is
inconsistent across its repository materials, so reuse cannot be evaluated
reliably until that discrepancy is clarified.

### Decision

- Extend the existing `ENGINEERING_QUALITY` and QA-Security guidance with
  conditional evaluation of AI workflows and tool permissions. When applicable,
  verify least privilege, authorization for the specific resource and tenant,
  denied-access paths, and protection against untrusted input.
- Require explicit, current confirmation before consequential external side
  effects, unless a documented policy authorizes bounded, pre-approved
  automation. Bind approval to the exact action and target; read-only calls do
  not require per-request confirmation.
- Add an API integration checklist to the existing `ENGINEERING_FIELD_GUIDE`,
  covering authoritative contracts and versions, authentication and resource
  authorization, bounded retries/idempotency, limits, data minimization,
  webhook validation, failure behavior and proportionate testing.
- Keep these checks conditional on the project having the relevant AI workflow,
  access-controlled operation, external side effect or API integration. Do not
  add modules, agents, products, dependencies, CLIs or mandatory workflow phases.
- Synchronize affected EN-US and PT-BR documents. Defer specialized video, voice
  and OSINT guidance, and do not reuse Fincept-specific material until its
  licensing discrepancy is resolved.

### Alternatives Considered

- Import complete external repositories, products, dependencies or CLIs.
- Add a mandatory AI workflow evaluation or API integration phase to every
  project.
- Defer all selected practices until the Framework creates new modules or
  agents.

The first alternative adds unnecessary product and maintenance surface. The
second would impose checks on projects where they do not apply. The third would
duplicate existing responsibilities instead of extending the established
quality gate and field guide.

### Consequences

Projects with AI workflows or APIs gain explicit, risk-proportionate checks for
resource-level access and external side effects; projects without those surfaces
do not acquire new requirements. The changes add documentation and translation
maintenance but no runtime dependency, new agent or mandatory development phase.
The Framework release version and default development sequence remain unchanged.

### Related Artifacts

- `knowledge/ENGINEERING_QUALITY.md`
- `knowledge/ENGINEERING_FIELD_GUIDE.md`
- `agents/QA-Security/SPECS.md`
- `locales/pt-BR/knowledge/ENGINEERING_QUALITY.md`
- `locales/pt-BR/knowledge/ENGINEERING_FIELD_GUIDE.md`
- `locales/pt-BR/agents/QA-Security/SPECS.md`
- `CHANGELOG.md`

## ADR-010 - Especificações de agentes neutras e alinhamento da publicação

### Status

Accepted

### Date

2026-10-31

### Context

The published `v1.3.0` distribution is vendor-neutral by default, but several
canonical agent `SPECS.md` and `CONFIGURATION.md` files still prescribed
provider-specific models and described settings from one assistant interface.
Setup examples also assumed a particular local Framework path, while the roadmap
and translation-status documents still described v1.3.0 as pre-release at the
time of this decision. The versioned security audit PDF contains findings and
release gates from 2026-10-19 that are no longer current.

### Decision

- Define `SPECS.md` as the canonical, harness-neutral behavior specification;
  define `CONFIGURATION.md` as a platform-independent execution profile. Neither
  file prescribes a model, vendor, interface or CLI.
- Express useful runtime needs as generic optional capabilities. Keep provider- or
  CLI-specific entrypoints, tool syntax and permission settings in optional
  adapters, with `generic` as the default.
- Synchronize the PT-BR agent mirrors and update agent documentation, setup
  examples, release status and translation coverage without changing the
  published `v1.3.0` tag.
- Preserve the security audit PDF as historical evidence dated 2026-10-19.
  Identify it as non-current in its public documentation and generator; do not
  represent regeneration or presentation changes as a new audit.
- Replace unknown legacy changelog dates with an explicit not-recorded status
  rather than inventing dates. Keep proposed supplemental modules and optional
  adapters in the repository; this decision does not promote or remove them.

### Alternatives Considered

- Keep model and interface-specific settings as historical snapshots in the
  canonical agent specifications.
- Remove optional adapters and all proposed supplemental modules from the
  publication surface.
- Redate or regenerate the old audit PDF as though it reflected current
  repository evidence.

These alternatives would either preserve a misleading dependency, remove
intentional optional material, or overstate the date and scope of the audit.

### Consequences

Agent behavior can be implemented by any compatible harness or CLI, while
optional adapters carry integration details. Documentation and translation
maintenance increase slightly; no runtime dependency, agent responsibility or
mandatory workflow phase is added. The already-published `v1.3.0` remains
unchanged. At the time of this decision, these updates were unreleased pending a
later tag; current `v1.4.0` release execution is tracked in the execution plan
and contribution record.

### Related Artifacts

- `agents/README.md` and `locales/pt-BR/agents/README.md`
- `agents/*/SPECS.md` and `agents/*/CONFIGURATION.md`
- `agents/*/CHANGELOG.md` and PT-BR mirrors
- `README.md`, `README.pt-BR.md`, `START_PROJECTS.en-US.md` and
  `locales/pt-BR/public-docs/START_PROJECTS.md`
- `ROADMAP.md`, `OVERVIEW.md` and `locales/pt-BR/TRANSLATION_STATUS.md`
- `docs/security-audit/`
- `CHANGELOG.md`

## ADR-011 - Integração opcional e somente leitura do GitHub MCP no OpenCode

### Status

Accepted

### Date

2026-11-01

### Context

The Framework repository contains a project-local OpenCode configuration for
the GitHub MCP Server. MCP servers connect automatically unless disabled, and
the upstream server's default toolsets include repository, issue and pull
request operations. Starting Docker and authorizing GitHub access implicitly
would exceed the Framework's vendor-neutral, opt-in integration boundary. The
GitHub server also requires a fixed callback port for Docker OAuth.

### Decision

- Keep the GitHub MCP configuration only as an optional Framework-side
  configuration in `.opencode/opencode.jsonc`; do not add it to the generic
  template or generated client OpenCode adapter.
- Set `disabled: true` by default. A maintainer must explicitly enable the
  server after reviewing the access being granted.
- Pin the Docker image to the upstream `v2.0.3` release, restrict it to the
  `repos` toolset, enable the server's read-only mode, and request only the
  `public_repo` OAuth scope for this example.
- Bind the Docker OAuth callback to `127.0.0.1:8085`, matching the upstream
  registered callback port. Do not store credentials in the repository.
- Validate the configuration statically in both native Framework validators;
  validation must not start Docker or initiate OAuth.

### Alternatives Considered

- Automatically connect the default GitHub MCP server with the upstream
  default toolsets and scopes.
- Remove all GitHub MCP configuration from the Framework repository.
- Install GitHub MCP automatically whenever a client selects the OpenCode
  adapter.

The first alternative adds implicit execution and broader access. The second
removes a useful, explicitly optional maintainer integration. The third would
make GitHub access appear to be a requirement of the OpenCode adapter.

### Consequences

Opening the Framework in OpenCode does not start Docker or authorize GitHub
unless a maintainer explicitly enables the server. When enabled, the MCP tool
surface is restricted to read-only repository operations, while actual access
continues to depend on the user's GitHub authorization. The `public_repo` OAuth
grant itself is not read-only; maintainers must treat it as public-repository
access outside the MCP tool filter as well. The integration adds no dependency
to the generic bootstrap and is not installed in client projects.

### Related Artifacts

- `.opencode/opencode.jsonc`
- `.opencode/README.md`
- `adapters/opencode/README.md`
- `scripts/validate-framework.sh`
- `scripts/validate-framework.ps1`
- `TESTING.md` and `locales/pt-BR/public-docs/TESTING.md`
- `OVERVIEW.md`
- `ROADMAP.md`
- `CHANGELOG.md`

## ADR-012 - Escopo de tradução e classificação de referências públicas

### Status

Accepted; the supplemental-module adoption status was superseded by ADR-014,
and the decision to retain the legacy framework manuscript was superseded by
ADR-016. Its translation scope and non-mandatory dependency and locale-gate
boundaries remain in force.

### Date

2026-11-01

### Context

The PT-BR translation backlog mixed active public documentation, four proposed
supplemental Knowledge evaluations and two Portuguese reference documents with
different authority. Translating a proposed module must not promote it into the
stable dependency graph. Treating the removed historical framework manuscript as current would
create a competing source of truth, while translating every detail in
`docs/reference/LF_DESIGN_PERFORMANCE_GUIDE.md` as policy would exceed the selective adoption
recorded in ADR-002. The published `v1.3.0` tag must also remain distinct from
post-tag work in the checkout.

### Decision

- Translate the four proposed supplemental Knowledge modules into PT-BR and
  validate structural parity, while retaining their `Proposed` status and
  excluding them from the stable dependency graph, mandatory locale gate for
  stable knowledge and agent requirements.
- The decision at the time to keep the frozen historical PT-BR framework
  manuscript was superseded by ADR-016; current normative principles remain in
  canonical Framework modules.
- Keep `docs/reference/LF_DESIGN_PERFORMANCE_GUIDE.md` as a detailed reference, not a complete
  operational authority. Review additional guidance selectively; only material
  explicitly adopted by canonical modules, protocols, schemas or ADRs is
  operational. Do not translate the full guide merely to claim locale parity.
- Translate the active public overview, roadmap, changelog and ADR records into
  PT-BR with source-baseline metadata and a clear distinction between the
  published `v1.3.0` tag and unreleased maintenance.
- Track deliberate exclusions separately from incomplete translations in
  `locales/pt-BR/TRANSLATION_STATUS.md` and `locales/README.md`.
- Keep one release archive containing both language packs; users select the
  project language during bootstrap. Do not create separate EN-US and PT-BR
  release archives.
- Do not alter the `v1.3.0` tag, its release archives or checksums. At the time
  of this decision, all resulting changes were unreleased pending a separately
  authorized future release.

### Alternatives Considered

- Translate every public file without distinguishing authority or status.
- Promote the four supplemental evaluations because PT-BR mirrors exist.
- Maintain the legacy framework reference as a second normative source.
- Treat every recommendation in the detailed design/performance guide as an
  adopted requirement.
- Omit translation of active public decisions and release context without
  recording the language-access limitation.

These alternatives either create source-of-truth drift, silently change the
Framework's scope, or leave language coverage ambiguous.

### Consequences

The translation boundary follows document authority rather than file location or
length. Proposed modules become accessible in PT-BR without changing their
adoption status. Historical and detailed reference material remains available
without creating an unreviewed duplicate policy. Active public records gain
language mirrors, which require ongoing synchronization. Structural checks do
not certify semantic translation quality. The published baseline is unchanged.

### Related Artifacts

- `docs/reference/LF_DESIGN_PERFORMANCE_GUIDE.md`
- `knowledge/INDEX.md` and `knowledge/REGISTRY.md`
- `knowledge/ENGINEERING_ELEPHANT_GOLDFISH.md`
- `knowledge/ENGINEERING_AGENT_GRAPH_FLOW.md`
- `knowledge/ENGINEERING_RTK.md`
- `knowledge/ENGINEERING_GRAPHIFY.md`
- `OVERVIEW.md`, `ROADMAP.md`, `CHANGELOG.md` and `docs/ADR.md`
- `locales/README.md`
- `locales/pt-BR/TRANSLATION_STATUS.md`
- `scripts/check-locales.sh`
- `scripts/validate-framework.ps1`

## ADR-013 - Adoção seletiva de motion design e validação visual

### Status

Accepted

### Date

2026-11-01

### Context

The visual-design and performance guidance already requires reduced-motion
accessibility and separate mobile/desktop evidence, but it does not provide a
technology-independent contract for motion intent, choreography, interaction
behavior or motion-specific review. The reviewed Motion Design Skill provides
library-neutral principles; the GSAP skills provide useful but library-specific
implementation guidance; img2threejs demonstrates staged, quality-gated visual
asset creation and evidence-based comparison. Their installation instructions,
tool defaults and fixed heuristics do not fit the Framework's generic,
vendor-neutral default.

### Decision

- Add `ENGINEERING_MOTION_DESIGN` as a stable, conditional Knowledge module for
  projects that plan, implement or evaluate motion. It does not require motion,
  add a workflow phase or prescribe an implementation library.
- Record motion intent, behavior and reduced-motion expectations in the
  applicable product/design handoff. Add a conditional Motion Review to the
  existing performance validation protocol, schema and report template; record
  `Not applicable` when motion is outside scope.
- Adopt cross-tool principles for intent, hierarchy, accessibility, user
  control, runtime cleanup, performance evidence and visual review. Treat
  published timing and element-count suggestions as heuristics, not fixed gates.
- Keep GSAP-specific instructions conditional on a project selecting GSAP. Keep
  procedural 3D reconstruction as a separately scoped opt-in pipeline; require
  explicit project approval before installing external skills, plugins or
  dependencies.
- Keep `generic` as the default, preserve the legacy design guide as a
  non-authoritative reference and leave the published `v1.3.0` tag, archives
  and checksums unchanged.

### Alternatives Considered

- Copy all three repositories' skills and add them to the default workflow.
- Recommend GSAP as the Framework-wide animation implementation.
- Make procedural 3D modeling or a new animation workflow mandatory for visual
  projects.
- Rely only on the existing generic performance and accessibility checks without
  recording motion behavior or evidence.

These alternatives would create tool lock-in, scope expansion, unnecessary
installation risk or insufficiently traceable motion acceptance.

### Consequences

Visual projects with motion receive a reusable design contract and explicit
review evidence, including reduced-motion behavior. Projects without motion
record a conditional skip. The Framework remains technology-neutral and gains no
runtime dependency, mandatory external skill, CLI or workflow phase. New module,
protocol, template, decision and translation maintenance are required. At the
time of this decision, these changes were unreleased pending a future authorized
tag.

### Related Artifacts

- `knowledge/ENGINEERING_MOTION_DESIGN.md` and its PT-BR mirror
- `knowledge/INDEX.md`, `knowledge/REGISTRY.md` and `knowledge/ENGINEERING_DESIGN_PERFORMANCE.md`
- `protocols/PERFORMANCE_VALIDATION.md`
- `schemas/PERFORMANCE_VALIDATION_REPORT.schema.md`
- `PROJECT_TEMPLATE/docs/DESIGN.md` and `PROJECT_TEMPLATE/docs/PERFORMANCE_VALIDATION_REPORT.md`
- `workflows/NEW_PROJECT.md` and `workflows/STANDARD_DEVELOPMENT.md`
- `OVERVIEW.md`, `ROADMAP.md`, `CHANGELOG.md` and PT-BR mirrors
- [Motion Design Skill](https://github.com/lottiefiles/motion-design-skill)
- [GSAP Skills](https://github.com/greensock/gsap-skills)
- [img2threejs](https://github.com/img2threejs/img2threejs)

## ADR-014 - Optional adoption of the four supplemental modules

### Status

Accepted

### Date

2026-11-01

### Context

Four supplemental Knowledge modules have bounded pilot evidence. The
independent, fresh-session Elephant-Goldfish review of the motion-design pilot
passed comprehension with qualifications, while critic and implementation-
readiness checks did not pass. The AGF and RTK pilots were small and synthetic;
Graphify's source-to-build provenance remains incomplete. The Project Owner
approved their advancement for the `v1.4.0` candidate and clarified that they
should be approved as optional references, not mandatory dependencies. This
decision must not imply general effectiveness, production readiness, or approval
to install external tools.

### Decision

- Approve `ENGINEERING_ELEPHANT_GOLDFISH`, `ENGINEERING_AGENT_GRAPH_FLOW`,
  `ENGINEERING_RTK` and `ENGINEERING_GRAPHIFY` as optional supplemental
  references for the `v1.4.0` candidate. Mark each module `Approved Optional`.
- Keep the modules outside the mandatory dependency graph, default agent
  knowledge, required workflow gates and required artifacts. Select a module
  only when it is relevant to a task and its limits are understood.
- Treat this as approval of guidance only. It does not authorize installing or
  activating `agf`, RTK or Graphify, or adding their CLI, packages, hooks,
  plugins, skills, MCP servers, providers, telemetry or generated state. Each
  such use requires separate, specific owner approval.
- Preserve Graphify's explicit boundary: the optional module is approved, but
  its source-to-build provenance gap is unresolved; do not install, execute or
  integrate the tool further without separate approval of a provenance
  threshold.
- Record the Elephant-Goldfish evaluation without calling the pilot successful
  or the design implementation-ready. Its findings do not create a universal
  gate and do not replace human approval, Code Review, QA or security review.
- Keep `generic` as the default and leave the published `v1.3.0` tag, archives
  and checksums unchanged. The `v1.4.0` candidate is approved for preparation;
  this ADR does not authorize release packaging, tagging or publication.

### Alternatives Considered

- Keep all four modules in `Proposed` status until larger or representative
  pilots are complete.
- Promote the modules into the stable mandatory dependency graph or make their
  practices universal workflow requirements.
- Treat approval of the Graphify module as approval to install or integrate the
  Graphify tool, or treat the AGF/RTK pilots as authorization for automatic
  setup.

The first alternative would disregard the Project Owner's explicit scope
decision. The latter alternatives would overstate the evidence, introduce
unapproved tool risk and change the vendor-neutral default.

### Consequences

The four modules become discoverable, approved optional references in EN-US and
PT-BR. Registry and locale validation now assert the approved-optional status;
the stable dependency graph, default workflow and `generic` bootstrap remain
unchanged. Pilot evidence and unresolved findings remain explicit, and external
tool installation or integration stays separately gated. At the time of this
decision, the candidate remained unreleased pending all release gates and
separate final authorization; subsequent release execution is tracked in the
contribution record and execution plan.

### Related Artifacts

- `knowledge/ENGINEERING_ELEPHANT_GOLDFISH.md` and its PT-BR mirror
- `knowledge/ENGINEERING_AGENT_GRAPH_FLOW.md` and its PT-BR mirror
- `knowledge/ENGINEERING_RTK.md` and its PT-BR mirror
- `knowledge/ENGINEERING_GRAPHIFY.md` and its PT-BR mirror
- `knowledge/INDEX.md`, `knowledge/REGISTRY.md` and their PT-BR mirrors
- `docs/evaluations/ELEPHANT_GOLDFISH_MOTION_DESIGN_2026-11-01.md`
- `docs/proposals/V1.4.0_CONTRIBUTION_PROPOSAL.md`
- `docs/plans/V1.4.0_EXECUTION_PLAN.md`
- `CHANGELOG.md`, `OVERVIEW.md`, `ROADMAP.md` and PT-BR mirrors
- `scripts/check-locales.sh` and `scripts/validate-framework.ps1`

## ADR-015 - EN-US source and PT-BR document organization

### Status

Accepted; its compatibility-path retention decision was superseded by ADR-016.

### Date

2026-11-01

### Context

The canonical EN-US technical library already lives in the repository root,
while most PT-BR mirrors live under `locales/pt-BR/`. Selected translated public
documents remained mixed into the root and `docs/`, and the `locales/en-US/`
directory contained only a README. This made language ownership less clear and
created an ambiguous `START_PROJECTS.md` path. Moving the canonical library into
a second locale tree would require changing bootstrap, adapters, validators and
many documentation references without improving the source-of-truth boundary.

### Decision

- Keep EN-US as the technical source. Canonical agents, Knowledge, workflows,
  protocols, schemas and the default `PROJECT_TEMPLATE/` remain at the repository
  root.
- Group translated public documents under `locales/pt-BR/public-docs/` and the
  PT-BR ADR mirror under `locales/pt-BR/docs/ADR.md`. Keep technical PT-BR
  mirrors and the translated project template under their existing
  `locales/pt-BR/` paths.
- Keep `locales/en-US/README.md` as an index explaining that canonical EN-US
  sources remain at the root; do not duplicate the source tree there.
- Keep `README.pt-BR.md` as the PT-BR repository landing page. The decision to
  retain root-level PT-BR compatibility pages was superseded by ADR-016.
- Update locale checks, platform validators, language switchers and repository
  indexes to use the canonical locale paths. This is a documentation-layout
  change only; it does not alter bootstrap language selection, the `generic`
  default, optional-module boundaries or release contents.
- Leave the published `v1.3.0` tag, archives and checksums unchanged. This ADR
  does not authorize release packaging, tagging or publication.

### Alternatives Considered

- Move all canonical EN-US modules into `locales/en-US/` and update every
  consumer path.
- Keep translated public documents mixed between the root and `locales/`.
- Remove old public paths immediately and require users to discover the new
  locale layout.

The first option adds broad path churn without improving canonical ownership;
the second preserves the current ambiguity; the third needlessly breaks existing
links. The chosen layout makes language-specific documents discoverable while
retaining compatibility.

### Consequences

PT-BR public-document content now has one canonical location under
`locales/pt-BR/`. At the time this ADR was accepted, root compatibility pages
preserved old entry paths; ADR-016 removes those aliases. The locale validator
compares active public documents directly against their EN-US sources.
Structural parity remains a mechanical check and does not certify semantic
translation quality. No release or published baseline changes as a result.

### Related Artifacts

- `locales/README.md`, `locales/en-US/README.md` and
  `locales/pt-BR/TRANSLATION_STATUS.md`
- `locales/pt-BR/public-docs/` and `locales/pt-BR/docs/ADR.md`
- `README.pt-BR.md` and the former root PT-BR compatibility paths (removed by ADR-016)
- `scripts/check-locales.sh`, `scripts/validate-framework.sh` and
  `scripts/validate-framework.ps1`
- `README.md`, `README.pt-BR.md`, `CHANGELOG.md` and its PT-BR mirror

## ADR-016 - Removal of legacy references and compatibility paths

### Status

Accepted

### Date

2026-11-01

### Context

ADR-012 retained a frozen Portuguese framework manuscript as a historical public
reference, and ADR-015 kept root-level compatibility pages after the PT-BR public
documents had been grouped under `locales/pt-BR/`. The legacy manuscript is not
an operational source; the current normative library lives in the canonical
modules. The compatibility pages duplicate navigation to the canonical locale
documents and are not consumed by the bootstrap. The detailed design/performance
guide is different: the canonical Knowledge module cites it as source rationale.

### Decision

- Remove the obsolete root-level PT-BR compatibility paths:
  `CONTRIBUTING.pt-BR.md`, `SECURITY.pt-BR.md`, `TESTING.pt-BR.md`,
  `CHANGELOG.pt-BR.md`, `OVERVIEW.pt-BR.md`, `ROADMAP.pt-BR.md`,
  `docs/ADR.pt-BR.md` and the ambiguous `START_PROJECTS.md` selector. Their
  canonical PT-BR content remains under `locales/pt-BR/`. Keep the full
  repository landing page `README.pt-BR.md`.
- Remove the superseded `LF_ENGINEERING_FRAMEWORK.md` manuscript. Current
  normative guidance remains in `agents/`, `knowledge/`, `workflows/`,
  `protocols/` and `schemas/`.
- Move `LF_DESIGN_PERFORMANCE_GUIDE.md` to
  `docs/reference/LF_DESIGN_PERFORMANCE_GUIDE.md`. Keep it as a detailed,
  non-normative source reference because the canonical design/performance
  Knowledge module cites its provenance. Only requirements explicitly adopted
  by canonical artifacts are operational.
- Update repository documentation, locale validators, platform validators and
  the audit report generator to use canonical paths. Keep the existing audit PDF
  unchanged as a historical snapshot; do not regenerate it as part of this
  decision.
- Accept that links to removed compatibility paths on the current branch no
  longer resolve. This does not change bootstrap behavior, the `generic`
  default, optional-module boundaries, the published `v1.3.0` tag or its
  archives/checksums.

### Alternatives Considered

- Keep all root compatibility pages indefinitely to preserve old URLs.
- Delete the detailed design/performance guide along with the obsolete
  manuscript, losing the source rationale cited by canonical Knowledge.
- Move all EN-US technical sources into a parallel `locales/en-US/` tree.

The first alternative retains duplicate paths with no runtime consumer; the
second would sever provenance; the third would create broad path churn. The
decision removes obsolete aliases while preserving the one source guide that
still supports canonical traceability.

### Consequences

Current links and validators point only to canonical locale paths, and the
obsolete Portuguese manuscript is no longer presented as a current public
reference. External links to removed paths may break; historical tags remain
unchanged. The design/performance guide remains available under `docs/reference/`
without becoming an operational authority.

### Related Artifacts

- `README.md`, `README.pt-BR.md`, `OVERVIEW.md` and its PT-BR mirror
- `locales/README.md` and `locales/pt-BR/TRANSLATION_STATUS.md`
- `locales/pt-BR/public-docs/` and `locales/pt-BR/docs/ADR.md`
- `docs/reference/LF_DESIGN_PERFORMANCE_GUIDE.md`
- `knowledge/ENGINEERING_DESIGN_PERFORMANCE.md` and its PT-BR mirror
- `scripts/validate-framework.sh`, `scripts/validate-framework.ps1` and
  `docs/security-audit/gerar_relatorio.py`

## ADR-017 - Release publication without a GitHub Environment

### Status

Accepted (branch-protection policy for the public repository superseded by ADR-019)

### Date

2026-11-01

### Context

In the predecessor private repository, the release workflow referenced a GitHub Environment named `release` for its
publish job. The repository owner chose not to use environment-based protection
or manual reviewer approval. Deleting the environment in GitHub alone is not
sufficient: a later workflow run can recreate a referenced environment without
protection rules. Keeping that reference would therefore misrepresent the
release policy and create an implicit, unprotected environment.

### Decision

- Do not use or require a GitHub Environment for Framework release publication;
  remove the `environment` declaration from the publish job.
- After the exact release-tag commit passes the Ubuntu/macOS/Windows matrix and
  the read-only packaging job completes, the publish job runs automatically with
  `contents: write`.
- A push of a matching stable release tag is the workflow's only publication
  trigger. Remove `workflow_dispatch` so an existing tag cannot be republished
  through a separate manual path.
- Treat creating/pushing a matching release tag as the explicit, consequential
  release action. It still requires separate owner authorization; this decision
  does not authorize creating or pushing a release tag now.
- For the predecessor private repository, branch/tag rulesets were not required
  release gates because it had a single owner. ADR-019 defines the separate
  protection policy for the new public repository. Environment deployment rules
  and required reviewers are not release gates for this Framework.

### Alternatives Considered

- Keep the `release` environment and configure required reviewers in GitHub.
- Delete the environment but leave the workflow reference, allowing GitHub to
  recreate it without protection rules.
- Remove the environment reference while claiming that publication still waits
  for manual reviewer approval.
- Keep `workflow_dispatch` as a second publication trigger for existing tags.
- Require paid-plan branch/tag rulesets for a repository maintained by one owner.

The first alternative conflicts with the owner's decision for the predecessor
repository that environments are
not applicable. The second leaves a misleading, unprotected environment. The
third would document a gate that the workflow does not enforce. The fourth would
allow a separate manual publication path. The fifth adds plan and administration
overhead without separating release authority in the predecessor single-owner repository.

### Consequences

The workflow no longer creates or depends on a `release` environment and only a
matching stable tag push can trigger publication. After the required
cross-platform checks and packaging, publication proceeds automatically; no
environment reviewer pauses the job. The access and branch-protection policy for
the public repository is recorded separately in ADR-019. No release is created
by this ADR.

### Related Artifacts

- `.github/workflows/release.yml`
- `TESTING.md` and its PT-BR mirror
- `CHANGELOG.md` and its PT-BR mirror
- `docs/plans/V1.4.0_EXECUTION_PLAN.md`
- `docs/proposals/V1.4.0_CONTRIBUTION_PROPOSAL.md`
- `locales/pt-BR/TRANSLATION_STATUS.md`

## ADR-018 - Dynamic local inspection and checkout-name independence

### Status

Accepted

### Date

2026-11-01

### Context

The security report generator contained fixed findings and a fixed assessment
date, so rerunning it could not describe the current project. Its historical
PDF was also easy to mistake for a current assessment. In addition, documented
commands could be read as depending on the repository's default clone directory,
while users may check it out as `LF-Engineering-Framework` or another name.

### Decision

- Make `docs/security-audit/gerar_relatorio.py` a local, read-only preliminary
  inspector. It inspects the current working directory by default and accepts
  `--project PATH` to inspect another directory.
- Write the PDF to
  `<project>/docs/security-audit/relatorio-auditoria-seguranca.pdf` by default;
  overwrite it on each run and allow an explicit `--output PATH`.
- Do not execute project code or commands, use the network, change permissions,
  or delete project files. Skip symlinks and common dependency/build directories.
  Report credential-shaped matches by type and location only, never by value.
- Keep the report explicitly preliminary and heuristic. It must not claim to be
  a complete security audit, certify absence of vulnerabilities, or approve a
  project; QA-Security review remains required.
- Keep the 2026-10-19 PDF identified as historical evidence, not a current audit.
  The predecessor private repository's `v1.4.0` tag is not imported into the
  public repository; the checked-in PDF remains the preserved historical file.
- Derive Framework paths from script locations or explicit paths, not a fixed
  checkout directory name. Document and test commands with a checkout named
  `LF-Engineering-Framework`.

### Alternatives Considered

- Keep rendering fixed historical data, which does not meet the need for current
  project evidence.
- Add a second inspector, which would leave two similarly named commands and
  increase the chance of regenerating the wrong report.
- Include matched credential values for convenience, which would unnecessarily
  expose secrets in the generated PDF.

The first alternative preserves the original limitation; the second creates an
ambiguous tool boundary; the third increases the impact of report disclosure.

### Consequences

The report changes with the inspected working tree and is overwritten at its
configured destination. The scan is local and avoids project execution and
network access, but its limited signatures and heuristics can produce false
positives and false negatives. Human QA-Security review and project-specific
testing remain necessary. The predecessor private repository's `v1.4.0` tag is
not part of the public repository; its checked-in historical PDF is not modified.
Bootstrap and validation commands remain independent of the checkout folder's
name.

### Related Artifacts

- `docs/security-audit/gerar_relatorio.py` and `test_gerar_relatorio.py`
- `docs/security-audit/README.md` and its PT-BR mirror
- `TESTING.md` and its PT-BR mirror
- `CONTRIBUTING.md` and its PT-BR mirror; `.github/PULL_REQUEST_TEMPLATE.md`
- `START_PROJECTS.en-US.md` and its PT-BR mirror
- `scripts/validate-framework.sh`, `scripts/validate-framework.ps1` and
  `scripts/check-locales.sh`
- `scripts/bootstrap.sh`, `scripts/bootstrap.ps1`, `scripts/test-bootstrap.sh` and
  `scripts/test-bootstrap.ps1` (owner-only local state is implemented under ADR-001)
- `.github/workflows/validate.yml`
- `CHANGELOG.md` and its PT-BR mirror

## ADR-019 - Clean public repository and first public release

### Status

Accepted

### Date

2026-11-03

### Context

The predecessor private repository contains historical commit metadata and
maintainer-local paths that should not be exposed by a public repository. The
owner also chose to preserve that private repository and its published tags.
Rewriting its history would violate that boundary, while importing its history,
branches or tags would expose unnecessary private metadata and make the public
baseline ambiguous.

### Decision

- Create `LeandroFernandess/LF-Engineering-Framework` as a separate public
  repository from a reviewed source snapshot, initialized with one clean root
  commit on `main`.
- Do not copy the predecessor repository's `.git` directory, history, branches
  or tags. Keep its working tree, remote, branches and tags unchanged.
- Make `v1.5.0` the first public release. Describe `v1.4.0` and earlier versions
  only as historical predecessor-repository releases; do not create or import
  their public tags or assets.
- Use the account's GitHub noreply address for the public commit identity.
- Protect `main` by requiring pull requests and successful Ubuntu, macOS and
  Windows validation checks. Do not require an approving review while the
  repository has one maintainer; reassess if write access expands.
- Keep stable-tag release publication gated by the exact-tag validation and
  packaging workflow; a release tag still requires separate owner authorization.

### Alternatives Considered

- Rewrite and migrate the predecessor history, which risks changing the private
  repository's release boundary and retaining unnecessary metadata.
- Publish only the old `v1.4.0` content, which would exclude already reviewed
  follow-up fixes and leave the public baseline behind the intended snapshot.
- Publish the current repository as-is, which would expose its historical Git
  metadata and private branch/tag structure.

The clean snapshot preserves the private repository while making the public
baseline explicit and independently verifiable.

### Consequences

The public repository has no inherited Git history or tags before `v1.5.0`.
Historical planning and evaluation records are retained only where explicitly
approved and sanitized; private run links, local paths and session identifiers
are not part of the public record. The private repository remains the owner-held
historical source. Pull requests and cross-platform checks protect `main`, while
release tags remain a separately authorized consequential action.

### Related Artifacts

- `.github/workflows/validate.yml` and `.github/workflows/release.yml`
- `CHANGELOG.md`, `OVERVIEW.md`, `ROADMAP.md` and their PT-BR mirrors
- `README.md` and `README.pt-BR.md`
- `SECURITY.md` and its PT-BR mirror

## ADR-020 - Keep `.ai/state/` local and ignored by default

### Status

Accepted

### Date

2026-11-03

### Context

Project state files support recovery and coordination but can contain private
operational context. Owner-only filesystem permissions do not prevent Git from
publishing a file, and the bootstrap preserves an existing project's `.gitignore`
rather than replacing project policy.

### Decision

- Add `/.ai/state/` to the root and generated project `.gitignore` files so state
  copied into a new project remains local by default.
- Keep bootstrap permission restrictions for `.ai/state/` directories and files;
  Git ignore and local filesystem permissions address different risks.
- Preserve existing `.gitignore` files. Document that existing projects must
  adopt the rule manually if they want the same default protection.
- Share state only by explicit, file-specific review and approval; do not
  force-add `.ai/state/` wholesale.

### Alternatives Considered

- Leave `.ai/state/` trackable and rely on manual review before every commit.
- Ignore all of `.ai/`, which would also exclude coordination contracts and
  project decisions that are intended to be versioned.
- Rewrite existing `.gitignore` files during bootstrap, which would violate the
  copy-missing-only preservation contract.

The selected rule protects new projects without changing adoption behavior for
existing projects or hiding the rest of `.ai/`.

### Consequences

New projects do not accidentally track local state through ordinary Git adds.
Existing projects keep their current ignore policy until maintainers adopt the
rule. Users can still force-add individual files after review, so Git ignore is a
safety default rather than an access-control boundary. Local owner-only
permissions remain in effect independently.

### Related Artifacts

- `.gitignore` and `PROJECT_TEMPLATE/.gitignore`
- `scripts/bootstrap.sh`, `scripts/bootstrap.ps1` and their test suites
- `PROJECT_TEMPLATE/AGENTS.md` and its PT-BR mirror
- `START_PROJECTS.en-US.md` and its PT-BR mirror
- `SECURITY.md` and its PT-BR mirror
