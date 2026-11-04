# Protocolo de atualização de workflow

## Objetivo

Definir como os agentes atualizam o estado do workflow do projeto durante a
execução assistida por IA, independentemente do CLI ou adapter selecionado.

## Quando usar

Use este protocolo ao selecionar um workflow, mudar de fase, alterar o agente
ativo, pausar o trabalho ou concluir uma etapa do workflow.

## Formato obrigatório

```markdown
## Atualização de workflow

- Data:
- Workflow:
- Fase atual:
- Agente ativo:
- Próximo agente:
- Gatilho:
- Status:
- Notas:
```

## Campos obrigatórios

- Data
- Workflow
- Fase atual
- Agente ativo
- Próximo agente
- Gatilho
- Status

## Exemplo preenchido

```markdown
## Atualização de workflow

- Data: 2026-06-30
- Workflow: BUG_FIX
- Fase atual: Análise da causa-raiz
- Agente ativo: Code Reviewer
- Próximo agente: QA Security
- Gatilho: Defeito reproduzido e correção candidata identificada.
- Status: Em andamento
- Notas: As evidências de validação devem ser adicionadas antes da revisão do
  Tech Lead.
```

## Regras de atualização

- Atualize `.ai/workflow.md` quando o workflow, a fase ou a ordem dos agentes
  mudar.
- Atualize `.ai/state/current-phase.md` após cada transição de fase.
- Atualize `.ai/state/current-agent.md` quando a responsabilidade ativa mudar.
- Atualize `.ai/state/next-actions.md` com a próxima ação concreta.

## O agente não deve

- Alterar o workflow sem registrar o motivo.
- Ignorar etapas obrigatórias de revisão ou validação silenciosamente.
- Marcar uma fase como concluída sem evidência ou handoff.
- Modificar arquivos do LF-ENGINEERING-SYSTEM ao operar em um projeto cliente.
