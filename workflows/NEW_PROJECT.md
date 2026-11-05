# New Project Workflow

## Purpose

Workflow for starting a new project from the LF Engineering System and preparing it for agent collaboration.

This workflow covers project initialization, planning, implementation readiness, delivery validation and post-delivery knowledge extraction.

## Steps

1. Create the new project directory outside the LF Engineering System repository.
2. Run the native bootstrap with the selected language and adapter; `generic` is
   the default.
3. If a vendor adapter is selected, create or validate its project entrypoint
   and keep LF Engineering System as an external read-only framework.
4. Confirm `LF_ENGINEERING.md` and `AGENTS.md` define project boundaries,
   framework read-only usage and state update rules.
5. Start with Engineering Manager to classify the raw user demand, identify ambiguities and generate `MANAGER_BRIEF`.
6. Use Orchestrator to select the workflow, agents, handoff order and required artifacts from the registry and contracts.
7. Use Prompt Architect to refine initial context and produce `PROJECT_BRIEF.md` when the prompt is raw, ambiguous or incomplete.
8. Use Product Owner to produce or update `docs/PRD.md`. When user evidence
   informs a product decision, reference its scope and limitations in relevant
   PRD sections; do not create a mandatory standalone research artifact.
9. Use Design System Analyst to produce or update `docs/DESIGN.md` when visual references exist or the user/Product Owner explicitly requests an initial direction proposal without references. Keep the two modes and their evidence distinct; otherwise skip this optional step.
10. For web or visual projects, use `knowledge/ENGINEERING_DESIGN_PERFORMANCE.md` to define mobile/desktop profiles, critical routes, LCP candidates, responsive states and initial budgets before architecture is approved.
    When motion or an explicitly requested model-driven interactive visual simulator is in scope, also use `knowledge/ENGINEERING_MOTION_DESIGN.md` for the relevant conditional guidance. Define motion purpose and reduced-motion behavior when applicable; for simulators, define model sources, intended fidelity and validation evidence. This does not add a workflow phase or require animation.
11. Use Software Architect to produce or update `docs/ARCHITECTURE.md`, performance/delivery decisions and ADR recommendations.
12. Use Sprint Planner to produce or update `docs/SPRINTS.md`, `.ai/tasks.md` and measurable performance baseline/validation tasks when applicable.
13. Require a plan containing affected files, acceptance criteria, tests, risks, performance profiles/budgets when applicable and exclusions; ask the user to approve it before implementation starts.
14. Execute implementation inside the project repository only, using a test-first loop where automated tests are supported and an early production-build performance check for web/visual work.
15. Use Code Reviewer to validate implementation correctness, maintainability, regression risk, performance-sensitive changes and architectural alignment.
16. Use QA Security to validate quality, security, consumer-visible behavior, validation evidence and readiness risks; execute `protocols/PERFORMANCE_VALIDATION.md` and create `docs/PERFORMANCE_VALIDATION_REPORT.md` for web/visual projects, including Motion Review when motion is in scope and Interactive Model Review when a model-driven simulator is in scope.
17. Use Documentation to keep `README.md`, `docs/`, `.ai/` and `.ai/state/` synchronized with the implementation and QA outcomes.
18. Use Tech Lead to consolidate evidence, review separate mobile/desktop results and approve, block or redirect delivery.
19. Ask the user to perform manual validation and capture corrections, removals or improvements.
20. Route corrections back to the responsible agent or implementation step when they affect scope, architecture, documentation, quality or delivery risk.
21. After Tech Lead approval and manual validation, use Engineering Knowledge Extractor to produce `PROJECT_KNOWLEDGE.md`.
22. Keep `.ai/workflow.md`, `.ai/handoff.md`, `.ai/decisions.md`, `.ai/tasks.md`, `.ai/artifacts.md` and `.ai/state/` current during execution.

## Agent Sequence

```text
Engineering Manager
  -> Orchestrator
  -> Prompt Architect (conditional)
  -> Product Owner
  -> Design System Analyst (conditional)
  -> Software Architect
  -> Sprint Planner
  -> Plan approval
  -> Implementation / selected CLI
  -> Code Reviewer
  -> QA Security
  -> Documentation
  -> Tech Lead
  -> Engineering Knowledge Extractor
  -> Human review / Framework Maintainer
```

