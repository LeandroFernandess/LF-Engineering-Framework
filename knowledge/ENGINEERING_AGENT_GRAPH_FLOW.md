# Engineering Knowledge: Agent Graph Flow (agf)

Version: 0.2.0

Status: Approved Optional

Category: Supplemental / External-tool evaluation

Owner: Leandro Fernandes
Framework Baseline: LF Engineering Framework 1.3.0; adoption status updated post-tag

---

# Adoption Status

This module is approved as optional guidance for evaluating `agent-graph-flow`
(`agf`) as an execution and evidence layer for the LF Engineering System.

It is not part of the mandatory LF dependency graph. It must not silently add
CLI requirements, graph gates, skills, hooks, providers or lifecycle changes to
the Framework.

This approval does not authorize installing or activating `agf`, its skills,
hooks, providers or dashboards. Any tool installation or integration requires
separate, specific owner approval. The recommendations do not become Framework
rules, workflow gates, agent instructions or mandatory artifacts by default.

---

# Purpose

This module preserves the useful engineering ideas behind `agf` and evaluates
their fit with the LF Engineering System.

The central fit is complementary:

- LF owns product intent, architecture, governance, artifacts, agent roles and
  human approval.
- `agf` can own a live execution ledger with task state, dependencies,
  acceptance criteria, completion evidence and cost measurements.
- The project repository and its tests remain the authority for actual code and
  behavior.

The proposed boundary avoids duplicating the responsibilities of `PRD.md`,
`ARCHITECTURE.md`, `SPRINTS.md`, ADRs, reviews, QA reports and `.ai/` state.

---

# Non-goals

This module does not:

- Replace the LF Engineering Framework or its artifact contracts.
- Require `agf` for every LF project or every maintenance change.
- Treat the `agf` website, README or marketing claims as independently proven.
- Treat a graph status as proof when the filesystem, tests or review evidence
  disagree with it.
- Treat `agf` as a sandbox, security boundary or replacement for a container or
  virtual machine.
- Require MCP. The public project describes the CLI as the primary interface
  and says the MCP transport is optional and disabled by default.
- Copy the full LF backlog into a second source of truth without an explicit
  ownership and synchronization model.
- Activate stigmergy, ACO, neural retrieval, external providers or autonomous
  delivery without a reviewed pilot.

---

# Sources and Evidence

## Public Sources

- Product site: <https://graph-flow.cloud/>
- Repository: <https://github.com/DiegoNogueiraDev/agf>
- README: <https://raw.githubusercontent.com/DiegoNogueiraDev/agf/main/README.md>
- Installation guide: <https://raw.githubusercontent.com/DiegoNogueiraDev/agf/main/INSTALL.md>
- Security policy: <https://raw.githubusercontent.com/DiegoNogueiraDev/agf/main/SECURITY.md>
- Public agent instructions: <https://raw.githubusercontent.com/DiegoNogueiraDev/agf/main/AGENTS.md>
- Skills repository: <https://github.com/DiegoNogueiraDev/skills-graph>
- Skills README: <https://raw.githubusercontent.com/DiegoNogueiraDev/skills-graph/main/README.md>
- Installer reviewed: <https://graph-flow.cloud/install.sh>

Consulted: 2026-09-03.

The reviewed public release identifies itself as `v0.24.2`.

## Evidence Classes

Use these labels when referring to `agf` in LF documentation:

| Label | Meaning |
| --- | --- |
| Public claim | Behavior or property described by the site, README, source documentation or installer. |
| Local observation | Behavior actually observed while running the installed CLI in this LF workspace or in the user's home directory. |
| LF recommendation | A proposed use or boundary that still requires review and pilot evidence. |

The installed CLI and the public source were not treated as identical by
default. Version drift, generated files, local configuration and project scope
can change behavior.

---

# Executive Synthesis

`agf` turns software execution into a persistent SQLite graph instead of an
ephemeral conversation. Its public model contains tasks, dependencies,
acceptance criteria and state transitions. Its advertised execution loop is:

1. Shape the work into an executable graph.
2. Pull one unblocked task at a time.
3. Implement with test-first development.
4. Validate the Definition of Done and filesystem evidence.
5. Record the result, memory and cost before selecting the next task.

