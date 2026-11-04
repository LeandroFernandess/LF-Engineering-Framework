# Engineering Knowledge: RTK (Rust Token Killer)

Version: 0.2.0

Status: Approved Optional

Category: Supplemental / External-tool evaluation

Owner: Leandro Fernandes
Framework Baseline: LF Engineering Framework 1.3.0; adoption status updated post-tag

---

# Adoption Status

This module is approved as optional guidance for evaluating RTK as a
command-output filtering layer for the LF Engineering System.

It is not part of the mandatory LF dependency graph. It must not silently add
hooks, plugins, generated instructions, telemetry, configuration, provider
requirements or command-rewriting behavior to the Framework or to a client
project.

This approval does not authorize installing RTK or enabling hooks, plugins,
telemetry, generated instructions or command rewriting. Any tool installation
or integration requires separate, specific owner approval. The recommendations
do not become Framework rules, agent instructions, workflow gates or mandatory
setup steps by default.

---

# Purpose

RTK (Rust Token Killer) is a Rust CLI proxy that runs supported shell commands,
filters or summarizes their output and returns a smaller result to an AI agent.
It can also rewrite raw commands through agent hooks so that the user or agent
does not need to type the `rtk` prefix manually.

Its potential LF role is narrow and complementary:

- LF owns intent, artifacts, architecture, task scope, agent roles, review and
  human approval.
- `agf` can own optional execution graph state and task evidence.
- RTK can own optional command-output reduction at the shell boundary.
- The underlying command, repository, tests and review remain authoritative.

RTK should therefore be evaluated as a context and observability optimization,
not as a replacement for LF governance or `agf` task control.

---

# Non-goals

This module does not:

- Replace the LF Engineering Framework or `.ai/contracts.md`.
- Claim that a 60-90% output reduction is a 60-90% bill reduction.
- Require RTK for every project, agent or command.
- Treat filtered output as equivalent to full output without a recovery path.
- Treat RTK hooks, permissions or filters as a sandbox or security boundary.
- Install an OpenCode plugin, modify settings or enable telemetry.
- Treat website examples, benchmarks or `rtk gain` totals as LF targets.
- Duplicate the responsibilities of `PRD.md`, `ARCHITECTURE.md`, `SPRINTS.md`,
  reviews, QA reports or the task graph.

---

# Sources and Evidence

## Public Sources

- Official site: <https://www.rtk-ai.app/>
- Repository: <https://github.com/rtk-ai/rtk>
- README: <https://raw.githubusercontent.com/rtk-ai/rtk/master/README.md>
- Architecture: <https://raw.githubusercontent.com/rtk-ai/rtk/master/docs/contributing/ARCHITECTURE.md>
- Technical flow: <https://raw.githubusercontent.com/rtk-ai/rtk/master/docs/contributing/TECHNICAL.md>
- Security policy: <https://raw.githubusercontent.com/rtk-ai/rtk/master/SECURITY.md>
- Installer: <https://raw.githubusercontent.com/rtk-ai/rtk/master/install.sh>
- Telemetry policy: <https://raw.githubusercontent.com/rtk-ai/rtk/master/docs/TELEMETRY.md>
- Configuration: <https://raw.githubusercontent.com/rtk-ai/rtk/master/docs/guide/getting-started/configuration.md>
- Hook artifacts: <https://raw.githubusercontent.com/rtk-ai/rtk/master/hooks/README.md>
- OpenCode hook: <https://raw.githubusercontent.com/rtk-ai/rtk/master/hooks/opencode/README.md>
- Savings explanation: <https://raw.githubusercontent.com/rtk-ai/rtk/master/docs/guide/resources/savings-explained.md>
- Benchmarks: <https://www.rtk-ai.app/benchmarks/>
- Installation page: <https://www.rtk-ai.app/docs/getting-started/installation/>
- Supported agents: <https://www.rtk-ai.app/docs/getting-started/supported-agents/>

Consulted: 2026-09-03.

The user-installed release reported itself as `rtk 0.47.0`.

## Evidence Classes

Use these labels when referring to RTK in LF records:

| Label | Meaning |
| --- | --- |
| Public claim | Behavior described by the site, repository, documentation or installer. |
| Local observation | Behavior observed from the installed binary in the LF workspace. |
| LF recommendation | A proposed boundary or use that still needs pilot evidence. |

