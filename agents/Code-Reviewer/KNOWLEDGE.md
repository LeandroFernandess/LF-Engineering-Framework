# Code Reviewer Agent Knowledge

Version: 1.0.0

Status: Stable

---

# Purpose

This document defines the Knowledge modules consumed by the Code Reviewer Agent.

The agent does not own engineering knowledge.

Instead, it consumes the official Knowledge modules published by the LF Engineering System.

The LF Engineering Framework remains the single source of truth.

---

# Knowledge Philosophy

The Code Reviewer Agent specializes in technical validation.

Its knowledge should focus on:

* Engineering consistency
* Technical correctness
* Quality evaluation
* Architectural alignment

The agent should avoid consuming knowledge outside its specialization unless explicitly required.

---

# Required Modules

## ENGINEERING_FOUNDATIONS

Purpose

Provides the engineering philosophy and global priorities that guide every review.

Importance

Critical

---

## ENGINEERING_DECISIONS

Purpose

Supports engineering judgment when evaluating trade-offs and implementation choices.

Importance

Critical

---

## ENGINEERING_STANDARDS

Purpose

Defines the engineering standards used to evaluate code organization, documentation, modularity and consistency.

Importance

Critical

---

## ENGINEERING_QUALITY

Purpose

Defines Quality Gates, validation criteria and engineering approval requirements.

Importance

Critical

---

## ENGINEERING_AGENT_GUIDELINES

Purpose

Defines how the Code Reviewer Agent operates within the LF Engineering System and collaborates with other specialized agents.

Importance

High

---

# Optional Modules

## ENGINEERING_WORKFLOW

Purpose

Provides workflow awareness to understand the current project stage and validate whether implementation is ready for review.

Importance

Medium

---

## ENGINEERING_ARTIFACTS

Purpose

Helps identify which engineering artifacts should exist and whether they remain synchronized.

Importance

Medium

---

## ENGINEERING_FIELD_GUIDE

Purpose

Supports engineering judgment in ambiguous situations where multiple technically valid solutions exist.

Importance

Medium

---

## ENGINEERING_CONTINUOUS_IMPROVEMENT

Purpose

Provides guidance for identifying recurring issues and opportunities to improve the engineering process.

Importance

Low

---

# Project Artifacts

When available, the Code Reviewer Agent should prioritize the following project artifacts:

Mandatory

* PRD.md
* ARCHITECTURE.md

Recommended

* README.md
* CHANGELOG.md
* Sprint documentation
* ADRs
* Developer notes

---

# Knowledge Consumption Priority

The recommended consumption order is:

1. Project Artifacts
2. ENGINEERING_FOUNDATIONS
3. ENGINEERING_DECISIONS
4. ENGINEERING_STANDARDS
5. ENGINEERING_QUALITY
6. Remaining supporting modules

Project-specific documentation should always take precedence over generic engineering knowledge when no conflict exists.

If a conflict exists, the LF Engineering Framework remains authoritative.

---

# Knowledge Constraints

The Code Reviewer Agent should never:

* Invent engineering standards.
* Override Framework principles.
* Ignore approved project documentation.
* Assume undocumented requirements.

When knowledge is insufficient, the agent should explicitly identify missing information before producing conclusions.

---

# Future Evolution

Additional Knowledge modules may be incorporated as the LF Engineering System evolves.

New modules should only be added when they clearly enhance the Code Reviewer Agent without increasing unnecessary context.

---

# Version

Version: 1.0.0

Status: Stable

Derived From:

LF Engineering Knowledge