This is useful to LF because the existing Framework already defines artifacts,
roles and governance, but a client project may still need a durable operational
view of task execution across agent sessions.

The strongest candidate for adoption is the deterministic graph discipline:
explicit task nodes, dependency edges, WIP control, acceptance criteria,
validation commands, evidence records and honest status transitions.

The weaker or higher-risk candidates are autonomous delivery, pheromone-based
routing, broad provider integration, neural retrieval and claims about token or
delivery speed. Those require measured project evidence and stronger trust
boundaries before adoption.

---

# Conceptual Model

## Persistent Graph

The graph is presented as the operational source of truth for execution:

- A requirement, epic, task, risk, interface or constraint is represented by a
  node.
- A dependency, parent-child relation, implementation relation or other link is
  represented by an edge.
- A task contains a description, acceptance criteria, status and metadata.
- Commands read and update the graph through the CLI.
- The local store is SQLite, normally under `workflow-graph/graph.db`.

### Local State Privacy

The SQLite store, WAL/SHM companions, snapshots, manifests and memories may
contain prompts, commands, agent output or project context. Treat
`workflow-graph/` as local sensitive state: create directories with mode `0700`,
files with mode `0600` and a restrictive creation default such as `umask 077`
when the host supports it. Verify modes after graph runs, keep the directory
ignored by version control and define retention before cleanup. Do not assume
`.gitignore` protects data from other users on the same host, and do not delete
historical state automatically.

The graph should be understood as a live execution projection in an LF
integration, not as an uncontrolled duplicate of every canonical artifact.

## Source Ownership

The following ownership boundary is recommended:

| Concern | LF authority | Possible `agf` representation |
| --- | --- | --- |
| User intent and business scope | `PROJECT_BRIEF.md`, `PRD.md` | Requirement or epic reference with a link, not an independent rewrite |
| Architecture and trade-offs | `ARCHITECTURE.md`, ADRs | Interface, constraint, risk or implementation relation |
| Sprint intent and priority | `SPRINTS.md` and approved planning records | Executable task nodes and dependencies |
| Live execution status | `.ai/` state plus the agreed task tracker | Graph node status and task history |
| Source code and tests | Project filesystem and test runner | Completion evidence and changed-file references |
| Review and quality decision | `REVIEW.md`, QA report, Tech Lead decision | Validation result, finding or handoff reference |
| Reusable Framework knowledge | `knowledge/` after human review | Optional memory reference, never sole authority |

The exact ownership contract must be decided before any automatic import or
sync is introduced.

---

# Lifecycle

## Three Public Pillars

The `skills-graph` repository describes three skills as the complete product
cycle:

| Skill | Pillar | Intended use | LF mapping |
| --- | --- | --- | --- |
| `graph-backlog-generation` | PLAN | Investigate the project and turn an idea or PRD into epics, atomic tasks and testable acceptance criteria. It must not write implementation code. | Prompt Architect, Product Owner, Software Architect and Sprint Planner responsibilities. |
| `graph-builder-leafcutter` | BUILD | Pull an unblocked task, implement with TDD, validate it and continue until the assigned backlog is exhausted. | Implementation / selected CLI execution under the approved LF sprint and handoffs. |
| `graph-woodpecker` | HARDEN | Find bugs, vulnerabilities, debt and observability gaps, then prove fixes with regression tests. | Code Reviewer, QA-Security and Tech Lead validation. |

The shared protocols include a delegation protocol, a retrieval protocol and
common rules for context, economy and anti-patterns.

## Nine Public Phases

The public agent instructions group a nine-phase lifecycle into SHAPE, BUILD
and SHIP:

1. ANALYZE: import or create requirements and pass readiness checks.
2. DESIGN: create architecture, interfaces, ADR relations and constraints.
3. PLAN: decompose work and make acceptance criteria testable.
4. IMPLEMENT: execute one task at a time with TDD.
5. VALIDATE: run task checks, gates and metrics.
6. REVIEW: export evidence and review the completed work.
7. HANDOFF: persist memory and snapshot the result.
8. DEPLOY: pass the deployment gate and export the final state.
9. LISTENING: add findings or a new cycle from observed outcomes.