The public documentation and the installed binary are not assumed to be
identical. The README contains at least one stale example version, the website
benchmark page currently says that no benchmark data is published, and the
Disclaimer describes telemetry differently from the README and telemetry policy.

---

# Executive Synthesis

RTK addresses a real bottleneck in agent-driven development: shell commands
often return progress bars, repeated passing tests, boilerplate, directory
noise and verbose metadata that consume context without improving a decision.

Its strongest engineering ideas are:

- Keep filtering at a clearly defined command boundary.
- Preserve exit codes and meaningful errors.
- Fall back to the original output when a filter cannot safely process it.
- Preserve a full-output recovery path when output is truncated or a command
  fails.
- Measure raw and filtered output separately from actual provider billing.
- Make disabling or excluding a command explicit and easy.

Its main risks are equally important:

- A filter can hide information that the agent needs.
- A hook can silently change the command an agent executes.
- Raw failure output and local history can contain sensitive data.
- The proxy executes commands with the user's host permissions.
- Silent telemetry, generated configuration and remote installers need explicit
  trust decisions.

The recommended LF position is an opt-in, delegated pilot using manual RTK
commands first, followed by an OpenCode plugin only if measured benefit exceeds
semantic, operational and security cost.

---

# What RTK Does

## Proxy Boundary

The public architecture describes this flow:

```text
Agent or user command
        |
        v
Optional hook rewrites `git status` to `rtk git status`
        |
        v
RTK executes the underlying command
        |
        v
RTK filters, groups, truncates or summarizes output
        |
        v
Agent receives compact output and the underlying exit code
```

The Rust binary routes commands to specialized modules. Complex formats use
compiled Rust filters; simpler predictable text can use trusted TOML filters.
Unknown or unsupported commands pass through unchanged.

RTK is not an execution graph. It does not define task dependencies, product
requirements, architectural approval or a delivery lifecycle.

## Filtering Strategies

The public architecture describes these strategies:

| Strategy | Typical use | Main risk |
| --- | --- | --- |
| Stats extraction | `git status`, `git log`, package lists | Details useful for diagnosis may disappear. |
| Error or failure focus | Tests, builds and linters | Passing context or warnings may be relevant to a decision. |
| Grouping | Repeated lint or grep results | Grouping can hide location-specific patterns. |
| Deduplication | Repeated logs | Frequency or ordering can matter. |
| Structure-only output | JSON and dependency data | Values may be needed, not only keys and types. |
| Code filtering | Smart file reads and summaries | Signatures cannot replace implementation reasoning. |
| Tree compression | `ls`, `find` and directory output | File order or hidden files may matter. |
| Progress filtering | Package installation and downloads | Progress can reveal a hang or partial failure. |
| JSON or NDJSON parsing | Structured tools and streaming test events | Parser drift can lose new fields or events. |
| State-machine parsing | Test runners with phases and summaries | Unrecognized formats need a raw fallback. |

The right strategy depends on the consumer's decision. Aggressive compression is
appropriate for repetitive context, not automatically for security evidence,
production diagnostics, migration output or an explicitly requested verbose
command.

## Raw Recovery

The documented tee system saves full raw output locally on command failure and
prints a path for later reading. Configuration also supports saving raw output
on every command or disabling tee.

The default settings described publicly are:

- Tee enabled for failures.
- Maximum of 20 saved files.
- Maximum file size of 1 MB.
- Local retention and database history commonly default to 90 days.

Raw recovery is valuable because an agent can inspect the failure without
re-running a potentially expensive or stateful command. It also means the tee
directory is a sensitive data store and must be included in project privacy and
retention decisions.

---

# Command and Hook Integration

## Manual Prefixing

Every supported command can be invoked explicitly, for example:

```bash
rtk git status
rtk git diff
rtk grep "pattern" .
rtk find "*.rs" .
rtk test "cargo test"
rtk vitest
rtk tsc
```

The explicit form is the safest first pilot because the change is visible and
does not patch an agent's configuration.

## Rewrite Registry

