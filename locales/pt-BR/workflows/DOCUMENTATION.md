# Workflow de documentação

## Objetivo

Workflow para criar ou atualizar documentação de engenharia como um artefato de
projeto de primeira classe.

## Etapas

1. Identifique o público e a decisão apoiada pelo documento.
2. Consulte os artefatos atuais do projeto e `knowledge/INDEX.md`.
3. Atualize o documento relevante em `docs/` ou `.ai/`.
4. Mantenha a documentação factual, atual e rastreável às decisões.
5. Revise contradições em relação ao PRD, arquitetura, ADRs e tarefas da sprint.
6. Em projetos web ou visuais, sincronize
   `docs/PERFORMANCE_VALIDATION_REPORT.md` com as metas de rota/perfil,
   orçamentos, implementação e evidências de QA aprovados. Mantenha dados de
   campo ausentes e exceções explícitos.

## Saídas esperadas

- `docs/PRD.md` atualizado quando o escopo do produto mudar.
- `docs/ARCHITECTURE.md` atualizado quando o design técnico mudar.
- `docs/SPRINTS.md` atualizado quando o planejamento de entrega mudar.
- `docs/ADR.md` atualizado quando uma decisão significativa for tomada.
- `docs/PERFORMANCE_VALIDATION_REPORT.md` atualizado quando um projeto web ou
  visual tiver evidências de performance ou uma exceção aceita.
- `.ai/artifacts.md` atualizado quando saídas geradas ou referências mudarem.
