# Independent Elephant-Goldfish Evaluation — Motion Design Pilot

**Status:** Completed; combined design-readiness result did not pass.<br>
**Date:** 2026-11-01<br>
**Subject:** Durable pre-implementation design packet in a read-only client sandbox; owner-local path and project name omitted.<br>
**Protocol:** `knowledge/ENGINEERING_ELEPHANT_GOLDFISH.md`, Phase F

## Executive Result

Three separate fresh OpenCode sessions received the same 13-file design packet
and no prior task conversation. They were not given implementation source,
screenshots, review/QA outputs or other pilot evidence, and were instructed not
to search the repository or external sources.

| Goldfish test | Independent result | Summary |
|---|---|---|
| Comprehension | **PASS with qualifications** | The packet supports a materially correct explanation of the problem, architecture, behavior, scope, file plan and evidence limits. Status and file-operation inconsistencies and several undefined details remain. |
| Critic | **FAIL** | High-severity issues remain around preference/pause/focus transitions, continuous-motion performance measurement, and acceptance criteria that allow limitations to be confused with passes. |
| Implementation readiness | **FAIL** | A one-pass implementation cannot be confidently specified without resolving state/focus policy, motion behavior, evidence gates, required context and file inventory. |

**Combined disposition:** Not ready for one-pass implementation. The comprehension
pass does not offset failed critic and readiness checks. This is a retrospective
artifact evaluation after the local pilot was implemented; it does not reverse
the earlier sandbox-only approval, validate the implementation, or establish
production readiness. No sandbox files were changed by this evaluation.

## Independence and Input Record

The sessions were created independently with separate session IDs. Each received
the same explicit packet:

- Sandbox: `PROJECT_BRIEF.md`, `LF_ENGINEERING.md`, `.ai/contracts.md`,
  `.ai/decisions.md`, `docs/PRD.md`, `docs/DESIGN.md`, `docs/ARCHITECTURE.md`,
  `docs/ADR.md` and `docs/SPRINTS.md`.
- Framework references: `knowledge/INDEX.md`,
  `knowledge/ENGINEERING_MOTION_DESIGN.md`,
  `knowledge/ENGINEERING_DESIGN_PERFORMANCE.md` and
  `protocols/PERFORMANCE_VALIDATION.md`.

`docs/DESIGN.md` was supplied because it was present and referenced by project
decisions, although it is an empty template and D-001 says the project artifact
is skipped. Review and QA reports, performance results, source code and browser
evidence were deliberately excluded to prevent hindsight from affecting the
pre-implementation design assessment.

| Session | Role | Outcome |
|---|---|---|
| Comprehension session | Comprehension | PASS with qualifications |
| Critic session | Critic | FAIL; material findings remain |
| Implementation-readiness session | Implementation readiness | FAIL; blockers remain |

## Findings

### High — resolve before using this packet as an implementation-ready design

1. **Live reduced-motion, pause and focus policy is incomplete.** The artifacts
   define pause persistence across planet selection, but not across
   `no-preference → reduce → no-preference`. They do not state whether a prior
   pause must persist, whether the orbit freezes in place or moves to static
   positions, or what happens if the pause control has focus when it is replaced
   by a status. The accessible focus outcome is therefore ambiguous.
   **Evidence:** `docs/PRD.md` RF-004/RF-005; `docs/ARCHITECTURE.md` Interaction
   and Motion Flow / Motion Runtime and Integration; `docs/SPRINTS.md` AC-005 and
   Tests Expected 4.

2. **Continuous-motion performance evidence has no repeatable measurement plan.**
   The motion guidance calls for performance measurement for continuous effects.
   Position changes prove that animation is running or paused, not its rendering
   cost. The approved exclusion of a production Lighthouse gate does not resolve
   the separate question of whether the motion itself was reviewed adequately.
   **Evidence:** `knowledge/ENGINEERING_MOTION_DESIGN.md` Validation and
   Evidence; `docs/ARCHITECTURE.md` Motion Runtime and Integration / Validation
   Strategy; `docs/SPRINTS.md` Tests Expected 7.