The `rtk rewrite` command is the single decision point used by hooks. Public
documentation describes support for simple and compound shell commands,
including `&&`, `||`, `;`, pipes and redirects, with conservative rules for
heredocs, arithmetic expressions and pipeline stages.

Important controls include:

- `RTK_DISABLED=1` disables rewriting for one command.
- `hooks.exclude_commands` excludes commands or command patterns globally.
- Already-prefixed `rtk` commands are not recursively prefixed.
- Explicitly detailed flags should be respected rather than aggressively
  compressed.
- A command that cannot be safely classified should remain raw.

An LF pilot must test compound commands, redirections, pipes, environment
prefixes, quoted arguments, failures and explicit verbose flags. A successful
rewrite is not enough; the underlying command must still mean the same thing.

## Hook Tiers

The public supported-agent guide groups integrations into three tiers:

| Tier | Mechanism | Behavior |
| --- | --- | --- |
| Full hook | Agent hook API or native hook binary | Rewrites before the agent executes the command. |
| Plugin | TypeScript, JavaScript or Python plugin | Mutates a tool call when the agent supports it. |
| Rules file | Agent instructions such as `AGENTS.md` | Relies on the model choosing `rtk <command>`. |

Listed integrations include Claude Code, Cursor, GitHub Copilot, Gemini CLI,
OpenCode, Pi, OpenClaw, Hermes, Factory Droid, Cline, Windsurf, Codex, Kilo
Code, Google Antigravity and Mistral Vibe. Availability and behavior vary by
agent and should not be generalized from one hook implementation.

## OpenCode Integration

The documented OpenCode integration is a TypeScript plugin installed at:

```text
~/.config/opencode/plugins/rtk.ts
```

It listens to `tool.execute.before`, invokes `rtk rewrite` through `zx` and
mutates `args.command` when the rewritten command differs. This is a plugin
side effect on the agent configuration, not a change to the LF Framework.

The user did not run `rtk init --global --opencode`. Local verification reported:

- `rtk 0.47.0` is installed.
- No RTK hook is installed.
- The OpenCode plugin is not found.
- `settings.json` exists but has no RTK hook.
- `RTK.md`, Claude hooks and Cursor hooks are not found.

The current OpenCode workflow uses dedicated `Read`, `Grep` and `Glob` tools in
addition to shell commands. The RTK project documents automatic rewriting for
Bash or terminal tool calls; these dedicated tools do not pass through the
Bash hook. RTK therefore cannot be described as filtering all context in an
OpenCode session.

## Hook Failure Contract

Public hook documentation says hooks should fail open:

- Missing RTK binary: warn and let the raw command execute.
- Invalid input: pass through unchanged.
- Rewrite failure: execute the original command.
- Filter failure: return raw output.
- Hook errors should not block the user's command.

This is a useful safety invariant but must be tested per agent. The public hook
documentation also lists a known gap where a Gemini invalid-JSON path exits
non-zero, which could violate the non-blocking contract. A pilot must not assume
that every listed integration has identical failure behavior.

---

# Token Economy and Measurement

## What Is Actually Measured

RTK's own documentation correctly limits its main claim to Bash output:

```text
raw shell output -> filtered shell output -> agent input
```

The savings chain is broader:

```text
model input = shell output + prompt + system prompt + history
model bill = model input + model output + provider pricing rules
```

RTK controls only the first term. It does not reduce model output tokens,
prompts, system instructions or conversation history. A 90% reduction in one
command's output cannot be cited as a 90% reduction in a session bill.

## Estimator Limits

The public source documents an estimator equivalent to:

```text
estimated tokens = output bytes / 4
```

RTK ships no model-specific tokenizer. The percentage is useful for comparing
raw and filtered output through the same estimator; absolute token counts are
approximate and should not be treated as provider invoice data.

`rtk gain` is therefore an operational trend instrument. It is not, by itself,
proof of API cost reduction, reasoning improvement, session extension or return
on investment.

## Claims Versus Evidence

The website presents examples such as approximately 89% output savings and
large lifetime token totals. Its benchmark page currently states that no
benchmark data has been published. These materials are useful hypotheses and
demonstrations, not LF performance targets.

The public repository is more precise: it says percentages refer to Bash output
and that absolute token counts are approximate. The pilot should preserve this
wording and report at least:

