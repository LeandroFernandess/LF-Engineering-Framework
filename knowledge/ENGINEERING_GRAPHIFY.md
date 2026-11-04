# Engineering Knowledge: Graphify Code Knowledge Graph

Version: 0.2.0

Status: Approved Optional

Category: Supplemental / External-tool evaluation

Owner: Leandro Fernandes
Framework Baseline: LF Engineering Framework 1.5.0; optional-reference status retained in the first public release

---

# Adoption Status

This module is approved as optional guidance for evaluating Graphify as a code
knowledge graph and context-retrieval layer for the LF Engineering System.

It is not part of the mandatory LF dependency graph. It must not silently add
Python packages, generated instructions, hooks, plugins, MCP servers, model
providers, telemetry or graph artifacts to the Framework or to a client
project.

Approval of this guidance does not resolve the documented source-to-build
provenance gap or authorize further installation, execution or integration of
Graphify. Tool use requires separate, specific owner approval after the
provenance threshold is explicitly accepted. The recommendations do not become
Framework rules, agent instructions, workflow gates or mandatory setup steps by
default.

---

# Purpose

Graphify presents a codebase as a knowledge graph: files, functions, classes,
documents and other entities become nodes, while calls, imports, definitions,
references and semantic relationships become typed edges.

Its potential LF role is narrow and complementary:

- LF owns product intent, architecture, artifacts, governance, review and
  human approval.
- `agf` can own optional execution state, task dependencies and completion
  evidence.
- Graphify can provide optional structural context about a codebase and trace
  relationships between symbols.
- RTK can optionally reduce noisy shell output at the command boundary.
- The project filesystem, tests and review evidence remain authoritative.

The useful question is not whether every LF agent should use Graphify. It is
whether a version-pinned, local-first graph can answer selected structural
questions with better traceability and lower context cost than raw file search,
without weakening source ownership or privacy controls.

---

# Non-goals

This module does not:

- Replace the LF Engineering Framework or `.ai/contracts.md`.
- Replace `PROJECT_BRIEF.md`, `PRD.md`, `ARCHITECTURE.md`, `SPRINTS.md`, ADRs,
  reviews, QA reports or human approval.
- Treat a graph query, report or edge as proof when the filesystem, tests or
  review evidence disagree with it.
- Require Graphify for every LF project, agent or maintenance change.
- Treat a graph as a replacement for fuzzy retrieval over prose, embeddings or
  a carefully scoped direct file read.
- Install `graphifyy`, run `graphify install`, create hooks or configure MCP.
- Treat public website claims, benchmark values, star counts or download
  counts as LF evidence.
- Treat Graphify's local parsing claim as proof that all content stays local;
  non-code semantic extraction and explicitly requested URL ingestion have
  different data paths.
- Duplicate the responsibilities of the existing LF artifacts or the optional
  `agf` execution ledger.

---

# Sources and Evidence

## Supplied Sources

- Supplied concepts URL: <https://graphiffy.com/concepts>
- Supplied what-is URL: <https://graphify.com/what-is-graphify>

The supplied `graphiffy.com/concepts` URL served a page titled "How Graphify
works: concepts" on 2026-09-03. The supplied `graphify.com/what-is-graphify`
URL returned HTTP 404 on the same date. The user subsequently supplied the
plain-language content attributed to that URL. That content is included as
user-provided source evidence below, but it is not treated as an independently
fetched page or as proof of the current deployed URL. The concepts page links
to several `.html` pages on `graphify.com`, but those linked page variants also
returned 404 during this evaluation.

## Related Public Sources

- Graphify home page: <https://graphify.com/>
- Official-site domain verification: <https://graphify.com/graphify-net-vs-graphify-com>
- Full machine-readable site index: <https://graphify.com/llms-full.txt>
- Public repository: <https://github.com/Graphify-Labs/graphify>
- Reviewed v8 README: <https://raw.githubusercontent.com/Graphify-Labs/graphify/v8/README.md>
- Reviewed v8 package metadata: <https://raw.githubusercontent.com/Graphify-Labs/graphify/v8/pyproject.toml>
- Reviewed v8 security policy: <https://raw.githubusercontent.com/Graphify-Labs/graphify/v8/SECURITY.md>

