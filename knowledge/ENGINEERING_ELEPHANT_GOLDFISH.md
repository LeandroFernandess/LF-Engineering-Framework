# Engineering Knowledge: Elephant-Goldfish Design Governance

Version: 0.2.0

Status: Approved Optional

Category: Supplemental / Research-derived

Owner: Leandro Fernandes
Framework Baseline: LF Engineering Framework 1.3.0; adoption status updated post-tag

---

# Adoption Status

This research-derived module is approved as optional guidance for the LF
Engineering Framework. It remains outside the mandatory dependency graph and
must not silently change the active workflow or create a universal design gate.

It preserves the ideas and records their fit with the LF Engineering System.
Use it only when the task's scope and risk justify the additional design and
independent-comprehension work.

Approval of this module does not make its recommendations Framework rules,
workflow gates, mandatory agent instructions or required artifacts. Each such
change requires a separate human decision.

---

# Purpose

This module describes a design-first operating model for software engineering
with AI coding agents.

Its main objective is to move human engineering judgment into explicit,
reviewable and reusable artifacts before an AI agent writes implementation
code. It also defines how a fresh AI session can test whether those artifacts
contain enough context to support safe implementation.

The model is useful for:

- New features.
- Architectural changes.
- High-risk refactors.
- Legacy codebase onboarding.
- Recovery after an AI session is interrupted or lost.
- Delegation and coordination of multiple AI agents.

---

# Non-goals

This module does not:

- Replace the LF Engineering Framework.
- Replace `PRD.md`, `ARCHITECTURE.md`, `SPRINTS.md`, ADRs or quality reports.
- Grant AI agents ownership of engineering decisions.
- Treat a design document as a substitute for tests, code review, QA or security validation.
- Require a full design cycle for every trivial text or isolated maintenance change.
- Treat the article's anecdotal numbers as engineering targets.

---

# Source

Title: *Elephants, Goldfish and the New Golden Age of Software Engineering*

Author: Dave Rensin

URL: <https://drensin.medium.com/elephants-goldfish-and-the-new-golden-age-of-software-engineering-c33641a48874>

Published: 2026-04-27

Consulted: 2026-09-03

Source stance: The article is a personal account and a set of predictions. It
should be treated as an experience report and design input, not as an
independently validated standard.

---

# Executive Synthesis

The article argues that AI-assisted development fails when the model is asked
to generate output before the human has made the problem, constraints,
trade-offs and quality bar explicit.

The proposed remedy is a loop:

1. Use a context-rich session, the **Elephant**, to interrogate the problem,
   challenge assumptions and produce a complete design.
2. Use a fresh, memoryless session, the **Goldfish**, to test whether the
   design can be understood and implemented without relying on hidden
   conversation history.
3. Implement only after the design passes comprehension, criticism,
   implementation-readiness and human approval checks.

The most important engineering claim is:

> When AI produces more implementation than humans can confidently understand,
> the explicit design becomes the primary carrier of human intent and
> accountability.

The practical consequence for LF is not to remove code review. It is to move
more judgment and validation earlier, make session state durable, and review
AI output against an explicit design and evaluation rubric.

---

# General Research Pattern

The article's first part applies the same model beyond software implementation.
For any consequential research or decision:

1. Ask the AI to interrogate the initial request and expose missing dimensions.
2. Turn the resulting problem description into explicit evaluation criteria.
3. Open a new session and provide both the problem description and the rubric.
4. Require evidence, links, assumptions, alternatives and limitations in the
   final result.
5. Save the problem description, evaluation criteria and final result as
   durable knowledge.

This pattern prevents the model from grading its own work against an unstated
standard and creates a reusable record of the reasoning that produced the
decision.

---

# Core Model

## The Elephant

The Elephant is the context-rich working session plus the durable artifacts it
produces.

It contains:

- Project and system context.
- The problem statement.
- Clarifying questions and answers.
- Challenged assumptions.
- Technical alternatives and rejected options.
- Micro-decisions and their rationale.
- The current implementation state.
- The design document used as the source of truth for the feature.

The Elephant is not the chat transcript. The durable artifacts are the useful
part of the session. The transcript is usually too noisy, too long and too
dependent on conversational context to be a reliable engineering record.

## The Goldfish

The Goldfish is a brand-new AI session with no access to the previous
conversation. It receives only the design document and the files explicitly
referenced by that document.

The Goldfish is used as an independent context test. If it cannot explain the
system, the intended change or the implementation path, the design is not yet
complete.

## The Operating Rule

**Feed the Elephant; test it against the Goldfish.**

The Elephant creates and refines the design. The Goldfish exposes missing
context, hidden assumptions and accidental dependence on the original
conversation.

---

# Main Technical Insights

## 1. Use AI as an Interrogator Before Using It as a Generator

A one-shot request asks the model to fill gaps with assumptions. A better
interaction asks the model to discover the gaps first.

The model should:

- Ask clarifying questions.
- Identify missing requirements.
- Challenge assumptions.
- Explore edge cases.
- Expose conflicting goals.
- Ask what evidence would support a conclusion.

The human should argue to learn, not to win. Agreement is not evidence of
correctness.

### LF implication

The Discovery, Prompt Architect and Product Owner phases should explicitly
allow an interrogation loop before requirements are considered ready. A
refined prompt should record unresolved questions and assumptions instead of
forcing premature certainty.

## 2. Define the Evaluation Criteria Before Requesting the Final Output

The article separates two activities that are often mixed together:

1. Describing the problem or research topic.
2. Defining how the eventual answer will be judged.

The evaluation criteria can require, depending on the task:

- Evidence and citations.
- Coverage of stated requirements.
- Explicit assumptions.
- Alternative options.
- Risks and limitations.
- Testable acceptance conditions.
- Traceability to authoritative files.

### LF implication

Acceptance criteria should not be limited to product behavior. For AI-produced
designs and implementations, LF should also define an output evaluation rubric:
what must be present, what must be referenced, which uncertainties must be
escalated and what evidence is required for approval.

