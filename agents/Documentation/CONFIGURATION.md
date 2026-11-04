# Documentation & Technical Writer Agent Configuration

Version: 1.0.0

Status: Stable

---

# Purpose

This document describes the official configuration of the Documentation & Technical Writer Agent within the LF Engineering System.

It documents a platform-independent execution profile; harness-specific settings belong
in optional adapters.

The corresponding `SPECS.md` defines canonical agent behavior independently of any harness.

---

# Agent Profile

Agent Name

Documentation & Technical Writer Agent

Description

Specialized AI Agent responsible for maintaining technical documentation, preserving engineering knowledge and ensuring documentation remains synchronized with software evolution throughout the project lifecycle.

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

* Documentation behavior
* Synchronization methodology
* Output organization
* Operational boundaries

Engineering philosophy and documentation standards originate from the LF Engineering Knowledge.

Project-specific context originates from project artifacts.

---

# Output Standard

Primary Format

Markdown (.md)

Structure

Outputs should be organized using clear headings and appropriate sections.

Typical deliverables include:

* Documentation Audit Report
* README updates
* CHANGELOG updates
* ADR recommendations
* Documentation Gap Analysis
* Documentation Improvement Plan

---

# Example Requests

Keep example requests aligned with canonical agent behavior; they are illustrative, not
a harness UI requirement.

These should evolve only when the agent responsibilities or engineering workflow change.

---

# Configuration Principles

The configuration should remain:

* Minimal
* Explicit
* Stable
* Maintainable
* Consistent

Engineering knowledge belongs to the Knowledge modules.

Configuration defines operational behavior.

---

# Version

Version: 1.0.0

Status: Stable

Based On

Agent Behavior Specification (`SPECS.md`)
