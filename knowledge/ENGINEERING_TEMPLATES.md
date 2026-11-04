# Engineering Templates

Version: 0.2.0
Status: Draft<br>
Category: Operational

---

# Purpose

This module defines the official template strategy adopted by the LF Engineering System.

Its objective is to standardize reusable engineering artifacts while ensuring consistency across projects.

Templates accelerate engineering without reducing quality.

---

# Scope

Defines:

- Template philosophy
- Template lifecycle
- Official template categories
- Usage rules
- Ownership

---

# Consumers

Primary:

- Prompt Architect Agent
- Product Owner Agent
- Software Architect Agent
- Sprint Planner Agent
- Documentation Agent

Secondary:

- Tech Lead Agent

---

# Dependencies

Required:

- ENGINEERING_FOUNDATIONS
- ENGINEERING_ARTIFACTS
- ENGINEERING_WORKFLOW

Related:

- ENGINEERING_STANDARDS

---

# Source

Derived From:

LF Engineering Framework 1.3.0; post-tag maintenance

---

## Version History

- `0.2.0` — 2026-11-01: Added the optional technical-debt audit report template
  and clarified that it is not created by default.

Sections:

- Engineering Artifacts
- Workflow
- Documentation Standards

---

# Responsibilities

This module defines:

- Which templates are considered official.
- How templates evolve.
- How templates should be applied.
- Template ownership.

---

# Template Philosophy

Templates exist to:

- Standardize engineering artifacts.
- Reduce repetitive work.
- Preserve consistency.
- Improve maintainability.

Templates should accelerate engineering while remaining adaptable to project context.

---

# Official Template Categories

## Project Templates

Examples:

- Project Brief
- PRD
- Architecture
- Sprint Planning

---

## Documentation Templates

Examples:

- README
- CHANGELOG
- Release Notes
- ADR

---

## Review Templates

Examples:

- Code Review
- QA Report
- Security Review
- Performance Validation Report (conditional for web and visual projects)
- Technical Debt Audit Report (only when explicitly requested or included in
  approved maintenance; not created by default)

---

## Planning Templates

Examples:

- Sprint Planning
- Backlog
- Roadmap

---

## Prompt Templates

Examples:

- Prompt Refinement
- Context Creation
- AI Instructions

---

# Template Rules

Every executable plan template should include:

* objective and user-visible outcome;
* source requirements and assumptions;
* affected files or file-discovery strategy;
* acceptance criteria and validation commands;
* dependencies, risks and explicit non-goals;
* handoff owner and completion evidence.

Unknown values must be marked as open questions or left as intentional empty fields. Templates must not use `TBD` as an operational state that can be mistaken for completed planning.

Rule 01

Official engineering artifacts should use approved templates whenever available.

Type

Mandatory

Priority

High

---

Rule 02

Templates provide structure, not mandatory content.

Type

Mandatory

Priority

High

---

Rule 03

Templates may evolve independently from projects.

Type

Recommended

Priority

Medium

---

Rule 04

Project-specific adaptations are allowed when justified.

Type

Contextual

Priority

Medium

---

# Template Lifecycle

Create

↓

Review

↓

Approve

↓

Publish

↓

Use

↓

Improve

↓

Version

---

# Best Practices

- Keep templates simple.
- Minimize duplicated sections.
- Preserve consistent naming.
- Version important templates.
- Review templates periodically.

---

# Anti-Patterns

Avoid:

- Project-specific templates becoming official.
- Overly complex templates.
- Duplicated templates.
- Outdated templates.
- Mandatory fields without purpose.

---

# Decision Matrix

| Situation | Recommended Action |
|-----------|--------------------|
| New engineering artifact | Use an official template |
| Missing template | Create and validate before adoption |
| Existing template insufficient | Extend while preserving compatibility |
| Template duplicated | Consolidate into one version |
| Significant improvement | Publish new template version |

---

# Related Modules

ENGINEERING_ARTIFACTS

ENGINEERING_STANDARDS

ENGINEERING_WORKFLOW

ENGINEERING_CONTINUOUS_IMPROVEMENT

---

# Versioning

Version: 0.2.0

Status: Draft

Derived From:

LF Engineering Framework 1.3.0; post-tag maintenance