For research or analysis tasks, the final request should preferably be run in a
new session with both the complete problem description and the evaluation
rubric. This reduces anchoring on the exploratory conversation and makes the
final output reproducible from durable inputs.

## 3. Preserve Human Judgment in Durable Artifacts

AI can produce plausible language and code without possessing the judgment
required to own the consequences. The responsible human must retain ownership
of:

- Intent.
- Scope.
- Trade-offs.
- Risk acceptance.
- Architecture.
- Acceptance decisions.
- Final approval.

The article recommends saving three durable outputs from an important session:

- The complete problem description.
- The acceptance or evaluation criteria.
- The final result.

### LF implication

The LF source-of-truth model already supports this principle. The missing
improvement is to make the problem statement, evaluation rubric and final
approved result easy to locate and link from `.ai/artifacts.md`, decisions and
handoffs.

## 4. Treat Lost Context as an Engineering Failure Mode

An AI session can crash, reach a context limit, lose tool state or be handed to
another agent. If intent exists only in the conversation, recovery requires
reconstructing the work from raw source code and memory.

A durable current-state document should let a new session answer:

- What are we trying to accomplish?
- What has already been decided?
- What has been implemented?
- What remains incomplete?
- Which files and artifacts are authoritative?
- Which questions or risks are unresolved?

### LF implication

The existing `.ai/state/`, `.ai/handoff.md`, `.ai/decisions.md` and
`.ai/tasks.md` are the correct foundation. A feature-level design or progress
record should be added only where those files cannot represent the feature
without duplicating it. Recovery state must have one canonical owner.

## 5. Shift Design Judgment Left

When a human writes code, many small design decisions are embedded in the
implementation. When an AI writes code, those decisions can be generated
without the responsible human consciously making or reviewing each one.

The proposed response is to make the design explicit before implementation:

- Define behavior before syntax.
- Define boundaries before abstractions.
- Define alternatives before committing to one approach.
- Define file scope before editing the repository.
- Define acceptance evidence before reviewing the result.

The article summarizes this as **design is the new code**. This is a
provocative phrase, not a reason to discard source code. It means that design
becomes the primary human-readable expression of intent when generated code
becomes too abundant or opaque to review line by line.

## 6. Maintain a High Signal-to-Noise Ratio

AI increases the rate at which both useful work and bad work can be produced.
If low-quality output accumulates faster than it is removed, the project
eventually becomes harder to understand and slower to change.

Useful signals include:

- A clear link to the approved requirement.
- A clear link to the relevant design decision.
- A bounded file list.
- Explicit assumptions.
- Tests or validation evidence.
- A small and explainable diff.
- Known limitations and follow-up work.

Noise includes:

- Unrequested features.
- Speculative abstractions.
- Repeated or contradictory documentation.
- Unverified APIs.
- Code that passes a superficial test but violates architecture.
- Long output that does not improve decision quality.

### LF implication

The objective is not to maximize AI output. The objective is to maximize
accepted, understandable and maintainable engineering value per unit of human
review.

## 7. Require a No-Code Design Phase

Before implementation, the AI should be explicitly told not to write code.
This creates room for:

- Context verification.
- Problem framing.
- Requirements interrogation.
- Architecture discussion.
- Alternative analysis.
- Risk discovery.

The first technical proposal should be produced by the AI from its own
understanding of the problem, rather than being constrained by a human's first
solution. This increases the chance that blind spots are exposed.

The proposal should prefer:

- Plain prose.
- Component relationships.
- Data or control-flow diagrams.
- Short pseudocode only when it clarifies behavior.

The implementation session begins only after the proposal has been challenged,
corrected and approved.

## 8. Use Fresh Sessions as Adversarial Tests

A long session can create the illusion of correctness because the model and the
human share hidden context. Fresh sessions provide a practical independence
check.

The article proposes three Goldfish tests:

1. **Comprehension:** Can the session explain the goal and current system from
   the design and referenced files?
2. **Criticism:** Can it identify omissions, faulty assumptions, edge cases and
   rejected alternatives that should have been considered?
3. **Implementation readiness:** Does it have enough information to implement
   the feature correctly on the first pass?

These tests form a loop. Questions raised by a Goldfish must be answered in the
design or explicitly accepted as unresolved risk before implementation.

## 9. Document Alternatives and Rejected Paths

An implementation plan without rejected alternatives gives a future agent no
way to distinguish an intentional choice from an omission.

The design should record:

- Options considered.
- The selected option.
- Reasons for rejection.
- Trade-offs accepted.
- Conditions that would justify revisiting the decision.

Rejected alternatives are guardrails against future hallucinations and
unnecessary redesign.

## 10. Enumerate Every File in the Implementation Plan

The article treats the file inventory as a critical guardrail. A design should
state:

- Every file to create.
- Every file to change.
- The responsibility of each file.
- The reason for the change.
- Expected tests or documentation updates.
- Files explicitly out of scope when confusion is likely.

This makes scope inspectable before coding and makes the resulting diff easier
to compare against intent.

## 11. Compress Context Instead of Dumping the Entire Codebase

Feeding a large source tree to an AI at once can overload retrieval and reduce
understanding. The article proposes small, structured context summaries, using
hierarchical `README.md` files as "peanuts and hay".

The summaries should explain:

- The purpose of each directory.
- The role of each file in that directory.
- Important relationships and boundaries.
- The source of truth for behavior and configuration.

This is a context compression strategy, not a replacement for source code.
The AI must still inspect authoritative implementation files before making
changes.

## 12. Treat AI Agents as Delegated Work, Not Autonomous Owners

The article compares agent management with people management. The useful
technical analogy is delegation:

- Specify the desired outcome.
- Establish guardrails.
- Define the agent's authority.
- Define when it must stop and ask for guidance.
- Require evidence of completion.
- Review the result rather than micromanaging every intermediate action.

Agents are not people and should not be granted implicit trust. The analogy is
useful only for designing delegation and coordination boundaries.

## 13. Scale Agent Count Gradually

