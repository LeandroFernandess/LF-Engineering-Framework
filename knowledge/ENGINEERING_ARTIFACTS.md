# Engineering Artifacts

Version: 0.6.0
Status: Draft
Owner: Leandro Fernandes
Derived From: LF Engineering Framework 1.3.0; post-tag maintenance

---

# Purpose

This module defines the canonical project artifacts, their ownership, dependencies and evidence requirements. It prevents parallel documents from becoming competing sources of truth.

---

# Canonical Artifact Chain

```text
Original prompt
  -> PROJECT_BRIEF.md
  -> docs/PRD.md
  -> docs/DESIGN.md (when references exist or an initial direction is explicitly requested)
  -> docs/ARCHITECTURE.md
  -> docs/SPRINTS.md
  -> implementation and tests
  -> REVIEW.md
  -> docs/PERFORMANCE_VALIDATION_REPORT.md (when a web or visual interface exists)
  -> QA_SECURITY_REPORT.md
  -> documentation audit
  -> Tech Lead decision
  -> PROJECT_KNOWLEDGE.md
```

Each artifact has one authoritative owner. Downstream artifacts may reference upstream decisions but must not silently redefine them.

---

# Artifact Ownership

| Artifact | Owner | Required condition |
| --- | --- | --- |
| `PROJECT_BRIEF.md` | Prompt Architect | Raw or incomplete demand, or whenever project context must be preserved |
| `docs/PRD.md` | Product Owner | Every planned product change |
| `docs/DESIGN.md` | Design System Analyst | Visual references exist, or the user/Product Owner explicitly requests an initial direction proposal for a visual product |
| `docs/ARCHITECTURE.md` | Software Architect | Technical implementation is planned |
| `docs/SPRINTS.md` | Sprint Planner | Implementation is planned |
| Code and tests | Implementation / selected CLI | Approved sprint exists |
| `REVIEW.md` | Code Reviewer | Code changes exist |
| `docs/PERFORMANCE_VALIDATION_REPORT.md` | QA-Security | Web or visual interface exists and implementation evidence is available |
| `docs/TECH_DEBT_AUDIT.md` | QA-Security | An audit is explicitly requested or part of approved maintenance; never created by default |
| `QA_SECURITY_REPORT.md` | QA-Security | Review and implementation evidence exist |
| Documentation audit | Documentation | Documentation must be synchronized |
| `docs/ADR.md` | Architect / Tech Lead | Architecture, scope or delivery risk decisions exist |
| `PROJECT_KNOWLEDGE.md` | Knowledge Extractor | Delivery was approved |

---

# Optional Audit Artifact

`docs/TECH_DEBT_AUDIT.md` is a separate, conditional report produced only through
`workflows/TECH_DEBT_AUDIT.md`. It is not part of the canonical artifact chain
or a delivery gate. The report is read-only: approved findings may be converted
into planned work after Tech Lead prioritization.

---

# Artifact Rules

1. Consult `.ai/contracts.md` before creating, updating or validating an artifact.
2. Record missing upstream inputs or intentional skips in `.ai/decisions.md`.
3. Update `.ai/artifacts.md` when an artifact is created, changed, invalidated or approved.
4. Re-check downstream artifacts after an upstream change.
5. Every plan names expected files, tests, acceptance criteria and known exclusions.
6. Every validation report names the evidence used, the scope covered and unresolved findings.
7. A template provides structure; it does not justify inventing unknown project facts.
8. A no-reference direction proposal must be labeled `Proposed` and approved
   before becoming the implementation baseline; preserve approved token sources.

---

# Evidence Classes

Use explicit labels when reporting:

- `Observed`: verified in the repository, running system or supplied reference.
- `Derived`: reasoned from observed evidence and stated assumptions.
- `Proposed`: recommendation not yet validated.
- `Unverified`: claim requiring user, repository or runtime confirmation.

Agents must not present proposed or unverified content as an observed project fact.

---

# Related Modules

ENGINEERING_WORKFLOW
ENGINEERING_DECISIONS
ENGINEERING_QUALITY
ENGINEERING_TEMPLATES
ENGINEERING_AGENT_GUIDELINES
ENGINEERING_CONTINUOUS_IMPROVEMENT
ENGINEERING_DESIGN_PERFORMANCE

ENGINEERING_MOTION_DESIGN (conditional when motion is in scope)

---

# Version History

- `0.6.0` — 2026-11-01: Linked conditional motion-design requirements to the
  DESIGN, PRD and validation-report artifacts.
- `0.5.0` — 2026-10-31: Clarified the conditional DESIGN.md trigger for explicitly
  requested no-reference direction proposals and approval/evidence safeguards.