LF has a longer and more artifact-oriented lifecycle. The two lifecycles should
be mapped, not merged casually. `agf` phases can provide execution checkpoints
inside an LF workflow, while LF remains responsible for artifact contracts and
approval decisions.

## Recommended LF Sequence

```text
LF intake and requirements
        |
        v
LF architecture, ADRs and sprint approval
        |
        v
Optional agf graph projection with stable LF references
        |
        v
agf pull -> TDD implementation -> filesystem and task validation
        |
        v
LF review -> QA/Security -> Tech Lead decision
        |
        v
Optional graph export, memory and metrics back into LF records
```

The graph should not be created as a reason to bypass missing upstream LF
artifacts. If an upstream artifact is intentionally skipped, record the reason
in `.ai/decisions.md` as required by `.ai/contracts.md`.

---

# Deterministic Guardrails

The public project emphasizes gates instead of agent memory. The following
principles are the most reusable part of the design.

## Node Before Code

Implementation must have a graph node with a clear scope and testable
acceptance criteria. This addresses untracked work and makes an agent's
assignment inspectable before files change.

LF equivalent: the task must also be traceable to the approved `SPRINTS.md`,
architecture and relevant acceptance criteria. A graph node alone does not
authorize a scope that LF has not approved.

## Pull, Not Push

`agf next` or `agf start` selects an unblocked task and marks it in progress.
The advertised WIP limit is one task at a time.

This supports Little's Law and reduces parallel ambiguity, but it may conflict
with legitimate LF parallel work across independent agents. The pilot must
measure whether WIP=1 is global, per project, per agent or per workstream before
making it a Framework rule.

## Acceptance Criteria, Code and Test

The public invariant is that acceptance criteria, implementation files and test
files must agree on disk. A status field or agent message cannot prove that
condition by itself.

This aligns with LF's requirement for implementation evidence, review and QA.
The limitation is important: filesystem presence does not prove semantic
correctness, adequate coverage, security or user value. Human review and the LF
quality gates remain necessary.

## Test-First Execution

The advertised BUILD loop is:

```text
RED -> GREEN -> REFACTOR
```

The proposed LF use is to keep this as a task-level execution expectation while
allowing the existing project test strategy to define the actual commands and
test quality. `agf` should not invent a test runner for a project that has none.

## Status Flow and Definition of Done

The graph validates transitions and exposes checks such as:

- Acceptance criteria exist and have sufficient quality.
- Blockers are resolved.
- The task passed through `in_progress`.
- Implementation and test files are physically present where required.
- The appropriate task or project test gate passed.
- The task is not oversized for the available decomposition.

These checks are useful evidence, not automatic approval. A passing `agf done`
must still be reconciled with the actual diff, code review, QA/security result
and human decision.

## Gaps and Harness

`agf gaps` is described as a deterministic detector for missing links such as:

- Requirement to task to test traceability.
- Acceptance criteria with no testable form.
- Missing non-functional requirements.
- Missing error cases or edge cases.
- Ambiguous or oversized tasks.
- Drift between design, estimate and implementation.

`agf harness` is described as a hardening and quality instrument. It should be
used as a supplemental signal until its dimensions, thresholds and false
positive rate are validated against LF QA reports.

---

# Operating Modes

## Delegated Mode

When no LLM provider is configured, public guidance says commands can return a
`mode: delegated` brief for the external agent that is actually driving the
work. The intended loop is:

```bash
agf next
agf context <id>
agf brief <id>
# The external agent implements and tests the task.
agf submit <id> --result '{"arquivos":[],"testes":{"passed":0,"failed":0},"desvios":[]}'
```

This mode fits OpenCode and LF well because the CLI can remain an execution
ledger while the selected LF agent retains reasoning and approval
responsibility.

The result payload must be truthful. A zero-test result is not a successful
software implementation unless the task is genuinely documentation-only and
the exception is recorded.

## Live Provider Mode

With a configured provider, `agf` can make model calls and associate them with a
task. Public documentation describes provider detection, model selection,
cached input and call accounting.

This mode creates additional trust, privacy, availability and cost concerns. It
should not be the first LF pilot mode. Start with delegated execution and the
user's existing agent provider, then evaluate whether direct provider routing
adds value.

