# Artefatos de engenharia

Versão: 0.6.0
Status: Rascunho
Responsável: Leandro Fernandes
Derivado de: LF Engineering Framework 1.3.0; manutenção pós-tag

---

# Objetivo

Este módulo define os artefatos canônicos do projeto, seus responsáveis,
dependências e requisitos de evidência. Ele impede que documentos paralelos se
tornem fontes concorrentes da verdade.

---

# Cadeia canônica de artefatos

```text
Prompt original
  -> PROJECT_BRIEF.md
  -> docs/PRD.md
  -> docs/DESIGN.md (quando houver referências ou solicitação explícita de direção inicial)
  -> docs/ARCHITECTURE.md
  -> docs/SPRINTS.md
  -> implementação e testes
  -> REVIEW.md
  -> docs/PERFORMANCE_VALIDATION_REPORT.md (quando houver interface web ou visual)
  -> QA_SECURITY_REPORT.md
  -> auditoria de documentação
  -> decisão do Tech Lead
  -> PROJECT_KNOWLEDGE.md
```

Cada artefato tem um responsável autorizado. Artefatos downstream podem
referenciar decisões upstream, mas não devem redefini-las silenciosamente.

---

# Responsabilidade pelos artefatos

| Artefato | Responsável | Condição necessária |
| --- | --- | --- |
| `PROJECT_BRIEF.md` | Prompt Architect | Demanda bruta ou incompleta, ou quando o contexto precisa ser preservado |
| `docs/PRD.md` | Product Owner | Toda mudança planejada de produto |
| `docs/DESIGN.md` | Design System Analyst | Existem referências visuais ou o usuário/Product Owner solicita explicitamente uma proposta de direção inicial para um produto visual |
| `docs/ARCHITECTURE.md` | Software Architect | A implementação técnica está sendo planejada |
| `docs/SPRINTS.md` | Sprint Planner | A implementação está sendo planejada |
| Código e testes | Implementation / selected CLI | Existe uma sprint aprovada |
| `REVIEW.md` | Code Reviewer | Existem mudanças de código |
| `docs/PERFORMANCE_VALIDATION_REPORT.md` | QA-Security | Existe interface web ou visual e evidência de implementação |
| `docs/TECH_DEBT_AUDIT.md` | QA-Security | Auditoria solicitada explicitamente ou parte de manutenção aprovada; nunca é criado por padrão |
| `QA_SECURITY_REPORT.md` | QA-Security | Existem evidências de revisão e implementação |
| Auditoria de documentação | Documentation | A documentação precisa ser sincronizada |
| `docs/ADR.md` | Architect / Tech Lead | Existem decisões de arquitetura, escopo ou risco de entrega |
| `PROJECT_KNOWLEDGE.md` | Knowledge Extractor | A entrega foi aprovada |

---

# Artefato opcional de auditoria

`docs/TECH_DEBT_AUDIT.md` é um relatório separado e condicional, produzido
somente por meio de `workflows/TECH_DEBT_AUDIT.md`. Ele não faz parte da cadeia
canônica de artefatos nem é um gate de entrega. O relatório é somente leitura:
achados aprovados podem ser convertidos em trabalho planejado após priorização
do Tech Lead.

---

# Regras de artefatos

1. Consulte `.ai/contracts.md` antes de criar, atualizar ou validar um artefato.
2. Registre entradas upstream ausentes ou dispensas intencionais em
   `.ai/decisions.md`.
3. Atualize `.ai/artifacts.md` quando um artefato for criado, alterado,
   invalidado ou aprovado.
4. Reavalie os artefatos downstream após uma mudança upstream.
5. Todo plano nomeia arquivos esperados, testes, critérios de aceite e
   exclusões conhecidas.
6. Todo relatório de validação nomeia as evidências usadas, o escopo coberto e
   os achados não resolvidos.
7. Um template fornece estrutura; não justifica inventar fatos desconhecidos do
   projeto.
8. Uma proposta de direção sem referências deve ser identificada como `Proposed`
   e aprovada antes de se tornar baseline de implementação; preserve as fontes
   aprovadas de tokens.

---

# Classes de evidência

Use rótulos explícitos ao reportar:

- `Observed`: verificado no repositório, no sistema em execução ou na referência
  fornecida.
- `Derived`: raciocinado a partir de evidência observada e premissas declaradas.
- `Proposed`: recomendação ainda não validada.
- `Unverified`: afirmação que exige confirmação do usuário, repositório ou
  runtime.

Os agentes não devem apresentar conteúdo proposto ou não verificado como fato
observado do projeto.

---

# Módulos relacionados

ENGINEERING_WORKFLOW

ENGINEERING_DECISIONS

ENGINEERING_QUALITY

ENGINEERING_TEMPLATES

ENGINEERING_AGENT_GUIDELINES

ENGINEERING_CONTINUOUS_IMPROVEMENT

ENGINEERING_DESIGN_PERFORMANCE

ENGINEERING_MOTION_DESIGN (condicional quando houver movimento ou simulador visual interativo orientado por modelo no escopo)

---

# Histórico de versões

- `0.6.0` — 2026-11-01: Vinculados requisitos condicionais de motion design aos
  artefatos DESIGN, PRD e relatório de validação.
- `0.5.0` — 2026-10-31: Esclarecida a condição de criação do DESIGN.md para
  propostas de direção sem referências solicitadas explicitamente e adicionadas
  salvaguardas de aprovação/evidência.
