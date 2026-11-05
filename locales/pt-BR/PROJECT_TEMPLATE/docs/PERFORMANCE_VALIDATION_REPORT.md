# Relatório de validação de performance

> Artefato condicional para projetos web ou visuais. QA-Security cria e
> completa este relatório após implementação e Code Review usando
> `protocols/PERFORMANCE_VALIDATION.md`. Em projetos não visuais, registre a
> decisão de aplicabilidade em `.ai/decisions.md` e no relatório de QA, sem
> inventar medições de navegador.

## Escopo

- Rotas/templates:
- Público ou autenticado:
- Jornadas críticas:
- Perfil mobile:
- Perfil desktop:

## Build e ambiente

- Commit/build:
- Data (UTC):
- Ferramenta e versão:
- Navegador e versão:
- Cache/rede/CPU:
- Região:
- Dados representativos e terceiros ativos:

## Metas e orçamentos

- Mínimo de Performance mediana: `91` por rota e perfil crítico.
- Meta de engenharia: `95`.
- Orçamentos por rota e exceções aprovadas:

## Resultados

<!-- Salvo indicação diferente, os valores desta tabela são medianas de laboratório nas execuções válidas. -->
| Rota | Perfil | Execuções válidas | Scores | Mediana | LCP | INP | CLS | TBT | TTFB | FCP | Speed Index | Elemento LCP | Decisão |
|---|---|---:|---|---:|---:|---:|---:|---:|---:|---:|---:|---|---|

## Jornada e acessibilidade

- Navegação inicial:
- Navegação interna:
- Scroll/filtro/formulário/alto volume/erros:
- Teclado e foco:
- Contraste, zoom e reflow:
- Movimento reduzido:

## Revisão de movimento

- Aplicabilidade e superfície inspecionada:
- Rotas, estados e jornadas do usuário:
- Propósito e comportamento aprovados:
- Resultado com movimento normal:
- Resultado com movimento reduzido:
- Teclado/toque e comportamento de interrupção:
- Diferenças mobile/desktop:
- Evidência visual ou temporal:
- Achados, responsável e acompanhamento:

## Revisão de modelo interativo

- Aplicabilidade e superfície inspecionada:
- Uso pretendido e impacto nas decisões, fidelidade e limitações:
- Fontes importantes, unidades, premissas e classificações de evidência:
- Verificações numéricas independentes e resultados:
- Consistência do estado do modelo entre geometria e valores exibidos:
- Achados sobre teclado/toque, controle do usuário e movimento reduzido:
- Evidência visual ou temporal e discrepâncias não resolvidas:
- Fonte/revisor de validação de domínio quando houver alegação de precisão real:
- Achados, responsável e acompanhamento:

## Dados de campo

- Escopo RUM/CrUX:
- Período e amostra:
- URL ou origem:
- Status mobile:
- Status desktop:

| Rota | Perfil | LCP p75 | INP p75 | CLS p75 | Fonte/escopo | Período/amostra |
|---|---|---:|---:|---:|---|---|

## Achados e exceções

| ID | Severidade | Evidência | Impacto | Responsável | Mitigação | Data de revisão |
|---|---|---|---|---|---|---|

## Decisão

- Status: Aprovado / Aprovado com recomendações / Ajustes necessários / Bloqueado
- Responsável:
- Acompanhamento:
