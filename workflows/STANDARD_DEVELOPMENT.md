# Standard Development Workflow

## Purpose

Default workflow for transforming an idea into a reviewed, documented and delivery-ready software change.

## Agent Sequence

1. Engineering Manager classifies the demand and records ambiguity, constraints and risk.
2. Orchestrator selects the workflow, agents and artifact handoffs.
3. Prompt Architect refines the initial context when needed.
4. Product Owner defines product scope, requirements and observable acceptance
   criteria. When user evidence informs a product decision, reference its scope
   and limitations in relevant PRD sections; do not create a mandatory
   standalone research artifact.
5. Design System Analyst analyzes supplied visual references or, only when explicitly requested by the user/Product Owner, proposes an initial direction without references and records it in `DESIGN.md` as `Proposed` pending approval. Skip when neither condition applies.
6. For web or visual projects, use `knowledge/ENGINEERING_DESIGN_PERFORMANCE.md` to define critical routes, mobile/desktop profiles, responsive states, LCP candidates and experience targets. Product Owner owns the product requirements; Design System Analyst contributes to `DESIGN.md` when references exist or an initial direction was explicitly requested.
   When motion is in scope, use `knowledge/ENGINEERING_MOTION_DESIGN.md` to document purpose, reduced-motion behavior and acceptance evidence without prescribing an implementation library.
7. Software Architect designs the technical solution, rendering/delivery strategy and performance budgets, and records relevant trade-offs.
8. Sprint Planner breaks the work into executable tasks, affected files, tests, performance baselines, budgets and exclusions.
9. The user or designated approver approves the plan before implementation.
10. Implementation is performed by the project team or coding agent using test-first validation where supported and an early production-build performance baseline when applicable.
11. Code Reviewer validates maintainability, correctness, regression risk, performance-sensitive changes and plan alignment.
12. QA Security validates quality, consumer-visible behavior, risks, security and evidence; for web/visual projects it executes `protocols/PERFORMANCE_VALIDATION.md` and produces `docs/PERFORMANCE_VALIDATION_REPORT.md`, including Motion Review when motion is in scope.
13. Documentation records product, technical and performance artifacts and synchronizes them with review and QA outcomes.
14. Tech Lead makes final engineering decisions and delivery assessment using separate mobile and desktop evidence when applicable.
15. Engineering Knowledge Extractor analyzes the completed project and produces PROJECT_KNOWLEDGE.md.

## Required Project Files

- `.ai/workflow.md`
- `.ai/handoff.md`
- `.ai/decisions.md`
- `.ai/tasks.md`
- `.ai/artifacts.md`
- `docs/PRD.md`
- `docs/DESIGN.md` (when visual references exist or an initial direction is explicitly requested)
- `docs/PERFORMANCE_VALIDATION_REPORT.md` (when a web or visual interface exists)
- `docs/ARCHITECTURE.md`
- `docs/SPRINTS.md`
- `docs/ADR.md`

## Operating Rules

- Consult `knowledge/INDEX.md` before loading specific knowledge modules.
- Keep agent outputs concise, traceable and linked to project artifacts.
- Require each non-trivial plan to identify affected files, tests, acceptance criteria, risks and explicit non-goals.
- For web or visual projects, require route/profile coverage, production-build evidence, performance budgets and a separate mobile/desktop acceptance decision.
- Treat unknown or unverified claims as open questions, not completed work.
- Update `.ai/` communication files whenever work changes scope, decisions, tasks or handoff state.
- Do not bypass review, QA or Tech Lead validation for delivery decisions.
- Do not treat one route, one device profile, a best-of-five run or missing field data as application-wide performance approval.
