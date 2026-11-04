# Protocolo de handoff entre agentes

## Objetivo

Definir como um agente transfere contexto, decisões, questões abertas e próximas
ações para outro agente.

## Quando usar

Use este protocolo sempre que o trabalho passar de um agente para outro, quando
um agente parar antes da conclusão ou quando a responsabilidade mudar dentro de
um projeto.

## Formato obrigatório

```markdown
## Handoff

- Data:
- Agente de origem:
- Agente de destino:
- Workflow:
- Fase atual:
- Resumo:
- Trabalho concluído:
- Trabalho pendente:
- Decisões:
- Riscos:
- Próximas ações necessárias:
- Artefatos relacionados:
```

## Campos obrigatórios

- Data
- Agente de origem
- Agente de destino
- Fase atual
- Resumo
- Próximas ações necessárias
- Artefatos relacionados

## Exemplo preenchido

```markdown
## Handoff

- Data: 2026-06-30
- Agente de origem: Product Owner
- Agente de destino: Software Architect
- Workflow: STANDARD_DEVELOPMENT
- Fase atual: Definição do produto concluída
- Resumo: O escopo do PRD está pronto para o design técnico.
- Trabalho concluído: MVP, requisitos e critérios de aceite elaborados.
- Trabalho pendente: Design da arquitetura e avaliação dos riscos técnicos.
- Decisões: O MVP exclui integração de pagamentos.
- Riscos: Os requisitos de autenticação ainda são amplos.
- Próximas ações necessárias: Produzir `docs/ARCHITECTURE.md` e identificar
  candidatos a ADR.
- Artefatos relacionados: `docs/PRD.md`, `.ai/decisions.md`
```

## Regras de atualização

- Atualize `.ai/handoff.md` antes de o próximo agente começar.
- Atualize `.ai/state/current-agent.md` com o agente que recebe o trabalho.
- Atualize `.ai/state/current-phase.md` com a próxima fase.
- Referencie os artefatos relacionados em vez de copiar documentos completos.

## O agente não deve

- Ocultar premissas não resolvidas.
- Transferir a responsabilidade sem nomear a próxima ação necessária.
- Duplicar documentos inteiros do Framework nos arquivos do projeto.
- Modificar arquivos do LF-ENGINEERING-SYSTEM ao operar em um projeto cliente.
