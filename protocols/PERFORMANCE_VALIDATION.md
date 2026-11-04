# Performance Validation Protocol

## Objective

Define a repeatable, evidence-based performance and responsive-experience gate
for projects with web or visual interfaces. The protocol validates mobile and
desktop independently while preserving accessibility, functionality and visual
identity.

## When To Use

Use this protocol when a project has a web UI, public site, authenticated
interface, dashboard, checkout, catalog, search, form or other visual route.
For non-visual systems, record `Not applicable` and identify the inspected
surface instead of inventing browser measurements.

## Owners and Handoffs

- Design System Analyst: design contract, responsive states and LCP candidates.
- Software Architect: runtime, rendering, delivery and budget strategy.
- Sprint Planner: executable measurement and remediation tasks.
- Implementation / selected CLI: implementation and repeatable test setup.
- Code Reviewer: regression and route-coverage review.
- QA-Security: execution, evidence, accessibility review and report owner.
- Tech Lead: acceptance, block or documented exception.

## Required Inputs

- Approved `docs/PRD.md` with critical routes and experience requirements.
- `docs/DESIGN.md` when available (reference analysis or an explicitly requested initial direction); it is not required when no references or proposal request exist.
- Approved `docs/ARCHITECTURE.md` with rendering and delivery decisions.
- `docs/SPRINTS.md` with performance tasks and acceptance criteria.
- Production build and representative data.
- Controlled measurement tool/version, such as Lighthouse or PageSpeed
  Insights, recorded in the report.
- When motion is in scope, an approved motion contract or product acceptance
  criteria in `docs/DESIGN.md` or `docs/PRD.md`, plus relevant implementation
  constraints from `docs/ARCHITECTURE.md`.

If an input is missing, record the limitation and do not mark the related gate
complete without an approved exception.

## Route and Profile Selection

Select the home page plus one representative route for every critical template,
such as product, content, search, form, dashboard or checkout. Include
authenticated routes with a test session; never publish private screens merely
to make them visible to PageSpeed Insights.

For every selected route, run both profiles:

| Profile | Required context |
| --- | --- |
| Mobile | Viewport, CPU/network throttling, device emulation or real device and region when available. |
| Desktop | Viewport, CPU/network conditions, device or environment and region when available. |

Do not combine profiles, routes, tool versions or materially different network
conditions as if they were comparable.

## Preparation

1. Use the published production build or an equivalent production build.
2. Record commit/build, URL or route, UTC date, tool version, browser version,
   profile, region, cache state, throttling, extensions and test data.
3. Confirm that resources are intact and that the tested route contains real,
   representative content and active third parties.
4. Identify and record the candidate LCP element separately for mobile and
   desktop.
5. Measure initial navigation and, when applicable, internal navigation,
   scrolling, filtering, forms, large data sets and error/retry states.

## Execution

1. Perform five valid runs for every selected route and profile under comparable
   conditions. Five runs are the LF baseline convention, not a statistical
   guarantee.
2. Preserve all valid runs, including slow runs. Invalidate only tool failures
   or unusable captures, with a reason in the report.
3. Record Performance score, LCP, FCP, Speed Index, TBT, CLS and the LCP
   element for each run. Record TTFB as a server-response diagnostic and
   interaction evidence and INP when available.
4. Calculate and report the median per route/profile; never select the best run.
5. Investigate meaningful dispersion, including server response, redirects,
   third parties, CPU contention and variable resources.
6. Repeat after changes that can affect performance. Do not repeat until a
   convenient score appears.

## Acceptance Gate

For each critical route and each profile:

- [ ] Median Performance score is `>= 91`; target `>= 95` is reported separately.
- [ ] No valid run below `90` remains without investigation and a recorded
      owner, mitigation, risk and decision.
- [ ] Resource budgets are met or an approved, traceable exception exists.
- [ ] Candidate LCP and critical content are confirmed without artificial delay.
- [ ] Responsive images, fonts, loading order and network waterfall are reviewed.
- [ ] Layout remains stable with async content, long text, zoom and slow data.
- [ ] Critical journeys respond acceptably; INP is not inferred from TBT.
- [ ] Manual keyboard, focus, contrast, zoom, reflow, form and reduced-motion
      review is complete.
- [ ] The conditional Motion Review is complete when motion is in scope, or
      explicitly marked not applicable with the inspected scope.