The public site and repository identify `graphify.com`, Graphify Labs and the
PyPI package `graphifyy` as related. A follow-up check of Graphify's official
domain-verification page on 2026-11-01 found its statement that `graphiffy.com`
no longer resolves; that page records its own check on 2026-10-27. The historical
operator or affiliation of the supplied `graphiffy.com/concepts` page was not
established. Keep that captured page as unverified historical evidence, not as
an authority for current product claims, package identity or release provenance.

Consulted: 2026-09-03; official-site follow-up: 2026-11-01.

## Evidence Classes

Use these labels when referring to Graphify in LF records:

| Label | Meaning |
| --- | --- |
| Public claim | Behavior or property described by the supplied pages, public site, repository, README, package metadata or security policy. |
| Local observation | Behavior actually observed from a locally installed Graphify binary, generated graph or LF project run. None was performed in this evaluation. |
| LF recommendation | A proposed use or boundary that still requires human review and pilot evidence. |

The supplied pages, the public repository and a future installed package must
not be assumed to be identical. Domain aliases, branch versions, generated
skills, package metadata and local configuration can change behavior.

---

# Executive Synthesis

Graphify's central idea is to preserve code relationships as explicit graph
edges instead of reducing a repository to independent text chunks. A query can
then traverse callers, imports, definitions or other links and return a
scoped, inspectable subgraph.

The strongest candidate for LF adoption is the provenance discipline:

- Static facts extracted from source should be distinguished from model-derived
  relationships.
- A result should identify the entities and source locations that support it.
- Unresolved dynamic behavior should remain visible as uncertainty rather than
  becoming an unmarked guess.
- A graph should be refreshed when the source changes and should never outrank
  the current filesystem or tests.

The higher-risk claims are broad language coverage, semantic accuracy, token
savings, privacy, automatic freshness, MCP safety and assistant integration.
Those claims require a version-pinned pilot on a representative project.

The recommended LF position is an optional, code-only, local-first experiment
with no hooks or automatic agent instructions. Use the graph for discovery and
impact questions; use canonical artifacts and the repository for decisions and
proof.

---

# Plain-Language Definition

Graphify is presented as a free, open-source Apache 2.0 command-line tool and
assistant skill that turns a codebase into a knowledge graph. It parses code on
the user's machine, writes local graph files and gives an assistant a way to
query structure instead of repeatedly grepping source text.

The user-provided content attributed to `graphify.com/what-is-graphify` gives
the shortest operational description:

1. Install the PyPI package `graphifyy`, whose executable is `graphify`.
2. Register the `/graphify` skill with the selected coding assistant.
3. Run `/graphify .` to create `graphify-out/graph.html`,
   `graphify-out/GRAPH_REPORT.md` and `graphify-out/graph.json`.
4. Query the graph from the assistant or terminal with structural questions,
   paths and explanations that can include `file:line` citations.

The content also states that the graph is exposed through MCP and that the
structural graph does not itself write code or take actions. These are public
claims to verify for the selected release, not actions performed in this LF
workspace.

# What Graphify Deliberately Is Not

## Not RAG or Vector Search

The supplied what-is content explicitly says there are no embeddings and no
similarity retrieval in the core graph path. Graphify extracts explicit
relationships such as calls, imports and references into nodes and edges, then
answers with traversed paths rather than nearest-neighbor chunks.

This is a retrieval strategy distinction, not a promise that every answer is
exact. Inferred edges, parser gaps and stale output can still produce an
incorrect path. Embeddings or RAG remain appropriate for fuzzy search over
large prose collections.

## Not a Cloud Service

The supplied content describes the local tool as having no hosted backend,
account or telemetry and says that code parsing happens on the user's machine.
The concepts and README materials qualify that non-code semantic extraction,
configured model backends and explicit URL ingestion can use network services.
Therefore LF should say "local-first code parsing" rather than make an
unqualified claim that no data can leave the machine.

## Not a Code Generator or Agent

Graphify is a map and query surface. The existing assistant remains responsible
for interpreting context, editing files, running commands and making decisions.
Graphify should not be treated as an autonomous implementer, a task owner or a
replacement for LF review and approval.

---

# Honest Limits

Graphify's structural output is useful context, not ground truth:

- Inferred edges are guesses and must be checked against current source.
- Static extraction can miss dynamic dispatch, reflection and configuration-
  driven wiring; ambiguous relationships should remain visible.
