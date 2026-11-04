# Schema de DESIGN

## Objetivo

Estrutura canônica para documentação de design system produzida pelo Design
System Analyst Agent.

## Seções obrigatórias

- Origem e status da direção
- Baseline e overrides específicos de página
- Identidade visual
- Paleta de cores
- Tipografia
- Sistema de espaçamento
- Estrutura de layout
- Análise de grid
- Hierarquia de componentes
- Padrões de botões
- Padrões de formulários
- Estrutura de navegação
- Cards
- Tabelas
- Ícones
- Padrões de interação
- Estados de hover
- Estados de foco
- Animações
- Princípios de movimento
- Observações de responsividade
- Considerações de acessibilidade
- Tokens de design
- Componentes de UI reutilizáveis sugeridos
- Recomendações para o design system
- Considerações de implementação frontend
- Contrato de performance do design (quando houver interface web ou visual)

## Validação

- Declare se `DESIGN.md` documenta referências fornecidas ou uma proposta de direção inicial solicitada explicitamente.
- Classifique afirmações de design como `Observed`, `Derived`, `Proposed` ou `Unverified`, identifique sua base e mantenha propostas separadas de observações de referências.
- Uma direção sem referências deve ser solicitada explicitamente, identificada como `Proposed` e aprovada antes de se tornar baseline de implementação; heurísticas não são evidência de preferência ou validação de usuários.
- Preserve tokens de design aprovados como fonte da verdade. Overrides específicos de página devem ser necessários, delimitados, justificados e aprovados; não crie um sistema de tokens concorrente.
- Todas as cores devem incluir valores HEX.
- A tipografia deve definir níveis de hierarquia (H1-H6, corpo, legenda).
- O espaçamento deve seguir uma escala consistente.
- Os componentes devem ser descritos em termos de engenharia.
- Estados de interação (hover, foco, ativo, desabilitado) devem ser
  documentados.
- Os tokens de design devem ser estruturados para consumo por desenvolvedores.
- Não deve haver código de implementação (CSS, HTML, JS).
- Referências visuais não devem ser redesenhadas ou criticadas.
- O Contrato de Performance do Design deve identificar rotas mobile e desktop,
  elementos LCP candidatos, estados de carregamento, restrições de assets/fontes
  e riscos de handoff quando aplicável; não deve alegar resultados de performance
  medidos.
- Não crie `DESIGN.md` para um projeto sem interface visual nem quando não houver
  referências visuais ou solicitação explícita de direção inicial.

## Seções condicionais

Seções podem ser omitidas quando o material de referência visual não contiver o
padrão correspondente:

- Animações (somente quando presentes)
- Tabelas (somente quando presentes)
- Cards (somente quando presentes)
- Ícones (somente quando presentes)
- Princípios de movimento (somente quando o movimento for observável)
