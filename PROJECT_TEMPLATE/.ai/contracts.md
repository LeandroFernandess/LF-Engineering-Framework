# Artifact Contracts

Version: 1.3.1

Status: Stable

---

## Purpose

This file defines required dependencies between project artifacts. Agents must consult it before creating, updating or validating artifacts.

The goal is to keep project work traceable from the original prompt through final governance.

---

## Dependency Chain

| Artifact Or Activity | Depends On | Reason |
| --- | --- | --- |
| `PROJECT_BRIEF.md` | Original prompt | The brief must preserve the user's initial intent, constraints and assumptions. |
| `PRD.md` | `PROJECT_BRIEF.md` | Product requirements must derive from structured project context. |
| `DESIGN.md` | Visual references for analysis, or an explicit user/Product Owner request for an initial direction; approved `PRD.md` or `PROJECT_BRIEF.md` product context | Conditional for visual products. Without references, create only the optional, explicitly requested proposal; label it `Proposed`, separate it from observations and require approval before adoption. Skip when neither references nor a proposal request exist. |
| `ARCHITECTURE.md` | `PRD.md`, `DESIGN.md` (when available) | Technical design must satisfy approved product requirements and, when applicable, documented design specifications. |
| `SPRINTS.md` | `ARCHITECTURE.md` | Execution planning must be based on approved technical architecture. |
| Implementation | `SPRINTS.md` | Code changes must follow approved sprint scope and acceptance criteria. |
| Code Review | Implementation | Review must evaluate actual code changes and implementation evidence. |
| `PERFORMANCE_VALIDATION_REPORT.md` | `PRD.md`, `DESIGN.md` (when applicable), `ARCHITECTURE.md`, `SPRINTS.md`, implementation and Code Review | Conditional web/interface validation must use approved routes, budgets, production evidence and separate mobile/desktop profiles; include a Motion Review when motion is in scope and an Interactive Model Review when a model-driven simulator is in scope. |
| `QA_SECURITY_REPORT.md` | Implementation and Code Review | Quality and security validation must consider both the changed system and review findings. |
| Tech Lead | Final reports | Governance must consolidate review, QA/security and documentation evidence before approval. |
| `PROJECT_KNOWLEDGE.md` | All project artifacts | Knowledge extraction requires complete project context. Runs after delivery approval. |

---

## Optional Artifacts and Workflows

| Artifact | Depends On | Reason |
| --- | --- | --- |
| Optional `docs/TECH_DEBT_AUDIT.md` | Explicit audit request or approved maintenance scope, repository baseline and available evidence | A separate read-only audit is created only when requested; it is not a default dependency or delivery gate. |

## Enforcement Rules

- Do not skip an upstream artifact without recording the reason in `.ai/decisions.md`.
- If a dependency is missing, either create the missing artifact first or pause and request confirmation.
- If an artifact changes, re-check downstream artifacts that depend on it.
- Keep `.ai/artifacts.md` updated when dependencies are created, updated, reviewed or invalidated.
- Keep `.ai/handoff.md` updated when responsibility moves to the next agent.
- Do not create the optional technical debt report unless its audit workflow is
  explicitly invoked.
- Do not treat an unapproved visual-direction proposal or page override as the
  accepted design baseline or as evidence of user preference.

---

## Final Report Inputs

The Tech Lead should treat the following as final report inputs when available:

- Implementation summary
- `DESIGN.md` (when applicable)
- `PERFORMANCE_VALIDATION_REPORT.md` (when a web or visual interface exists)
- `REVIEW.md`
- `QA_SECURITY_REPORT.md`
- `docs/TECH_DEBT_AUDIT.md`, when an optional audit was requested
- Documentation audit
- Updated `.ai/artifacts.md`
- Updated `.ai/decisions.md`

## Post-Delivery

After Tech Lead approval, the Engineering Knowledge Extractor Agent may be invoked to produce `PROJECT_KNOWLEDGE.md`. This artifact is not a delivery gate but feeds into Framework evolution through human review.
