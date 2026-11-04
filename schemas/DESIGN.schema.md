# DESIGN Schema

## Purpose

Canonical structure for design system documentation produced by the Design System Analyst Agent.

## Required Sections

- Direction Source and Status
- Baseline and Page-specific Overrides
- Visual Identity
- Color Palette
- Typography
- Spacing System
- Layout Structure
- Grid Analysis
- Component Hierarchy
- Button Patterns
- Form Patterns
- Navigation Structure
- Cards
- Tables
- Icons
- Interaction Patterns
- Hover States
- Focus States
- Animations
- Motion Principles
- Responsiveness Observations
- Accessibility Considerations
- Design Tokens
- Suggested Reusable UI Components
- Design System Recommendations
- Frontend Implementation Considerations
- Design Performance Contract (when the project has a web or visual interface)

## Validation

- State whether `DESIGN.md` documents supplied references or an explicitly requested initial direction proposal.
- Classify design statements as `Observed`, `Derived`, `Proposed` or `Unverified`, identify their basis and keep proposals separate from reference observations.
- A no-reference direction must be explicitly requested, marked `Proposed` and approved before becoming an implementation baseline; heuristics are not evidence of user preference or validation.
- Preserve approved design tokens as the source of truth. Page-specific overrides must be necessary, scoped, justified and approved; do not create a competing token system.
- All colors must include HEX values.
- Typography must define hierarchy levels (H1-H6, body, caption).
- Spacing must follow a consistent scale.
- Components must be described in engineering terms.
- Interaction states (hover, focus, active, disabled) must be documented.
- Design tokens must be structured for developer consumption.
- No implementation code (CSS, HTML, JS) should be present.
- Visual references should not be redesigned or critiqued.
- The Design Performance Contract must identify mobile and desktop routes,
  candidate LCP elements, loading states, asset/font constraints and handoff
  risks when applicable; it must not claim measured performance results.
- Do not create `DESIGN.md` for a project without a visual interface or when no
  visual references and no explicit initial-direction request exist.

## Conditional Sections

Sections may be omitted when the visual reference material does not contain the corresponding pattern:

- Animations (only when present)
- Tables (only when present)
- Cards (only when present)
- Icons (only when present)
- Motion Principles (only when motion is observable)
