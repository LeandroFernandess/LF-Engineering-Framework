# DESIGN.md

> Este arquivo é produzido pelo Design System Analyst quando existem referências
> visuais ou quando o usuário/Product Owner solicita explicitamente uma proposta
> de direção visual inicial sem referências.
>
> Ignore-o se o projeto não possuir interface visual ou quando não houver
> referências nem solicitação explícita de proposta. Uma proposta é opcional e
> não equivale à validação com usuários.
>
> Quando presente, documenta a origem, o status e as características de engenharia
> da direção visual para o Software Architect. Mantenha escolhas propostas
> distintas das observações e não trate uma proposta não aprovada como baseline
> de implementação.

---

## Origem e status da direção

<!-- Declare: análise de referências ou proposta de direção inicial solicitada explicitamente. Liste fontes ou contexto aprovado do produto, identifique afirmações materiais como Observed / Derived / Proposed / Unverified, cite sua base e registre a aprovação separadamente. Aprovação não implica validação com usuários. -->

| Modo | Fontes ou base | Status de aprovação |
|---|---|---|
|  |  |  |

## Baseline e overrides específicos de página

<!-- Identifique a fonte da verdade aprovada do design system/tokens. Adicione somente exceções necessárias por página; não crie um sistema de tokens concorrente. -->

| Página / escopo | Token ou regra base | Override | Justificativa | Aprovação |
|---|---|---|---|---|

## Identidade visual

<!-- Documente estilo visual, identidade da marca e linguagem de design. -->

## Paleta de cores

<!-- Extraia cores, valores HEX/RGB, nomes e usos principais. -->

| Nome | HEX | RGB | Uso |
|---|---|---|---|

## Tipografia

<!-- Documente famílias, tamanhos, pesos, hierarquia e alturas de linha. -->

| Elemento | Família | Tamanho | Peso | Altura de linha |
|---|---|---:|---:|---:|

## Sistema de espaçamento

<!-- Documente escala, margens, padding e gaps. -->

## Estrutura de layout

<!-- Documente layouts, áreas de conteúdo e padrões estruturais. -->

## Análise de grid

<!-- Documente colunas, breakpoints e alinhamentos. -->

## Hierarquia de componentes

<!-- Documente a árvore de componentes e suas relações. -->

## Padrões de botões

<!-- Documente variantes, tamanhos, estados e usos. -->

## Padrões de formulários

<!-- Documente layouts, tipos de campo e estados de validação. -->

## Estrutura de navegação

<!-- Documente menus, breadcrumbs e roteamento. -->

## Cards

<!-- Documente componentes, conteúdo, layouts e variantes. -->

## Tabelas

<!-- Documente padrões, ordenação, filtros e paginação. -->

## Ícones

<!-- Documente conjuntos, tamanhos, usos e nomenclatura. -->

## Padrões de interação

<!-- Documente interações, gestos e padrões de feedback. -->

## Estados de hover

<!-- Documente o comportamento de hover dos elementos interativos. -->

## Estados de foco

<!-- Documente indicadores de foco, ordem de tabulação e teclado. -->

## Animações

<!-- Quando houver movimento no escopo, documente propósito, estado, hierarquia, escolhas de timing/easing, interrupção e alternativas para movimento reduzido. Valores são decisões de projeto, não padrões universais. -->

## Princípios de movimento

<!-- Documente a personalidade de movimento aprovada e regras de consistência. Separe referências observadas e requisitos aprovados de propostas ou heurísticas. -->

## Contrato de motion design

<!-- Condicional quando o produto usa intencionalmente animações, transições, microinterações, efeitos vinculados à rolagem ou assets animados. Se este arquivo for dispensado, registre os resultados do produto em PRD.md e as restrições técnicas em ARCHITECTURE.md. -->

| Interação / estado | Propósito e contexto do público | Sequência / comportamento | Decisão de timing e easing | Alternativa para movimento reduzido | Diferenças responsivas ou de entrada | Evidência / aprovação |
|---|---|---|---|---|---|---|

## Observações de responsividade

<!-- Documente breakpoints, padrões adaptativos e considerações mobile. -->

## Acessibilidade

<!-- Documente contraste, ARIA, leitores de tela e conformidade WCAG. -->

## Tokens de design

<!-- Documente a fonte aprovada e a estrutura dos tokens. Preserve os tokens existentes; classifique tokens originados em proposta sem referências como Proposed e registre a aprovação separadamente. -->

```json
{
  "colors": {},
  "typography": {},
  "spacing": {},
  "shadows": {},
  "borderRadius": {}
}
```

## Componentes de UI reutilizáveis sugeridos

<!-- Recomende componentes que devem ser construídos como primitives reutilizáveis. -->

| Componente | Objetivo | Variantes | Prioridade |
|---|---|---|---|

## Recomendações para o design system

<!-- Recomende estrutura, governança e manutenção sem duplicar ou substituir a fonte da verdade existente. -->

## Considerações de implementação frontend

<!-- Registre implicações de CSS, biblioteca de componentes e framework. -->

## Contrato de performance do design

<!-- Condicional para projetos web ou visuais. Registre composição mobile/desktop,
rotas críticas, estados de carregamento, candidatos a LCP, contratos de assets e
fontes, orçamentos, movimento reduzido e restrições de acessibilidade. -->

| Item | Mobile | Desktop | Evidência ou decisão |
|---|---|---|---|
| Rota/template crítico |  |  |  |
| Elemento candidato a LCP |  |  |  |
| Conteúdo/ação inicial |  |  |  |
| Carregamento de asset/fonte |  |  |  |
| Riscos de estado responsivo |  |  |  |

<!-- Este é um handoff de design, não um resultado de teste de performance.
QA-Security registra medições em docs/PERFORMANCE_VALIDATION_REPORT.md. -->
