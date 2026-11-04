# Protocolo de atualização de artefatos

## Objetivo

Definir como os agentes acompanham artefatos de projeto criados, atualizados ou
consumidos durante um workflow.

## Quando usar

Use este protocolo sempre que um agente criar, modificar, revisar ou depender de
um artefato do projeto.

## Formato obrigatório

```markdown
## Atualização de artefato

- Data:
- Artefato:
- Caminho:
- Responsável:
- Tipo de mudança:
- Status:
- Resumo:
- Decisões relacionadas:
- Próxima ação:
```

## Campos obrigatórios

- Data
- Artefato
- Caminho
- Responsável
- Tipo de mudança
- Status
- Resumo

## Exemplo preenchido

```markdown
## Atualização de artefato

- Data: 2026-06-30
- Artefato: Documento de requisitos do produto
- Caminho: `docs/PRD.md`
- Responsável: Product Owner
- Tipo de mudança: Atualizado
- Status: Pronto para arquitetura
- Resumo: Escopo do MVP, metas e critérios de aceite adicionados.
- Decisões relacionadas: O MVP exclui integração de pagamentos.
- Próxima ação: Software Architect deve produzir `docs/ARCHITECTURE.md`.
```

## Regras de atualização

- Atualize `.ai/artifacts.md` após a criação ou modificação significativa de um
  artefato.
- Atualize `.ai/state/project-summary.md` quando mudanças em artefatos alterarem
  o resumo do projeto.
- Atualize `.ai/state/next-actions.md` quando o estado do artefato alterar a
  próxima etapa.
- Mantenha o status do artefato alinhado ao estado do handoff e do workflow.

## O agente não deve

- Declarar um artefato pronto sem responsável e status claros.
- Duplicar o conteúdo completo do artefato em `.ai/artifacts.md`.
- Deixar artefatos gerados sem rastreamento.
- Modificar arquivos do LF-ENGINEERING-SYSTEM ao operar em um projeto cliente.