Multiple agents can increase throughput, but they also increase interrupts,
conflicting assumptions and coordination cost. The article suggests starting
with a small team-like number of agents while learning the operating model.

For LF, the practical rule should be:

- Start with the smallest agent set that covers the work.
- Add parallel agents only when boundaries and outputs are independent.
- Keep one coordinator accountable for synthesis.
- Measure whether coordination overhead is lower than the saved effort.

The article's specific team-size heuristic is a starting point, not a hard LF
limit.

## 14. Reinvest Automation Gains in Judgment

The article argues that AI removes toil but increases the importance of hard
thinking, architecture and design. Sustained concentration is treated as a
skill that must be practiced.

The operational lesson for engineering is to protect time for:

- Problem framing.
- Architecture and trade-off analysis.
- Risk review.
- Design-document refinement.
- Learning from production and code review evidence.

The article also invokes Jevons' Paradox: cheaper production can create demand
for more production rather than less work. Teams should not interpret AI speed
as permission to expand scope without increasing quality controls.

A practical concentration exercise suggested by the article is to begin with a
protected 30- to 45-minute design or reasoning block each workday and increase
the duration gradually as the habit develops. This is a team operating
practice, not a quality gate or a universal productivity prescription.

---

# LF Gap Analysis

| Capability | Present in LF | Gap exposed by the article | Future action |
| --- | --- | --- | --- |
| Human accountability | Yes | It is stated, but should be reinforced at each AI delegation boundary. | Add explicit authority and escalation fields. |
| Phase-based workflow | Yes | The active flow moves toward implementation without a dedicated no-code design loop. | Add design-readiness phases for appropriate risk levels. |
| Product acceptance | Yes | Product criteria do not fully define the quality of AI-generated designs or plans. | Add an output evaluation rubric. |
| Technical architecture | Yes | Feature-level rationale, rejected alternatives and file inventory may remain implicit. | Add them to architecture or an optional feature design artifact. |
| Session continuity | Partially | Shared `.ai/` state exists, but feature-specific recovery requirements are not standardized. | Strengthen handoff and progress contracts. |
| Independent validation | Partially | Review and QA occur after implementation; design comprehension is not an explicit gate. | Add Goldfish comprehension, critic and readiness checks. |
| Implementation review | Yes | Review can be made more directly traceable to design intent and scope. | Add design-conformance evidence. |
| Legacy onboarding | Partially | The framework assumes usable project context and does not define recursive context bootstrap. | Add an optional legacy context workflow. |
| Agent coordination | Yes | Roles exist, but task-level authority, stop conditions and evidence can be more explicit. | Add delegation contracts and gradual scaling guidance. |
| Knowledge evolution | Yes | External experience reports need a controlled evidence-to-framework path. | Pilot, measure, review and version before adoption. |

---

# Proposed LF Operating Model

The following process is an adaptation for the LF Engineering System. It is
proposed behavior, not an active Framework requirement.

## Phase A: Establish Context

### Objective

Make the current system and the initial request explicit before solutioning.

### Actions

1. Load the minimum authoritative artifacts.
2. Ask the AI for a high-level understanding of the relevant system.
3. Identify missing, conflicting or stale context.
4. Correct misunderstandings by pointing to authoritative files.
5. Record assumptions and open questions.

### Exit criteria

- The human agrees that the AI's system summary is materially accurate.
- Referenced artifacts are identified.
- Unknowns are visible rather than silently filled by assumptions.

### LF mapping

- Engineering Manager and Orchestrator classify the work.
- Prompt Architect refines raw intent.
- `.ai/state/project-summary.md` and project artifacts provide context.

## Phase B: Interrogate the Problem

### Objective

Expand the initial request into a complete problem description without writing
implementation code.

### Actions

1. Instruct the AI to ask questions instead of generating code.
2. Explore goals, non-goals, users, constraints and edge cases.
3. Challenge assumptions and conflicting requirements.
4. Ask the AI to explain why it believes a proposed assumption is valid.
5. Stop when the problem statement and unresolved questions are explicit.

### Exit criteria

- Problem and desired outcome are stated in plain language.
- Scope and non-goals are clear.
- Important edge cases have an owner or a decision.
- No implementation has been accepted merely because it was suggested.

### LF mapping

- Prompt Architect produces or updates `PROJECT_BRIEF.md`.
- Product Owner converts the clarified context into `PRD.md`.

## Phase C: Define the Evaluation Rubric

### Objective

Define how the design and implementation will be judged before asking an AI
agent to produce them.

### The rubric should cover

- Requirement coverage.
- Architecture and boundary adherence.
- Security and privacy conditions.
- Performance expectations when relevant.
- Error and failure behavior.
- Test and validation evidence.
- Documentation and traceability.
- Out-of-scope behavior.
- Conditions requiring escalation.

### Exit criteria

- Acceptance criteria are testable.
- Reviewers know what evidence to request.
- Ambiguous quality expectations are either resolved or documented as risk.

### LF mapping

- Product Owner owns product acceptance criteria.
- Software Architect and QA Security contribute technical quality criteria.
- Sprint Planner turns criteria into executable validation items.

## Phase D: Produce and Debate a Technical Proposal

### Objective

Create a prose-first solution proposal before implementation.

### Actions

1. Ask the AI to propose the first technical approach from the established
   context.
2. Require prose, diagrams and limited pseudocode instead of implementation.
3. Examine component boundaries, data flow, interfaces, failure modes and
   operational impact.
4. Compare alternatives and document why they were rejected.
5. Correct hallucinated APIs or architecture by pointing to authoritative files.
6. Continue until the human accepts the reasoning, not merely the wording.

### Exit criteria

- The selected approach satisfies the PRD and architecture constraints.
- Alternatives and trade-offs are documented.
- Security, failure and operational concerns are addressed.
- The proposal is ready to be expressed as an implementation plan.

### LF mapping

- Software Architect owns technical design.
- Significant decisions are recorded in `docs/ADR.md` and `.ai/decisions.md`.

## Phase E: Teach the Elephant Through a Durable Design Document

### Objective

Create the durable feature-level source of truth that can survive session
changes and guide implementation.

