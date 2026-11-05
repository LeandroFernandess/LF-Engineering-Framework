# Engineering Design Performance

Version: 1.2.0
Status: Stable<br>
Category: Operational<br>
Source: `docs/reference/LF_DESIGN_PERFORMANCE_GUIDE.md` (reviewed 2026-10-18; detailed non-normative reference); adopted operational requirements are defined here, in `protocols/PERFORMANCE_VALIDATION.md` and related canonical artifacts. Selective design-direction guidance is recorded in ADR-008 (2026-10-31).
Derived From: LF Engineering Framework 1.3.0; post-tag maintenance

---

## Purpose

This module turns the LF design and performance guide into a reusable workflow
contract for web and interface projects. It keeps performance, accessibility,
responsiveness, visual identity and functionality under the same engineering
decision process.

It is conditional for projects with a web or visual interface. APIs, CLIs,
workers and other non-visual systems must record the conditional skip and do
not need to invent mobile or desktop measurements.

The module is framework-independent. It does not prescribe a frontend
framework, hosting provider or a fixed PageSpeed result.

---

## Consumers

Primary:

- Product Owner Agent
- Design System Analyst Agent
- Software Architect Agent
- Sprint Planner Agent
- QA & Security Agent
- Tech Lead Agent

Secondary:

- Implementation / selected CLI
- Code Reviewer Agent
- Documentation Agent
- Engineering Knowledge Extractor Agent

---

## Dependencies

Required:

- `ENGINEERING_FOUNDATIONS`
- `ENGINEERING_WORKFLOW`
- `ENGINEERING_ARTIFACTS`
- `ENGINEERING_QUALITY`

Related:

- `ENGINEERING_MOTION_DESIGN` — conditional motion contract, accessibility and
  review guidance when motion or a model-driven interactive visual simulator is
  in scope.
- `ENGINEERING_STANDARDS`
- `ENGINEERING_TEMPLATES`
- `ENGINEERING_FIELD_GUIDE`

---

## Policy Status and Interpretation

The workflow and evidence requirements in this module are mandatory when the
project has a web or visual interface. The numeric budgets are baseline LF
starting points and may be changed only with a documented project decision,
measured baseline, owner and review date.

PageSpeed and Lighthouse scores are scores from a model, not percentages or a
guarantee of user experience. The literal requirement “above 90” maps to a
minimum median score of `91`; `95` is the engineering target. Mobile and
desktop are separate profiles and must never be collapsed into one score.

A high automated score does not certify accessibility, SEO, Core Web Vitals or
production readiness. Missing field data means insufficient evidence, not
approval.

---

## Experience Targets

| Dimension | Baseline policy | Interpretation |
| --- | --- | --- |
| Performance score | Median `>= 91` per critical route and profile; target `>= 95` | Run mobile and desktop independently. |
| LCP | p75 `<= 2.5 s` when field data is sufficient | Segment by mobile and desktop; use lab LCP for diagnosis. |
| INP | p75 `<= 200 ms` when field data is sufficient | Measure real interactions; do not infer INP from TBT. |
| CLS | p75 `<= 0.1` when field data is sufficient | Check initial load, scroll and interaction. |
| Accessibility | Automated target `100` plus manual review | A score is not a complete WCAG conformance claim. |
| Best Practices | Target `100`; explain exceptions | Version the tool used. |
| SEO | Target `100` for public, indexable routes when applicable | Private or intentionally non-indexable routes may be exempt. |

The protocol in `protocols/PERFORMANCE_VALIDATION.md` defines how these
targets become evidence and acceptance decisions. The LF baseline convention is
five valid comparable runs per critical route and profile, summarized by median;
it is not a statistical guarantee and does not authorize selecting the best run.
The Lighthouse model, weights and curves can change; record the tool/model
version and do not treat a score as a permanent or universal guarantee.

---

## Design Contract

Before implementation, the project must identify:

- critical routes and representative templates;
- target users, devices, viewport sizes and relevant network conditions;
- the primary content and action for each first screen;
- a candidate LCP element for mobile and desktop;
- important loading, empty, success, error, validation, restricted and
  high-volume states;
- asset, font, third-party and data-loading budgets;
- accessibility and reduced-motion expectations;
- a motion-design contract when animation or other intentional motion is in
  scope, following `ENGINEERING_MOTION_DESIGN`;
- accepted exceptions, owner, mitigation and review date.

Design decisions should prioritize the visual hierarchy and useful initial
content before decorative effects. Content and actions must remain meaningful
when media, animation or data is delayed. The route measured must represent the
real product experience: a simple home page cannot approve a dashboard,
checkout, search, catalog or data-heavy workflow that was not measured.

