# LF Engineering Knowledge

Version: 0.1.0<br>
Status: Draft<br>
Owner: Leandro Fernandes

---

# Purpose

The LF Engineering Knowledge is the official AI-oriented knowledge layer of the LF Engineering System.

Its purpose is to transform the concepts, principles, standards and processes defined in the LF Engineering Framework into structured, modular and reusable knowledge optimized for AI Agents.

The Framework remains the single source of truth.

The Knowledge never replaces the Framework.

Instead, it reorganizes and structures its content for efficient AI consumption.

---

# Philosophy

The Framework teaches.

The Knowledge instructs.

The Agents execute.

---

# Objectives

The LF Engineering Knowledge has five primary objectives:

- Standardize the knowledge consumed by AI Agents.
- Ensure consistency across all engineering decisions.
- Eliminate duplicated instructions between agents.
- Simplify maintenance of AI knowledge.
- Keep every agent aligned with the LF Engineering Framework.

---

# Architecture

The LF Engineering Knowledge is organized into independent modules.

Each module represents a single engineering domain.

Every module has one responsibility and may be consumed by one or more AI Agents.

No module should duplicate knowledge from another module.

The Framework is always the authoritative source.

---

# Knowledge Flow

```text
LF Engineering Framework
            │
            ▼
LF Engineering Knowledge
            │
            ▼
AI Engineering Agents
            │
            ▼
Project Deliverables
```

---

# Design Principles

Every knowledge module must follow these principles:

## Single Responsibility

Each module must address only one engineering domain.

---

## No Duplication

Knowledge should exist in only one module.

Other modules must reference it instead of duplicating it.

---

## Structured Information

Modules prioritize structured information over long explanations.

Knowledge should be optimized for retrieval.

---

## Consistency

Every module must follow the same template and writing style.

---

## Modularity

Modules must be independent whenever possible.

AI Agents should consume only the modules required for their responsibilities.

---

# Module Lifecycle

Every module follows the same lifecycle:

1. Created
2. Reviewed
3. Approved
4. Published
5. Updated
6. Deprecated (when applicable)

---

# Source of Truth

The LF Engineering Framework is the only official source of engineering knowledge.

Knowledge modules are derived from the Framework.

No engineering decision should originate exclusively inside the Knowledge.

---

# Agent Consumption

AI Agents should consume only the modules required for their specialization.

This minimizes context overload and improves response quality.

The required modules for each agent are documented inside the `agents/` directory.

---

# Versioning

Knowledge modules evolve independently from the Framework.

Every significant update must include:

- Version increment
- Changelog
- Updated date
- Reference to the originating Framework version

---

# Contribution Guidelines

Before modifying any module:

- Verify the corresponding Framework section.
- Check related modules.
- Avoid duplicated information.
- Preserve consistency.
- Update the Version History when applicable.

---

# Directory Structure

```text
knowledge/

├── INDEX.md
├── README.md
├── ENGINEERING_FOUNDATIONS.md
├── ENGINEERING_WORKFLOW.md
├── ENGINEERING_ARTIFACTS.md
├── ENGINEERING_DECISIONS.md
├── ENGINEERING_STANDARDS.md
├── ENGINEERING_QUALITY.md
├── ENGINEERING_MOTION_DESIGN.md
├── ENGINEERING_AI_COLLABORATION.md
├── ENGINEERING_AGENT_GUIDELINES.md
├── ENGINEERING_TEMPLATES.md
├── ENGINEERING_FIELD_GUIDE.md
├── ENGINEERING_CONTINUOUS_IMPROVEMENT.md
├── ENGINEERING_ELEPHANT_GOLDFISH.md (approved optional supplemental module)
├── ENGINEERING_AGENT_GRAPH_FLOW.md (approved optional supplemental module)
├── ENGINEERING_RTK.md (approved optional supplemental module)
└── ENGINEERING_GRAPHIFY.md (approved optional supplemental module)
```

---

## Approved Optional Supplemental Modules

`ENGINEERING_ELEPHANT_GOLDFISH.md` is approved for optional, task-specific use.
It is not part of the mandatory dependency graph and does not create a universal
design gate or required artifact.

`ENGINEERING_AGENT_GRAPH_FLOW.md` is approved as optional execution and evidence
guidance. It is not part of the mandatory dependency graph. Installing or
integrating `agf` requires separate, specific owner approval.

`ENGINEERING_RTK.md` is approved as optional command-output filtering and
context-optimization guidance. It is not part of the mandatory dependency graph.
Installing or integrating RTK requires separate, specific owner approval.

`ENGINEERING_GRAPHIFY.md` is approved as optional local-first code knowledge
graph and structural-context guidance. It is not part of the mandatory
dependency graph. The documented provenance gap remains unresolved; further
installation or integration requires separate, specific owner approval.

# Final Statement

The LF Engineering Knowledge is not intended to replace engineering judgment.

Its purpose is to provide a consistent, structured and maintainable knowledge layer that enables AI Agents to operate under the same engineering philosophy defined by the LF Engineering Framework.