- [ ] Third parties are tested in the scenario where they are actually active.
- [ ] Field status is explicit: approved with sufficient data, or pending
      sampling with a monitoring owner and follow-up date.

Performance, accessibility, Best Practices and SEO results must be reported as
separate dimensions. Automated scores do not replace manual accessibility
review or product-functional validation.

## Motion Review

When animation, transitions, micro-interactions, scroll-linked effects or
animated visual assets are in scope, include a Motion Review in
`docs/PERFORMANCE_VALIDATION_REPORT.md`. It must record representative routes
and states, the approved purpose and behavior, normal and reduced-motion
results, keyboard/touch access, responsive differences, evidence and unresolved
risks. Use a recording or equivalent time-based evidence when still images do
not show the behavior. Measure performance when the effect is identified as a
risk; do not invent a universal frame-rate target or treat a source-level check
as proof of smoothness.

If no motion is in scope, record `Not applicable` and the inspected surface.
Motion review does not replace the separate mobile/desktop performance,
accessibility or functional acceptance gates.

Lab metric summaries in the results table must be labeled as lab medians (or
another explicitly stated summary). Field Core Web Vitals must be reported as
p75 values with their source, scope, rolling period and sample sufficiency; do
not substitute lab medians for field p75.

## Field Evidence

When CrUX or RUM is available, record whether the result covers the URL or the
origin, its rolling period, sample sufficiency and mobile/desktop segment. CrUX
field data may reflect a moving 28-day window. Absence of data is
`Insufficient evidence`, not `Approved`.

For authenticated areas, use Lighthouse with a test session and project-owned
RUM. Do not expose private data to a public audit service.

## Required Report

Create `docs/PERFORMANCE_VALIDATION_REPORT.md` when applicable. It must include:

```markdown
# Performance Validation Report

## Scope
- Routes/templates:
- Public or authenticated:
- Critical journeys:
- Mobile profile:
- Desktop profile:

## Build and Environment
- Commit/build:
- Date (UTC):
- Tool and version:
- Browser and version:
- Cache/network/CPU conditions:
- Region:
- Representative data and active third parties:

## Targets and Budgets
- Median Performance minimum: 91
- Engineering target: 95
- Route-specific budgets and approved exceptions:

## Results
<!-- Unless labeled otherwise, metric values in this table are lab medians across the valid runs. -->
| Route | Profile | Valid runs | Scores (each valid run) | Median score | LCP | INP | CLS | TBT | TTFB | FCP | Speed Index | LCP element | Decision |
|---|---|---:|---|---:|---:|---:|---:|---:|---:|---:|---:|---|---|

## Journey and Accessibility Review
- Initial navigation:
- Internal navigation:
- Scroll/filter/form/high-volume/error states:
- Keyboard and focus:
- Contrast, zoom and reflow:
- Reduced motion:

## Motion Review
- Applicability and inspected scope:
- Routes, states and user journeys:
- Purpose and approved behavior:
- Normal-motion result:
- Reduced-motion result:
- Keyboard/touch and interruption behavior:
- Mobile/desktop differences:
- Visual or time-based evidence:
- Findings, owner and follow-up:

## Field Data
- RUM/CrUX scope:
- Period and sample:
- URL or origin:
- Mobile status:
- Desktop status:

| Route | Profile | LCP p75 | INP p75 | CLS p75 | Source/scope | Period/sample |
|---|---|---:|---:|---:|---|---|

## Findings and Exceptions
| ID | Severity | Evidence | Impact | Owner | Mitigation | Review date |
|---|---|---|---|---|---|---|

## Decision
- Status: Approved / Approved with recommendations / Needs adjustment / Blocked
- Responsible:
- Follow-up:
```

## Anti-Gaming Rules

- Do not remove real functionality, content or third parties only for the test.
- Do not serve a special experience to the auditor.
- Do not use an empty skeleton or placeholder as successful content.
- Do not hide mobile or desktop media and assume it has no transfer cost.
- Do not preload or prioritize every resource.
- Do not claim application-wide approval from one route or one profile.

## Related Protocols

- `protocols/ARTIFACT_UPDATE.md`
- `protocols/DECISION_RECORD.md`
- `protocols/TASK_UPDATE.md`
- `protocols/WORKFLOW_UPDATE.md`
