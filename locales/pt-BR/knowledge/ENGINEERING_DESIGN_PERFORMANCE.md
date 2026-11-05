# Performance de design de engenharia

Versão: 1.2.0
Status: Estável
Categoria: Operacional
Fonte: `docs/reference/LF_DESIGN_PERFORMANCE_GUIDE.md` (revisado em 2026-10-18; referência detalhada não normativa); os requisitos operacionais adotados são definidos aqui, em `protocols/PERFORMANCE_VALIDATION.md` e nos artefatos canônicos relacionados. A orientação seletiva de direção visual está registrada no ADR-008 (2026-10-31).
Derivado de: LF Engineering Framework 1.3.0; manutenção pós-tag

---

## Objetivo

Este módulo transforma o guia de design e performance do LF em um contrato de
workflow reutilizável para projetos web e de interfaces. Ele mantém performance,
acessibilidade, responsividade, identidade visual e funcionalidade sob o mesmo
processo de decisão de engenharia.

Ele é condicional para projetos com interface web ou visual. APIs, CLIs,
workers e outros sistemas não visuais devem registrar a dispensa condicional e
não precisam inventar medições mobile ou desktop.

O módulo é independente de framework. Ele não prescreve um framework frontend,
provedor de hospedagem ou resultado fixo do PageSpeed.

---

## Consumidores

Principais:

- Product Owner Agent
- Design System Analyst Agent
- Software Architect Agent
- Sprint Planner Agent
- QA & Security Agent
- Tech Lead Agent

Secundários:

- Implementation / selected CLI
- Code Reviewer Agent
- Documentation Agent
- Engineering Knowledge Extractor Agent

---

## Dependências

Obrigatórias:

- `ENGINEERING_FOUNDATIONS`
- `ENGINEERING_WORKFLOW`
- `ENGINEERING_ARTIFACTS`
- `ENGINEERING_QUALITY`

Relacionadas:

- `ENGINEERING_MOTION_DESIGN` — contrato condicional de movimento, acessibilidade
  e orientação de revisão quando houver movimento ou simulador visual interativo
  orientado por modelo no escopo.
- `ENGINEERING_STANDARDS`
- `ENGINEERING_TEMPLATES`
- `ENGINEERING_FIELD_GUIDE`

---

## Status e interpretação da política

O workflow e os requisitos de evidência deste módulo são obrigatórios quando o
projeto tem interface web ou visual. Os orçamentos numéricos são pontos de
partida do LF e só podem ser alterados com uma decisão de projeto documentada,
baseline medido, responsável e data de revisão.

Scores do PageSpeed e do Lighthouse são resultados de um modelo, não
porcentagens nem garantia de experiência do usuário. O requisito literal
“acima de 90” corresponde a um score mediano mínimo de `91`; `95` é a meta de
engenharia. Mobile e desktop são perfis separados e nunca devem ser colapsados
em um único score.

Um score automatizado alto não certifica acessibilidade, SEO, Core Web Vitals ou
prontidão de produção. Dados de campo ausentes significam evidência
insuficiente, não aprovação.

---

## Metas de experiência

| Dimensão | Política de baseline | Interpretação |
| --- | --- | --- |
| Performance score | Mediana `>= 91` por rota crítica e perfil; meta `>= 95` | Execute mobile e desktop de forma independente. |
| LCP | p75 `<= 2.5 s` quando os dados de campo forem suficientes | Segmente por mobile e desktop; use LCP de laboratório para diagnóstico. |
| INP | p75 `<= 200 ms` quando os dados de campo forem suficientes | Meça interações reais; não infira INP a partir de TBT. |
| CLS | p75 `<= 0.1` quando os dados de campo forem suficientes | Verifique carregamento inicial, rolagem e interação. |
| Acessibilidade | Meta automatizada `100` mais revisão manual | Um score não é uma alegação completa de conformidade WCAG. |
| Boas práticas | Meta `100`; explique exceções | Versione a ferramenta utilizada. |
| SEO | Meta `100` para rotas públicas e indexáveis quando aplicável | Rotas privadas ou intencionalmente não indexáveis podem ser isentas. |

O protocolo em `protocols/PERFORMANCE_VALIDATION.md` define como essas metas se
tornam evidências e decisões de aceite. A convenção de baseline do LF é de cinco
execuções válidas e comparáveis por rota crítica e perfil, resumidas pela
mediana; isso não é garantia estatística e não autoriza selecionar a melhor
execução.