- `graph.json` is a snapshot and becomes stale after edits, branch changes,
  merges or incomplete updates.
- The code-only graph can be built without a model, but deeper semantic
  extraction for documents and media needs a configured model backend.
- A graph path can narrow investigation; it cannot prove behavior, security,
  requirements satisfaction or test coverage.

These limits are part of the product definition, not exceptional failure cases.

# Conceptual Model

## Code Knowledge Graph

The supplied concepts page defines a code knowledge graph as a machine-readable
map of a codebase. Typical nodes include:

- Files and modules.
- Functions, methods and classes.
- Database tables and other technical entities.
- Documentation concepts and services.

Typical typed, directed edges include:

- `calls` between executable symbols.
- `imports` between modules or packages.
- `defines` between a file and a symbol.
- `references` between code, documents and concepts.
- `inherits`, `uses` or other relationships resolved by the extractor.

The edge vocabulary is an implementation detail until verified from a pinned
release. LF should consume stable query and evidence contracts rather than
copying an assumed internal schema into Framework artifacts.

## Deterministic and Semantic Passes

The public concepts page describes two distinct extraction paths:

1. Code is parsed locally with bundled tree-sitter grammars. Functions,
   classes, imports and calls can become graph entities because a parser found
   them, without an LLM call.
2. Content that an AST cannot represent, such as documents, PDFs, SQL schemas
   and Terraform, can be connected through a configured model backend. Those
   relationships are described as inferred rather than parsed facts.

This distinction is valuable but does not remove all uncertainty. A parser can
miss generated or dynamic behavior, and a semantic pass can produce an
incorrect relationship while still attaching a provenance label. The source
type, extractor version, model, prompt and refresh time should be recorded in
pilot evidence when semantic extraction is enabled.

## Edge Provenance

The supplied concepts page names three edge states:

| Tag | Interpretation | LF treatment |
| --- | --- | --- |
| `EXTRACTED` | The parser or direct source evidence established the relationship. | Candidate fact; verify against the current source for consequential decisions. |
| `INFERRED` | A model or resolver connected evidence that was not explicit in the parsed structure. | Hypothesis; require source inspection before implementation or approval. |
| `AMBIGUOUS` | Evidence exists but dynamic dispatch, reflection, generated names or another limitation prevented full resolution. | Preserve as uncertainty and investigate; never silently promote it to fact. |

The v8 README emphasizes `EXTRACTED` and `INFERRED`, while the concepts page
also describes `AMBIGUOUS`. This difference is an example of why the exact
installed version and output schema must be pinned before automation.

## Graph, Grep, Embeddings and RAG

The public comparison is directionally useful:

| Approach | Strong at | Weak at | LF use |
| --- | --- | --- | --- |
| Grep or direct search | Exact strings, fast local checks and source confirmation | Multi-hop relationships and renamed or indirect concepts | Keep as an authoritative verification tool. |
| Embeddings or vector search | Fuzzy retrieval over large prose collections | Exact call paths, typed relationships and deterministic provenance | Use when semantic similarity is the actual need. |
| Chunk-based RAG | Combining retrieved text with a model answer | Links severed by chunk boundaries and multi-hop impact questions | Use with explicit citations and source checks. |
| Graphify-style traversal | Callers, imports, paths, neighborhoods and relationship explanations | Fuzzy prose, incomplete parsing and unresolved dynamic behavior | Consider for scoped structural discovery after a pilot. |

Graph traversal is not automatically better retrieval. It is a better fit for a
question such as "what calls this service?" than for "which document expresses
the same policy?" A hybrid strategy may be appropriate, but ownership and
fallback behavior must remain explicit.

---

# Pipeline and Outputs

## Public Pipeline

The public materials describe a flow similar to:

```text
Project files
    |
    +--> local detection and AST extraction
    |
    +--> optional semantic extraction for non-code content
    |
    +--> graph construction and optional community analysis
    |
    +--> graph.json, GRAPH_REPORT.md and graph.html
    |
    +--> query, path, explain or assistant context
```

The documented assistant command is `/graphify .` or, in some platforms,
`$graphify`. The terminal command and skill syntax vary by host and should be
tested for the selected assistant rather than copied globally.

## Generated Artifacts

