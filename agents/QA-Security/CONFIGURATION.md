# Quality Assurance & Security Agent Configuration

Version: 1.2.0

Status: Stable

---

# Purpose

This document describes the official configuration of the Quality Assurance & Security Agent within the LF Engineering System.

It documents a platform-independent execution profile; harness-specific settings belong
in optional adapters.

The corresponding `SPECS.md` defines canonical agent behavior independently of any harness.

---

# Agent Profile

Agent Name

Quality Assurance & Security Agent

Description

Specialized AI Agent responsible for performing comprehensive engineering audits focused on software quality, security, performance, observability, accessibility and production readiness before final engineering approval.

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

- Audit methodology
- Quality validation process
- Risk classification
- Production readiness evaluation
- Operational boundaries
- Trust-boundary and prompt-injection validation
- Local-state and generated-artifact privacy checks

Engineering principles originate from the LF Engineering Knowledge.

Project-specific validation originates from project artifacts.

---

# Output Standard

Primary Format

Markdown (.md)

Structure

Typical deliverables include:

- Technical Audit Report
- Security Assessment
- Performance Assessment
- Conditional `PERFORMANCE_VALIDATION_REPORT.md` using the mobile/desktop validation protocol
- Accessibility Assessment
- Observability Assessment
- Risk Matrix
- Production Readiness Decision
- Corrective Prompt
- Applicability matrix for the requested security categories
- Evidence, confidence, limitations and acceptance criteria for every finding

---

# Example Requests

Keep example requests aligned with canonical agent behavior; they are illustrative, not
a harness UI requirement.

Example requests should evolve only when engineering audit responsibilities or workflow change.

---

# Configuration Principles

The configuration should remain:

- Explicit
- Stable
- Traceable
- Maintainable
- Consistent

Engineering knowledge belongs to the Knowledge modules.

Configuration defines audit behavior.

---

# Version

Version: 1.2.0

Status: Stable

Based On

Agent Behavior Specification (`SPECS.md`)
