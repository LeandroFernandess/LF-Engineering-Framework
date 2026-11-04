# Technical Debt Audit Schema

## Purpose

Canonical structure for the optional `docs/TECH_DEBT_AUDIT.md` produced through
`workflows/TECH_DEBT_AUDIT.md`.

## Applicability

- Use only for an explicit audit request or approved maintenance work.
- Do not create this report as a default project artifact or release gate.
- The audit is read-only; implementation requires separately approved work.

## Required Sections

- Audit Context
- Scope and Method
- Summary
- Findings
- Counter-Evidence and Acceptable Cases
- Limitations
- Prioritization and Decision

## Required Finding Fields

Every actionable finding must identify:

- ID and concise title;
- evidence class: `Observed`, `Derived` or `Proposed`;
- category and exact path plus line/range, or a clear artifact reference when
  line numbers do not apply;
- evidence and impact;
- severity (`Critical`, `High`, `Medium` or `Low`);
- confidence (`High`, `Medium` or `Low`);
- estimated effort and the basis for the estimate;
- specific recommendation, proposed owner and verifiable acceptance criteria.

## Validation Rules

- State the inspected baseline, scope, exclusions, method and limitations.
- Distinguish observed facts from inferences and unvalidated proposals.
- Record counter-evidence and intentional or acceptable patterns; do not force a
  finding when the evidence does not support one.
- A no-findings result applies only to the inspected scope.
- Avoid generic advice and do not change code during an audit.
- Record the Tech Lead disposition for each actionable item; only approved
  findings become planned remediation work.