The public README describes a `graphify-out/` directory containing:

- `graph.html`: interactive visualization.
- `GRAPH_REPORT.md`: broad architecture highlights, communities and suggested
  questions.
- `graph.json`: the graph used for subsequent queries.

The output can contain source paths, symbol names, documentation text and
relationships. It is therefore a project artifact with privacy, retention and
freshness implications, not disposable agent output by default.

The repository recommends committing the graph for team reuse while excluding
local cost data and optionally caching files. LF should not adopt that policy
without deciding whether generated graph data is a canonical artifact,
derived cache or sensitive local state. A first pilot should keep outputs in a
disposable directory and document the retention decision.

## Refresh and Staleness

Public instructions describe `--update`, `graphify update .`, watch mode and
optional Git hooks. A graph can be stale after a source edit, branch switch,
merge, generated-code change or failed incremental extraction.

The minimum LF invariant is:

```text
graph timestamp and source revision must be known before trusting a query
```

If the graph is stale or incomplete, fall back to direct source inspection and
record the limitation. A query result without source revision information is
not sufficient completion evidence.

---

# Assistant and MCP Boundaries

## Skill Installation

The public installation flow is:

```bash
uv tool install graphifyy
```

Project-scoped installation can write assistant skill or instruction files.
Platform-specific commands can also write hooks, plugins or settings. The
public README lists OpenCode among supported platforms and describes an
OpenCode installation that writes an instruction file and a tool-execution
plugin.

None of these changes were made in the LF workspace. Assistant skill, hook,
plugin or settings integration remains outside the approved optional guidance
and is not authorized. Any future integration requires a separate owner-approved
pilot with exact file ownership, rollback and review processes.

## Query Surface

The public examples include:

```bash
```

These operations should be treated as context discovery. The answer must still
be checked against current source, tests and approved LF artifacts before it is
used for architecture, implementation or governance.

## MCP

The public README describes an optional MCP server with structured operations
such as `query_graph`, `get_node`, `get_neighbors` and `shortest_path`. It
supports local stdio and an opt-in HTTP transport, with a loopback default and
an API-key option for exposed servers.

MCP is an integration boundary, not a trust boundary. Before enabling it, the
pilot must verify:

- The exact graph path accepted by the server.
- Whether a query can read outside the intended project directory.
- Authentication, bind address, session handling and logs for HTTP mode.
- Error behavior for malformed or corrupted graph data.
- The provider and assistant data path after a graph result is returned.

LF should start with direct CLI queries in a disposable project. Do not add an
MCP server or assistant plugin to the Framework by default.

---

# Security and Privacy

## Public Security Claims

The reviewed v8 security policy describes Graphify as a local development tool
that makes no network calls during graph analysis, except for explicit URL
ingestion. It documents claimed mitigations for:

- URL scheme validation, private-address blocking and redirect checks.
- Download size limits and non-2xx response handling.
- Graph path validation for the MCP server.
- HTML label sanitization and control-character limits.
- Prompt-injection delimiters for semantic extraction.
- YAML escaping, replacement decoding and disabled symlink following.
- Corrupted graph recovery and no execution of source code during AST parsing.

These are public claims about a particular source snapshot. They are not a
substitute for a QA-Security review of the selected package and generated
configuration.

## Data Paths

The data path differs by input type:

| Input | Claimed path | LF concern |
| --- | --- | --- |
| Code-only corpus | Local tree-sitter parsing; no model API required. | Prefer this first for sensitive repositories and verify it is truly offline. |
| Documents, PDFs, images or other non-code content | Semantic pass through the assistant's model or a configured backend. | Classify data before sending it to a provider; record backend and residency. |
| Explicit URLs or media ingestion | Network fetch initiated by a user command. | Treat as untrusted input; verify SSRF, size, redirect and content controls. |
| Local graph and report | Files under the project output directory. | Apply access, retention, ignore and commit rules. |
| MCP stdio | Local process communication. | Review process permissions and graph path resolution. |
| MCP HTTP | Network server when explicitly enabled. | Require loopback or reviewed exposure, authentication and monitoring. |

The site claims no account, hosted index or telemetry for the local tool, while
the page footer mentions privacy-friendly site analytics. The distinction
between website analytics, local-tool telemetry and enterprise services must be
confirmed before making a blanket privacy claim.