- Raw output bytes and filtered output bytes.
- Estimated tokens using the RTK estimator.
- Provider-reported input and output tokens when available.
- Actual command duration and RTK overhead.
- Exit-code preservation.
- Information lost, recovery requests and user corrections.
- Rework, review findings and escaped defects.

Only after these values are measured together should the LF team discuss cost or
quality impact.

---

# Tracking, Configuration and Trust

## Local Tracking

RTK stores command history and savings metrics in a local SQLite database. The
public schema includes the original command, RTK command, project path, raw and
filtered estimated tokens, savings percentage and execution time. Retention is
configurable and commonly defaults to 90 days.

The data can reveal project paths, command usage, timing and operational
patterns even when telemetry is disabled. It needs access control, retention
and deletion rules appropriate to the project.

## Configuration Defaults

Public configuration describes settings for:

- Tracking enablement, history days and database path.
- Display colors, emoji and maximum width.
- Ignored directories and files for file-oriented filters.
- Tee recovery, rotation and size limits.
- Telemetry consent.
- Hook exclusions.
- Output limits for grep, status and passthrough.

The user-local `rtk config` command showed a default config that was not written
to disk. It reported tracking enabled, 90-day history, failure tee enabled,
telemetry disabled and no hook exclusions.

## Custom Filters

RTK supports project-local and user-global TOML filters. The public
configuration documentation says filters are trust-gated using SHA-256 because
they can change what the AI assistant sees.

This is an important control: a project-local filter is executable behavior at
the context boundary, not harmless documentation. Review it, trust it
explicitly and re-trust it after edits. Prefer built-in filters during the
first LF pilot.

## Raw and Filtered Data

The raw command, filtered output, tee files and tracking database have different
privacy characteristics:

- Filtered output may omit sensitive text but is still part of the prompt.
- Raw tee output can preserve secrets or personal data that filtering removed.
- Tracking history can preserve paths, command names and timing.
- A provider receives whatever the agent ultimately sends, independent of RTK's
  local storage policy.

Do not assume that a command named `env`, `aws`, `curl` or `docker` is safe to
send through a filter without reviewing its actual output and recovery path.

---

# Telemetry and Privacy

## Documented Policy

The README and telemetry policy state that telemetry is disabled by default and
requires explicit consent. If enabled, the public policy describes one daily
HTTPS ping containing aggregate or anonymized information such as:

- Salted device hash, RTK version, operating system and architecture.
- Installation method, command counts and top command names.
- Estimated savings and filter parse failures.
- Ecosystem distribution, hook type and configuration counts.

The policy says it does not collect source code, file contents, full command
arguments, paths, secrets, repository names or environment values. These are
public statements that still require an organizational privacy decision.

## Local Observation

On 2026-09-03, `rtk telemetry status` reported:

```text
consent: never asked
enabled: no
device hash: (no salt file)
```

The displayed default configuration also reported `[telemetry] enabled = false`.
No telemetry consent or device salt was created during the evaluation.

## Documentation Conflict

The repository Disclaimer says the software collects anonymous aggregate metrics
"by default", while the README, website FAQ, configuration output and telemetry
policy describe opt-in or disabled-by-default behavior. The LF must treat this
as an unresolved documentation conflict, not silently choose the more favorable
interpretation.

Before a pilot, confirm the installed binary's effective behavior, record
whether telemetry is disabled by environment and configuration, and obtain the
required privacy approval. Recommended explicit control:

```bash
export RTK_TELEMETRY_DISABLED=1
```

---

# Security and Supply Chain

## Command Execution

RTK executes the underlying shell tools and can handle file, network, cloud,
container and package-manager commands. It therefore runs with the permissions
available to the user or agent.

Filtering and hook permissions improve awareness and correctness; they do not
isolate code from the host. Use a container, VM or other approved isolation when
the command, repository or provider is untrusted. Keep production credentials
and destructive operations outside the first pilot.

## Installer

The user installed RTK with:

```bash
curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh
```

The observed installer:

- Detected `darwin aarch64` and target `aarch64-apple-darwin`.
- Selected version `v0.47.0`.
- Downloaded the release archive from GitHub.
- Downloaded and verified SHA-256 checksums.
- Verified archive contents before extraction.
- Installed the binary at `$HOME/.local/bin/rtk`.
- Reported `rtk 0.47.0` after installation.

