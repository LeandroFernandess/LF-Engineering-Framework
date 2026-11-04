# Technical Debt Audit Workflow

## Purpose

Provide a scoped, evidence-based review of technical debt without mixing
assessment with implementation.

## Applicability

- Run only when explicitly requested or included in approved maintenance work.
- This workflow is separate from the default development lifecycle and is not a
  required project artifact or release gate.
- QA-Security conducts the audit; Tech Lead evaluates and prioritizes findings.

## Inputs

- Explicit audit request or approved maintenance scope.
- Repository and baseline commit or revision to inspect.
- Available PRD, architecture, sprint and review artifacts, when relevant.
- Constraints, known acceptable trade-offs and areas excluded from review.

## Steps

1. Confirm the audit objective, owner, scope, exclusions, baseline and read-only
   boundary. Ask for clarification when these cannot be established.
2. Inspect relevant project artifacts and source evidence within the agreed
   scope. Record tools, commands and limitations; preserve existing changes and
   do not perform cleanup or edits.
3. Evaluate candidate debt against observed evidence and project context. Do not
   treat age, unfamiliar style, missing documentation or a clean search alone
   as proof of a defect.
4. Record each actionable finding with its evidence class, exact path and
   line/range, impact, severity, confidence, estimated effort, owner,
   recommendation and verifiable acceptance criteria.
5. Record counter-evidence and patterns that appear problematic but are
   intentional or acceptable. State when no actionable findings were identified
   within the inspected scope.
6. Produce `docs/TECH_DEBT_AUDIT.md` using the schema and template. Include
   evidence limitations and do not change code as part of the audit.
7. Hand the report to Tech Lead for prioritization. Convert accepted findings
   into Sprint Planner work only after approval; implementation follows its own
   approved plan and workflow.

## Expected Output

- Optional `docs/TECH_DEBT_AUDIT.md` with scoped findings and evidence.
- Tech Lead decision to accept, defer, reject or request more evidence for each
  actionable finding.
- Sprint tasks only for findings that are explicitly approved for remediation.

## Guardrails

- Do not run this workflow by default or create an empty report just to satisfy a
  checklist.
- Do not modify source files, dependencies, configuration or user data during
  the audit.
- Do not prescribe broad rewrites or generic cleanup without a specific,
  evidence-backed impact.
- A finding is not automatically a defect or a commitment to remediate.
- Do not generalize conclusions beyond the inspected scope and baseline.
