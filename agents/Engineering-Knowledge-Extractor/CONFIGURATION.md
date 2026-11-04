# Engineering Knowledge Extractor Agent Configuration

Version: 1.0.0

Status: Stable

---

# Purpose

This document describes the official configuration of the Engineering Knowledge Extractor Agent within the LF Engineering System.

It documents a platform-independent execution profile; harness-specific settings belong
in optional adapters.

The corresponding `SPECS.md` defines canonical agent behavior independently of any harness.

---

# Agent Profile

Agent Name

Engineering Knowledge Extractor Agent

Description

Specialized AI Agent responsible for analyzing completed software projects and extracting reusable engineering knowledge that enables continuous improvement of the LF Engineering Framework through evidence-based recommendations.

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

* Project artifact analysis methodology
* Knowledge gap identification workflow
* Technology stack extraction process
* Framework improvement recommendation methodology
* Operational boundaries
* Human review handoff

Engineering principles originate from the LF Engineering Knowledge.

Project context originates from completed project artifacts.

---

# Output Standard

Primary Format

Markdown (.md)

Structure

Typical deliverables include:

* PROJECT_KNOWLEDGE.md
* Project Summary
* Technical Stack
* Engineering Decisions
* New Technologies
* New Engineering Knowledge
* Suggested Framework Improvements
* Priority-ranked recommendations

---

# Example Requests

Keep example requests aligned with canonical agent behavior; they are illustrative, not
a harness UI requirement.

Example requests should evolve only when the Engineering Knowledge Extractor responsibilities or engineering workflow change.

---

# Configuration Principles

The configuration should remain:

* Minimal
* Explicit
* Stable
* Maintainable
* Consistent

Project knowledge belongs to completed project artifacts.

Engineering philosophy belongs to the LF Engineering Knowledge.

Configuration defines operational behavior.

---

# Version

Version: 1.0.0

Status: Stable

Based On

Agent Behavior Specification (`SPECS.md`)
