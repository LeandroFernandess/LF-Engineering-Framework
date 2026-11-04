# Protocolo de registro de decisão

## Objetivo

Definir como os agentes registram decisões de projeto que afetam escopo,
arquitetura, qualidade, risco ou entrega.

## Quando usar

Use este protocolo ao aceitar um trade-off, alterar escopo, escolher uma direção
técnica, aprovar um risco ou rejeitar uma alternativa.

## Formato obrigatório

```markdown
## Registro de decisão

- Data:
- Decisão:
- Responsável:
- Status:
- Contexto:
- Alternativas:
- Consequências:
- Artefatos relacionados:
- Acompanhamento:
```

## Campos obrigatórios

- Data
- Decisão
- Responsável
- Status
- Contexto
- Consequências
- Artefatos relacionados

## Exemplo preenchido

```markdown
## Registro de decisão

- Data: 2026-06-30
- Decisão: Usar validação de sessão no servidor para o MVP.
- Responsável: Software Architect
- Status: Aceita
- Contexto: O MVP exige acesso autenticado ao dashboard.
- Alternativas: Apenas JWT stateless, provedor de autenticação terceirizado.
- Consequências: Modelo de revogação mais simples, mas exige armazenamento de
  sessões.
- Artefatos relacionados: `docs/ARCHITECTURE.md`, `docs/ADR.md`
- Acompanhamento: Tech Lead deve aprovar as implicações operacionais.
```

## Regras de atualização

- Atualize `.ai/decisions.md` para toda decisão significativa.
- Atualize `docs/ADR.md` quando a decisão for arquitetural ou duradoura.
- Atualize `.ai/state/risks.md` se a decisão aceitar um risco.
- Referencie os artefatos e tarefas afetados.

## O agente não deve

- Tomar decisões irreversíveis sem registrar consequências.
- Esconder decisões de alto risco apenas em prosa.
- Substituir restrições do usuário sem confirmação.
- Modificar arquivos do LF-ENGINEERING-SYSTEM ao operar em um projeto cliente.
