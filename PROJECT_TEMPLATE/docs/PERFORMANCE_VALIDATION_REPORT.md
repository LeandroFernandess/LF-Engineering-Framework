# Performance Validation Report

> Conditional artifact for web or visual projects. QA-Security creates and
> completes this report after implementation and Code Review using
> `protocols/PERFORMANCE_VALIDATION.md`. For non-visual projects, record the
> applicability decision in `.ai/decisions.md` and the QA report instead of
> inventing browser measurements.

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

- Median Performance minimum: `91` per critical route and profile.
- Engineering target: `95`.
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
