# Performance Validation Report Schema

## Purpose

Canonical structure for the conditional `docs/PERFORMANCE_VALIDATION_REPORT.md`
produced by QA-Security for web and visual projects.

## Applicability

- Required for projects with public or authenticated visual routes.
- Not applicable for non-visual systems when the skip and inspected scope are
  recorded in `.ai/decisions.md` and the QA report.

## Required Sections

- Scope
- Build and Environment
- Targets and Budgets
- Results for mobile and desktop
- Journey and Accessibility Review
- Motion Review (record `Not applicable` and inspected scope when no motion is in scope)
- Interactive Model Review (conditional for model-driven interactive simulators; otherwise record `Not applicable` and inspected scope)
- Field Data
- Findings and Exceptions
- Decision

## Required Result Fields

Every route/profile result must identify:

- route or template;
- `mobile` or `desktop` profile;
- tool and version;
- five-run validity count or documented exception;
- every valid score and the median score;
- Lab LCP, INP when available, CLS, TBT, TTFB, FCP, Speed Index and LCP
  element;
- cache, network, CPU and data conditions;
- decision and remaining risk.

Field evidence must additionally identify, per route/profile when available:

- LCP p75, INP p75 and CLS p75;
- URL or origin scope;
- rolling period and sample sufficiency;
- RUM or CrUX source and status when data is absent.

When motion is in scope, the Motion Review must additionally identify:

- representative routes, states and user journeys;
- approved purpose and intended behavior;
- normal and reduced-motion results;
- keyboard/touch access and responsive differences;
- visual or time-based evidence, findings, owner and follow-up.

When a model-driven interactive simulator is in scope, the Interactive Model
Review must additionally identify:

- intended use and decision impact, fidelity and limitations;
- important data sources, units, assumptions and evidence classifications;
- independent numerical checks and results;
- consistency between the model state, geometry and displayed values;
- visual or time-based evidence, unresolved discrepancies, owner and follow-up;
- keyboard/touch access, reduced-motion and user-control findings, or a reference
  to the Motion Review when it covers them;
- domain-validation source and reviewer when real-world accuracy is claimed.

## Validation Rules

- Mobile and desktop results are separate.
- Median Performance score must be `>= 91` per critical route/profile unless a
  Tech Lead-approved exception is recorded.
- A valid run below `90` requires investigation and a decision.
- Missing CrUX/RUM data is reported as insufficient evidence.
- Automated accessibility results do not replace manual review.
- A report must distinguish `Observed`, `Derived`, `Proposed` and `Unverified`
  evidence.
- The report must not claim that one route or score proves application-wide
  performance.
