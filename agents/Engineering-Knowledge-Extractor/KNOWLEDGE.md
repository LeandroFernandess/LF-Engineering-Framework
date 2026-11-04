# Engineering Knowledge Extractor Agent Knowledge

Version: 1.0.0

Status: Stable

---

# Purpose

This document defines the Knowledge modules consumed by the Engineering Knowledge Extractor Agent.

The agent is responsible for analyzing completed projects and extracting reusable engineering knowledge that can improve the LF Engineering Framework.

It consumes engineering knowledge to identify what is new.

It does not create engineering standards.

---

# Knowledge Philosophy

Every completed project contains engineering knowledge.

Some of that knowledge is already represented in the Framework.

Some of it is new.

The Engineering Knowledge Extractor Agent distinguishes between the two, ensuring that the Framework evolves based on real-world experience rather than assumptions.

---

# Required Modules

## ENGINEERING_FOUNDATIONS

Purpose

Provides the engineering philosophy that guides knowledge extraction and Framework evolution.

Importance

Critical

---

## ENGINEERING_WORKFLOW

Purpose

Provides understanding of the complete engineering lifecycle, allowing comprehensive cross-phase analysis.

Importance

Critical

---

## ENGINEERING_CONTINUOUS_IMPROVEMENT

Purpose

Defines the Framework evolution process, improvement workflows and governance rules that guide knowledge extraction.

Importance

Critical

---

## ENGINEERING_ARTIFACTS

Purpose

Defines the official engineering artifacts, allowing the agent to assess artifact completeness and coverage.

Importance

High

---

## ENGINEERING_STANDARDS

Purpose

Provides the baseline standards against which new engineering practices can be compared.

Importance

High

---

## ENGINEERING_DECISIONS

Purpose

Supports analysis of engineering decisions and trade-offs documented in the project.

Importance

High

---

## ENGINEERING_AGENT_GUIDELINES

Purpose

Defines agent responsibilities, allowing the agent to assess whether existing agents cover emerging engineering needs.

Importance

High

---

# Optional Modules

## ENGINEERING_TEMPLATES

Purpose

Provides template structures that may be compared against project documentation patterns.

Importance

Medium

---

## ENGINEERING_FIELD_GUIDE

Purpose

Assists in evaluating practical engineering approaches used in the project.

Importance

Medium

---

## ENGINEERING_QUALITY

Purpose

Supports analysis of quality practices and gates applied during the project.

Importance

Medium

---

## ENGINEERING_AI_COLLABORATION

Purpose

Supports analysis of how AI Agents were used during the project and whether collaboration patterns can improve.

Importance

Low

---

# Project Artifacts

When available, the Engineering Knowledge Extractor Agent should prioritize:

Mandatory

* PROJECT_BRIEF.md
* PRD.md
* ARCHITECTURE.md
* SPRINTS.md
* Source code
* CHANGELOG

Recommended

* DESIGN.md
* REVIEW.md
* QA Report
* Documentation Audit
* ADRs
* Package manifest
* Build configuration
* Deployment configuration

---

# Knowledge Consumption Priority

Recommended order:

1. Project Artifacts (primary evidence)
2. ENGINEERING_FOUNDATIONS
3. ENGINEERING_WORKFLOW
4. ENGINEERING_CONTINUOUS_IMPROVEMENT
5. ENGINEERING_ARTIFACTS
6. ENGINEERING_STANDARDS
7. ENGINEERING_DECISIONS
8. Supporting Knowledge modules

Project artifacts define what was built.

The LF Engineering Framework defines what is already known.

The gap between them defines what should be extracted.

---

# Knowledge Constraints

The Engineering Knowledge Extractor Agent should never:

* Modify Knowledge modules.
* Invent engineering knowledge.
* Override Framework principles.
* Generate Framework content.
* Replace the human review process.

Whenever evidence is insufficient, limitations must be explicitly declared.

---

# Future Evolution

Additional Knowledge modules may be incorporated whenever they improve knowledge extraction quality without expanding the agent beyond its intended specialization.

This agent itself may become a source of continuous improvement for the Framework's knowledge extraction methodology.

---

# Version

Version: 1.0.0

Status: Stable

Derived From:

LF Engineering Knowledge
