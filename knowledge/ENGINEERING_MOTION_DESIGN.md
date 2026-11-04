# Engineering Motion Design

Version: 1.0.0
Status: Stable
Category: Operational
Applicability: Conditional for projects that plan, implement or evaluate motion in a visual experience.
Derived From: LF Engineering Framework 1.3.0; post-tag maintenance

---

## Purpose

Define a technology-independent way to plan, implement and validate motion as
part of an interface or visual experience. Motion should communicate intent,
support interaction and remain accessible, useful and performant.

This module complements `ENGINEERING_DESIGN_PERFORMANCE`. It does not add a
workflow phase or require animation in projects that do not need it.

---

## Consumers

Primary:

- Product Owner Agent
- Design System Analyst Agent
- Software Architect Agent
- Sprint Planner Agent
- QA-Security Agent
- Tech Lead Agent

Supporting, when motion is in scope:

- Implementation / selected CLI
- Code Reviewer Agent
- Documentation Agent
- Engineering Knowledge Extractor Agent

---

## Dependencies

Required:

- `ENGINEERING_FOUNDATIONS`
- `ENGINEERING_WORKFLOW`
- `ENGINEERING_QUALITY`

Related:

- `ENGINEERING_DESIGN_PERFORMANCE`
- `ENGINEERING_ARTIFACTS`
- `ENGINEERING_STANDARDS`
- `ENGINEERING_TEMPLATES`

---

## Applicability and Boundaries

Use this module when a product intentionally uses animation, transitions,
micro-interactions, scroll-linked motion or animated 2D/3D assets. If motion is
not part of the product scope, record it as not applicable rather than adding
decorative motion or validation work.

The motion contract may live in `docs/DESIGN.md` when that artifact exists. If
it is skipped, record user-visible outcomes and acceptance criteria in
`docs/PRD.md`, and relevant implementation constraints in `docs/ARCHITECTURE.md`.

The Framework does not prescribe a visual style, motion library, frontend
framework, fixed timing value or universal frame-rate target.

---

## Motion Design Contract

Before implementation, capture the decisions needed to make the motion
intentional and testable:

- **Purpose and context:** the user action, state change or communication need
  the motion serves; identify the relevant audience and task context without
  inventing user research.
- **Hierarchy:** which element leads, what supporting elements do, and whether
  sequencing or simultaneous movement best preserves clarity.
- **Behavior:** direction, relative distance, timing, easing, repetition,
  interruption and reversal where relevant. Select values for the product
  context; published timing tables and ratios are heuristics, not requirements.
- **Accessibility and control:** reduced-motion behavior, essential information
  that must remain available without animation, and user controls for
  continuous or automatically starting motion when applicable.
- **Responsive behavior:** differences needed for relevant viewports, input
  methods and device constraints.
- **Evidence and ownership:** how the result will be reviewed, who accepts it,
  and which decisions remain proposed or unverified.

Keep approved product requirements, observed references, derived interpretations
and proposals distinct. Approval of a proposal is not evidence of user
preference or usability validation.

---

## Design Principles

- Decide what the motion communicates before selecting properties or writing
  animation code.
- Prefer clear feedback, orientation and state communication over decoration.
- Match intensity and timing to the importance and frequency of the interaction;
  repeated interactions should remain predictable and restrained.
- Establish a clear primary action and coordinate related elements so movement
  does not compete with content or another active interaction.
- Use sequencing, anticipation, follow-through or narrative structure only when
  they improve comprehension or the intended expression.
- Keep the operation's true completion state separate from visual feedback.
  Animation must not imply that an asynchronous action succeeded before it has.
- Treat duration, easing, distance and element-count recommendations as
  context-dependent heuristics. Validate the result at normal playback speed.

---

## Accessibility and User Control

- Respect the user's `prefers-reduced-motion` setting and provide an equivalent
  reduced-motion experience. Preserve essential content, state, focus and
  functionality.
- Where appropriate, replace large spatial movement, parallax, spinning or
  spring-like motion with a simpler transition or an immediate state change.