## Conditional Rules

- Prompt Architect is required when the initial context is raw, ambiguous, incomplete or must be preserved as `PROJECT_BRIEF.md`.
- Design System Analyst runs for reference analysis when visual references exist, or for a no-reference initial direction only when the user/Product Owner explicitly requests it for a visual product.
- A requested initial direction is optional, must be labeled `Proposed`, grounded in approved product context and approved before it becomes a baseline. Heuristics are not user evidence.
- `docs/DESIGN.md` is conditional; skip it for non-visual projects and when neither references nor an explicit proposal request exist.
- Load `ENGINEERING_MOTION_DESIGN` when motion is planned or reviewed, or when an explicitly requested model-driven interactive visual simulator is in scope. Otherwise record the conditional skip; do not introduce a library or a new workflow phase.
- Engineering Knowledge Extractor runs after delivery approval. It recommends framework improvements but does not modify the framework.
- The `generic` adapter is sufficient for any compatible AI assistant. Codex,
  Claude Code, Gemini CLI and OpenCode adapters are optional.
- If an upstream artifact is missing, create it first or record the exception in `.ai/decisions.md`.
- Do not modify LF Engineering System while operating inside a client project unless explicitly approved.

## Required Project Files

- `AGENTS.md`
- `LF_ENGINEERING.md`
- `README.md`
- `.ai/workflow.md`
- `.ai/handoff.md`
- `.ai/decisions.md`
- `.ai/tasks.md`
- `.ai/artifacts.md`
- `.ai/state/current-phase.md`
- `.ai/state/current-agent.md`
- `.ai/state/project-summary.md`
- `.ai/state/next-actions.md`
- `.ai/state/risks.md`
- `PROJECT_BRIEF.md`, when applicable
- `docs/PRD.md`
- `docs/DESIGN.md`, when visual references exist or an initial direction is explicitly requested
- `docs/PERFORMANCE_VALIDATION_REPORT.md`, when the project has a web or visual interface
- `docs/ARCHITECTURE.md`
- `docs/SPRINTS.md`
- `docs/ADR.md`
- `PROJECT_KNOWLEDGE.md`, after delivery approval and knowledge extraction
- `CLAUDE.md`, `GEMINI.md` or `opencode.jsonc`, only when the corresponding
  adapter is selected

## Post-Implementation Flow

1. Compare implementation against the approved plan and `docs/SPRINTS.md`.
2. Validate that `PROJECT_BRIEF.md`, `docs/PRD.md`, `docs/ARCHITECTURE.md` and `docs/DESIGN.md` are coherent when present.
3. Review implementation through Code Reviewer.
4. Validate quality and security through QA Security.
5. Synchronize documentation through Documentation.
6. Consolidate delivery evidence through Tech Lead.
7. Request manual validation from the user.
8. Apply approved corrections or removals inside the client project.
9. Generate `PROJECT_KNOWLEDGE.md` through Engineering Knowledge Extractor.
10. Submit framework improvement recommendations for human review.

## Readiness Checklist

- Project purpose is clear.
- Product scope is documented.
- Architecture constraints are documented.
- First sprint or task set is executable.
- Agent handoff state is current.
- The bootstrap copied the selected language template into the project root.
- The selected adapter entrypoint, when any, references or loads LF Engineering
  System as an external read-only framework.
- `AGENTS.md` confirms project boundaries and framework read-only usage.
- Required `.ai/` and `.ai/state/` files exist and contain no unresolved operational `TBD` placeholders.
- Conditional design analysis is either completed or explicitly skipped.
- Conditional performance analysis is either completed for mobile and desktop or explicitly marked not applicable for a non-visual project; the Interactive Model Review is completed or marked not applicable according to simulator scope.
- User approval is captured before implementation.
- Review, QA/Security, documentation and Tech Lead validation are planned; web/visual projects include the performance protocol and report.
- Post-delivery knowledge extraction is planned through `PROJECT_KNOWLEDGE.md`.