The reviewed script fails if checksums are unavailable or mismatched unless the
explicit `RTK_SKIP_CHECKSUM=1` override is used. It also rejects absolute and
directory-traversal archive paths and installs without `sudo`.

This is stronger evidence than an unverified binary download, but the command
still executes remote shell code from the moving `master` branch. For a
controlled environment, inspect and pin the installer or release, record the
version and checksum, and prefer a reviewed distribution path.

## Hook Integrity

The public hook system stores a SHA-256 baseline and can verify whether the
installed hook was modified. Local `rtk verify` reported:

- No RTK hook installed.
- Data directory owner-only.
- `154/154 tests passed` for the verification command.

Those 154 tests validate RTK's local verification path; they are not tests of an
LF project or proof that every filter preserves semantics.

## Generated Configuration

`rtk init` can create or modify hook files, agent settings and instruction
documents such as `RTK.md`. Treat these as code changes:

- Inspect the generated diff before accepting it.
- Keep backups and know the uninstall command.
- Review the hook's permissions and command rewrite behavior.
- Do not install globally while evaluating a client project without explicit
  approval.

---

# Local Evaluation in LF

## Installation and Help Output

The installer was run from a user home directory and produced a successful,
checksum-verified installation. The provided `rtk --help` showed a broad command
surface including:

- File and search commands: `ls`, `tree`, `read`, `smart`, `find`, `grep`,
  `diff`, `json`, `deps`, `env`.
- Git and hosting commands: `git`, `gh`, `glab`, `gt`.
- Build and test commands: `cargo`, `npm`, `npx`, `pnpm`, `vitest`, `jest`,
  `pytest`, `go`, `tsc`, `playwright`, `next`, `mvn`, `dotnet`, `php` and
  others.
- Infrastructure commands: `aws`, `docker`, `kubectl`, `oc`.
- Control and analytics: `err`, `test`, `summary`, `gain`, `discover`,
  `session`, `telemetry`, `config`, `trust`, `verify`, `rewrite`, `hook` and
  `proxy`.

This broad surface increases potential value and increases the number of
command-specific semantics that a pilot must validate.

## Safe Local Checks

The following non-installing checks were run in the LF workspace:

| Command | Result | Meaning |
| --- | --- | --- |
| `rtk --version` | `rtk 0.47.0` | Installed binary confirmed. |
| `rtk verify` | No hook; owner-only data directory; 154/154 checks passed | Integrity path works locally; no agent integration is active. |
| `rtk telemetry status` | Never asked; disabled; no salt | No telemetry consent was created. |
| `rtk config` | Default config displayed; file not created; telemetry disabled | Defaults were inspected without changing configuration. |
| `rtk init --show` | Hook and OpenCode plugin not found; settings exists without RTK hook | Automatic integration is not active. |
| `rtk rewrite "git status"` | Returned `rtk git status` | Registry rewrite works for a simple command. |
| `rtk rewrite "cargo test --all && git diff"` | Rewrote both supported segments | Compound rewrite works for this case. |
| `rtk rewrite "RTK_DISABLED=1 git status"` | Reported disabled and did not rewrite | Per-command override is visible. |

No `rtk init`, `rtk init --global`, OpenCode plugin installation, telemetry
enablement or project-local filter trust operation was performed.

## Scope Limitation

The LF root is a documentation Framework and has no Git metadata or application
test runner. The local checks prove installation, rewrite and configuration
observations only. They do not establish savings, semantic equivalence,
performance overhead or agent behavior in a real client project.

---

# Fit with LF and agf

## Layered Model

The safest combined model is:

```text
LF artifacts and governance
        |
        v
agf optional task graph and execution evidence
        |
        v
Agent shell command
        |
        v
RTK optional rewrite and output filtering
        |
        v
Underlying command, tests and filesystem
```

Each layer has a different responsibility. RTK must not hide a failing test
from `agf` or LF; `agf` must not treat a compact summary as complete evidence;
LF must retain the ability to request or recover full output.

## Existing LF Principles It Reinforces

RTK can support these existing LF principles when configured carefully:

