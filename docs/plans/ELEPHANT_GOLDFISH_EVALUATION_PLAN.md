# Elephant-Goldfish Independent Evaluation Plan

**Status:** Executed; combined design-readiness result did not pass.<br>
**Evaluation date:** 2026-11-01<br>
**Subject:** Motion-design pilot durable design packet<br>
**Canonical result:** `docs/evaluations/ELEPHANT_GOLDFISH_MOTION_DESIGN_2026-11-01.md`

## Objective

Test whether the motion-design pilot artifacts communicate enough context for a
new session to understand, criticize and implement the planned motion-design
pilot without access to the original working conversation.

## Scope and Independence Controls

- Use three separate, newly created OpenCode sessions: comprehension, critic and
  implementation readiness. No session receives the earlier task conversation
  or another Goldfish session's output.
- Give each session the same explicit artifact packet. Do not provide
  implementation source, screenshots, review/QA reports or pilot outcome
  artifacts; do not browse external sources or inspect the repository.
- Assess the packet as a **pre-implementation design**, despite the sandbox now
  containing an implementation. Do not use the implementation as correctness
  evidence.
- Run read-only. Do not edit the client sandbox, install tools, or change its
  state. Record the results in the Framework repository only.

## Input Packet

The same 13 files were attached to each session:

1. `PROJECT_BRIEF.md`
2. `LF_ENGINEERING.md`
3. `.ai/contracts.md`
4. `.ai/decisions.md`
5. `docs/PRD.md`
6. `docs/DESIGN.md` (included as supplied; it is a blank template and D-001 says
   the project artifact is skipped)
7. `docs/ARCHITECTURE.md`
8. `docs/ADR.md`
9. `docs/SPRINTS.md`
10. Framework `knowledge/INDEX.md`
11. Framework `knowledge/ENGINEERING_MOTION_DESIGN.md`
12. Framework `knowledge/ENGINEERING_DESIGN_PERFORMANCE.md`
13. Framework `protocols/PERFORMANCE_VALIDATION.md`

## Evaluation Sequence and Acceptance Criteria

| Test | Question | Pass condition | Session | Result |
|---|---|---|---|---|
| Comprehension | Can a fresh session accurately explain the problem, design, constraints, expected files and acceptance evidence? | Materially correct explanation without hidden conversation context; uncertainty and contradictions are explicit. | Separate fresh session | Pass with qualifications |
| Critic | Can a different fresh session expose material omissions, contradictions, edge cases and unsupported assumptions? | Material findings are concrete, evidenced and either resolved or accepted as explicit risk. | Separate fresh session | Fail; material findings remain |
| Implementation readiness | Can a third fresh session implement correctly in one pass from the packet? | No material decisions, interface contracts, file responsibilities or validation conditions remain unanswered. | Separate fresh session | Fail; blockers remain |

## Recorded Outcome

The comprehension session explained the intended system and scope but found a
mixed-timeframe packet, zoom-acceptance conflict, file-inventory inconsistency
and unresolved motion-state details. The critic and readiness sessions failed;
their most important findings concern live reduced-motion/pause/focus policy,
continuous-motion performance evidence, inconsistent treatment of unverified
acceptance criteria, incomplete motion/accessibility contracts and ambiguous
report/evidence ownership.

**Combined result:** The design packet is not one-pass implementation-ready.
This is a retrospective artifact evaluation, not a rollback or invalidation of
the Project Owner's earlier local-sandbox approval. It does not establish that
the motion guidance is ineffective or that the implementation is defective; the
Goldfish sessions were explicitly prevented from inspecting the implementation.
The pilot must not be described as a successful full Goldfish cycle.

## Handoff

Detailed findings, evidence references and limitations are recorded in the
canonical evaluation report. No fixes are applied to the external sandbox under
this plan. Any future reuse of the pilot as a design-readiness example should
first resolve or explicitly accept the recorded findings with owner, risk and
validation evidence.