## Prompt Injection and Untrusted Content

Documentation and source comments can be attacker-controlled input. A graph
that sends those contents to a model can carry prompt-injection text through
nodes, labels, summaries or inferred edges. Delimiters and sanitization reduce
risk but do not make semantic extraction trustworthy by default.

The pilot should:

- Start with a code-only corpus and no untrusted URLs or media.
- Keep model-backed extraction disabled until the data path is approved.
- Treat every inferred edge and generated report sentence as untrusted output.
- Test malicious labels, comments, filenames, Markdown, YAML and HTML.
- Avoid exposing an HTTP MCP server during the first run.

## Installation and Hook Risk

The public installation commands execute a package manager or installer and can
write assistant instructions, plugins or Git hooks. Those generated files can
change how an agent reads source or which commands it executes.

Before any installation:

- Pin the package version and record package provenance and hashes.
- Inspect the package and generated diff in a disposable environment.
- Do not install global hooks or OpenCode plugins during the baseline.
- Keep an explicit uninstall and rollback path.
- Run the tool with the minimum repository and host permissions practical.

---

# Source and Version Uncertainty

The public materials contain unresolved inconsistencies that affect trust:

| Item | Observed values or statements | Required response |
| --- | --- | --- |
| Supplied domains | The 2026-09-03 capture found a concepts page at `graphiffy.com` and a 404 at `graphify.com/what-is-graphify`; Graphify's official domain-verification page now says `graphiffy.com` no longer resolves (its check is dated 2026-10-27). Historical affiliation remains unverified. | Do not treat the supplied domain as official or use it for package/release provenance. Prefer the official site, repository and pinned package. |
| Project identity | Public repository is `Graphify-Labs/graphify`; older README or metadata may reference another owner. | Record the exact repository, branch, commit and package source used. |
| Version | Site banner reports `v0.9.35`; reviewed v8 package metadata reports `0.9.53`; security policy supports `0.3.x`. | Do not generalize security or behavior across versions. Pin and verify the chosen release. |
| Language count | Public pages describe 36 languages or 37 tree-sitter grammars in different places. | Treat coverage as a claim until tested against the LF/client stack. |
| Edge schema | Concepts page describes `EXTRACTED`, `INFERRED` and `AMBIGUOUS`; README examples emphasize two tags. | Validate the output schema before writing integrations or gates. |
| Privacy | Local tool is described as no-telemetry, while the public site has analytics and a separate service model. | Separate core, website and enterprise data paths in the privacy decision. |
| Benchmarks | Public benchmark and marketing values are not independently reproduced in LF. | Use them as hypotheses, not acceptance criteria. |

These are not reasons to reject the tool. They are reasons to make release
identity and evidence scope explicit before relying on it.

---

# Fit with LF, agf and RTK

## Layered Model

The proposed combined model is:

```text
LF artifacts and governance
        |
        +--> agf optional task state and execution evidence
        |
        +--> Graphify optional code structure and relationship context
        |
        +--> RTK optional shell-output reduction
        |
        v
Current filesystem, commands, tests, review and human approval
```

The tools are complementary only when each has one owner. Graphify must not
become a second PRD, architecture record, task tracker or completion proof.
RTK must not hide the source or test evidence that Graphify or `agf` needs.

## Ownership Boundary

| Concern | LF authority | Possible Graphify representation |
| --- | --- | --- |
| User intent and product scope | `PROJECT_BRIEF.md`, `PRD.md` | Referenced document nodes; never an independent requirement source. |
| Architecture and decisions | `ARCHITECTURE.md`, `docs/ADR.md` | Linked rationale or source references; human-approved records remain canonical. |
| Sprint and task state | `SPRINTS.md`, `.ai/`, optional `agf` graph | Related files and symbols; no task status inferred from graph degree. |
| Code and behavior | Current repository and tests | Parsed nodes, edges, paths and citations. |
| Review and quality | `REVIEW.md`, QA report, Tech Lead decision | Context for discovery only; graph output cannot replace the reports. |
| Reusable knowledge | `knowledge/` after review | Optional reference to verified concepts and pilot lessons. |

## Candidate Consumers

- Software Architect: trace dependencies and likely impact paths before
  consulting the canonical architecture records.
