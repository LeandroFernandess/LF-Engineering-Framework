# Sprint Planner Agent Configuration

Version: 1.1.0

Status: Stable

---

# Purpose

This document describes the official configuration of the Sprint Planner Agent within the LF Engineering System.

It documents a platform-independent execution profile; harness-specific settings belong
in optional adapters.

The corresponding `SPECS.md` defines canonical agent behavior independently of any harness.

---

# Agent Profile

Agent Name

Sprint Planner Agent

Description

Specialized AI Agent responsible for transforming approved software architectures into structured, executable Sprint plans by organizing backlog items, identifying dependencies and producing implementation-ready Sprint documentation.

---

# Harness-Neutral Requirements

The Framework does not prescribe a model, vendor, interface or CLI. The consuming
environment must follow the canonical behavior in `SPECS.md`, provide the assigned
modules listed in `KNOWLEDGE.md`, and respect project permissions. Platform-specific
entrypoints, prompt wrappers, tool syntax and permission configuration belong in
optional adapters.

## Optional Capabilities

- External research: Not required by default; use only when explicitly requested or
  needed to resolve a documented evidence gap.
- Structured data analysis: Not required by default; implementation and execution remain
  with authorized tools and designated workflows.

---

# Knowledge Source

Primary

LF Engineering Knowledge

Secondary

Project Artifacts

Reference

SPECS.md

---

# Instruction Strategy

The agent instructions should define:

* Sprint planning methodology
* Backlog decomposition process
* Dependency management
* Scope control
* Operational boundaries

Engineering philosophy originates from the LF Engineering Knowledge.

Project planning originates from approved engineering artifacts.

---

# Output Standard

Primary Format

Markdown (.md)

Structure

Typical deliverables include:

* SPRINT-01.md
* SPRINT-02.md
* Sprint Planning Report
* Sprint Backlog
* Dependency Analysis
* Sprint Roadmap
* Execution Checklist
* Sprint Risk Assessment

---

# Example Requests

Keep example requests aligned with canonical agent behavior; they are illustrative, not
a harness UI requirement.

Example requests should evolve only when Sprint planning responsibilities or engineering workflow change.

---

# Configuration Principles

The configuration should remain:

* Explicit
* Stable
* Predictable
* Maintainable
* Consistent

Engineering knowledge belongs to the Knowledge modules.

Configuration defines planning behavior.

---

# Version

Version: 1.1.0

Status: Stable

Based On

Agent Behavior Specification (`SPECS.md`)