## Autonomous Delivery

Commands such as `agf deliver` are advertised as a full pipeline from request
to completed graph. They are convenient for low-risk experiments but can hide
the points where LF expects artifact review, approval or a handoff.

The recommended LF default is granular execution. Use an autonomous command
only after scope, environment, rollback, review ownership and evidence
requirements are explicit.

---

# Token Economy and Retrieval

## Public Mechanisms

The public product describes these cost and context mechanisms:

- Diff edits that rewrite only changed regions.
- A ranked repository map rather than a full tree dump.
- Reversible cold-content markers that can be retrieved by hash.
- Compression at the command boundary.
- Cached input and provider call ledgers.
- RAG retrieval for commands and relevant context.
- Economy levers that can be enabled or disabled and are recorded in a ledger.

The public README also distinguishes direct model cost from delegated savings.
In delegated mode, the external agent pays for the model call and `agf` may
report estimated savings against a structural baseline rather than a direct
provider invoice.

## LF Recommendation

Adopt the measurement discipline before adopting the levers:

1. Record the task, session, provider mode, input and output counts where
   available.
2. Label measured, cached, estimated and contrafactual values separately.
3. Compare equivalent tasks with and without the mechanism.
4. Include quality, rework and review time in the cost evaluation.
5. Never cite a savings percentage without its baseline and measurement scope.

The LF shell-output rule already requires filtering and compressing large
command output. `agf` may be a useful implementation of that principle, but it
must not cause double compression or hide error output from the agent.

## Retrieval Boundary

`agf retrieve-command` and related retrieval features should be treated as
command suggestions, not authority. The final command must be checked against
the installed CLI version, project path, security context and `--help` output.

Memory and retrieval can accelerate work, but current code, graph state,
contracts and approved artifacts outrank stale memories or generated context.

---

# Stigmergy and Learning

## Useful Idea

Persistent outcomes can make future routing more informed. In principle, a
successful path can retain:

- The task type and context shape.
- The command or skill route used.
- The evidence that passed.
- The cost and elapsed time.
- The reason a route was rejected.

This is a useful input to LF continuous improvement and knowledge extraction.

## Safety Boundary

Learning must not turn an unverified assertion into Framework truth. The public
README describes provenance levels such as `claim`, `validated` and `proven`,
with stronger route weight reserved for stronger evidence. LF should preserve
the same separation:

- Claim: an agent or tool says that a path worked.
- Validated: a defined test or gate passed.
- Proven: the result is reproducible with deterministic evidence and review.

Only the latter two should influence a pilot conclusion, and neither should
automatically change a canonical rule.

## ACO Risk

The public site describes reinforcement, evaporation and approximately 70%
exploitation versus 30% exploration. This may improve repeated routing, but it
can also reinforce a local optimum, propagate a wrong assumption or hide a
regression behind historical success.

The LF recommendation is deterministic routing first. If ACO is piloted, keep
it opt-in, log the selected route and alternatives, preserve a deterministic
fallback and compare outcomes against the baseline.

---

# Security and Trust Boundaries

## No Sandbox

The public `SECURITY.md` explicitly states that `agf` does not sandbox the
agent. Its permission system is a UX feature, not security isolation. The
document recommends Docker or a VM when true isolation is required.

Therefore:

- Never present `agf` permissions as a security control.
- Do not run an unreviewed autonomous cycle in a sensitive repository.
- Use a container, VM or equivalent isolation for untrusted code, tools or
  provider behavior.
- Keep credentials, production access and destructive commands outside the
  default pilot environment.

## External Providers and MCP

Provider data is governed by the configured provider's policy. External MCP
servers, when enabled, are outside the tool's trust boundary according to the
public security document.

The public `AGENTS.md` says `agf` works with zero MCP and that the MCP transport
is optional. The local initialization output reported a `DirectMCP bridge`, but
that observation does not establish that MCP is required or active for normal
CLI use. LF documentation must distinguish the CLI, optional transport and any
external server.

## Installer and Update Risks

The installation guide claims that the installer verifies SHA256 and aborts on
mismatch. The reviewed `install.sh` downloads the checksum when available, but
its mismatch branch only emits `checksum nao confere (continuando)` and proceeds.
It also skips verification when the checksum cannot be downloaded.

