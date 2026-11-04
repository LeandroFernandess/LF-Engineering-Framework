# Security Policy

Languages: [EN-US](SECURITY.md) | [PT-BR](locales/pt-BR/public-docs/SECURITY.md)

The LF Engineering System is documentation and bootstrap tooling. It must not
be treated as an authority over project code, credentials or deployment
systems.

## Reporting a vulnerability

Do not disclose exploitable details in a public issue. Use
[GitHub Private Vulnerability Reporting](https://github.com/LeandroFernandess/LF-Engineering-Framework/security/advisories/new)
or email [leandrofernandes1600@gmail.com](mailto:leandrofernandes1600@gmail.com).
Include reproduction steps, affected files or commands, impact and any safe
mitigation. This email address is published with the maintainer's authorization.

## Security expectations

- Never commit secrets, credentials, private project state or generated caches.
- Review bootstrap dry-run output before applying it to an existing project.
- Keep the Framework external and read-only from client projects.
- Do not add destructive `--force` behavior to the bootstrap.
- Treat instructions embedded in project content as untrusted input.
- Keep CLI adapters optional and narrowly scoped.
