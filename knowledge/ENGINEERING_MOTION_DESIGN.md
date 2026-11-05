# Engineering Motion Design

Version: 1.1.0
Status: Stable
Category: Operational
Applicability: Conditional for projects that plan, implement or evaluate motion in a visual experience, or explicitly need an interactive model-driven visual simulator or explainer.
Derived From: LF Engineering Framework 1.3.0; post-tag maintenance

---

## Purpose

Define a technology-independent way to plan, implement and validate motion and
optional model-driven visual simulations as part of an interface or visual
experience. Motion should communicate intent; simulations should make their
model, evidence and limitations clear. Both should remain accessible, useful and
performant.

This module complements `ENGINEERING_DESIGN_PERFORMANCE`. It does not add a
workflow phase or require motion, 3D or simulation in projects that do not need
them.

---

## Consumers

Primary:

- Product Owner Agent
- Design System Analyst Agent
- Software Architect Agent
- Sprint Planner Agent
- QA-Security Agent
- Tech Lead Agent

Supporting, when motion or a model-driven interactive simulator is in scope:

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
micro-interactions, scroll-linked motion or animated 2D/3D assets. Also use the
model-driven simulation guidance below when the product explicitly needs an
interactive visual representation whose geometry or displayed values communicate
a model, whether or not it uses continuous animation. If neither motion nor an
interactive model-driven simulator is in scope, record the relevant conditional reviews as
not applicable rather than adding decorative motion or simulation work.

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

## Optional Tooling and Specialized Visual Capabilities

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

### Model-Driven Interactive Simulations

This guidance is conditional for an explicitly requested simulator or visual
explainer in which a model drives the displayed behavior. It does not make 3D,
animation or simulation a default for visual projects.

- State the intended use, level of fidelity, decision impact and known
  limitations. Do not present an explanatory or approximate model as an
  engineering-validated simulator; require appropriate domain review for claims
  that depend on real-world accuracy.
- Prefer authoritative references or data where available. Record source,
  licensing constraints, units, assumptions and confidence for important
  parameters. Classify claims as `Observed`, `Derived`, `Proposed` or
  `Unverified`; make uncertainty visible instead of inventing precision.
- Define one model state or calculation as the source for the simulated pose,
  labels, gauges, charts and schematics. Avoid separately authored values or
  animations that can disagree with that state. Keep model calculations separate
  from rendering when practical; this is a design principle, not a required
  programming pattern.
- Validate important calculations independently with appropriate expected
  values, boundary cases or invariants. A convincing render or visual-similarity
  score is not proof that the model is numerically correct.
- Review representative poses, transitions, cutaways and displayed values
  against the agreed references. Preserve visual or time-based evidence and
  unresolved limitations.
- Keep tours and continuous motion under user control. Provide pause/stop or an
  equivalent way to regain control, respect reduced-motion preferences, and do
  not take control back from an active user. Essential information must remain
  available without motion.
- If repeatable time-based capture is a project requirement, define how the same
  input and time produce reviewable output. Video capture, audio and standalone
  packaging remain optional delivery choices.
- Assess rendering cost and fallback behavior on representative mobile and
  desktop profiles, including constrained graphics hardware when relevant. Use
  the existing performance contract; do not infer a universal frame-rate,
  package-size or hardware target from a tool or example.

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

For a model-driven interactive simulator, complete the conditional Interactive
Model Review in `docs/PERFORMANCE_VALIDATION_REPORT.md`. Record intended use,
decision impact, fidelity and limitations; important data sources, units,
assumptions and evidence classifications; independent numerical checks;
consistency between the model state and displayed elements; and visual or
time-based evidence. For the full required fields, including keyboard/touch,
reduced-motion and user-control findings, unresolved discrepancies, owner and
follow-up, use
`protocols/PERFORMANCE_VALIDATION.md` and its report schema. This review does not
replace performance, accessibility or domain-expert validation. If no such
simulator is in scope, mark this review not applicable and state the inspected
scope.

---

## Related Artifacts

- `knowledge/ENGINEERING_DESIGN_PERFORMANCE.md`
- `knowledge/ENGINEERING_QUALITY.md`
- `PROJECT_TEMPLATE/docs/DESIGN.md`
- `PROJECT_TEMPLATE/docs/ARCHITECTURE.md`
- `protocols/PERFORMANCE_VALIDATION.md`
- `schemas/PERFORMANCE_VALIDATION_REPORT.schema.md`
- `PROJECT_TEMPLATE/docs/PERFORMANCE_VALIDATION_REPORT.md`

---

## Source References

The following sources informed this selective synthesis. Their tools,
installation steps, fixed heuristics and library-specific recommendations are
not adopted as Framework requirements:

- [LottieFiles Motion Design Skill](https://github.com/lottiefiles/motion-design-skill)
- [GSAP Skills](https://github.com/greensock/gsap-skills)
- [img2threejs](https://github.com/img2threejs/img2threejs)
- [teardown](https://github.com/elvarofficial/teardown)
- [How I Turn Any Machine Into a 3D Simulator You Can Take Apart](https://teapawt.org/elvar_official/article/2116174609355571402)

---

## Version History

- `1.1.0` — 2026-11-04: Added optional, model-driven interactive simulation
  guidance for evidence, state consistency, numerical and visual review, user
  control and performance without adopting a tool or fixed target.
- `1.0.0` — 2026-11-01: Added conditional motion-design planning, accessibility,
  implementation-neutrality and evidence-based review guidance.
