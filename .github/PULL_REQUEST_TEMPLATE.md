## Summary

<!-- What problem does this change solve? -->

## Scope

- [ ] Core Framework
- [ ] Project template
- [ ] Bootstrap script
- [ ] CLI adapter
- [ ] Translation or locale metadata
- [ ] Documentation/governance

## Validation

- [ ] `./scripts/validate-framework.sh`
- [ ] `./scripts/test-bootstrap.sh`
- [ ] Python security-inspector regression suite when relevant
- [ ] PowerShell validation when the change affects `*.ps1`
- [ ] Bootstrap local-state permission tests when bootstrap behavior changes
- [ ] Translation parity validation when locale files changed

## Safety and compatibility

- [ ] Existing project files are not overwritten.
- [ ] No secrets, local state or generated caches are included.
- [ ] Architecture or delivery-risk decisions are recorded in `docs/ADR.md`.
- [ ] Deferred work and known limitations are documented.