### Required sections

1. Problem.
2. Goals and non-goals.
3. Current system understanding.
4. Technical plan.
5. Component or sequence diagrams when useful.
6. Constraints, assumptions and open questions.
7. Alternatives considered and rejected.
8. Detailed implementation steps.
9. Complete file inventory with rationale.
10. Acceptance and evaluation criteria.
11. Tests and validation evidence.
12. Security, privacy, performance and observability considerations.
13. Rollback or recovery approach when relevant.
14. Related PRD, architecture, ADR, sprint and issue references.
15. Status, owner, approvals and current progress.

### Document-writing rules

- Build the document section by section.
- Review each section before generating the next.
- Do not rely on one-shot document generation for complex work.
- Keep one canonical owner for each fact.
- Link to existing artifacts instead of copying them without a reason.
- Mark unknowns explicitly.
- Update the document when implementation decisions change.

### LF integration options

There are two safe adoption paths:

1. **Incremental path:** Extend existing `PRD.md`, `ARCHITECTURE.md` and
   `SPRINTS.md` with the sections and gates above.
2. **Feature path:** Add an optional feature design document such as
   `docs/design/<FEATURE-ID>.md` for medium- and high-complexity changes.

The feature path is preferable when multiple features evolve inside one
project, because a project-level `ARCHITECTURE.md` should not become a stream
of unrelated implementation journals. It must be approved before adoption to
avoid creating a duplicate source of truth.

## Phase F: Run the Goldfish Protocol

### Test 1: Comprehension

Give a fresh session the design document and its referenced files. Ask it to
explain the intended change and the current system.

Pass condition:

- The explanation is materially correct.
- The session does not need the original conversation.
- Important boundaries and constraints are present.

Failure action:

- Add missing context to the canonical design or referenced artifact.
- Repeat the test.

### Test 2: Critic Review

Give a different fresh session the same material. Ask it to find:

- Missing requirements.
- Faulty assumptions.
- Edge cases.
- Security or privacy gaps.
- Architectural inconsistencies.
- Unconsidered alternatives.
- Ambiguous implementation steps.

Pass condition:

- Remaining findings are understood and either corrected, accepted or
  recorded as explicit risk.

### Test 3: Implementation Readiness

Ask another fresh session whether it has enough information to implement the
feature in one pass.

Pass condition:

- No material question about scope, behavior, file ownership, interfaces or
  validation remains unanswered.
- The human reviewer approves the design.

### Governance rule

Goldfish tests supplement human approval. They do not grant approval by
themselves and they do not replace automated tests, Code Review or QA Security.

## Phase G: Implement With Guardrails

### Inputs

- Approved feature design.
- Referenced project artifacts.
- Approved sprint or task scope.
- Explicit evaluation rubric.

### Implementation rules

- Read the design and referenced files before editing.
- Follow the listed file inventory unless a deviation is escalated.
- Stop when a requirement or architectural assumption is unclear.
- Do not invent APIs, dependencies or business rules.
- Keep the diff aligned with the approved scope.
- Update progress state when the session ends or changes direction.

### Recovery rule

If the session crashes, start a new session with the design document, current
state and referenced files. Do not reconstruct the entire task from raw chat
history unless the durable artifacts are demonstrably incomplete.

## Phase H: Run an Adversarial Review

The post-implementation review should try to disprove correctness rather than
confirm the implementer's preferred story.

Review against:

- The approved design.
- The PRD and acceptance criteria.
- The sprint file inventory.
- ADRs and architecture boundaries.
- Security and quality gates.
- Tests and observed validation evidence.

Ask the reviewer to prioritize concrete findings by severity, location, impact
and remediation. Repeat after corrections when material findings remain.

The article suggests asking the AI to be intentionally harsh. The LF adaptation
should preserve the adversarial objective without requiring insulting language
or reducing review quality to a tone preference.

### Comment policy

Do not adopt a literal rule that every fixed number of code lines must have a
comment. The current LF standard correctly favors comments for business rules,
architectural decisions, limitations and non-obvious behavior. Readability is
the gate; arbitrary comment density is not.

---

# Feature Design Document Contract

If LF adopts a separate feature design artifact, the following is the proposed
minimum contract for `docs/design/<FEATURE-ID>.md`.

## Metadata

- Feature ID.
- Title.
- Status: Draft, Goldfish Review, Ready, Implementing, Implemented, Superseded.
- Owner.
- Created and updated dates.
- Related `PROJECT_BRIEF.md`, `PRD.md`, `ARCHITECTURE.md`, sprint and ADRs.

## Problem

Describe the business or engineering problem in three to five plain-language
sentences.

## Goals and Non-goals

State what success includes and what is deliberately excluded.

## Current System

Explain the relevant existing behavior and link to the authoritative files.
Include only the context required to understand the feature.

## Constraints and Assumptions

Separate verified facts from assumptions. Give each unresolved assumption an
owner or an escalation path.

## Technical Plan

Describe components, responsibilities, interfaces, data flow, error behavior
and operational concerns. Use diagrams when they clarify relationships.

## Alternatives

List meaningful alternatives, reasons for rejection, accepted trade-offs and
conditions that would justify revisiting the choice.

## Detailed Implementation

Enumerate the implementation sequence and every expected file change.

| File | Change | Reason | Validation |
| --- | --- | --- | --- |
| `path/to/file` | Create / Update / Delete | Why this file changes | Test or review evidence |

Also list files explicitly out of scope when a future agent could reasonably
assume they belong in the change.

## Acceptance and Evaluation Criteria

Separate:

- Product acceptance criteria.
- Technical acceptance criteria.
- Design comprehension criteria.
- Implementation evidence criteria.
- Human approval criteria.

## Risks and Operations

Document security, privacy, performance, observability, migration, rollback,
failure recovery and maintenance risks that apply to the feature.

## Progress and Recovery State

Record:

- Completed steps.
- Current step.
- Next action.
- Decisions made since the last handoff.
- Blockers and unresolved questions.
- Validation already performed.