---

## Visual Direction and Recommendation Governance

The Design System Analyst may document a direction proposal without visual
references only when the user or Product Owner explicitly requests one for a
visual product. This is an optional proposal, not an automatic workflow step.
Skip the artifact when neither references nor an explicit proposal request exist.

For a proposal:

- use the approved `PRD.md`, `PROJECT_BRIEF.md`, product constraints and known
  user needs as its basis; ask the Product Owner for missing context instead of
  inferring an audience or need from an industry label;
- label the direction and every unconfirmed choice `Proposed`, state its basis,
  rationale, trade-offs and approval status, and keep it separate from
  observations about supplied references;
- do not present heuristics, catalog matches or design conventions as user
  research, user preference, usability validation or evidence of demand;
- select only recommendations relevant to the product's actual tasks, content,
  routes, documented stack and constraints. Treat a weak or missing match as
  `Unverified` and ask for clarification rather than inventing certainty;
- keep accessibility, responsive behavior, performance and functional
  requirements as gates; a visual preference cannot override them.

For an existing design system, preserve its approved tokens and documentation as
the source of truth. Do not create a competing token set or replace the system
all at once. `DESIGN.md` may summarize the approved project baseline; record a
page-specific override only when needed, with its page scope, base token or rule,
rationale and approval. An unapproved proposal or override must not be treated as
the implementation baseline.

No external catalog, CLI, dependency or copied recommendation set is required by
this workflow.

---

## Responsive Mobile and Desktop Rules

- Start with the smallest relevant viewport and expand the composition.
- Choose breakpoints when content requires a structural change, not only by
  device names.
- Test real content, long text, translations, zoom, reflow and narrow widths.
- Avoid fixed widths and rigid heights that overflow or cut messages.
- Use CSS layout primitives before JavaScript measurement; use JavaScript only
  when the interaction requires it.
- Do not maintain separate complete mobile and desktop trees without measured
  product or technical justification.
- Do not assume hidden desktop media will not download on mobile.
- Keep fixed headers, banners and overlays from covering focus, messages,
  anchors or essential actions.
- Confirm both initial navigation and internal transitions for applications
  whose performance differs after the first load.

---

## Asset, Typography and Stability Rules

For images and illustrations:

- provide variants for rendered width and pixel density using `srcset` and
  `sizes` where appropriate;
- use `picture` when formats or crops change;
- evaluate AVIF/WebP for photographs and SVG for suitable vectors;
- reserve dimensions with width/height or a stable aspect ratio;
- make the LCP resource discoverable early, avoid lazy loading the critical
  hero and use high priority only when justified;
- lazy-load content below the first screen after reserving its space;
- document purpose, variants, dimensions, crop, focal point, loading strategy,
  alt text and transferred size for every critical asset.

For fonts:

- prefer WOFF2 and only preload genuinely critical fonts;
- preserve required characters, including accents;
- select `font-display` intentionally;
- test fallback metrics, title/button wrapping and empty-cache behavior.

For layout stability:

- reserve space for images, embeds, consent banners, async content and fonts;
- validate CLS after load, during scroll and during interaction;
- keep form errors, focus, toasts and chart containers predictable.

---

## Interaction, Media and Accessibility Rules

- Prefer `transform` and `opacity` for motion after measurement; investigate
  blur, large shadows, filters, `will-change` and long tasks.
- Provide a reduced-motion variant without removing focus or functionality.
- Do not require hover for essential actions.
- Give video, maps, chat, carousels and complex charts a static or textual
  first state and load the expensive service by need or user intent.
- Do not preload every resource or assign high priority indiscriminately.
- Separate visual feedback from completion of the underlying operation.
- Preserve native semantics, visible focus, logical keyboard order, accessible
  names, labels, zoom, reflow and useful alternatives for charts and images.
- Check contrast in normal, focus, selected, error and theme states. Do not
  reduce contrast, touch target size or legibility to improve a score.

For large volumes, test empty, typical, high-volume, long-text, API-error and
slow-network data. Pagination, cancellation of stale filter requests,
virtualization, aggregation and staged dashboard loading are decisions to
measure, not automatic prescriptions.

---

## Architecture and Delivery Expectations

The Software Architect must document, when applicable:

- rendering strategy per route (SSG, SSR, CSR or combination);
- JavaScript and CSS splitting, dependency cost and main-thread work;
- asset pipeline, compression and responsive variants;
- network redirects and dependency chains;
- server response and API timing;
- TTFB as a diagnostic for the initial server response;
- cache boundaries for versioned assets, HTML and private data;
- third-party owners and activation timing;
- RUM and field-data collection boundaries.

