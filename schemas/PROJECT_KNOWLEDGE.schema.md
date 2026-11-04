# PROJECT_KNOWLEDGE Schema

## Purpose

Canonical structure for project knowledge extraction documentation produced by the Engineering Knowledge Extractor Agent.

## Required Sections

- Project Summary
  - Project Name
  - Business Objective
  - Problem Solved
  - Scope

- Technical Stack
  - Languages and Runtimes
  - Frameworks
  - Libraries
  - APIs
  - Databases
  - Cloud Services
  - External Integrations
  - Development Tools

- Engineering Decisions
  - Architectural Patterns
  - Folder Organization
  - Design Patterns
  - Key Trade-offs
  - Decision Rationale

- New Technologies
  - Technology Name and Version
  - Purpose in Project
  - Already Documented in Framework? (Yes/No)
  - Documentation Recommendation

- New Engineering Knowledge
  - Knowledge Domain
  - Description
  - Why It Is New
  - Relevance to Framework

- Suggested Framework Improvements
  - Target Module or Agent
  - Recommended Change
  - Rationale
  - Priority (Critical / High / Medium / Low)

- Recommendations Summary
  - Prioritized list of all recommendations

## Validation

- All findings must reference specific project evidence.
- Technologies listed must be present in project artifacts.
- New knowledge must be clearly distinguished from existing Framework knowledge.
- Every recommendation must reference a specific Framework module, Knowledge module or Agent.
- Every recommendation must include a priority level.
- The Framework itself must not be modified by this document.
- Subjective assessments without evidence should not be included.

## Constraints

- This document recommends. It does not prescribe.
- All recommendations require human review before Framework changes.
- This document is read-only with respect to the LF Engineering Framework.