This is a concrete documentation-versus-script discrepancy. Until corrected or
independently verified:

- Pin and inspect the installer or release artifact before using it in a
  controlled environment.
- Prefer a verified internal mirror when appropriate.
- Do not treat `curl ... | bash` as an equivalent of a reviewed package source.
- Record the installed version and checksum in the pilot evidence.

The installer also removes the macOS quarantine attribute from the downloaded
binary. That may be intentional for a checksum-verified artifact, but it
reduces a user-visible warning and should be part of the local security review.

## Project Boundary and Anchor Guard

The CLI uses a project anchor such as `.git` or `package.json` to avoid writing
to the wrong `workflow-graph` store. `AGF_ALLOW_NO_ANCHOR=1` disables that safety
check and should be used only when the path and graph ownership are explicit.

A graph must never be shared accidentally between the user's home directory,
the LF framework and a client project.

## Sensitive Local Data

The graph, memories, session manifests, provider settings and cost ledgers may
contain project names, task descriptions, file paths, prompts or operational
history. They need the same access control, backup and retention decisions as
other project state.

---

# Local Evaluation in the LF Workspace

## Wrong-Scope Initialization

The first `agf dashboard` and `agf init` commands ran in the user home directory, not
in the LF workspace. The safety guard detected an existing
`$HOME/workflow-graph/graph.db` without a `.git` or `package.json`
anchor and refused the operation until `AGF_ALLOW_NO_ANCHOR=1` was set.

The subsequent home-directory initialization created a project named
`local-user`, a guided sample epic/task and a local dashboard at
`http://127.0.0.1:3000`. Its output also said that no recognizable source files
were present. This state must not be interpreted as LF project state.

## LF Graph Initialization

Because the LF workspace itself has no Git or package anchor, the local graph
was intentionally initialized with:

```bash
AGF_ALLOW_NO_ANCHOR=1 agf init --graph-only --no-serve --skip-neural --no-open
```

This created the local `workflow-graph/graph.db` without generating project
context files, installing hooks or starting a dashboard. The override is an
explicit test exception, not a recommended default for client projects.

## Observed Command Results

| Observation | Interpretation |
| --- | --- |
| `agf --version` returned `0.24.2` | The installed binary was identified. |
| `agf preflight` initially returned `STORE_NOT_FOUND` | The anchor guard worked; the workspace scope was ambiguous to the CLI. |
| `agf status` and `agf stats` initially reported an uninitialized graph | The LF graph did not exist before the explicit graph-only initialization. |
| `agf doctor --store` succeeded after initialization | The local SQLite store was available. |
| `agf phase` reported `BUILD` | The CLI exposes grouped lifecycle phases; this is not an LF phase transition. |
| `agf doctor --providers --no-ping` found no configured API provider | Delegated mode is the safe local evaluation mode. |
| `agf skill list` returned no installed skills in the LF graph | The public skills repository was reviewed but not installed into LF. |
| Initialization reported neural installation failure | Retrieval is degraded to hash embeddings; this is not a reason to make neural dependencies mandatory. |
| Initialization reported Playwright, Sentrux and Serena unavailable | Optional integrations were not available in the environment. |
| Initialization reported stale or out-of-date generated context | Generated context must not be treated as authoritative without review. |
| The CLI reported `DirectMCP bridge ready` | A bridge was detected or prepared; normal CLI use still does not require MCP. |

## Tracked Evaluation Task

The LF graph tracks `node_a7dcc8d81e6d`, titled `Capture agent-graph-flow
integration knowledge`, with status `in_progress`, priority `2` and tags
`documentation`, `graph-flow`, `knowledge`. Its acceptance criteria cover the
graph model, lifecycle, gates, economy, security boundaries, integration risks,
claim-versus-observation evidence and proposed-only indexing. The task declares
the module, indexes and `.ai/` records as implementation files.

---

# Fit with Existing LF Knowledge

## Relationship to Elephant-Goldfish

The approved optional `ENGINEERING_ELEPHANT_GOLDFISH.md` and this module solve different
problems:

