# Code Reviewer Agent Configuration

Version: 1.0.0

Status: Stable

---

# Purpose

This document describes the official configuration of the Code Reviewer Agent within the LF Engineering System.

It documents a platform-independent execution profile; harness-specific settings belong
in optional adapters.

`SPECS.md` defines canonical agent behavior independently of any harness.

---

# Agent Profile

Agent Name

Code Reviewer Agent

Description

Specialized AI Agent responsible for reviewing software implementations, validating engineering quality and producing structured technical review reports.

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

- Operational behavior
- Review methodology
- Output format
- Scope limitations

Engineering principles must originate from the LF Engineering Knowledge.

Project-specific behavior must originate from project artifacts.

---

# Output Standard

Primary Format

Markdown (.md)

Structure

- Executive Summary
- Findings
- Severity Classification
- Recommendations
- Approval Decision

---

# Example Requests

Keep example requests aligned with canonical agent behavior; they are illustrative, not
a harness UI requirement.

These should evolve only when the agent responsibilities change.

---

# Configuration Principles

Configuration should remain:

- Minimal
- Explicit
- Stable
- Consistent

Knowledge belongs to Knowledge modules.

Configuration defines behavior.

---

# Version

Version: 1.0.0

Status: Stable

Based On

Agent Behavior Specification (`SPECS.md`)
