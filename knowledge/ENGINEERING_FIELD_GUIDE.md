# Engineering Field Guide

Version: 0.2.0
Status: Draft
Category: Decision

---

# Purpose

This module provides practical engineering guidance for situations where multiple valid approaches exist or where the Framework does not explicitly define a solution.

Its objective is to promote consistent engineering judgment while preserving the principles of the LF Engineering Framework.

---

# Scope

Defines:

- Practical engineering guidance
- Decision heuristics
- Ambiguous scenarios
- Engineering trade-offs
- Exception handling

---

# Consumers

Primary:

- Software Architect Agent
- Code Reviewer Agent
- QA & Security Agent
- Tech Lead Agent

Secondary:

- Product Owner Agent
- Prompt Architect Agent

---

# Dependencies

Required:

- ENGINEERING_FOUNDATIONS
- ENGINEERING_DECISIONS
- ENGINEERING_STANDARDS

Related:

- ENGINEERING_QUALITY

---

# Source

Derived From:

LF Engineering Framework 1.3.0; post-tag maintenance

Sections:

- Engineering Philosophy
- Engineering Decisions
- Best Practices

---

# Responsibilities

This module provides engineering guidance for situations where explicit rules are insufficient.

---

# Engineering Heuristics

When multiple valid solutions exist:

- Prefer simplicity.
- Prefer maintainability.
- Prefer consistency.
- Prefer explicitness.
- Prefer long-term evolution.

---

# Ambiguous Requirements

If requirements are incomplete:

- Request clarification whenever possible.
- Explicitly state assumptions.
- Avoid implementing hidden business rules.

---

# Technical Debt

Technical debt may be accepted only when:

- Explicitly documented.
- Intentionally approved.
- Clearly understood.
- Planned for future resolution.

---

# Trade-offs

Every trade-off should evaluate:

- Benefits
- Risks
- Complexity
- Long-term impact
- Maintainability

---

# API Integrations

Use this checklist only when a solution includes an API integration; it does not
imply that a project should add an API or external provider.

- Confirm the provider's authoritative documentation, supported API version,
  lifecycle/deprecation status and contract assumptions.
- Define authentication, secret storage/rotation and least-privilege scopes;
  enforce authorization for each resource and tenant where applicable.
- Set explicit timeouts and bounded retry/backoff behavior. Use idempotency for
  retryable writes, and account for rate limits, pagination and partial failure.
- Validate and minimize exchanged data. For webhooks, verify authenticity and
  protect against replay where supported.
- Define behavior for provider errors, outages, version changes and recovery;
  avoid exposing credentials or sensitive payloads in logs.
- Choose proportionate contract, sandbox or representative tests and preserve
  evidence of consequential external actions and their approvals.

For read-only integrations, do not impose confirmation for each request. For
consequential writes or other external side effects, follow the approval and
authorization controls in `ENGINEERING_QUALITY`.

---

# Escalation

Escalate when:

- Architecture changes significantly.
- Security is uncertain.
- Business goals conflict.
- Multiple strategic directions exist.

---

# Best Practices

- Prefer clarity.
- Think long-term.
- Document assumptions.
- Avoid unnecessary complexity.
- Respect existing architecture.

---

# Anti-Patterns

Avoid:

- Hidden assumptions.
- Premature optimization.
- Framework violations.
- Unnecessary rewrites.
- Large changes without justification.

---

# Decision Matrix

| Situation | Recommended Action |
|-----------|--------------------|
| Missing information | Request clarification |
| Multiple good solutions | Present trade-offs |
| Architecture conflict | Escalate |
| Technical debt | Document |
| Framework conflict | Follow the Framework |

---

# Related Modules

ENGINEERING_DECISIONS

ENGINEERING_STANDARDS

ENGINEERING_QUALITY

---

# Versioning

Version: 0.2.0

Status: Draft

Derived From:

LF Engineering Framework 1.3.0; post-tag maintenance

---

## Version History

- `0.2.0` — 2026-11-01: Added a conditional API-integration checklist tied to
  authorization, provider failure and external-side-effect guidance.