This section must not duplicate `.ai/state` globally. It should contain only
feature-specific state and link to shared state files.

## Approval Record

Record Goldfish results, human review, deviations from the plan and the final
implementation readiness decision.

---

# Prompt Recipes

These prompts are reusable patterns, not mandatory wording. They should be
adapted to the tool, project and agent role.

## Context Summary

```text
Read the relevant project artifacts and source files before proposing a
solution. Do not write code. First summarize how the relevant part of the
system works, which files are authoritative, and what you are uncertain about.
Wait for correction before continuing.
```

## Interrogator Mode

```text
Do not implement anything yet. Interview me about this problem. Ask questions
that expose missing requirements, conflicting constraints, edge cases,
security concerns and hidden assumptions. Challenge my proposals instead of
agreeing automatically. When you make an assumption, label it and explain why
you made it. Continue until the problem and its boundaries are explicit.
```

## Anti-sycophancy Reset

```text
Agreement is not evidence that the idea is correct. Your most useful role is
to challenge the reasoning. Tell me what could be wrong, what is missing and
why you believe each conclusion. Ask "why?" whenever the justification is
weak.
```

## Evaluation Rubric

```text
Before producing the final design or report, help me define the criteria by
which it will be judged. Include coverage, evidence, assumptions, alternatives,
risks, validation, traceability and conditions that require escalation. Do not
assume that a fluent answer is a correct answer.
```

## First Technical Proposal

```text
Based only on the approved context and our discussion, propose the first
technical approach in prose. Do not write implementation code. Explain the
major components, boundaries, data flow, failure behavior, alternatives and
trade-offs. Use a diagram or short pseudocode only when it improves clarity.
The proposal is expected to be imperfect and will be reviewed critically.
```

## Goldfish Comprehension Test

```text
You are a fresh session with no access to previous conversations. Read this
design document and every file it references. Explain the problem, current
system behavior, proposed change, constraints, expected files and acceptance
criteria. Identify anything you cannot determine from the provided material.
Do not invent missing context.
```

## Goldfish Critic Review

```text
Act as an independent senior reviewer. Read the design document and its
referenced files. Find omissions, faulty assumptions, edge cases, security or
privacy risks, architectural conflicts, ambiguous steps, unsupported APIs and
alternatives that should have been considered. Rank findings by severity and
state the evidence or question behind each finding.
```

## Implementation Readiness

```text
You are an experienced engineer joining this work for the first time. Read the
design document and its references. Can you implement the feature correctly in
one pass? List every missing decision, ambiguous behavior, missing file,
missing interface contract and missing validation condition. Do not implement
until the list is resolved or explicitly accepted as risk.
```

## Guarded Implementation

```text
Read the approved design document and all referenced files. Implement only the
described scope and follow the file inventory. If the repository contradicts
the design or an important decision is missing, stop and report it instead of
guessing. At the end, report changed files, tests run, evidence, deviations,
known limitations and remaining risks.
```

## Adversarial Code Review

```text
Review this implementation against the approved design, requirements,
architecture, acceptance criteria and tests. Assume there may be serious
defects. Look for incorrect behavior, security issues, regressions, hidden
coupling, unnecessary complexity, unhandled failures, stale documentation and
scope deviations. Report concrete findings with severity, location, impact,
evidence and remediation. Do not praise the implementation unless it helps
explain a finding.
```

## Session Recovery

```text
This is a continuation after a lost or interrupted session. Read the feature
design, current progress state and all referenced files. Summarize completed
work, current repository state, pending work, decisions, blockers and the next
safe action. Do not repeat completed work or infer decisions that are not
documented.
```

---

# Legacy Context Bootstrap

The article proposes a recursive documentation process for a large or poorly
documented codebase.

## Step 1: Start at the Leaves

Assign small directories or modules to engineers. Avoid sending the entire
repository to one AI session.

## Step 2: Generate a Local Context Summary

For each directory, generate or update a `README.md` that explains:

- The directory's purpose.
- The files it contains.
- The responsibility of each file.
- Important dependencies and boundaries.
- The source of truth for behavior or configuration.

## Step 3: Human Verification

The first summary is a draft. A responsible engineer must verify it against
the code and correct inaccurate or missing information.

Generated context must never become authoritative merely because an AI wrote
it.

## Step 4: Roll Up One Level at a Time

At the parent directory:

1. Read the verified child summaries.
2. Read the code directly in the parent directory.
3. Create or update the parent's summary.
4. Verify the result.

Repeat until the repository root has a useful context map.

## Step 5: Track Coverage and Staleness

Every summary should have, when useful:

- Owner.
- Last verified date.
- Scope of files covered.
- Known gaps.
- Links to design documents.

When design documents cover all relevant source files, the hierarchy can be
retained as navigation or retired to reduce maintenance. Do not keep duplicate
summaries indefinitely without a clear benefit.

## Safety Constraints

- Exclude secrets, credentials, private data and generated/vendor content.
- Do not send the entire repository to an external model by default.
- Verify summaries before using them for architecture or implementation.
- Treat stale summaries as hints, not authority.
- Prefer existing project READMEs and design artifacts when they are current.

## LF integration opportunity

This process could become an optional `LEGACY_CONTEXT_BOOTSTRAP` workflow or a
field guide rather than a mandatory step in every project. It is most valuable
when a project lacks reliable architecture documentation and has enough
maintenance activity to justify the initial investment.

---

# Onboarding and Contribution Model

The article identifies a second use for durable context: onboarding people and
screening proposed contributions.

## Knowledge Pack Onboarding

1. Assemble the relevant hierarchy of verified `README.md` summaries and
   design documents.
2. Load them into a searchable knowledge space such as a notebook or an
   equivalent internal tool.
3. Provide instructions that focus the learner on the subsystem they will
   change.
4. Ask the learner to write a feature design that passes the Goldfish
   comprehension and readiness checks before writing implementation code.

This changes onboarding from passive reading or prolonged shadowing into an
observable comprehension exercise. Passing the exercise is evidence that the
person can reason about the relevant system; it is not a replacement for human
mentoring or domain-specific review.

