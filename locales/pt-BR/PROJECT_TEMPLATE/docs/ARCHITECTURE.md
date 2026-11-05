# Arquitetura

## Visão geral

Descreva a solução proposta e seus limites.

## Restrições

Liste restrições técnicas, de produto, segurança e operação.

## Componentes

Liste componentes, responsabilidades, interfaces e fluxos de dados. Para um
simulador orientado por modelo, identifique o estado autoritativo do modelo e
como geometria, rótulos, medidores, gráficos e esquemas derivam dele; registre
fontes importantes, unidades, premissas e limites de implementação nas seções
existentes da arquitetura.

## Decisões

Relacione decisões significativas em `docs/ADR.md`.

## Estratégia de validação

Liste testes, observabilidade e verificações de runtime que validarão o design.
Para um simulador orientado por modelo, inclua verificações numéricas
independentes e evidências visuais de que estados renderizados representativos
correspondem ao modelo; não trate similaridade visual, por si só, como prova de
correção numérica.

## Performance web e entrega (quando aplicável)

Documente a estratégia de renderização por rota, divisão de JavaScript/CSS,
variantes de assets, resposta de servidor/API, cache, ativação de terceiros,
orçamentos mobile/desktop e plano de medição. QA-Security executa o protocolo
repetível em `protocols/PERFORMANCE_VALIDATION.md`.

## Runtime e integração de movimento (quando aplicável)

Quando houver movimento no escopo, registre o sistema de implementação
selecionado e sua justificativa, dependências existentes ou adições propostas,
integração com movimento reduzido, ciclo de vida e limpeza de componente/rota e
riscos de renderização ou performance. Não selecione uma biblioteca somente por
ela aparecer nas orientações do Framework.
