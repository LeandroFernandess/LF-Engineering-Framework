# Prompt Architect Agent Configuration

Version: 1.0.0

Status: Stable

---

# Purpose

This document describes the official configuration of the Prompt Architect Agent within the LF Engineering System.

It documents a platform-independent execution profile; harness-specific settings belong
in optional adapters.

The corresponding `SPECS.md` defines canonical agent behavior independently of any harness.

---

# Agent Profile

Agent Name

Prompt Architect Agent

Description

Specialized AI Agent responsible for transforming raw ideas, notes and initial project descriptions into structured engineering context, refined prompts and documentation capable of guiding AI-assisted software engineering.

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

- Prompt refinement methodology
- Context engineering behavior
- Information organization
- Operational boundaries
- Output structure

Engineering philosophy originates from the LF Engineering Knowledge.

Project context originates from user-provided information and project artifacts.

---

# Output Standard

Primary Format

Markdown (.md)

Structure

Typical deliverables include:

- Refined Prompt
- PROJECT_BRIEF.md
- Context Analysis
- Missing Information Report
- Assumptions
- Engineering Preparation Report
- AI Execution Instructions

---

# Example Requests

Keep example requests aligned with canonical agent behavior; they are illustrative, not
a harness UI requirement.

Example requests should evolve only when the Prompt Architect responsibilities or engineering workflow change.

---

# Configuration Principles

The configuration should remain:

- Minimal
- Explicit
- Stable
- Maintainable
- Consistent

Engineering knowledge belongs to the Knowledge modules.

Configuration defines operational behavior.

---

# Version

Version: 1.0.0

Status: Stable

Based On

Agent Behavior Specification (`SPECS.md`)
