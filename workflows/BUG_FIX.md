# Bug Fix Workflow

## Purpose

Workflow for diagnosing, correcting and validating defects without expanding scope unnecessarily.

## Steps

1. Reproduce or describe the defect with observable evidence.
2. Identify expected behavior, actual behavior and affected users.
3. Locate the probable root cause.
4. Define the smallest coherent fix.
5. Update tests or validation steps.
6. Review code impact and regression risk.
7. Record the decision and validation result in `.ai/`.

## Agent Focus

- Product Owner clarifies user impact when behavior is ambiguous.
- Software Architect validates architectural impact for non-trivial fixes.
- Code Reviewer checks correctness, maintainability and regression risk.
- QA Security validates reproduction, test coverage and security implications.
- Tech Lead approves the delivery decision when the fix has meaningful risk.