O modelo, os pesos e as curvas do Lighthouse podem mudar; registre a versão da
ferramenta/modelo e não trate um score como garantia permanente ou universal.

---

## Contrato de design

Antes da implementação, o projeto deve identificar:

- rotas críticas e templates representativos;
- usuários-alvo, dispositivos, tamanhos de viewport e condições de rede
  relevantes;
- conteúdo e ação principais de cada primeira tela;
- um elemento LCP candidato para mobile e desktop;
- estados importantes de carregamento, vazio, sucesso, erro, validação, acesso
  restrito e alto volume;
- orçamentos de assets, fontes, terceiros e carregamento de dados;
- expectativas de acessibilidade e movimento reduzido;
- um contrato de motion design quando animações ou outros movimentos
  intencionais estiverem no escopo, seguindo `ENGINEERING_MOTION_DESIGN`;
- exceções aceitas, responsável, mitigação e data de revisão.

Decisões de design devem priorizar a hierarquia visual e o conteúdo inicial útil
antes dos efeitos decorativos. Conteúdo e ações devem continuar significativos
quando mídia, animação ou dados estiverem atrasados. A rota medida deve
representar a experiência real do produto: uma página inicial simples não pode
aprovar um dashboard, checkout, busca, catálogo ou workflow com muitos dados que
não foi medido.

---

## Governança de direção visual e recomendações

O Design System Analyst pode documentar uma proposta de direção sem referências
visuais somente quando o usuário ou Product Owner a solicitar explicitamente
para um produto visual. Essa é uma proposta opcional, não uma etapa automática do
workflow. Ignore o artefato quando não houver referências nem solicitação
explícita de proposta.

Para uma proposta:

- use como base o `PRD.md`, `PROJECT_BRIEF.md`, restrições do produto e
  necessidades de usuários conhecidas e aprovadas; peça contexto faltante ao
  Product Owner em vez de inferir público ou necessidade a partir de um rótulo de
  setor;
- rotule a direção e cada escolha não confirmada como `Proposed`, declare sua
  base, justificativa, trade-offs e status de aprovação, e mantenha-a separada de
  observações extraídas das referências fornecidas;
- não apresente heurísticas, correspondências de catálogo ou convenções de
  design como pesquisa de usuários, preferência do público, validação de
  usabilidade ou evidência de demanda;
- selecione somente recomendações relevantes às tarefas, conteúdo, rotas, stack
  documentada e restrições reais do produto. Trate uma correspondência fraca ou
  inexistente como `Unverified` e peça esclarecimentos em vez de inventar
  certeza;
- mantenha acessibilidade, comportamento responsivo, performance e requisitos
  funcionais como gates; uma preferência visual não pode substituí-los.

Em um design system existente, preserve os tokens e a documentação aprovados
como fonte da verdade. Não crie um conjunto de tokens concorrente nem substitua o
sistema de uma só vez. `DESIGN.md` pode resumir o baseline aprovado do projeto;
registre um override específico de página somente quando necessário, com escopo
da página, token ou regra de origem, justificativa e aprovação. Uma proposta ou
override não aprovado não pode ser tratado como baseline de implementação.

Este workflow não exige catálogo externo, CLI, dependência ou conjunto de
recomendações copiado.

---

## Regras responsivas para mobile e desktop

- Comece pelo menor viewport relevante e expanda a composição.
- Escolha breakpoints quando o conteúdo exigir uma mudança estrutural, não apenas
  por nomes de dispositivos.
- Teste conteúdo real, textos longos, traduções, zoom, reflow e larguras
  estreitas.
- Evite larguras fixas e alturas rígidas que causem overflow ou cortem mensagens.
- Use primitivas de layout CSS antes de medição com JavaScript; use JavaScript
  somente quando a interação exigir.
- Não mantenha árvores completas separadas para mobile e desktop sem justificativa
  de produto ou técnica medida.
- Não presuma que mídia desktop oculta não será baixada no mobile.
- Evite que cabeçalhos, banners e overlays fixos cubram foco, mensagens,
  âncoras ou ações essenciais.
- Confirme a navegação inicial e as transições internas em aplicações cuja
  performance difere após o primeiro carregamento.

---

## Regras de assets, tipografia e estabilidade

Para imagens e ilustrações:

- forneça variantes para largura renderizada e densidade de pixels usando
  `srcset` e `sizes` quando apropriado;