## Distributed Feature Proposals

Product managers, program managers and other contributors who understand the
problem domain can use the same knowledge pack to draft feature designs. A
technical owner reviews the design before implementation is accepted.

The contribution gate is the quality of the design and its evidence, not the
amount of code generated by the contributor or the AI.

## LF integration opportunity

`workflows/NEW_PROJECT.md` or `ENGINEERING_FIELD_GUIDE.md` could later define a
lightweight onboarding path. The path should require current context,
feature-design review and clear ownership while keeping implementation and
approval responsibilities with the appropriate LF agents.

---

# Agent Delegation Contract

Before delegating work to an AI agent, define the following contract.

| Contract Element | Required Question |
| --- | --- |
| Outcome | What result must exist when the agent stops? |
| Context | Which artifacts and files are authoritative? |
| Scope | What may the agent change or inspect? |
| Authority | Which decisions may it make without escalation? |
| Guardrails | Which standards, architecture and constraints apply? |
| Stop conditions | When must it stop and ask for guidance? |
| Evidence | What tests, reports or references prove completion? |
| Handoff | What summary and next action must it leave? |

## Proposed LF mapping

- **Engineering Manager:** outcome, classification, risks and ambiguity.
- **Orchestrator:** workflow, agent sequence, boundaries and handoffs.
- **Prompt Architect:** problem context, assumptions and missing information.
- **Product Owner:** product outcomes and acceptance criteria.
- **Software Architect:** technical boundaries, alternatives and decisions.
- **Sprint Planner:** executable scope, file inventory and validation tasks.
- **Implementation / selected CLI:** implementation within approved authority.
- **Code Reviewer:** adversarial conformance and maintainability review.
- **QA Security:** independent quality, security and readiness evidence.
- **Documentation:** durable synchronization and context preservation.
- **Tech Lead:** final synthesis, risk acceptance and approval or block.
- **Engineering Knowledge Extractor:** reusable lessons after approval.

No agent should infer authority from the ability to edit a file. Authority must
come from the workflow, artifact ownership and explicit handoff.

---

# Quality Gates Proposed for Future Adoption

These gates complement the current LF quality gates.

| Gate | Question | Evidence | Block condition |
| --- | --- | --- | --- |
| Design context | Does the AI understand the relevant system? | Corrected context summary | Material misunderstanding remains |
| Problem readiness | Is the problem and scope explicit? | Problem, goals, non-goals and open questions | Hidden or conflicting requirements |
| Evaluation readiness | Is the quality bar defined? | Acceptance and evaluation rubric | Review would rely on taste or fluency |
| Technical design | Is the solution reasoned before code? | Proposal, diagram, alternatives and decisions | Code is proposed before design is settled |
| Goldfish comprehension | Can a fresh session explain the design? | Comprehension result and corrections | Important context exists only in chat |
| Goldfish criticism | Were omissions and edge cases challenged? | Critic findings and dispositions | Material findings remain unexplained |
| Implementation readiness | Can the feature be implemented without guessing? | Readiness result and human approval | Scope, files or behavior remain ambiguous |
| Implementation conformance | Does code match the approved plan? | Diff, tests and deviation record | Unapproved scope or architecture drift |
| Adversarial review | Was the result actively challenged? | Review findings and remediation | Critical or high-risk defects remain |

The existing Functional, Security, Architecture, Code Quality, Documentation,
Performance and User Experience gates remain in force.

---

# Artifact and Workflow Mapping

| Existing LF asset | Article-aligned use | Recommended future refinement |
| --- | --- | --- |
| `PROJECT_BRIEF.md` | Durable problem context | Include explicit assumptions, non-goals and open questions |
| `PRD.md` | Product problem and acceptance | Separate product acceptance from AI output evaluation |
| `ARCHITECTURE.md` | System-level technical design | Link feature designs and record alternatives where relevant |
| `SPRINTS.md` | Executable scope and tests | Require expected files, rationale and deviation handling |
| `docs/ADR.md` | Durable architectural decisions | Link rejected alternatives and revisit conditions |
| `.ai/decisions.md` | Current decision traceability | Capture important micro-decisions before they disappear in chat |
| `.ai/handoff.md` | Cross-session continuity | Require current state, blockers and next safe action |
| `.ai/state/project-summary.md` | Project-level context | Keep feature-specific state in a linked feature artifact |
| `.ai/state/next-actions.md` | Recovery and coordination | Keep one actionable next step per active handoff |
| `.ai/tasks.md` | Agent execution contract | Add evidence and stop conditions for complex tasks |
| `.ai/artifacts.md` | Artifact inventory | Link design documents, rubrics and Goldfish results |
| `REVIEW.md` | Post-implementation scrutiny | Compare implementation against design and rubric explicitly |
| QA report | Independent validation | Include evidence that design risks were tested |
| `knowledge/INDEX.md` | Module discovery | Keep approved optional modules separate from the mandatory dependency chain |
| `.opencode/orchestrator.md` | Agent routing | Add design-readiness and recovery routing after approval |

---

# Suggested Framework Improvements

The following recommendations are prioritized for future review.

## Priority High: Add a Design-Readiness Loop to Standard Development

Target:

- `workflows/STANDARD_DEVELOPMENT.md`
- `knowledge/ENGINEERING_WORKFLOW.md`
- `knowledge/ENGINEERING_QUALITY.md`

Recommendation:

Add a pre-implementation loop covering context verification, no-code
interrogation, technical proposal, design completeness, Goldfish tests and
human approval.

Rationale:

The current workflow moves from architecture and sprint planning directly to
implementation. It has quality gates after implementation but no independent
test that the design can stand without the original AI conversation.

## Priority High: Define an AI Output Evaluation Rubric

Target:

- `knowledge/ENGINEERING_AI_COLLABORATION.md`
- `knowledge/ENGINEERING_QUALITY.md`
- `knowledge/ENGINEERING_TEMPLATES.md`

Recommendation:

Add reusable criteria for judging AI-generated analysis, design, plans and
implementation summaries before output is requested.