3. **Unverified acceptance can be mistaken for a pass.** The PRD requires a
   200%-zoom check; the sprint allows unavailable zoom to be recorded as a
   limitation. Live preference testing is conditional on tool support, while
   other artifacts require coherent live changes. The completion checklist
   combines demonstrated and not-verified outcomes. These should be separate
   states: pass, fail, not verified, and approved exception.
   **Evidence:** `docs/PRD.md` RNF-002 / AC-006 / AC-008;
   `docs/SPRINTS.md` AC-005–008, Tests Expected 4 and Completion Checklist;
   `protocols/PERFORMANCE_VALIDATION.md` Acceptance Gate.

### Medium — important gaps or consistency issues

- **Motion contract:** “subtle” and “continuous” do not specify context-specific
  direction, relative periods, easing, simultaneous behavior or interruption
  expectations. A universal timing target is unnecessary, but the pilot needs
  observable project-level decisions. (`PRD.md` RF-003;
  `ARCHITECTURE.md` Motion Runtime and Integration.)
- **Accessibility:** the packet does not fully define the mutually exclusive
  selection/group semantics, live-region content, orbit's decorative/textual
  treatment, or measurable contrast/focus checks. (`ARCHITECTURE.md` Data and
  Security Boundaries; `PRD.md` RNF-001; `SPRINTS.md` Tests Expected 5.)
- **Touch and repeated interaction:** keyboard is explicit, but mobile touch
  activation, repeated pause/resume, and preference changes while paused are not
  fully enumerated. (`PRD.md` Goals / RF-006;
  `knowledge/ENGINEERING_MOTION_DESIGN.md` Validation and Evidence.)
- **Resource/network evidence:** initial-route byte accounting, cache state,
  transfer-vs-source bytes and full request-observation scope are unspecified.
  (`PRD.md` RNF-003 / AC-007; `docs/SPRINTS.md` Tests Expected 7.)
- **File inventory/timeframe:** `ARCHITECTURE.md` says create the performance
  report while `SPRINTS.md` says update it; `docs/evidence/` is mentioned in the
  completion checklist but absent from the expected-file list. The brief says
  the plan awaits approval, while sprint and decision artifacts record approval
  and completion. (`PROJECT_BRIEF.md` Source and Status;
  `docs/ARCHITECTURE.md` File and Route Structure;
  `docs/SPRINTS.md` Expected Files / Completion Checklist;
  `.ai/decisions.md` D-003.)
- **Other implementation details:** default planet, initial HTML/data ownership,
  exact DOM/CSS/JS selectors, script-failure fallback and initial selection
  synchronization are left to the implementer or inconsistently described.
  (`docs/PRD.md` AC-001–002; `docs/ARCHITECTURE.md` Stack and Components;
  `docs/SPRINTS.md` S1-01/S1-03.)
- **Required context:** the design names canonical Framework references and
  project state that an independent engineer may not have. Supply the complete
  applicable packet or record an explicit packet-only exception.
  (`LF_ENGINEERING.md` Canonical Sources / Workflow; `.ai/contracts.md`;
  `docs/SPRINTS.md` S1-07.)

### Accepted boundaries, not defects by themselves

- Skipping a visual-direction proposal is supported by D-001; the supplied
  `docs/DESIGN.md` template is not an approved design baseline.
- No production deployment, field data, five-run Lighthouse gate, formal WCAG
  certification or physical-device certification is an explicit scope limit.
- A static HTML/CSS/JavaScript implementation with no package installation,
  backend, third-party runtime dependency or external service is coherent for
  this pilot.
- A four-planet, explicitly non-scale illustration is an acceptable pilot-sized
  content choice, not evidence of audience preference or a scientific model.

## Recommended Disposition

- Preserve the results as evidence that a fresh context can understand the
  central design, while also finding material implementation and review gaps.
- Do not label the full Elephant-Goldfish cycle successful or the design
  implementation-ready. The original sandbox's local pilot progression remains
  distinct from this artifact-readiness result.
- If the packet is reused for future implementation, resolve or explicitly
  accept the high findings, assign owners to remaining evidence gaps, and update
  the canonical project artifacts before coding. Do not edit the external
  sandbox or install tools without separate approval.

## Limitations

This review tests document comprehension and design readiness; it does not
validate browser behavior, source correctness, factual accuracy of all planet
copy, production performance or overall effectiveness of the Elephant-Goldfish
method. A fresh session can still be wrong. Human review and ordinary code,
security, accessibility and QA validation remain necessary.