- use `picture` quando formatos ou cortes mudarem;
- avalie AVIF/WebP para fotografias e SVG para vetores adequados;
- reserve dimensões com width/height ou uma proporção estável;
- torne o recurso LCP descobrível cedo, evite lazy loading do hero crítico e use
  alta prioridade somente quando justificado;
- faça lazy-load do conteúdo abaixo da primeira tela depois de reservar seu
  espaço;
- documente finalidade, variantes, dimensões, corte, ponto focal, estratégia de
  carregamento, alt text e tamanho transferido de cada asset crítico.

Para fontes:

- prefira WOFF2 e faça preload somente de fontes genuinamente críticas;
- preserve os caracteres necessários, incluindo acentos;
- selecione `font-display` intencionalmente;
- teste métricas de fallback, quebra de títulos/botões e comportamento com cache
  vazio.

Para estabilidade do layout:

- reserve espaço para imagens, embeds, banners de consentimento, conteúdo
  assíncrono e fontes;
- valide CLS após o carregamento, durante a rolagem e durante a interação;
- mantenha erros de formulário, foco, toasts e contêineres de gráficos
  previsíveis.

---

## Regras de interação, mídia e acessibilidade

- Prefira `transform` e `opacity` para movimento após a medição; investigue
  blur, sombras grandes, filtros, `will-change` e long tasks.
- Forneça uma variante de movimento reduzido sem remover foco ou funcionalidade.
- Não exija hover para ações essenciais.
- Dê a vídeos, mapas, chat, carrosséis e gráficos complexos um primeiro estado
  estático ou textual e carregue o serviço caro conforme necessidade ou intenção
  do usuário.
- Não faça preload de todo recurso nem atribua alta prioridade
  indiscriminadamente.
- Separe feedback visual da conclusão da operação subjacente.
- Preserve semântica nativa, foco visível, ordem lógica de teclado, nomes
  acessíveis, labels, zoom, reflow e alternativas úteis para gráficos e imagens.
- Verifique contraste em estados normal, foco, selecionado, erro e tema. Não
  reduza contraste, tamanho do alvo de toque ou legibilidade para melhorar um
  score.

Para grandes volumes, teste dados vazios, típicos, de alto volume, com textos
longos, erro de API e rede lenta. Paginação, cancelamento de requisições de
filtros obsoletas, virtualização, agregação e carregamento em etapas de
dashboards são decisões a medir, não prescrições automáticas.

---

## Expectativas de arquitetura e entrega

O Software Architect deve documentar, quando aplicável:

- estratégia de renderização por rota (SSG, SSR, CSR ou combinação);
- divisão de JavaScript e CSS, custo de dependências e trabalho na main thread;
- pipeline de assets, compressão e variantes responsivas;
- redirecionamentos de rede e cadeias de dependências;
- resposta do servidor e tempo de API;
- TTFB como diagnóstico da resposta inicial do servidor;
- fronteiras de cache para assets versionados, HTML e dados privados;
- responsáveis por terceiros e momento de ativação;
- fronteiras de coleta de RUM e dados de campo.

SSR não remove automaticamente o custo de hidratação. CSR não justifica fazer
uma rota pública de conteúdo esperar a aplicação inteira. Cache público não deve
expor dados personalizados, e `immutable`, preload e preconnect exigem
versionamento ou evidência.

---

## Orçamentos iniciais de recursos

Estes são orçamentos iniciais mobile-first para uma rota de produção
representativa com cache vazio do navegador. Eles incluem terceiros realmente
ativos e não substituem o orçamento total de transferência pelo custo posterior
adiado.

| Recurso ou métrica | Baseline inicial |
| --- | ---: |
| Transferência mobile inicial | `<= 1000 KiB` |
| JavaScript inicial por rota | `<= 170 KiB` |
| CSS inicial | `<= 50 KiB` |
| Fontes iniciais | `<= 100 KiB` |
| Imagem hero mobile escolhida | `<= 150 KiB` |
| Vídeo decorativo no carregamento inicial | `0 KiB` |
| Meta de LCP de laboratório | `<= 2.0 s` |
| Meta de CLS de laboratório | `<= 0.05` |
| Meta de TBT de laboratório | `<= 150 ms` |

