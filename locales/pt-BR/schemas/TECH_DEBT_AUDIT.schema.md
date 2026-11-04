# Schema de auditoria de dívida técnica

## Objetivo

Estrutura canônica para o relatório opcional `docs/TECH_DEBT_AUDIT.md`, produzido
por meio de `workflows/TECH_DEBT_AUDIT.md`.

## Aplicabilidade

- Use somente para uma solicitação explícita de auditoria ou trabalho de
  manutenção aprovado.
- Não crie este relatório como artefato padrão do projeto nem como gate de
  release.
- A auditoria é somente leitura; a implementação exige trabalho aprovado
  separadamente.

## Seções obrigatórias

- Contexto da auditoria
- Escopo e método
- Resumo
- Achados
- Contraevidências e casos aceitáveis
- Limitações
- Priorização e decisão

## Campos obrigatórios dos achados

Todo achado acionável deve identificar:

- ID e título conciso;
- classe de evidência: `Observed`, `Derived` ou `Proposed`;
- categoria e caminho exato com linha/intervalo, ou referência clara ao artefato
  quando números de linha não se aplicarem;
- evidência e impacto;
- severidade (`Critical`, `High`, `Medium` ou `Low`);
- confiança (`High`, `Medium` ou `Low`);
- esforço estimado e a base da estimativa;
- recomendação específica, responsável proposto e critérios de aceite
  verificáveis.

## Regras de validação

- Declare a baseline, o escopo, as exclusões, o método e as limitações
  inspecionados.
- Diferencie fatos observados de inferências e propostas não validadas.
- Registre contraevidências e padrões intencionais ou aceitáveis; não force um
  achado quando as evidências não o sustentarem.
- Um resultado sem achados aplica-se somente ao escopo inspecionado.
- Evite recomendações genéricas e não altere código durante uma auditoria.
- Registre a decisão do Tech Lead para cada item acionável; somente achados
  aprovados tornam-se trabalho de correção planejado.