SSR does not automatically remove hydration cost. CSR does not justify making a
public content route wait for the whole application. Public caching must not
expose personalized data, and `immutable`, preload and preconnect require
versioning or evidence.

---

## Baseline Resource Budgets

These are initial mobile-first budgets for a representative production route
with an empty browser cache. They include third parties that are actually
active and do not replace the total transfer budget with a later deferred cost.

| Resource or metric | Initial baseline |
| --- | ---: |
| Initial mobile transfer | `<= 1000 KiB` |
| Initial JavaScript per route | `<= 170 KiB` |
| Initial CSS | `<= 50 KiB` |
| Initial fonts | `<= 100 KiB` |
| Chosen mobile hero image | `<= 150 KiB` |
| Decorative video in initial load | `0 KiB` |
| Lab LCP target | `<= 2.0 s` |
| Lab CLS target | `<= 0.05` |
| Lab TBT target | `<= 150 ms` |

The subtotals do not necessarily sum to the total. Desktop also needs resource
control even when its score is high. Complex products may define route-specific
budgets, but the exception must preserve the experience target and be revisited
after the baseline changes.

---

## Agent Handoffs

| Agent | Required contribution |
| --- | --- |
| Product Owner | Critical routes, audience, device profiles, experience targets and accepted exceptions in `PRD.md`. |
| Design System Analyst | When active for reference analysis or an explicit initial-direction request, document responsive composition, states, asset/font contracts, LCP candidates, motion and accessibility notes in `DESIGN.md`. |
| Software Architect | Rendering, bundle, cache, server, API, third-party, observability and budget strategy in `ARCHITECTURE.md`. |
| Sprint Planner | Measurable performance tasks, dependencies, budgets, early baseline and validation work in `docs/SPRINTS.md`. |
| Implementation / selected CLI | Implement approved loading, responsive, semantic and instrumentation strategies; preserve evidence. |
| Code Reviewer | Review performance-sensitive changes, regressions, asset strategy and route coverage against the plan. |
| QA-Security | Execute the performance protocol, manual accessibility review, representative journeys and field-data status. |
| Documentation | Keep targets, exceptions, report and release notes synchronized. |
| Tech Lead | Accept, block or record a justified exception using the evidence from both profiles. |
| Knowledge Extractor | Capture reproducible before/after measurements, trade-offs and future framework recommendations. |

---

## Anti-Patterns

The workflow must reject or explicitly escalate:

- promising a fixed score without measuring the published version;
- testing only the home page or only one device profile;
- shipping a special page or removing functionality for the auditor;
- treating an empty placeholder as delivered content;
- lazy-loading the critical hero;
- loading complete icon, animation or third-party libraries by convenience;
- turning every resource into preload or high priority;
- using a high TBT result as proof of good INP;
- treating missing CrUX data as approval;
- reducing accessibility or functionality to improve a metric.

---

## Related Artifacts and Protocols

- `docs/reference/LF_DESIGN_PERFORMANCE_GUIDE.md` — detailed source guide and rationale.
- `docs/DESIGN.md` — conditional design and performance handoff.
- `docs/ARCHITECTURE.md` — rendering and delivery decisions.
- `docs/SPRINTS.md` — executable performance tasks and budgets.
- `docs/PERFORMANCE_VALIDATION_REPORT.md` — conditional evidence record.
- `protocols/PERFORMANCE_VALIDATION.md` — repeatable validation and acceptance.
- `QA_SECURITY_REPORT.md` — final quality and readiness findings.

---

## Evidence Classification

Agents must classify design statements, targets and measurements as `Observed`,
`Derived`, `Proposed` or `Unverified` and identify their basis. `Observed` is
directly present in supplied references or approved project artifacts;
`Derived` is an inference tied to that evidence and stated assumptions;
`Proposed` identifies a recommendation or hypothesis, with approval recorded
separately; and `Unverified` is unknown, weakly supported or conflicting. A
no-reference direction remains `Proposed` by origin after approval; approval
permits adoption but does not turn it into user evidence or validation.

The baseline budgets and thresholds are adopted LF policies for starting
projects, but project-specific exceptions remain `Proposed` until approved and
measured. A score is evidence for the tested route/profile only; it is not
evidence that the entire application is optimized.

---

## Version History

- `1.2.0` — 2026-11-01: Added a conditional relationship to the motion-design
  module for projects that include animation or other intentional motion.
- `1.1.0` — 2026-10-31: Added optional, explicitly requested visual-direction
  proposals, evidence classification and existing-token/override safeguards.