- Sprint Planner: identify candidate symbols and affected modules while
  decomposing approved work.
- Implementation / selected CLI: answer scoped call, import and ownership questions before
  reading a large source surface.
- Code-Reviewer: compare changed symbols with callers, imports and tests.
- QA-Security: inspect graph freshness, provenance, untrusted inputs and missed
  dynamic behavior.
- Documentation: use source locations to improve navigation without duplicating
  the Framework.

Graphify should remain an optional context aid. It should not be loaded by every
agent or every task merely because it is installed.

---

# Recommended Integration Boundary

## Pilot Sequence

1. Select one medium-complexity code project and one change with known callers,
   imports or cross-module impact.
2. Record the pilot scope, data classification and non-goals in `.ai/decisions.md`.
3. Pin the Graphify package, Python version, repository commit and optional
   extras; record hashes and the exact command used.
4. Run a code-only extraction in a disposable directory with no assistant hook,
   no MCP server and no cloud credentials.
5. Record source revision, graph timestamp, node and edge counts, warnings,
   outputs and runtime.
6. Ask a fixed set of structural questions and compare results with direct
   source inspection, tests and reviewer judgment.
7. Include dynamic dispatch, generated code, reflection, renamed symbols,
   ignored files, deleted files and stale-graph scenarios in the fixture.
8. If the baseline is positive, test semantic documents separately with an
   approved local or organizational backend and explicit data-residency rules.
9. Only after the manual baseline succeeds, evaluate a project-scoped assistant
   skill or MCP integration in a disposable configuration.
10. Remove the integration if traceability, privacy, freshness or maintenance
    cost is worse than the raw-source baseline.

## Recommended Defaults

- Keep the module approved as optional guidance and the tool separately opt-in.
- Prefer code-only, local parsing for the first experiment.
- Keep model-backed semantic extraction and URL ingestion disabled by default.
- Do not install global or project hooks during the baseline.
- Do not write Graphify instructions into `AGENTS.md`, `.opencode/` or agent
  registries without an explicit Framework decision.
- Treat `graph.json`, `GRAPH_REPORT.md` and `graph.html` as sensitive derived
  artifacts until retention and commit policy are decided.
- Require source revision and graph freshness in any query evidence.
- Treat `INFERRED` and `AMBIGUOUS` edges as hypotheses, not acceptance evidence.
- Fall back to current source and tests for consequential questions.
- Keep an uninstall, rollback and no-Graphify path available.

## Pilot Measures

Compare equivalent work with Graphify unavailable and available. Record:

- Query precision, recall and citation correctness for a fixed question set.
- Correctness of `calls`, `imports`, `defines`, `inherits` and path results.
- False positives, false negatives and unresolved dynamic relationships.
- Graph freshness after edits, branch changes, merges and partial failures.
- Node and edge counts, extraction duration and incremental update duration.
- Context bytes or provider tokens with and without scoped graph retrieval.
- Number of direct source reads still required to make a safe decision.
- Time to answer, rework, review findings and escaped defects.
- Model calls, provider, data residency and sensitive content exposure.
- MCP or hook failures, permissions, generated-file changes and rollback effort.
- Maintenance cost for version upgrades, ignored files and schema changes.

Success means better structural discovery without hidden semantic loss, stale
answers, unsafe data flow or duplicated sources of truth. A graph that is large,
fast or visually impressive is not automatically useful.

---

# Risks and Mitigations