Rationale:

The existing validation rules state that outputs must be reviewed, but do not
standardize what evidence or coverage constitutes a good output.

## Priority High: Add an Optional Feature Design Artifact

Target:

- `schemas/FEATURE_DESIGN.schema.md`
- `knowledge/ENGINEERING_ARTIFACTS.md`
- `knowledge/ENGINEERING_TEMPLATES.md`
- `agents/Software-Architect/`
- `agents/Sprint-Planner/`

Recommendation:

Define an optional `docs/design/<FEATURE-ID>.md` artifact for medium- and
high-complexity work. Keep project-level architecture and product requirements
as their own sources of truth.

Rationale:

The existing artifacts cover project-level intent and architecture, but a
feature-level design is better suited to file inventory, alternatives, current
progress and session recovery.

## Priority High: Make Independent Comprehension a Gate

Target:

- `knowledge/ENGINEERING_QUALITY.md`
- `agents/Code-Reviewer/`
- `agents/Software-Architect/`
- `agents/Tech-Lead/`

Recommendation:

Require a fresh-session comprehension and readiness result for complex AI-led
changes before implementation approval.

Rationale:

This catches context hidden in the original session before it becomes code and
reduces the chance of accepting a fluent but incomplete design.

## Priority Medium: Standardize Agent Delegation Contracts

Target:

- `.opencode/orchestrator.md`
- `knowledge/ENGINEERING_AGENT_GUIDELINES.md`
- `knowledge/ENGINEERING_AI_COLLABORATION.md`
- `protocols/AGENT_HANDOFF.md`

Recommendation:

Extend agent handoffs with outcome, authority, scope, guardrails, stop
conditions and required evidence.

Rationale:

The current system defines role and artifact ownership but does not fully
standardize the autonomy boundary for each delegated task.

## Priority Medium: Add a Legacy Context Bootstrap Workflow

Target:

- `workflows/`
- `knowledge/ENGINEERING_FIELD_GUIDE.md`
- `knowledge/ENGINEERING_TEMPLATES.md`

Recommendation:

Create an optional workflow for recursively building and human-verifying
directory context summaries in legacy projects.

Rationale:

The current framework assumes that project context and architecture artifacts
already exist. This provides a practical path when they do not.

## Priority Medium: Strengthen Session-Recovery Requirements

Target:

- `protocols/AGENT_HANDOFF.md`
- `protocols/WORKFLOW_UPDATE.md`
- `.ai/state/`
- `knowledge/ENGINEERING_AI_COLLABORATION.md`

Recommendation:

Require every active handoff to state completed work, current work, next safe
action, unresolved questions, decisions and validation evidence.

Rationale:

The LF already has the right state files. A stronger minimum handoff format
would make them more useful after crashes, context limits or agent changes.

## Priority Medium: Add Design-Conformance Review

Target:

- `agents/Code-Reviewer/`
- `knowledge/ENGINEERING_QUALITY.md`
- `workflows/STANDARD_DEVELOPMENT.md`

Recommendation:

Require review findings to identify divergence from the approved design,
expected file inventory and evaluation rubric.

Rationale:

The current review model checks implementation quality and architecture, but an
explicit design-conformance dimension makes scope drift easier to detect.

## Priority Low: Add Design-Based Onboarding

Target:

- `workflows/NEW_PROJECT.md`
- `knowledge/ENGINEERING_FIELD_GUIDE.md`
- `agents/Engineering-Knowledge-Extractor/`

Recommendation:

Use a Goldfish comprehension exercise as one optional onboarding signal for
engineers or contributors working on an unfamiliar subsystem.

Rationale:

The article shows that design comprehension can be a more useful readiness
signal than the ability to produce a large amount of code quickly.

## Priority Low: Protect Deliberate Design Capacity

Target:

- `knowledge/ENGINEERING_FOUNDATIONS.md`
- `knowledge/ENGINEERING_CONTINUOUS_IMPROVEMENT.md`

Recommendation:

Record focused design work and quality improvement as legitimate engineering
capacity, rather than measuring AI adoption only by generated lines or task
throughput.

Rationale:

AI productivity can increase demand and output volume. Without protected design
time, the system may optimize generation while underinvesting in judgment.

---

# Agent-Specific Adoption Notes

These notes are recommendations for a future update to canonical agent
documentation.

## Prompt Architect

- Lead the interrogation loop.
- Record assumptions and unanswered questions.
- Resist converting ambiguity into artificial certainty.

## Product Owner

- Define product acceptance criteria before implementation.
- Distinguish desired outcomes from proposed solutions.
- Include negative cases and explicit non-goals.

## Software Architect

- Ask the AI to produce the first prose proposal.
- Require alternatives, trade-offs and file-level impact.
- Keep architecture decisions separate from implementation speculation.

## Sprint Planner

- Translate approved design into sequenced tasks.
- Preserve the expected file inventory and validation evidence.
- Define stop conditions for ambiguous implementation work.

## Implementation / selected CLI

- Treat the approved design as the implementation contract.
- Stop rather than guess when the design and repository disagree.
- Leave a recovery summary after each meaningful implementation session.

## Code Reviewer

- Review against the design, not only the diff.
- Use adversarial questions and evidence.
- Avoid arbitrary style rules that do not improve comprehension.

## QA Security

- Validate risks identified during design.
- Check that acceptance criteria have evidence.
- Treat Goldfish results as supporting evidence, never as a replacement for QA.

## Documentation

- Keep design, implementation state and project artifacts synchronized.
- Detect stale context summaries.
- Preserve rejected alternatives and decision rationale.

## Tech Lead

- Approve the design before high-risk implementation.
- Decide whether remaining ambiguity is acceptable risk.
- Control how many agents are active and whether coordination is working.

## Engineering Knowledge Extractor

- Capture which design-first practices reduced rework or improved comprehension.
- Separate observed project evidence from article-derived hypotheses.
- Recommend Framework changes only after human review of evidence.

---

# Risks and Counterarguments

## Design Documents Can Become Stale