- Filter noisy shell output before reading it into context.
- Prefer deterministic tooling over agent memory.
- Keep the core command and evidence path real rather than mocked.
- Record measured savings and limitations.
- Preserve source-of-truth boundaries and explicit handoffs.
- Recover full output when a summary is insufficient.

It does not replace the Elephant-Goldfish design loop. That module tests whether
intent and design are understandable; RTK only changes command output shape.

## Agent Responsibilities

- Engineering-Manager decides whether RTK is appropriate for the project risk.
- Prompt-Architect and Product-Owner define what evidence must remain visible.
- Software-Architect identifies commands where filtering can change technical
  decisions or hide security signals.
- Sprint-Planner records the optional tool and version in pilot scope.
- Implementation / selected CLI uses explicit RTK commands or the approved hook and reports
  when raw output was required.
- Code-Reviewer checks rewrites, changed configuration and recovery evidence.
- QA-Security validates exit codes, hidden failures, sensitive data handling,
  telemetry and hook trust.
- Documentation keeps canonical artifacts and optional integration records in
  sync.
- Tech-Lead decides whether measured benefit justifies the operational risk.

---

# Recommended Integration Boundary

## Pilot Sequence

1. Select one medium-complexity feature and one legacy change with a known test
   suite and meaningful command output.
2. Record the pilot scope and non-goals in `.ai/decisions.md`.
3. Pin RTK `0.47.0` or a reviewed release and record its checksum.
4. Establish a raw-output baseline for representative commands.
5. Use manual `rtk` commands first; do not install hooks yet.
6. Compare raw and filtered output, exit codes, elapsed time, information loss,
   recovery effort, review findings and provider token data.
7. If the baseline is positive, test the OpenCode plugin in an isolated or
   disposable configuration and inspect every generated file.
8. Keep LF review, QA-Security and Tech Lead decisions independent of `rtk gain`.
9. Disable or uninstall the integration if the semantic or operational cost is
   higher than the measured benefit.

## Recommended Defaults

- Start with delegated/manual use, not silent global rewriting.
- Keep telemetry disabled with both configuration and environment controls.
- Use built-in filters before reviewing custom TOML filters.
- Keep tee recovery enabled, protect its directory and define retention.
- Exclude commands where complete output or exact syntax is safety-critical.
- Use `RTK_DISABLED=1` when a full raw result is needed.
- Use `rtk run` for raw execution without filtering or tracking when supported;
  use `rtk proxy` when raw output is needed but usage tracking is useful.
- Treat `rtk gain` as a local output-reduction trend, not a cost invoice.
- Keep the original command, rewritten command and recovery path visible in
  task evidence when a hook is active.

---

# Pilot Measures

Compare equivalent work with RTK disabled and enabled. Record:

- Raw and filtered bytes per command and per task.
- Estimated tokens and provider-reported tokens separately.
- Actual cost, if provider data is available, with model and pricing basis.
- Command runtime, RTK overhead and startup cost.
- Exit-code equality and signal preservation.
- Number of manual raw-output recoveries.
- Filter parse failures, passthroughs and disabled commands.
- Hook rewrite rate and commands that required correction.
- Review, QA, security and escaped-defect findings.
- Lost context, repeated commands and agent session length.
- Maintenance time for configuration, filters and generated hooks.
- User comprehension of the rewritten command and compact output.

Success means better context efficiency without hidden semantic loss, increased
rework, weakened safety or misleading economics. A high byte-reduction ratio
alone is not success.

---

# Risks and Mitigations

