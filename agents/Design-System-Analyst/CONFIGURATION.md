# Design System Analyst Agent Configuration

Version: 1.2.0

Status: Stable

---

# Purpose

This document describes the official configuration of the Design System Analyst Agent within the LF Engineering System.

It documents a platform-independent execution profile; harness-specific settings belong
in optional adapters.

The corresponding `SPECS.md` defines canonical agent behavior independently of any harness.

---

# Agent Profile

Agent Name

Design System Analyst Agent

Description

Specialized AI Agent responsible for analyzing visual references or, when explicitly requested, proposing an initial visual direction without references, while producing structured engineering-oriented design documentation.

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

* Visual reference analysis methodology
* Design pattern identification workflow
* DESIGN.md generation process
* Design token extraction
* Optional, explicitly requested no-reference proposals and evidence classification
* Operational boundaries

Engineering principles originate from the LF Engineering Knowledge.

Visual context originates from the provided references and project artifacts.

---

# Output Standard

Primary Format

Markdown (.md)

Structure

Typical deliverables include:

* DESIGN.md
* Visual identity documentation
* Color palette specification
* Typography analysis
* Spacing system documentation
* Layout structure documentation
* Component hierarchy catalog
* Interaction pattern documentation
* Design token specification
* Accessibility considerations
* UI Component recommendations
* Frontend implementation considerations
* Conditional design-performance handoff for web and visual projects
* Direction source, evidence classification and approval status

---

# Example Requests

Keep example requests aligned with canonical agent behavior; they are illustrative, not
a harness UI requirement.

Example requests should evolve only when the Design System Analyst responsibilities or engineering workflow change.

---

# Configuration Principles

The configuration should remain:

* Minimal
* Explicit
* Stable
* Maintainable
* Consistent

Reference analysis belongs to the provided references. A no-reference direction
is an optional proposal, not an observation, and requires approval.

Engineering philosophy belongs to the LF Engineering Knowledge.

Configuration defines operational behavior.

---

# Version

Version: 1.2.0

Status: Stable

Based On

Agent Behavior Specification (`SPECS.md`)