| Risk | Impact | Mitigation |
| --- | --- | --- |
| Stale graph | The agent follows deleted, renamed or uncommitted relationships. | Record source revision and freshness; refresh or fall back to source. |
| Static-analysis blind spot | Dynamic dispatch, reflection or generated code is missed. | Include known hard cases and require direct source/test verification. |
| Incorrect inferred edge | A model-derived relationship causes wrong impact analysis. | Label provenance, expose confidence and treat inferred edges as hypotheses. |
| Prompt injection in content | Reports or semantic extraction alter agent behavior. | Start code-only; delimit untrusted content; review generated output. |
| Sensitive content sent to a provider | Source, documents or media leave approved residency. | Classify inputs, disable semantic pass by default and pin approved backend. |
| URL ingestion abuse | SSRF, oversized downloads or malicious content reaches the process. | Keep ingestion off; review URL validation and network boundaries before use. |
| MCP exposure | A local graph becomes readable over an unsafe interface. | Use stdio or loopback first; require authentication and path tests for HTTP. |
| Generated hook or plugin | Agent behavior changes silently and becomes hard to roll back. | Manual baseline first; inspect diffs and keep project-scoped rollback. |
| Output artifacts leak data | `graph.json`, HTML or reports expose paths and source concepts. | Define access, retention, ignore and commit policies before team use. |
| Package or installer compromise | Remote code executes with user permissions. | Pin provenance, inspect package, verify hashes and use isolation. |
| Schema/version drift | Integrations break or silently misread edge types. | Pin release, test output schema and revalidate after upgrades. |
| Marketing claims overfit | LF adopts unsupported performance or quality expectations. | Use fixed project fixtures and provider billing data, not headline claims. |
| Duplicate source of truth | Graph findings are mistaken for requirements or architecture. | Keep ownership matrix and canonical artifact links explicit. |
| Partial assistant coverage | Some tools use the graph while direct reads bypass it. | Document the actual integration boundary and never claim universal coverage. |

---

# Prioritized Recommendations

## High Priority

1. Keep Graphify as an approved optional supplemental module, not a mandatory LF
   dependency.
2. Resolve package, repository, branch, version and domain provenance before
   installing or integrating it.
3. Start with code-only local parsing in a disposable project and no hooks,
   plugins, MCP or telemetry.
4. Require source revision, freshness and provenance in every pilot result.
5. Measure structural correctness and review quality separately from context or
   token reduction.
6. Keep current files, tests, LF artifacts and human review above graph output.

## Medium Priority

1. Define a small evidence record containing package identity, source revision,
   graph timestamp, query, returned paths, provenance, direct verification and
   outcome.
2. Compare Graphify retrieval with direct search, existing LF context rules,
   `agf` context packs and RTK-filtered commands to detect duplicated or hidden
   information.
3. Test project-local ignore rules, incremental update behavior and generated
   output retention before any team sharing.
4. Review semantic extraction and MCP separately from deterministic code
   parsing; do not let a successful code-only test approve both.

## Low Priority

1. Evaluate project-scoped OpenCode or other assistant instructions only after
   the manual baseline is positive.
2. Evaluate MCP HTTP or shared graph serving only after local stdio behavior,
   authentication and path isolation are proven.
3. Consider committed graph artifacts only after the team decides whether they
   are canonical, cacheable or sensitive derived data.

---

# Adoption Decision Gate

Before Graphify becomes a standard LF integration, the Framework Maintainer
should answer:

- Which repository, package, branch, version and checksum are approved?
- Can the historical operator or affiliation of the supplied `graphiffy.com`
  content be independently established if that content is reconsidered?
- Which graph data is allowed to leave the machine, if any?
- Which input classes require semantic extraction, and which are code-only?
- Who owns graph freshness, generated output, retention and deletion?
- Which edges are acceptable as context and which require direct verification?
- How are dynamic, ambiguous, stale or partial results surfaced to agents?
- What exact metric proves value: correctness, time, context tokens, cost or
  reduced rework?
- How is a skill, hook, plugin or MCP server audited, disabled, upgraded and
  removed?
- Can the integration be removed without changing canonical LF artifacts?

The decision must be recorded in `docs/ADR.md` or the appropriate LF decision
record. A successful graph build, attractive visualization or query response is
not sufficient for mandatory adoption.

---

# Final Principle

Graphify's durable lesson is that code relationships should be represented and
traced instead of repeatedly rediscovered from disconnected text. For LF, the
safe boundary is additive:

```text
LF governs intent, artifacts, quality and approval.
agf optionally governs executable task state and evidence.
Graphify optionally exposes code structure and relationship context.
RTK optionally reduces shell-output noise without hiding required signals.
The current filesystem, tests and human review remain authoritative.
```

Graphify is approved as an optional context-layer reference, not a Framework
requirement. The documented source-to-build provenance gap remains unresolved;
do not install, execute or integrate the tool further without separate owner
approval of an explicit provenance threshold.

---

## Version History

- `0.2.0` — 2026-11-01: Approved as optional supplemental guidance; updated
  official-domain and PyPI-publisher evidence and retained the source-to-build
  provenance hold and separate tool-use approval boundary.
