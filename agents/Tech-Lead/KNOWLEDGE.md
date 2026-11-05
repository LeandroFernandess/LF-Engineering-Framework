# Tech Lead Agent Knowledge

Version: 1.3.0

Status: Stable

---

# Purpose

This document defines the Knowledge modules consumed by the Tech Lead Agent.

The agent specializes in engineering governance, strategic decision-making and technical consolidation.

Its responsibility is to evaluate the engineering ecosystem as a whole before approving project progression.

---

# Knowledge Philosophy

Engineering leadership requires systemic thinking.

Every approval should consider the complete engineering context rather than isolated technical findings.

The Tech Lead Agent governs engineering.

It does not replace specialized expertise.

---

# Required Modules

## ENGINEERING_FOUNDATIONS

Importance

Critical

Purpose

Defines the engineering philosophy guiding governance decisions.

---

## ENGINEERING_DECISIONS

Importance

Critical

Purpose

Provides decision-making methodology and engineering trade-off analysis.

---

## ENGINEERING_QUALITY

Importance

Critical

Purpose

Defines engineering quality gates and production readiness criteria.

---

## ENGINEERING_DESIGN_PERFORMANCE

Purpose

Defines mobile/desktop performance acceptance, route coverage, budgets,
accessibility and field-evidence limitations for governance decisions.

Importance

High when the project has a web or visual interface; otherwise conditional.

---

## ENGINEERING_MOTION_DESIGN

Purpose

Defines conditional motion acceptance and evidence expectations, plus simulator
fidelity, model-validation evidence and residual-risk expectations for
governance.

Importance

High when motion or a model-driven interactive simulator is in scope; otherwise
not applicable.

---

## ENGINEERING_WORKFLOW

Importance

Critical

Purpose

Defines the complete engineering lifecycle and governance checkpoints.

---

## ENGINEERING_ARTIFACTS

Importance

High

Purpose

Defines the engineering artifacts evaluated during governance.

---

## ENGINEERING_AGENT_GUIDELINES

Importance

High

Purpose

Defines collaboration with every specialized Agent within the LF Engineering System.

---

# Optional Modules

## ENGINEERING_STANDARDS

Purpose

Supports consistency validation across engineering artifacts.

Importance

Medium

---

## ENGINEERING_CONTINUOUS_IMPROVEMENT

Purpose

Supports long-term engineering evolution.

Importance

Medium

---

## ENGINEERING_FIELD_GUIDE

Purpose

Supports engineering judgment in complex governance scenarios.

Importance

Medium

---

## ENGINEERING_TEMPLATES

Purpose

Supports standardized governance reporting.

Importance

Low

---

# Project Artifacts

Mandatory

* PROJECT_BRIEF.md
* PRD.md
* ARCHITECTURE.md
* `docs/SPRINTS.md`
* REVIEW.md
* QA Report
* Documentation Report
* `PERFORMANCE_VALIDATION_REPORT.md` when a web or visual interface exists

Recommended

* CHANGELOG.md
* Source Code
* Technical Notes
* ADRs
* `docs/TECH_DEBT_AUDIT.md` when an audit was explicitly requested or approved

---

# Knowledge Consumption Priority

1. Engineering Artifacts

2. ENGINEERING_FOUNDATIONS

3. ENGINEERING_DECISIONS

4. ENGINEERING_QUALITY

5. ENGINEERING_WORKFLOW

6. ENGINEERING_DESIGN_PERFORMANCE (when applicable)

7. ENGINEERING_MOTION_DESIGN (when motion or a model-driven interactive simulator is in scope)

8. Supporting Knowledge modules

---

# Knowledge Constraints

The Tech Lead Agent should never:

* Ignore Critical engineering risks.
* Override specialized technical evidence without justification.
* Modify business scope.
* Produce implementation.
* Treat optional technical debt findings as automatic defects or delivery
  blockers; evaluate evidence, impact and priority explicitly.

Whenever governance evidence is insufficient, project progression should be postponed until additional validation is completed.

---

# Future Evolution

The Tech Lead Agent should evolve alongside engineering governance practices while preserving consistency with the LF Engineering Framework.

---

# Version

Version: 1.3.0

Status: Stable

Derived From:

LF Engineering Knowledge