| LF knowledge | Primary question |
| --- | --- |
| Elephant-Goldfish | Is the problem, design, evaluation rubric and implementation context understandable before coding? |
| Agent Graph Flow | Is approved work tracked, sequenced, executed, validated and measured across sessions? |

The recommended sequence is:

```text
Elephant creates and challenges durable design
Goldfish tests independent comprehension
Human approves scope and artifacts
agf projects approved work into executable nodes
Agent implements with TDD and records evidence
LF review, QA and governance approve delivery
```

Neither module should duplicate `PRD.md`, `ARCHITECTURE.md` or `SPRINTS.md`.

## Agent Mapping

The three `agf` skills can inform, but must not replace, LF agents: PLAN maps to
requirements, architecture and sprint planning; BUILD maps to Implementation / selected CLI;
HARDEN maps to Code Review, QA-Security and Tech Lead. Documentation keeps the
canonical artifacts synchronized, and the Knowledge Extractor acts only after
approved delivery and human review.

---

# Recommended Integration Boundary

## Preferred Pilot

Use `agf` as an optional, delegated execution ledger for one representative
feature and one legacy change:

1. Complete the normal LF intake, requirements, architecture and sprint
   artifacts.
2. Record the reason and scope of the pilot in `.ai/decisions.md`.
3. Create or import only approved graph nodes, with stable LF artifact links.
4. Use granular `next`, `context`, `brief`, implementation, `check` and `done`
   steps rather than autonomous delivery.
5. Keep the existing LF code review, QA/Security and Tech Lead gates.
6. Export the graph evidence and compare it with the LF task and handoff
   records.
7. Measure whether the graph reduced rework, lost context, duplicate work or
   review ambiguity without adding disproportionate overhead.

## Integration Rules for a Pilot

- Keep one graph per clearly identified project or worktree; do not reuse a
  home-directory graph for a client project.
- Use a real project anchor when possible and document any override.
- Cross-reference LF artifact IDs and graph node IDs; preserve commands, tests,
  changed files and review evidence.
- Use the project's real test runner and data boundaries. Start delegated, with
  no external MCP server, and keep ACO and experimental levers disabled.
- Pin the CLI and skills version and make rollback possible without changing
  canonical LF artifacts.

---

# Safe Command Patterns

The exact CLI contract can change. Always use the installed binary's
`agf <command> --help` and verify the current working directory first.

## Discovery

```bash
agf --version
agf doctor --store
agf doctor --providers --no-ping
agf preflight "<topic>"
agf stats --select data.byStatus
agf query --search "<topic>"
```

## Explicit No-Anchor Evaluation

Only when the directory is intentionally selected and no project anchor exists:

```bash
AGF_ALLOW_NO_ANCHOR=1 agf init --graph-only --no-serve --skip-neural --no-open
```

Do not copy this override into a general project setup guide without a security
and scope explanation.

## Planning and Execution

```bash
agf import-prd <approved-prd>
agf node add --title "<task>" --type task
agf edge add --from <node> --to <node> --type depends_on
agf gaps --severity required --json
agf next
agf context <id> --compressed
agf brief <id>
```

Implementation and testing happen in the project workspace between the graph
commands. The selected LF agent owns the actual edits and must respect the
artifact contracts.

## Validation and Handoff

```bash
agf check <id>
agf harness --help
agf metrics
agf savings
agf export
agf snapshot create
```

Use the available command help before running a command with side effects. Do
not claim that a command validated a project when only its help output was
inspected.

---

# Pilot Measures

The pilot should compare equivalent work with and without the optional graph
layer. Record at least:

- Time from approved task to review-ready result.
- Number of lost-context recoveries.
- Duplicate or out-of-scope file changes.
- Rework after code review and QA.
- Acceptance criteria coverage and missing-edge-case findings.
- Test failures, escaped defects and security findings.
- Time spent maintaining graph state and synchronizing LF artifacts.
- Input, output, cached and estimated tokens with their baselines.
- Human comprehension of the graph and exported evidence.
- False positives from `gaps`, `harness` or completion checks.

The pilot succeeds only if it improves traceability or delivery economics while
preserving LF quality, security and human approval. A high savings number with
more rework is not a successful result.

---

# Risks and Mitigations

