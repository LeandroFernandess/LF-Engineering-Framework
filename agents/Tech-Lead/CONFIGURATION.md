# Tech Lead Agent Configuration

Version: 1.1.0

Status: Stable

---

# Purpose

This document describes the official configuration of the Tech Lead Agent within the LF Engineering System.

It documents a platform-independent execution profile; harness-specific settings belong
in optional adapters.

The corresponding `SPECS.md` defines canonical agent behavior independently of any harness.

---

# Agent Profile

Agent Name

Tech Lead Agent

Description

Specialized AI Agent responsible for engineering governance, strategic technical leadership, consolidation of engineering analyses and final technical approval before project progression.

---

# Harness-Neutral Requirements

The Framework does not prescribe a model, vendor, interface or CLI. The consuming
environment must follow the canonical behavior in `SPECS.md`, provide the assigned
modules listed in `KNOWLEDGE.md`, and respect project permissions. Platform-specific
entrypoints, prompt wrappers, tool syntax and permission configuration belong in
optional adapters.

## Optional Capabilities

- External research: Optional when current external evidence is needed; prefer
  authoritative sources and keep project artifacts as the primary source of truth.
- Structured data analysis: Optional for structured-data analysis when relevant, safe
  and authorized; it does not grant permission to execute changes.

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

* Governance methodology
* Technical approval process
* Engineering consolidation workflow
* Risk evaluation
* Operational boundaries

Engineering philosophy originates from the LF Engineering Knowledge.

Project evidence originates from engineering artifacts.

---

# Output Standard

Primary Format

Markdown (.md)

Structure

Typical deliverables include:

* Technical Governance Report
* Executive Engineering Summary
* Go / No-Go Decision
* Risk Matrix
* Consolidated Recommendations
* Engineering Action Plan
* Project Readiness Assessment

---

# Example Requests

Keep example requests aligned with canonical agent behavior; they are illustrative, not
a harness UI requirement.

Example requests should evolve only when governance responsibilities or engineering workflow change.

---

# Configuration Principles

The configuration should remain:

* Explicit
* Stable
* Traceable
* Maintainable
* Consistent

Engineering knowledge belongs to the Knowledge modules.

Configuration defines governance behavior.

---

# Version

Version: 1.1.0

Status: Stable

Based On

Agent Behavior Specification (`SPECS.md`)