Os subtotais não necessariamente somam o total. Desktop também precisa de
controle de recursos mesmo quando seu score for alto. Produtos complexos podem
definir orçamentos específicos por rota, mas a exceção deve preservar a meta de
experiência e ser revisitada após a mudança do baseline.

---

## Handoffs dos agentes

| Agent | Contribuição necessária |
| --- | --- |
| Product Owner | Rotas críticas, público, perfis de dispositivo, metas de experiência e exceções aceitas em `PRD.md`. |
| Design System Analyst | Quando ativo para análise de referências ou solicitação explícita de direção inicial, documenta composição responsiva, estados, contratos de assets/fontes, candidatos a LCP, notas de movimento e acessibilidade em `DESIGN.md`. |
| Software Architect | Estratégia de renderização, bundle, cache, servidor, API, terceiros, observabilidade e orçamento em `ARCHITECTURE.md`. |
| Sprint Planner | Tarefas de performance mensuráveis, dependências, orçamentos, baseline inicial e trabalho de validação em `docs/SPRINTS.md`. |
| Implementation / selected CLI | Implementar estratégias aprovadas de carregamento, responsividade, semântica e instrumentação; preservar evidências. |
| Code Reviewer | Revisar mudanças sensíveis a performance, regressões, estratégia de assets e cobertura de rotas em relação ao plano. |
| QA-Security | Executar o protocolo de performance, revisão manual de acessibilidade, jornadas representativas e status dos dados de campo. |
| Documentation | Manter metas, exceções, relatório e notas de release sincronizados. |
| Tech Lead | Aceitar, bloquear ou registrar uma exceção justificada usando evidências dos dois perfis. |
| Knowledge Extractor | Capturar medições reproduzíveis antes/depois, trade-offs e recomendações futuras para o Framework. |

---

## Antipadrões

O workflow deve rejeitar ou escalar explicitamente:

- prometer um score fixo sem medir a versão publicada;
- testar somente a página inicial ou somente um perfil de dispositivo;
- publicar uma página especial ou remover funcionalidade para o auditor;
- tratar um placeholder vazio como conteúdo entregue;
- fazer lazy-load do hero crítico;
- carregar bibliotecas completas de ícones, animação ou terceiros por conveniência;
- transformar todo recurso em preload ou alta prioridade;
- usar um bom resultado de TBT como prova de bom INP;
- tratar dados CrUX ausentes como aprovação;
- reduzir acessibilidade ou funcionalidade para melhorar uma métrica.

---

## Artefatos e protocolos relacionados

- `docs/reference/LF_DESIGN_PERFORMANCE_GUIDE.md` — guia-fonte detalhado e racional.
- `docs/DESIGN.md` — handoff condicional de design e performance.
- `docs/ARCHITECTURE.md` — decisões de renderização e entrega.
- `docs/SPRINTS.md` — tarefas e orçamentos executáveis de performance.
- `docs/PERFORMANCE_VALIDATION_REPORT.md` — registro condicional de evidências.
- `protocols/PERFORMANCE_VALIDATION.md` — validação e aceite repetíveis.
- `QA_SECURITY_REPORT.md` — achados finais de qualidade e prontidão.

---

## Classificação de evidências

Os agentes devem classificar afirmações de design, metas e medições como
`Observed`, `Derived`, `Proposed` ou `Unverified` e identificar sua base.
`Observed` está diretamente presente nas referências fornecidas ou em artefatos
aprovados do projeto; `Derived` é uma inferência vinculada a essa evidência e a
premissas declaradas; `Proposed` identifica uma recomendação ou hipótese, com a
aprovação registrada separadamente; e `Unverified` é desconhecido, pouco
sustentado ou conflitante. Uma direção sem referências permanece `Proposed` por
origem após a aprovação; a aprovação permite sua adoção, mas não a transforma em
evidência ou validação com usuários.

Os orçamentos e thresholds de baseline são políticas adotadas do LF para
projetos iniciais, mas exceções específicas do projeto permanecem `Proposed` até
serem aprovadas e medidas. Um score é evidência somente para a rota/perfil
testado; não é evidência de que toda a aplicação foi otimizada.

---

## Histórico de versões

- `1.2.0` — 2026-11-01: Adicionada relação condicional com o módulo de motion
  design para projetos que incluem animações ou outros movimentos intencionais.
- `1.1.0` — 2026-10-31: Adicionadas propostas opcionais de direção visual,
  solicitadas explicitamente, classificação de evidências e salvaguardas para
  tokens existentes e overrides.