| Risk | Impact | Mitigation |
| --- | --- | --- |
| No sandbox | Destructive or untrusted agent actions can reach the host. | Use isolation; keep the pilot away from production credentials and sensitive systems. |
| Wrong graph scope | Home, framework and client tasks can be mixed. | Require anchors, explicit paths and separate stores; record overrides. |
| Graph/artifact drift | Status becomes a second inconsistent source of truth. | Define ownership, stable IDs and a synchronization contract before automation. |
| Marketing or README overclaim | Teams adopt unverified behavior or targets. | Label evidence, inspect source and measure in the pilot. |
| Installer checksum discrepancy | A tampered or truncated artifact may be installed. | Verify independently, pin release artifacts and review the installer behavior. |
| Provider data exposure | Prompts, paths and code may leave the local environment. | Start delegated/local, classify data and review provider terms. |
| External MCP trust | Configured servers may execute or receive data outside the tool boundary. | Disable for the pilot or review every server and isolate execution. |
| Reinforcement loop | A bad route can gain historical weight and become harder to displace. | Keep routing deterministic or opt-in, retain exploration and compare to baseline. |
| Stale generated context | Agents follow outdated instructions. | Treat current code, graph and canonical artifacts as higher authority; regenerate and review. |
| Missing test infrastructure | A completion gate may be unable to prove implementation quality. | Configure the project's real tests or classify documentation-only work explicitly. |
| Version drift | CLI and skills behavior changes between runs. | Pin versions, capture `agf --version` and review release changes. |
| Local database loss | Execution history and cost evidence disappear. | Define retention, backup and export expectations before relying on the graph. |

---

# Prioritized Recommendations

## High Priority

1. Keep this module optional and outside the mandatory LF dependency graph.
2. Pilot the deterministic execution ledger in delegated mode on representative
   feature and legacy work.
3. Define source ownership and cross-references before importing or syncing LF
   artifacts.
4. Treat no-sandbox behavior, provider boundaries, graph scope and installer
   verification as explicit security review items.
5. Keep LF review, QA/Security and Tech Lead approval independent of `agf done`.

## Medium Priority

1. Add optional graph ID and evidence fields to handoff or task records only if
   the pilot shows that manual cross-referencing is valuable.
2. Compare `gaps` and `harness` findings with existing LF quality reports.
3. Evaluate the economy ledger using measured and estimated values separately.
4. Pin and review the public skills repository before placing it under
   `.agents/skills/` in any project.
5. Define a small export format for graph evidence rather than copying the full
   database into Markdown artifacts.

## Low Priority

1. Test pheromone or ACO routing only after a deterministic baseline exists.
2. Evaluate neural retrieval only when the repository has a real need and a
   reproducible dependency setup.
3. Consider direct provider routing or autonomous delivery only after delegated
   execution has demonstrated a clear benefit.

---

# Adoption Decision Gate

Before any recommendation becomes mandatory, the Framework Maintainer should
answer:

- Which LF artifact or protocol owns the information represented by each graph
  field?
- Which exact project types benefit enough to justify the CLI and SQLite state?
- What evidence proves that the graph reduces rework or context loss?
- What is the fallback when the CLI, store, provider or network is unavailable?
- How are graph data, prompts, paths, credentials and provider calls protected?
- Who reviews and resolves graph/artifact drift?
- Which checks are deterministic gates and which remain advisory?
- Can the integration be removed without changing canonical LF deliverables?
- What version, skill commit and command contract are supported?

No mandatory adoption should be approved without clear answers and a recorded
decision in `docs/ADR.md` or the appropriate LF decision record.

---

# Final Principle

The strongest lesson from `agf` is not autonomous agents or biological
branding. It is the insistence that execution state, task scope, acceptance
criteria, tests and cost evidence should survive the conversation that produced
 them.
For LF, the safest use is therefore additive:

```text
LF artifacts and governance remain canonical.
agf optionally makes approved execution explicit and measurable.
The filesystem, tests, review and human decision remain the final evidence.
```
This module is approved optional guidance; `agf` installation and operational
integration remain separately controlled and are not Framework dependencies.

---

## Version History

- `0.2.0` — 2026-11-01: Approved as optional supplemental guidance and clarified
  that this status does not authorize installing or integrating `agf`.
