# LF Engineering Knowledge Index

## Purpose

This document is the entry point for the LF Engineering Knowledge.

It provides a structured overview of every knowledge module, their responsibilities, dependencies and consumers.

This document should be consulted before adding, modifying or consuming any knowledge module.

---

# Knowledge Architecture

The LF Engineering Knowledge is organized into independent modules.

Each module represents a specific engineering domain.

Modules should be consumed according to the responsibilities of each AI Agent.

The LF Engineering Framework remains the single source of truth.

Knowledge modules are optimized representations of the Framework intended for AI consumption.

---

# Knowledge Flow

```text
LF Engineering Framework
        ↓
LF Engineering Knowledge
        ↓
AI Engineering Agents
```

---

# Knowledge Modules

| Module                             | Purpose                                        | Primary Consumers                                      |
| ---------------------------------- | ---------------------------------------------- | ------------------------------------------------------ |
| ENGINEERING_FOUNDATIONS            | Engineering philosophy, mission and principles | All Agents                                             |
| ENGINEERING_WORKFLOW               | Development lifecycle and workflow             | All Agents                                             |
| ENGINEERING_ARTIFACTS              | Official engineering artifacts                 | Product Owner, Design System Analyst, Architect, Documentation |
| ENGINEERING_DECISIONS              | Decision-making framework                      | Architect, Tech Lead, Knowledge Extractor              |
| ENGINEERING_STANDARDS              | Coding, architecture and engineering standards | Architect, Design System Analyst, Reviewer, QA, Knowledge Extractor |
| ENGINEERING_QUALITY                | Quality Gates, validation and audits           | QA, Reviewer, Tech Lead, Knowledge Extractor           |
| ENGINEERING_DESIGN_PERFORMANCE     | Responsive design, web performance budgets and mobile/desktop validation | Product Owner, Design System Analyst, Architect, Sprint Planner, QA, Tech Lead |
| ENGINEERING_MOTION_DESIGN          | Technology-independent motion design, accessibility, optional model-driven visual simulations and conditional validation | Product Owner, Design System Analyst, Architect, Sprint Planner, QA, Tech Lead |
| ENGINEERING_AI_COLLABORATION       | Human-AI collaboration model                   | All Agents                                             |
| ENGINEERING_AGENT_GUIDELINES       | Responsibilities and boundaries of each agent  | All Agents                                             |
| ENGINEERING_TEMPLATES              | Official engineering templates                 | Product Owner, Design System Analyst, Architect, Documentation |
| ENGINEERING_FIELD_GUIDE            | Practical engineering guidance                 | Architect, Design System Analyst, Reviewer, Tech Lead, Knowledge Extractor |
| ENGINEERING_CONTINUOUS_IMPROVEMENT | Knowledge evolution process                    | Tech Lead, Knowledge Extractor                         |

---

# Approved Optional Supplemental Modules

These modules are approved optional references. They remain outside the
mandatory dependency graph and are selected only when relevant to a task.
Approval does not authorize installation or activation of external tools.

| Module                         | Purpose                                                        | Intended Consumers |
| ------------------------------ | -------------------------------------------------------------- | ------------------ |
| ENGINEERING_ELEPHANT_GOLDFISH | Design-first AI collaboration, independent comprehension tests and context recovery | Software Architect, Sprint Planner, Code Reviewer, QA, Tech Lead, Documentation |
| ENGINEERING_AGENT_GRAPH_FLOW | Optional graph-based execution tracking, task gates, evidence and cost measurement | Engineering-Manager, Software Architect, Sprint Planner, Implementation / selected CLI, Code Reviewer, QA, Documentation, Tech Lead |
| ENGINEERING_RTK | Optional shell-output filtering, command rewrite, context optimization and token-measurement evaluation | Engineering-Manager, Software Architect, Implementation / selected CLI, Code Reviewer, QA, Documentation, Tech Lead |
| ENGINEERING_GRAPHIFY | Optional local-first code knowledge graph, structural traversal, provenance and adoption-boundary evaluation | Software Architect, Sprint Planner, Implementation / selected CLI, Code Reviewer, QA, Documentation, Tech Lead |

---

# Dependency Graph

ENGINEERING_FOUNDATIONS

↓

ENGINEERING_WORKFLOW

↓

ENGINEERING_ARTIFACTS

↓

ENGINEERING_DECISIONS

↓

ENGINEERING_STANDARDS

↓

ENGINEERING_QUALITY

↓

ENGINEERING_DESIGN_PERFORMANCE (conditional for web and visual projects)

↓

ENGINEERING_AI_COLLABORATION

↓

ENGINEERING_AGENT_GUIDELINES

↓

ENGINEERING_TEMPLATES

↓

ENGINEERING_FIELD_GUIDE

↓

ENGINEERING_CONTINUOUS_IMPROVEMENT

---

# Conditional Module (Outside the Dependency Flow)

`ENGINEERING_MOTION_DESIGN` is loaded only when motion or an explicitly requested
model-driven interactive visual simulator is in scope. It does not add a
dependency to the mandatory Knowledge flow or a workflow phase.

---

# Knowledge Principles

* The Framework is the only source of truth.
* Knowledge modules derive from the Framework.
* Modules should not duplicate information.
* Every module has a single responsibility.
* Knowledge is optimized for AI consumption.
* Human-readable explanations belong to the Framework.

---

# Version

Published Framework Baseline: 1.5.0

Checkout Status: Matches the first public release `v1.5.0`; predecessor private
repository history and earlier release tags were not migrated.

Owner: Leandro Fernandes

Framework: LF Engineering Framework
