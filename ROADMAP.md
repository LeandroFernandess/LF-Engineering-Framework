# LF Engineering Framework Roadmap

Languages: [EN-US](ROADMAP.md) | [PT-BR](locales/pt-BR/public-docs/ROADMAP.md)

Baseline version: 1.5.0

Status: First public stable release `v1.5.0` published 2026-11-03

---

# Purpose

This roadmap defines the long-term vision for the LF Engineering Framework.

It does not represent fixed deadlines or mandatory releases.

Instead, it documents the intended direction for the evolution of the framework.

The roadmap itself is expected to evolve over time.

---

# Guiding Principle

The LF Engineering Framework evolves only when the improvement increases engineering quality, consistency or maintainability.

New features are added only when they solve real engineering problems.

Simplicity is preferred over unnecessary complexity.

---

# Current Baseline

## Version 1.2.0

Status

Historical baseline; superseded by v1.3.0

Major Deliverables

* LF Engineering Knowledge
* Specialized AI Agents
* Engineering Workflow
* Agent Interaction Map
* Governance Model
* Documentation Standards
* Engineering Framework documentation
* Design System Analyst Agent
* Engineering Knowledge Extractor Agent
* DESIGN.md artifact and schema
* PROJECT_KNOWLEDGE.md artifact and schema
* Design-performance knowledge module and mobile/desktop validation protocol
* Conditional `PERFORMANCE_VALIDATION_REPORT.md` artifact and schema

---

# Distribution Tranche

## Version 1.3.0

Status

Published stable release

Primary Objective

Deliver a vendor-neutral, multilingual and CLI-compatible distribution while
refining the engineering ecosystem from real-world project feedback.

Included in the published release

* Vendor-neutral `generic` bootstrap default.
* Native macOS/Linux shell and Windows PowerShell bootstraps.
* Explicit `en-US`/`pt-BR` project-template selection.
* Optional Codex, Claude, Gemini and OpenCode adapters, with `generic` as default.
* Copy-missing-only adoption with Framework boundary protection.
* Native validators, bootstrap tests and three-OS GitHub Actions workflow.
* Structural PT-BR project-template parity checks.
* Canonical agent and stable Knowledge PT-BR translations with structural parity
  checks.

Release gates completed before publication

* Confirmed native Windows execution and successful Ubuntu/macOS/Windows GitHub
  Actions validation.
* Published and verified the authenticated GitHub repository release for
  `v1.3.0` with archives and checksums.

## Version 1.4.0 — predecessor private repository

The stable `v1.4.0` release was published in the predecessor private repository
after its exact tagged commit passed
Ubuntu/macOS/Windows validation and packaging. The automated publish job failed
because it lacked a Git checkout; the verified Actions artifact was published
manually with owner authorization. The `v1.3.0` tag and artifacts remain
unchanged. The release includes the opt-in
technical-debt audit, optional visual-direction guidance, conditional AI/API
quality checks, harness- and model-neutral agent specifications, and a
Framework-side GitHub MCP configuration that remains disabled by default,
corrections to translation coverage and Windows validation, and refreshed
Graphify identity/provenance evidence; its optional-reference approval does not
authorize further tool installation or integration. It now also includes conditional
motion-design guidance and review evidence for visual projects that use motion;
GSAP and procedural 3D workflows remain optional and no tool is installed by
default. Active public overview, roadmap,
changelog and ADR records now have PT-BR mirrors; all four supplemental
Knowledge modules are now approved optional references with PT-BR mirrors,
checked separately for version parity, approved-optional status and structural
parity. They do
not affect the mandatory dependency graph, and their approval does not authorize
external-tool installation or integration. One archive continues to carry both
language packs. None of this changes the published `v1.3.0` release or the
vendor-neutral `generic` bootstrap default. A checkout and local tag verification
fix for future automatic publications is recorded as unreleased maintenance in
`CHANGELOG.md`. Its Git tag and release assets were not migrated into this public
repository.

## Version 1.5.0 — first public release

The first public release is a clean snapshot on `main`. It includes the four
follow-up changes since the predecessor repository's `v1.4.0`, the default Git
ignore rule for client `.ai/state/`, updated release archive naming, and the
public security-reporting channels. The predecessor's history, branches, tags and
assets were intentionally not imported.

Future improvements

* Refine Knowledge modules.
* Improve Agent collaboration.
* Improve engineering documentation.
* Expand engineering governance.
* Improve prompt engineering methodology.
* Strengthen quality guidelines.
* Expand performance budgets and field validation from project evidence.
* Apply extracted knowledge from completed projects.

---

# Future Evolution

## Version 2.x

Possible initiatives

* Engineering templates.
* Reusable engineering checklists.
* Project bootstrap workflows.
* Standard engineering reports.
* Better project onboarding.

Only initiatives that provide measurable engineering value should be incorporated.

---

# Long-Term Vision

Future possibilities include:

* Local execution workflows.
* AI orchestration.
* Engineering dashboard.
* Framework automation.
* Public documentation website.
* Broader community contributions.

These ideas are exploratory and should only be pursued if aligned with the framework philosophy.

---

# What Will Not Be Added

The LF Engineering Framework intentionally avoids unnecessary complexity.

Examples include:

* Features without practical value.
* Duplicate documentation.
* Agents with overlapping responsibilities.
* Unnecessary abstractions.
* Tool-specific dependencies.

The framework should remain modular, understandable and maintainable.

---

# Evolution Principles

Every future improvement should satisfy at least one of the following:

* Improve software quality.
* Improve engineering consistency.
* Improve maintainability.
* Improve documentation.
* Improve developer experience.
* Improve AI collaboration.

## Distribution acceptance

The `v1.3.0` distribution was accepted after native Windows execution,
canonical-library translation parity, clean bootstrap evidence, authenticated
repository/Actions access and release archives/checksums were confirmed.

If an improvement satisfies none of these goals, it should not become part of the framework.

---

# Closing Statement

The LF Engineering Framework is intended to evolve gradually through practical experience.

Its success is measured by the quality of the engineering process it enables, not by the number of features it contains.