- Do not communicate an essential state or instruction through motion alone.
- Avoid motion that can distract from the task or cause discomfort; evaluate
  large-scale, rapid, flashing and vestibular-sensitive effects in context.
- Provide a way to pause, stop or control automatically starting or continuous
  motion when applicable.
- Do not make essential actions dependent on hover or on completing an
  animation. Preserve keyboard, touch and assistive-technology access.

---

## Performance and Implementation

- Prefer `transform` and `opacity` when they meet the design intent, but verify
  actual rendering cost; neither property guarantees smooth performance in
  every context.
- Avoid layout-heavy animation and repeated layout reads/writes when an
  equivalent lower-cost treatment is appropriate. Measure costly or
  scroll-linked motion on representative routes and devices.
- Clean up or cancel animation work when its component, route or owning state is
  no longer active. Avoid stale callbacks and interactions that can leave
  elements in an incorrect state.
- Coordinate responsive behavior and reduced-motion preferences with the
  selected implementation system. Do not ship large animation dependencies for
  convenience without evaluating their value and cost.
- Do not promise a fixed frame rate from a library choice or source-level
  review. Record the device, route, tool and evidence when performance is
  measured.

---

## Optional Tooling and Specialized Visual Pipelines

The project selects implementation tools through its architecture and existing
constraints. GSAP, CSS, Web Animations API and framework-specific systems are
implementation choices, not Framework defaults. When a project selects GSAP,
use current official GSAP documentation for its API and lifecycle details; do
not apply GSAP-specific patterns to other systems.

Procedural 3D reconstruction is a separate, opt-in capability. When a project
explicitly needs it, use a scoped pipeline that checks reference suitability,
defines a structured asset specification, builds in gated stages, validates
technical properties, reviews rendered views against the agreed criteria, and
records evidence and limitations. Visual similarity measures are signals, not
proof of correctness. Do not assume photogrammetry, exact reconstruction,
production readiness or installation of a skill, plugin or dependency. Require
explicit project approval before installing any external tool.

---

## Validation and Evidence

When motion is in scope, review the implemented experience against the approved
contract and include a conditional Motion Review in
`docs/PERFORMANCE_VALIDATION_REPORT.md`:

- Verify the purpose, hierarchy and state behavior in representative journeys.
- Test normal and reduced-motion behavior, including the operating-system or
  browser preference where supported.
- Check keyboard and touch interaction, interruption, repeated use, focus and
  access to content when motion is skipped or delayed.
- Review each relevant mobile and desktop behavior separately. Use screenshots
  for visual states and a recording or equivalent time-based evidence when a
  still image cannot show the behavior.
- Measure performance when the effect is costly, continuous, scroll-linked or
  otherwise identified as a risk. Report insufficient evidence honestly.
- Record findings, exceptions, owner and follow-up. A static code or structure
  check alone is not visual approval.

If no motion is in scope, mark the Motion Review not applicable and state the
inspected scope. Continue to use the separate route/profile performance and
accessibility requirements in `ENGINEERING_DESIGN_PERFORMANCE`.

---

## Related Artifacts

- `knowledge/ENGINEERING_DESIGN_PERFORMANCE.md`
- `knowledge/ENGINEERING_QUALITY.md`
- `PROJECT_TEMPLATE/docs/DESIGN.md`
- `protocols/PERFORMANCE_VALIDATION.md`
- `schemas/PERFORMANCE_VALIDATION_REPORT.schema.md`
- `PROJECT_TEMPLATE/docs/PERFORMANCE_VALIDATION_REPORT.md`

---

## Source References

The following repositories informed this selective synthesis. Their tools,
installation steps, fixed heuristics and library-specific recommendations are
not adopted as Framework requirements:

- [LottieFiles Motion Design Skill](https://github.com/lottiefiles/motion-design-skill)
- [GSAP Skills](https://github.com/greensock/gsap-skills)
- [img2threejs](https://github.com/img2threejs/img2threejs)

---

## Version History

- `1.0.0` — 2026-11-01: Added conditional motion-design planning, accessibility,
  implementation-neutrality and evidence-based review guidance.
