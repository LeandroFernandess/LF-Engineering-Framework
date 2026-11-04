# Decision Record Protocol

## Objective

Define how agents record project decisions that affect scope, architecture, quality, risk or delivery.

## When To Use

Use this protocol when accepting a trade-off, changing scope, choosing a technical direction, approving risk, or rejecting an alternative.

## Required Format

```markdown
## Decision Record

- Date:
- Decision:
- Owner:
- Status:
- Context:
- Alternatives:
- Consequences:
- Related Artifacts:
- Follow-Up:
```

## Required Fields

- Date
- Decision
- Owner
- Status
- Context
- Consequences
- Related Artifacts

## Filled Example

```markdown
## Decision Record

- Date: 2026-06-30
- Decision: Use server-side session validation for the MVP.
- Owner: Software Architect
- Status: Accepted
- Context: MVP requires authenticated dashboard access.
- Alternatives: Stateless JWT only, third-party auth provider.
- Consequences: Simpler revocation model, requires session storage.
- Related Artifacts: `docs/ARCHITECTURE.md`, `docs/ADR.md`
- Follow-Up: Tech Lead to approve operational implications.
```

## Update Rules

- Update `.ai/decisions.md` for every meaningful decision.
- Update `docs/ADR.md` when the decision is architectural or long-lived.
- Update `.ai/state/risks.md` if the decision accepts risk.
- Link to affected artifacts and tasks.

## Agent Must Not

- Make irreversible decisions without recording consequences.
- Bury high-risk decisions in prose only.
- Override user constraints without confirmation.
- Modify LF-ENGINEERING-SYSTEM files when operating in a client project.
