# LF Engineering Agents

Version: 1.0.0

Status: Stable

---

# Purpose

The `agents/` directory contains the official documentation for every AI Agent that is part of the LF Engineering System.

These documents are independent of any specific AI platform and serve as the authoritative reference for configuring, maintaining and evolving specialized engineering agents.

Agents may be implemented in any compatible harness or CLI; platform-specific setup belongs in optional adapters.

The documentation itself remains platform-independent.

---

# Architecture

The LF Engineering System is organized into three complementary layers:

```text
LF Engineering Framework
            │
            ▼
LF Engineering Knowledge
            │
            ▼
LF Engineering Agents
```

Each layer has a distinct responsibility.

The Framework defines engineering philosophy.

The Knowledge structures engineering knowledge.

The Agents apply that knowledge through specialized responsibilities.

---

# Directory Structure

Each agent follows exactly the same structure.

```text
Agent/

├── SPECS.md
├── README.md
├── CONTEXT.md
├── KNOWLEDGE.md
├── CONFIGURATION.md
└── CHANGELOG.md
```

This structure must remain consistent across all Agents.

---

# File Responsibilities

## SPECS.md

Platform-independent behavior specification for the agent.

Defines the agent's canonical behavior without prescribing a harness or runtime.

Update this document when canonical behavior changes and record the change in the agent
changelog.

---

## README.md

Defines the identity of the Agent.

Answers:

* Who is this Agent?
* What is its mission?
* What are its responsibilities?

---

## CONTEXT.md

Defines how the Agent operates inside the LF Engineering System.

Answers:

* When should this Agent be used?
* Which inputs are required?
* Which outputs are expected?
* Which decisions can it make?

---

## KNOWLEDGE.md

Defines which Knowledge modules are consumed by the Agent.

The Agent never owns engineering knowledge.

It consumes the official Knowledge published by the LF Engineering System.

---

## CONFIGURATION.md

Documents platform-independent execution requirements for the agent.

Explains:

* Capability and tool requirements
* Optional runtime capabilities
* Configuration rationale
* Output expectations

This document supports implementations across compatible harnesses and CLIs.

---

## CHANGELOG.md

Records the evolution of the Agent.

Documents:

* Improvements
* Configuration changes
* Knowledge updates
* Version history

---

# Engineering Principles

Every Agent must:

* Respect the LF Engineering Framework.
* Consume the official Knowledge modules.
* Operate only within its specialization.
* Produce deterministic and structured outputs.
* Preserve engineering consistency.

---

# Agent Lifecycle

Every Agent follows the same lifecycle.

```text
Design

↓

Configuration

↓

Documentation

↓

Knowledge Integration

↓

Validation

↓

Release

↓

Continuous Improvement
```

---

# Adding a New Agent

Every new Agent should follow these steps:

1. Define its specialization.
2. Define the agent's canonical behavior.
3. Document the canonical behavior specification.
4. Create the documentation files.
5. Map the required Knowledge modules.
6. Validate consistency with the Framework.
7. Publish the first stable version.

---

# Relationship with Knowledge

Agents never duplicate engineering knowledge.

Knowledge remains centralized inside the `knowledge/` directory.

Each Agent only declares which modules it consumes.

This architecture minimizes duplication and simplifies future maintenance.

---

# Versioning

Agents evolve independently.

Every significant change should be documented in the corresponding CHANGELOG.md.

Keep documentation aligned with canonical agent behavior; record platform-specific
integration only in optional adapters.

---

# Final Statement

The `agents/` directory is the operational layer of the LF Engineering System.

It transforms engineering knowledge into specialized AI behavior while preserving consistency, maintainability and long-term evolution across the entire ecosystem.
