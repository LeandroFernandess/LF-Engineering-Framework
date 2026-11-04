# Protocolo de atualização de tarefa

## Objetivo

Definir como os agentes criam, atualizam e encerram tarefas executáveis do
projeto.

## Quando usar

Use este protocolo ao adicionar tarefas, alterar status, bloquear trabalho,
concluir trabalho ou dividir uma tarefa.

## Formato obrigatório

```markdown
## Atualização de tarefa

- Data:
- ID da tarefa:
- Título:
- Responsável:
- Status:
- Tipo de mudança:
- Contexto:
- Critérios de aceite:
- Dependências:
- Próxima ação:
```

## Campos obrigatórios

- Data
- ID da tarefa
- Título
- Responsável
- Status
- Tipo de mudança
- Próxima ação

## Exemplo preenchido

```markdown
## Atualização de tarefa

- Data: 2026-06-30
- ID da tarefa: TASK-003
- Título: Adicionar testes de validação de autenticação
- Responsável: QA Security
- Status: Pronta
- Tipo de mudança: Criada
- Contexto: Risco de autenticação identificado durante a revisão arquitetural.
- Critérios de aceite: Casos de credenciais inválidas, token expirado e token
  ausente estão cobertos.
- Dependências: Decisão arquitetural sobre a estratégia de token.
- Próxima ação: Implementar testes de validação após a aprovação do ADR.
```

## Regras de atualização

- Atualize `.ai/tasks.md` sempre que o status da tarefa mudar.
- Atualize `.ai/state/next-actions.md` quando a tarefa afetar a execução imediata.
- Registre bloqueios em `.ai/state/risks.md` quando afetarem entrega ou qualidade.
- Mantenha as entradas de tarefa curtas e rastreáveis aos artefatos.

## O agente não deve

- Criar tarefas vagas sem critérios de aceite.
- Marcar tarefas bloqueadas como concluídas.
- Ocultar dependências ou riscos.
- Modificar arquivos do LF-ENGINEERING-SYSTEM ao operar em um projeto cliente.