A precise design that is not updated can mislead agents more effectively than
no documentation. Every design artifact needs an owner, status and update
trigger.

## A Goldfish Can Still Be Wrong

Fresh context reduces conversational bias but does not guarantee correctness.
The model may misunderstand the supplied files, accept a flawed premise or
miss a domain-specific risk. Human review, tests and QA remain mandatory.

## More Documentation Can Create Duplication

Adding a feature design file without assigning ownership can duplicate the PRD,
architecture and sprint. Adoption must define which artifact owns each fact and
use links for shared information.

## Adversarial Prompts Can Reduce Collaboration Quality

The goal is rigorous criticism, not hostility. The LF should require concrete
evidence, severity and remediation rather than a specific insulting tone.

## Context Summaries Can Encode Wrong Architecture

Recursive README generation is useful but generated summaries can be wrong,
especially at leaf directories. Human verification and freshness metadata are
required.

## Large File Inventories Can Become Bureaucratic

The inventory is valuable for high-risk work. For a trivial change, a compact
scope statement is enough. The workflow should scale documentation depth to
risk and complexity.

## More Agents Can Lower Throughput

Parallel work is not automatically faster. Conflicting edits, synchronization
and review load can exceed the saved time. Add agents only when work boundaries
are independent and a coordinator can synthesize results.

## Article Claims Are Not Universal Metrics

Claims such as tenfold productivity, a one-week bootstrap or approximate model
accuracy are anecdotal and context-dependent. LF should measure its own results
through rework, defect escape, review time, comprehension and maintainability.

## Design Does Not Eliminate Code

Code remains executable evidence and must be tested, reviewed and secured. The
article's "design is the new code" statement should be interpreted as a shift
in the primary human responsibility, not as permission to stop inspecting
implementation.

---

# Pilot Plan Before Framework Adoption

## Pilot Scope

Run the model on one or two medium-complexity features and one legacy change.
Do not change the canonical Framework first.

## Pilot Steps

1. Create a feature design using the proposed contract.
2. Record an evaluation rubric before implementation.
3. Run the comprehension, critic and readiness tests in fresh sessions.
4. Get human approval.
5. Implement within the enumerated file scope.
6. Run design-conformance review, Code Review and QA Security.
7. Record rework, missed assumptions, review findings and time spent.
8. Compare results with a similar change that did not use the model.
9. Decide which recommendations deserve canonical adoption.

## Suggested Success Signals

- Fewer implementation restarts caused by missing context.
- Fewer unplanned files or scope changes.
- Fewer architecture deviations.
- Earlier discovery of edge cases.
- Faster recovery after session interruption.
- Lower review rework for AI-generated code.
- Higher agreement between design, implementation and tests.
- New contributors can explain the relevant system sooner.

## Do Not Use as Primary Success Metrics

- Lines of code generated.
- Number of prompts.
- Length of the design document.
- Model confidence or fluency.
- Number of agents active at once.

---

# Future Integration Sequence

The safest order for adoption is:

1. Human review of this optional module and its evidence.
2. Pilot without changing mandatory Framework rules.
3. Add a feature design template and optional schema.
4. Add Goldfish checks to high-risk workflow paths.
5. Add design-conformance evidence to Code Review and QA.
6. Add delegation contracts and recovery requirements to protocols.
7. Add the optional legacy context bootstrap workflow.
8. Update agent adapters and registry only after the operating model is stable.
9. Version the affected canonical modules and record an ADR when the artifact
   chain or workflow changes.

---

# Relationship to Existing LF Knowledge

## Complements

- `ENGINEERING_FOUNDATIONS.md`: reinforces clarity, responsibility,
  maintainability and human accountability.
- `ENGINEERING_WORKFLOW.md`: adds pre-implementation design and independent
  comprehension loops.
- `ENGINEERING_ARTIFACTS.md`: proposes a feature-level design contract without
  replacing existing artifact ownership.
- `ENGINEERING_DECISIONS.md`: makes assumptions, alternatives and trade-offs
  explicit earlier.
- `ENGINEERING_AI_COLLABORATION.md`: adds interrogation, guardrails, recovery
  and output evaluation practices.
- `ENGINEERING_AGENT_GUIDELINES.md`: adds delegated-work contracts and stop
  conditions.
- `ENGINEERING_QUALITY.md`: adds design readiness and conformance evidence.
- `ENGINEERING_CONTINUOUS_IMPROVEMENT.md`: supplies a pilot and measurement
  path for framework evolution.

## Important Non-contradictions

- Human approval remains mandatory.
- The Framework remains the source of truth after adoption.
- Existing quality priorities remain unchanged.
- Code Review and QA remain required.
- Documentation ownership and artifact contracts still apply.
- This optional module does not authorize an agent to modify the Framework.

---

# Glossary

**Elephant:** A context-rich AI working session and the durable design,
decisions and progress artifacts it produces.

**Goldfish:** A fresh AI session with no access to prior conversation, used to
test whether explicit artifacts contain sufficient context.

**Design-first:** A workflow in which problem framing, technical reasoning,
alternatives and evaluation criteria precede implementation.

**Evaluation rubric:** Explicit criteria and evidence used to judge an AI
output, design or implementation.

**Context compression:** The deliberate reduction of a large codebase into
accurate, navigable summaries without discarding authoritative source files.

**Signal-to-noise ratio:** The relationship between useful, verifiable
engineering output and unrequested, speculative or misleading output.

**Look-away time:** The period during which a delegated agent can work safely
within its contract before human intervention is required. It is an operational
measure of delegation quality, not a claim of independent ownership.

---

# Final Principle

AI should make implementation faster without making intent harder to recover.

The human contribution moves toward problem framing, design judgment,
delegation, evidence and accountability. The LF Engineering System should
adopt these ideas incrementally, preserving a single source of truth and
requiring evidence before converting an experience report into a mandatory
engineering rule.

---

## Version History

- `0.2.0` — 2026-11-01: Approved as optional supplemental guidance and clarified
  that this status does not create universal gates or mandatory artifacts.