| Risk | Impact | Mitigation |
| --- | --- | --- |
| Filter hides needed information | Wrong implementation or diagnosis | Preserve raw recovery, test decision-critical commands and allow explicit bypass. |
| Silent command rewrite | Agent executes a different command than reviewed | Inspect rewrites, log them in pilot evidence and keep exclusions and bypasses easy. |
| Hook failure blocks a command | Broken development or CI flow | Verify fail-open behavior per agent and test malformed input and missing binary paths. |
| Hook failure passes unsafe rewrite | Wrong arguments or permissions reach a tool | Prefer conservative no-rewrite behavior and review agent-specific permission semantics. |
| No host isolation | RTK and underlying commands can affect the user's machine | Use a container or VM for untrusted work; keep credentials out of pilot scope. |
| Raw tee contains secrets | Sensitive output persists locally | Protect and rotate tee files; define retention and delete policy. |
| Tracking contains paths and usage | Local metadata exposes project behavior | Restrict database permissions and include it in privacy review. |
| Telemetry policy conflict | Unexpected data processing | Force telemetry off, confirm effective binary behavior and obtain privacy approval. |
| Custom filter changes context | A project file can manipulate agent-visible output | Use trust gating, review hashes and start with built-ins. |
| Installer supply-chain risk | Remote script or release compromise | Pin release, inspect script, verify SHA-256 and record provenance. |
| Estimator overstates savings | False cost or ROI decision | Report bytes, estimated tokens and provider billing as separate metrics. |
| Tool-specific parser drift | New output format is silently summarized incorrectly | Keep raw fallback, monitor parse failures and test real fixtures. |
| Direct tools bypass hooks | Partial optimization is mistaken for full coverage | State the supported tool boundary and measure actual Bash coverage. |
| Version drift | Rewrites or hooks change between sessions | Pin RTK and configuration versions; verify after upgrades. |
| Generated files conflict with LF | Agent instructions or settings diverge | Inspect diffs, register ownership and make integration removable. |

---

# Prioritized Recommendations

## High Priority

1. Keep RTK optional and outside the mandatory LF dependency graph.
2. Pilot manual commands before installing any global hook or OpenCode plugin.
3. Measure Bash-output reduction separately from provider tokens, cost and
   engineering quality.
4. Treat command execution, tee files, tracking, telemetry and custom filters as
   explicit security and privacy surfaces.
5. Preserve raw recovery and an immediate bypass for every decision-critical
   command.
6. Pin the release and record checksum and configuration in pilot evidence.

## Medium Priority

1. Add an optional RTK version, hook status and bypass note to task or handoff
   records only if the pilot demonstrates operational value.
2. Compare RTK output with `agf` context compression and LF shell-output rules to
   prevent double filtering or hidden error output.
3. Define a small evidence format containing original command, rewritten command,
   raw-output location, filtered result, exit code and measured reduction.
4. Review the documented telemetry conflict and known hook failure gap with
   QA-Security before team rollout.
5. Evaluate project-local custom filters only after built-in filter behavior is
   understood.

## Low Priority

1. Consider automated OpenCode integration after the manual baseline succeeds.
2. Evaluate custom filter authoring for repeated project-specific outputs.
3. Consider broader agent integration only when each agent's hook contract and
   rollback path are independently tested.

---

# Adoption Decision Gate

Before RTK becomes a standard LF integration, the Framework Maintainer should
answer:

- Which LF layer owns the original command, rewritten command and compact
  evidence?
- Which commands are safe to filter, and which must remain raw by policy?
- What exact metric proves value: bytes, context tokens, provider cost, time or
  reduced rework?
- How are filtered output, tee files, tracking databases and telemetry governed?
- How is a hook disabled, audited, upgraded and removed?
- What happens when RTK is missing, outdated, tampered with or incompatible?
- How are direct `Read`, `Grep` and `Glob` tools handled when hooks only cover
  Bash?
- Does the project have isolation for commands that can alter the host or cloud?
- What version, checksum, filter set and agent integration are supported?
- Can the integration be removed without changing canonical LF artifacts?

The decision must be recorded in `docs/ADR.md` or the appropriate LF decision
record. A passing `rtk verify` or a high `rtk gain` percentage is not sufficient
for mandatory adoption.

---

# Final Principle

RTK's durable lesson is not that less output is always better. It is that an
agent should receive the smallest output that still supports the current
engineering decision, with a truthful recovery path when it does not.

For LF, the safe model is additive:

```text
LF governs intent, artifacts, quality and approval.
agf optionally governs executable task state and evidence.
RTK optionally reduces shell-output noise without hiding required signals.
The underlying command, filesystem, tests and human review remain authoritative.
```

RTK is approved as optional context-optimization guidance, not as a Framework
requirement. Installing or operationally integrating the tool remains a
separate approval decision.

---

## Version History

- `0.2.0` — 2026-11-01: Approved as optional supplemental guidance and clarified
  that this status does not authorize installing RTK or enabling integrations.
