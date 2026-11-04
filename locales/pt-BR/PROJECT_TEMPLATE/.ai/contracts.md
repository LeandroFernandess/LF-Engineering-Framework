# Contratos de artefatos

Versão: 1.3.1

Status: Estável

---

## Objetivo

Este arquivo define as dependências obrigatórias entre artefatos do projeto.
Agentes devem consultá-lo antes de criar, atualizar ou validar artefatos.

O objetivo é manter o trabalho rastreável desde o prompt original até a
governança final.

## Cadeia de dependências

| Artefato ou atividade | Depende de | Motivo |
| --- | --- | --- |
| `PROJECT_BRIEF.md` | Prompt original | Preserva intenção, restrições e premissas do usuário. |
| `PRD.md` | `PROJECT_BRIEF.md` | Requisitos devem derivar do contexto estruturado. |
| `DESIGN.md` | Referências visuais para análise ou solicitação explícita do usuário/Product Owner por uma direção inicial; contexto aprovado do produto em `PRD.md` ou `PROJECT_BRIEF.md` | Condicional para produtos visuais. Sem referências, crie somente a proposta opcional explicitamente solicitada; identifique-a como `Proposed`, separe-a das observações e exija aprovação antes da adoção. Ignore quando não houver referências nem solicitação de proposta. |
| `ARCHITECTURE.md` | `PRD.md`, `DESIGN.md` (quando existir) | A arquitetura deve atender aos requisitos aprovados. |
| `SPRINTS.md` | `ARCHITECTURE.md` | O plano de execução depende da arquitetura aprovada. |
| Implementação | `SPRINTS.md` | Alterações seguem o escopo e os critérios da sprint. |
| Code Review | Implementação | A revisão avalia mudanças e evidências reais. |
| `PERFORMANCE_VALIDATION_REPORT.md` | Artefatos aprovados, implementação e revisão | Validação web condicional, com perfis mobile/desktop separados; inclua uma Revisão de movimento quando houver movimento no escopo. |
| `QA_SECURITY_REPORT.md` | Implementação e Code Review | QA e segurança consideram o sistema alterado e os achados. |
| Tech Lead | Relatórios finais | Consolida evidências antes da aprovação. |
| `PROJECT_KNOWLEDGE.md` | Todos os artefatos | Extração ocorre após a aprovação da entrega. |

## Artefatos e workflows opcionais

| Artefato | Depende de | Motivo |
| --- | --- | --- |
| `docs/TECH_DEBT_AUDIT.md` opcional | Solicitação explícita de auditoria ou escopo de manutenção aprovado, baseline do repositório e evidências disponíveis | Uma auditoria separada e somente leitura é criada apenas quando solicitada; não é dependência padrão nem gate de entrega. |

## Regras de aplicação

- Não pule um artefato upstream sem registrar o motivo em `.ai/decisions.md`.
- Se uma dependência estiver ausente, crie-a ou pause e peça confirmação.
- Se um artefato mudar, reavalie os artefatos downstream dependentes.
- Mantenha `.ai/artifacts.md` atualizado.
- Mantenha `.ai/handoff.md` atualizado quando a responsabilidade mudar.
- Não crie o relatório opcional de dívida técnica sem invocar explicitamente o
  workflow de auditoria.
- Não trate uma proposta de direção visual ou override de página não aprovado
  como baseline de design aceito nem como evidência de preferência de usuários.

## Entradas do relatório final

Quando disponíveis, o Tech Lead deve considerar:

- resumo da implementação;
- `DESIGN.md`, quando aplicável;
- `PERFORMANCE_VALIDATION_REPORT.md`, em interfaces web ou visuais;
- `REVIEW.md`;
- `QA_SECURITY_REPORT.md`;
- `docs/TECH_DEBT_AUDIT.md`, quando uma auditoria opcional tiver sido solicitada;
- auditoria da documentação;
- `.ai/artifacts.md` e `.ai/decisions.md` atualizados.

## Pós-entrega

Após a aprovação do Tech Lead, o Engineering Knowledge Extractor pode produzir
`PROJECT_KNOWLEDGE.md` para revisão humana e evolução do Framework.
