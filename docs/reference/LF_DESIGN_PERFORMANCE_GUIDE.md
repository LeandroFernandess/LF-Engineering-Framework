# LF Engineering System — Guia de design e performance web

Versão: 1.0 • Revisão das fontes: 18/10/2026 • Idioma: português brasileiro

**Status:** guia detalhado de referência; não é autoridade operacional completa.
As orientações adotadas pelo Framework são definidas pelos módulos, protocolos,
schemas e decisões canônicos. Conteúdo deste guia que não tenha sido adotado
explicitamente deve ser tratado como contexto ou proposta, não como requisito.

**Objetivo:** orientar design, implementação e validação de sites e sistemas web com meta de Performance superior a 90 no PageSpeed Insights, separadamente em mobile e desktop, preservando acessibilidade, identidade visual e funcionalidades.

**Formato de uso:** módulo de conhecimento independente de framework. As regras
foram adaptadas aos documentos canônicos do LF Engineering System; este arquivo
permanece como guia-fonte detalhado, enquanto o módulo e o protocolo canônicos
definem o comportamento do workflow.

## 1. Como interpretar a meta

O PageSpeed Insights apresenta notas de 0 a 100; não são percentuais de otimização. A faixa 90–100 é considerada boa. Para o requisito literal “acima de 90”, adotar **91 como mínimo de aceite** e **95 como alvo de engenharia**. O alvo oferece margem, mas nenhuma combinação de boas práticas garante uma nota fixa em todas as execuções. [1][2]

Separar quatro dimensões:

| Dimensão | O que avaliar | Política sugerida LF |
|---|---|---|
| Performance | Carregamento, bloqueio e estabilidade | Mediana ≥ 91 em cada perfil; alvo ≥ 95 |
| Accessibility | Auditorias automatizadas de acessibilidade | Alvo 100; revisão manual obrigatória |
| Best Practices | Auditorias técnicas disponíveis na versão | Alvo 100; justificar pendências |
| SEO | Verificações automatizadas para páginas públicas | Alvo 100 quando aplicável |

Os três últimos alvos são políticas propostas, não requisitos oficiais do Google. Uma nota 100 de acessibilidade não certifica conformidade completa. Uma nota alta em SEO não garante posicionamento. Em aplicações privadas, indexabilidade pode ser deliberadamente desativada.

### Laboratório e experiência real

O laboratório usa Lighthouse em condições simuladas. Os dados de campo do CrUX refletem uma janela móvel de 28 dias e dependem de amostragem suficiente. Confirmar se o relatório mostra a URL ou a origem inteira. Ausência de dados significa “sem evidência suficiente”, não aprovação. Uma publicação não substitui imediatamente todo o histórico. [1]

Para áreas autenticadas, usar Lighthouse local com sessão de teste e monitoramento próprio de usuários reais (RUM). Não publicar telas privadas para torná-las acessíveis ao PSI. Complementar o teste inicial com jornadas reais: filtros, formulários, navegação e grandes conjuntos de dados.

## 2. Métricas que o design influencia

| Métrica | Significado | Referência oficial de experiência boa |
|---|---|---|
| LCP | Tempo até o maior conteúdo relevante visível | ≤ 2,5 s |
| INP | Resposta visual às interações | ≤ 200 ms |
| CLS | Deslocamentos inesperados de layout | ≤ 0,1; sem unidade |

Avaliar essas três métricas no percentil 75, segmentando mobile e desktop. Não usar a média das visitas como substituta. [3]

FCP indica a primeira renderização de conteúdo; Speed Index descreve a progressão visual; TBT mede bloqueio durante o carregamento. TTFB ajuda a diagnosticar a resposta inicial do servidor. INP e TBT são medidas diferentes: um TBT baixo não comprova boa resposta em todas as interações.

A referência de pontuação do Lighthouse documenta, para o modelo Lighthouse 10: FCP 10%, Speed Index 10%, LCP 25%, TBT 30% e CLS 25%. Audits de oportunidades não somam pontos diretamente: as correções ajudam quando melhoram as métricas. Registrar a versão efetivamente executada; pesos e curvas podem mudar. Mobile e desktop possuem condições e pontuação próprias. [2]

**Consequência prática:** atingir os limites de Core Web Vitals não garante Performance 91. São critérios complementares.

## 3. Princípios de design para o LF

As regras seguintes constituem uma proposta de política de engenharia para o framework:

1. **Definir prioridade visual antes de escolher efeitos.** Identificar título, ação principal, conteúdo inicial e mídia essencial.
2. **Projetar o estado inicial completo.** Especificar onde cada elemento aparece, quanto espaço ocupa e de qual recurso depende.
3. **Orçar cada decisão.** Uma fonte, biblioteca ou vídeo deve ter função e custo aceitos.
4. **Projetar estados, não apenas telas finais.** Loading, sucesso, vazio, erro, validação, dados extensos e acesso limitado fazem parte da entrega.
5. **Manter conteúdo essencial independente de decoração.** Texto e ações devem aparecer mesmo se animações ou mídia demorarem.
6. **Medir a experiência representativa.** Home simples não representa dashboard, checkout ou catálogo.
7. **Exigir evidência para exceções.** Registrar motivo, impacto, mitigação, responsável e data de revisão.

Uma interface pode ser sofisticada usando composição, tipografia e cor. A adoção de efeitos caros deve decorrer da necessidade do produto e de medição em dispositivos representativos.

## 4. Layout responsivo e primeira tela

### Política de composição

- Começar pelo menor viewport relevante ao público e expandir a composição.
- Escolher breakpoints quando o conteúdo exigir mudança de layout; não apenas por nomes de dispositivos.
- Evitar larguras fixas que causem transbordamento. Testar textos longos, traduções, zoom e conteúdo real.
- Definir hierarquia clara de títulos, textos, ações e informações secundárias.
- Evitar cabeçalhos fixos que consumam a maior parte da tela ou cubram foco, mensagens e âncoras.
- Preferir CSS Grid e Flexbox para composição; usar JavaScript para medir layout somente quando necessário.
- Não manter duas árvores completas de interface, uma mobile e outra desktop, sem demonstrar necessidade.
- Não assumir que `display: none` impede downloads de recursos declarados no HTML.

### Primeira tela

Especificar um candidato a LCP para cada layout. O candidato pode mudar entre mobile e desktop e deve ser confirmado no relatório. Evitar introduções que ocultem título, hero ou ação principal até terminar um efeito. Skeletons devem representar espaços transitórios; não substituir indefinidamente conteúdo que já pode ser entregue.

**Critério de revisão LF:** com mídia indisponível, o usuário ainda deve compreender a proposta e encontrar a ação principal. Com dados atrasados, deve compreender o estado da operação.

## 5. Imagens, ilustrações e ícones

Usar variantes adequadas ao tamanho renderizado e à densidade de pixels. `srcset` fornece candidatos; `sizes` descreve o tamanho de exibição. Usar `<picture>` quando formatos ou recortes mudarem. Avaliar AVIF/WebP para fotografias, preservando legibilidade e qualidade; usar SVG para vetores adequados. Comprimir e remover metadados desnecessários. Não transformar texto de interface em imagem. [4]

Reservar dimensões de imagem com `width`/`height` ou proporção coerente. Para o elemento LCP, disponibilizar o recurso cedo no HTML, evitar lazy loading e considerar `fetchpriority="high"`. Não atribuir alta prioridade indiscriminadamente. Investigar descoberta, transferência e atraso de renderização; reduzir bytes pode não resolver um bloqueio de renderização. [5]

Exemplo LF: hero de largura total até 1200 px. Os arquivos devem existir, possuir as larguras declaradas e manter proporção 3:2.

```html
<img
  src="/images/hero-1200.webp"
  srcset="/images/hero-480.webp 480w,
          /images/hero-800.webp 800w,
          /images/hero-1200.webp 1200w,
          /images/hero-2400.webp 2400w"
  sizes="(max-width: 1200px) 100vw, 1200px"
  width="1200" height="800"
  fetchpriority="high"
  alt="Equipe acompanhando indicadores de produção"
>
```

Se houver margens ou colunas, ajustar `sizes` à largura real. Se a imagem for puramente decorativa, usar `alt=""`. Não duplicar a descrição no texto alternativo sem necessidade.

Para conteúdo distante da primeira tela:

```html
<img src="/images/equipe-640.webp"
     width="640" height="480"
     loading="lazy" decoding="async"
     alt="Equipe de atendimento na unidade de Contagem">
```

**Handoff LF de cada asset:** finalidade, arquivos/variantes, dimensões, proporção, recorte por breakpoint, ponto focal, posição inicial, estratégia de carregamento, texto alternativo e tamanho transferido.

Para ícones, adotar um conjunto coerente e importar apenas os necessários. A escolha entre SVG inline e arquivo externo deve considerar repetição, cache e tamanho do HTML. Um SVG complexo também pode ser caro.

## 6. Tipografia

Fontes podem atrasar texto e provocar mudanças de layout. Preferir WOFF2, reduzir arquivos e subconjuntos sem eliminar caracteres necessários, inclusive acentos. Escolher `font-display` conscientemente: `swap` mostra fallback cedo, mas pode deslocar conteúdo; `optional` pode manter fallback naquela visita. Precarregar apenas fontes realmente críticas. [6]

Proposta LF: começar com fonte de sistema ou uma família de texto; acrescentar uma família de destaque apenas se a identidade exigir. Comparar o peso real de fonte variável com os arquivos estáticos necessários.

```css
@font-face {
  font-family: "Interface";
  src: url("/fonts/interface-regular.woff2") format("woff2");
  font-style: normal;
  font-weight: 400;
  font-display: swap;
}
body {
  font-family: "Interface", system-ui, sans-serif;
  line-height: 1.5;
}
```

Validar que o fallback não altera drasticamente títulos, botões e linhas. Se necessário, ajustar métricas do fallback com valores medidos. Não copiar valores de `size-adjust` de uma fonte diferente. Testar a troca com cache vazio. [7]

## 7. Estabilidade visual e carregamento

Reservar espaço para mídia, embeds, anúncios e conteúdo assíncrono. Evitar inserir elementos acima do que o usuário está lendo. Fontes e componentes sem dimensões previsíveis são fontes frequentes de deslocamento. Investigar CLS também depois do carregamento, durante rolagem e interação. [8]

Regras LF para estados:

| Componente | Contrato de design |
|---|---|
| Card com imagem | Proporção definida antes do download |
| Painel de indicadores | Área de carregamento compatível com o estado final |
| Banner de consentimento | Não reposicionar inesperadamente conteúdo; manter controles acessíveis |
| Formulário | Erro junto ao campo, foco e anúncio adequados; layout previsível |
| Toast | Não cobrir ação essencial nem roubar foco sem motivo |
| Gráfico | Container estável e resumo textual disponível |

Dimensionar por breakpoint e conteúdo; não impor alturas rígidas que cortem mensagens. Espaço reservado precisa ser validado com textos extensos e zoom.

## 8. Interações, animações e efeitos

Para animações, priorizar `transform` e `opacity`, verificar composição e evitar trabalho repetitivo de layout/pintura. Blur, sombras extensas e filtros precisam de medição. `will-change` deve ser localizado e temporário quando necessário, pois promover muitas camadas consome recursos. [9]

Política LF:

- Usar movimento para indicar relação, estado ou resposta.
- Definir uma versão com movimento reduzido.
- Não exigir hover para ações essenciais.
- Evitar loops decorativos contínuos em telas de trabalho.
- Preservar foco, teclado e comportamento quando um efeito é desligado.

```css
.acao {
  transition: transform 160ms ease, opacity 160ms ease;
}
.acao:active { transform: scale(.98); }
@media (prefers-reduced-motion: reduce) {
  .acao { transition: none; }
}
```

O tempo de 160 ms é um exemplo interno, não um limite do Google. Evitar resets globais de animação que interrompam componentes dependentes de eventos de transição.

Responder rapidamente ao clique e separar processamento pesado do feedback visual. Reduzir tarefas longas e renderizações excessivas; carregar funcionalidades complexas quando necessárias. Não alternar repetidamente escrita de estilos e leitura de medidas, causando layout síncrono forçado. [10][11]

Mostrar “processando” não significa que a operação terminou. Manter estado de conclusão, erro e possibilidade de nova tentativa coerentes com a ação real.

## 9. Vídeos, carrosséis e serviços incorporados

Para vídeos, avaliar poster leve, controles e carregamento sob demanda. `preload="none"` pode reduzir transferência antecipada, mas autoplay modifica essa expectativa. Para players externos, considerar uma fachada estática que ativa o player por intenção do usuário. Evitar GIFs pesados quando vídeo apropriado atende melhor. [12]

Decisões propostas LF:

| Recurso | Padrão inicial | Exceção exige |
|---|---|---|
| Hero em vídeo | Imagem estática e reprodução opcional | Evidência de valor e custo mobile |
| Carrossel | Conteúdo estático prioritário | Navegação acessível e assets não prioritários adiados |
| Mapa | Endereço e preview; carregar mapa por ação | Necessidade de mapa interativo imediato |
| Chat | Inicialização adiada e botão acessível | Impacto mensurado e estado de abertura rápido |
| Gráfico complexo | Resumo inicial e módulo por rota | Necessidade imediata para a tarefa |

Não carregar todos os slides apenas para escondê-los. Medir o custo dos scripts de analytics, testes A/B e consentimento no cenário realmente entregue.

## 10. Acessibilidade como contrato de design

Contraste mínimo WCAG para texto normal: 4,5:1; para texto grande: 3:1, observadas as definições e exceções do critério. Não arredondar uma razão insuficiente para aprovação. [13]

WCAG 2.2, critério 2.5.8 nível AA, estabelece alvo mínimo de 24 × 24 CSS px ou condições de espaçamento/exceções especificadas. Como política de conforto LF, preferir 44 × 44 CSS px nos controles principais; isso não deve ser confundido com o mínimo universal do critério AA. [14]

Checklist LF de revisão manual:

- Usar elementos nativos: links para navegação, botões para ações.
- Definir foco visível, ordem lógica e retorno de foco após modais.
- Dar nome acessível aos controles; manter labels nos formulários.
- Não transmitir estado somente por cor.
- Verificar zoom, reflow, teclado e leitor de tela nas jornadas críticas.
- Não cortar conteúdo para manter um layout visualmente perfeito.
- Validar contraste nos estados normal, foco, seleção, erro e temas claro/escuro.
- Dar alternativa textual útil para gráficos e imagens informativas.

Otimizar desempenho preservando semântica e capacidade de operação da interface.

## 11. Sistemas, dashboards e grandes volumes

Esta seção propõe decisões de produto e engenharia; os parâmetros devem ser medidos com os dados do cliente.

- **Tabelas:** começar com paginação e consultas limitadas. Considerar virtualização quando o volume renderizado justificar, validando teclado, leitura assistiva, busca e impressão.
- **Filtros:** separar filtros locais de consultas remotas. Cancelar respostas obsoletas e definir debounce conforme a tarefa; não atrasar toda interação indiscriminadamente.
- **Dashboards:** priorizar os indicadores usados na decisão inicial; carregar detalhes por painel ou rota.
- **Gráficos:** reduzir pontos ou agregar quando a leitura não exigir cada amostra; disponibilizar dados ou resumo acessível.
- **Formulários extensos:** organizar por etapas significativas, preservar entradas e não remontar seções a cada tecla.
- **Navegação:** medir primeira visita e transições internas; uma SPA pode carregar rápido e navegar lentamente, ou o inverso.
- **Atualizações frequentes:** agrupar atualizações visuais, pausar trabalho desnecessário e testar sessões longas.

Matriz mínima de dados de teste: vazio, típico, alto volume, textos longos, erro de API e rede lenta. O aceite não pode depender exclusivamente de um dashboard sem dados.

## 12. Implementação e infraestrutura que sustentam o design

O agente de design deve apontar dependências; agentes de frontend, arquitetura e infraestrutura precisam assumir sua implementação. Política LF sugerida:

| Camada | Decisão necessária | Evidência de revisão |
|---|---|---|
| Renderização | Escolher SSG, SSR, CSR ou combinação por rota | Conteúdo inicial e custo de servidor/cliente |
| JavaScript | Dividir por rota e funcionalidade; reduzir dependências | Bundle e trabalho da thread principal |
| CSS | Remover estilos sem uso com cuidado; preservar estados dinâmicos | Cobertura e regressão visual |
| Assets | Compressão e variantes no pipeline | Arquivos publicados e bytes transferidos |
| Rede | Reduzir redirects e cadeias de dependências | Waterfall |
| Servidor | Diagnosticar resposta inicial e APIs | Tempos por rota e operação |
| Cache | Diferenciar assets versionados, HTML e dados privados | Cabeçalhos e invalidação |
| Terceiros | Definir proprietário e momento de ativação | Custo com o serviço ativo |

SSR não elimina automaticamente hidratação pesada e pode elevar tempo de servidor. CSR não deve obrigar páginas públicas simples a esperar toda a aplicação para mostrar conteúdo. A escolha depende da rota.

Não aplicar cache público indiscriminadamente a conteúdo personalizado. Não usar `immutable` em URLs cujo conteúdo muda sem versionamento. Preload e preconnect precisam de justificativa; marcar tudo como crítico cria competição.

## 13. Orçamentos de performance

Um orçamento estabelece limites de recursos ou experiência e permite acompanhar regressões. [15] A tabela abaixo é **uma proposta LF para iniciar projetos**, não uma tabela oficial do Google nem garantia de 91 pontos.

Escopo: navegação inicial em produção, cache de navegador vazio, rota representativa, incluindo terceiros efetivamente ativos. KiB = 1024 bytes. Medir transferência comprimida quando aplicável; imagens/fontes podem já estar comprimidas.

| Item | Orçamento inicial proposto |
|---|---:|
| Total transferido no carregamento inicial mobile | ≤ 1000 KiB |
| JavaScript inicial por rota, incluindo dependências | ≤ 170 KiB |
| CSS inicial | ≤ 50 KiB |
| Fontes iniciais, somadas | ≤ 100 KiB |
| Imagem hero escolhida no perfil mobile | ≤ 150 KiB |
| Vídeo decorativo no carregamento inicial | 0 KiB |
| LCP de laboratório, alvo interno | ≤ 2,0 s |
| CLS de laboratório, alvo interno | ≤ 0,05 |
| TBT de laboratório, alvo interno | ≤ 150 ms |

Os subtotais não precisam somar o teto total: HTML, outras imagens e demais recursos também contam. Documentar o final da janela de medição e medir separadamente recursos carregados por interação. Não “cumprir” orçamento apenas transferindo custo para logo depois da captura.

Adaptar os limites após o baseline e a análise do público. Aplicações complexas podem exigir outros orçamentos por rota; registrar exceções sem remover silenciosamente a meta de experiência. Desktop também deve ter controle de recursos, mesmo quando a nota é alta.

## 14. Fluxo proposto para agentes do LF

As responsabilidades abaixo são uma proposta baseada na estrutura do README. Mapear para os agentes existentes; não presumir nomes ou schemas que não foram definidos.

| Papel | Entrega esperada |
|---|---|
| Engineering Manager | Rotas críticas, metas, público e exceções aceitas |
| Orchestrator | Tarefas, dependências, owners e checkpoints |
| Design/UX | Composição responsiva, estados, assets e contratos dos componentes |
| Frontend | Implementação, estratégias de carregamento e análise de bundle |
| Backend/infraestrutura | Resposta inicial, APIs, cache e distribuição |
| QA/performance | Relatórios por perfil e testes das jornadas |
| Tech Lead | Aceite com evidências, riscos e decisões registradas |
| Engineering Knowledge Extractor | Aprendizados reproduzíveis após validação |

### Checkpoints

1. **Briefing:** definir rotas, dispositivos, dados e meta antes do design.
2. **Revisão do design:** validar hierarquia, estados, orçamento de mídia e candidato a LCP.
3. **Primeiro corte funcional:** medir cedo com build de produção e conteúdo realista.
4. **Pré-entrega:** executar protocolo repetível e revisar interação/acessibilidade.
5. **Pós-publicação:** observar RUM, CrUX quando disponível e regressões.

### Organização incorporada ao LF Engineering System

- Módulo canônico: `knowledge/ENGINEERING_DESIGN_PERFORMANCE.md`.
- Protocolo reutilizável: `protocols/PERFORMANCE_VALIDATION.md`.
- Schema do relatório: `schemas/PERFORMANCE_VALIDATION_REPORT.schema.md`.
- Template de cliente: `PROJECT_TEMPLATE/docs/PERFORMANCE_VALIDATION_REPORT.md`.
- Relatórios dos clientes: `docs/PERFORMANCE_VALIDATION_REPORT.md`, quando aplicável.
- Tarefas e decisões: usar os schemas canônicos e os arquivos `.ai/` existentes.

O módulo foi incorporado com atualizações em `knowledge/INDEX.md`,
`knowledge/REGISTRY.md`, agentes, workflows, contratos, schema e template.
Projeto cliente deve consumir a biblioteca somente leitura; futuras mudanças no
framework seguem autorização e governança próprias.

## 15. Protocolo de validação e aceite

**Política LF proposta:** executar cinco medições válidas por rota e perfil, na mesma versão publicada e em condições comparáveis. Guardar todas e usar a mediana, não o melhor resultado. Cinco execuções são uma convenção deste guia.

1. Selecionar home e uma rota de cada template crítico: produto, conteúdo, busca, formulário, dashboard etc.
2. Registrar commit/build, URL final, data UTC, perfil e versão Lighthouse quando disponível.
3. Confirmar build de produção, recursos íntegros e conteúdo representativo.
4. Executar mobile e desktop separadamente. Registrar ambiente e região do PSI quando fornecidos.
5. Para testes locais, controlar cache, extensões e throttling. Não comparar runs com configuração distinta como se fossem equivalentes.
6. Guardar notas, métricas, relatórios e elemento LCP. Conservar execuções lentas válidas; invalidar apenas falhas de ferramenta com justificativa.
7. Investigar dispersão relevante: terceiros, servidor, recursos variáveis e contenção de CPU.
8. Testar jornadas e estados além do carregamento inicial, inclusive rolagem e navegação interna.
9. Repetir após correções que afetem o resultado; não repetir apenas até aparecer uma nota conveniente.
10. Após publicação, acompanhar campo. Não declarar aprovação de Core Web Vitals sem dados adequados.

### Definition of Done sugerida

- [ ] Mediana de Performance ≥ 91 por rota crítica e por perfil.
- [ ] Nenhuma execução válida abaixo de 90 sem investigação e decisão registrada.
- [ ] Orçamentos cumpridos ou exceção rastreável.
- [ ] Hero e conteúdo inicial confirmados no teste; sem atraso artificial.
- [ ] Imagens responsivas, fontes e carregamento conferidos no Network.
- [ ] Layout estável nos estados assíncronos e com conteúdo extenso.
- [ ] Jornadas críticas respondem bem; INP não foi inferido apenas de TBT.
- [ ] Revisão manual de teclado, foco, contraste, zoom e formulários concluída.
- [ ] Serviços de terceiros testados no cenário de uso real.
- [ ] Campo aprovado quando houver dados; caso contrário, status “pendente de amostragem” e acompanhamento definido.

Automatização em CI pode acompanhar budgets e regressões usando uma versão controlada do Lighthouse. PSI serve como verificação externa complementar; seus resultados não são necessariamente idênticos aos locais.

## 16. Diagnóstico e ordem de correção

| Sintoma | Hipótese a verificar | Próximo passo |
|---|---|---|
| Conteúdo inteiro começa tarde | Servidor, redirects ou recursos bloqueantes | Examinar TTFB e waterfall |
| Hero baixa tarde | Descoberta tardia, lazy loading ou prioridade | Conferir HTML inicial e request |
| Hero baixa cedo, aparece tarde | JS, CSS, hidratação ou ocultação | Examinar trace de renderização |
| Mobile ruim, desktop bom | CPU, transferência ou efeitos caros | Reproduzir em perfil mobile |
| Botões respondem tarde | Tarefas longas ou renderização excessiva | Gravar interação no Performance |
| Elementos saltam | Espaço ausente, fonte ou conteúdo inserido | Localizar eventos de layout shift |
| Nota boa, usuários reclamam | Jornada não medida ou público distinto | Analisar RUM e segmentar |

Ordem LF sugerida: corrigir indisponibilidade e falhas funcionais; identificar gargalo principal com evidência; reduzir bloqueios de conteúdo/interação; estabilizar layout; tratar assets e terceiros; refinar efeitos. Reordenar conforme o diagnóstico, em vez de seguir uma lista às cegas.

## 17. Antipadrões proibidos na política proposta

- Prometer nota fixa sem medir a versão publicada.
- Remover funcionalidades ou entregar página especial ao auditor para aumentar a nota.
- Tratar placeholder vazio como conteúdo concluído.
- Aplicar lazy loading ao hero crítico.
- Carregar toda biblioteca de ícones ou animações por conveniência sem avaliar custo.
- Ocultar mídia desktop no mobile e assumir que não será baixada.
- Transformar todo recurso em preload ou prioridade alta.
- Reduzir contraste, área de toque ou legibilidade para cumprir estética.
- Concluir que a aplicação inteira está aprovada porque a home pontuou bem.
- Confundir Performance, conformidade de acessibilidade, Core Web Vitals e SEO.

## 18. Modelos reutilizáveis

### Brief de design e performance

```yaml
# Modelo ilustrativo; adaptar ao schema canônico do LF.
objetivo: ""
rotas_criticas: []
publico_e_dispositivos: ""
conteudo_inicial: ""
acao_principal: ""
candidato_lcp_mobile: ""
candidato_lcp_desktop: ""
assets_e_variantes: []
fontes_e_pesos: []
estados: [loading, vazio, sucesso, erro, dados_extensos]
terceiros_e_ativacao: []
budgets_por_rota: {}
acessibilidade_manual: []
excecoes: []
```

### Registro de validação

```yaml
# Campos vazios indicam evidência ainda não coletada.
build_commit: ""
url_ou_rota: ""
data_utc: ""
ferramenta_versao: ""
perfil: "mobile ou desktop"
ambiente_cache_rede_cpu: ""
dados_e_cenario_terceiros: ""
execucoes_validas: [] # score, LCP, FCP, SI, TBT, CLS e relatório
mediana_performance: null
elemento_lcp: ""
rum_crux: {escopo: "", periodo: "", amostra: "", status: ""}
jornadas_testadas: []
revisao_acessibilidade: ""
desvios_e_acoes: []
responsavel: ""
decisao_aceite: ""
```

### Instrução de trabalho para agentes

> Aplicar o módulo de design e performance aprovado pelo projeto. Antes de implementar, identificar rotas críticas, conteúdo inicial, candidatos a LCP e orçamento dos assets. Preservar semântica, responsividade e estados de interação. Justificar recursos caros e dependências. Validar build de produção em mobile e desktop e anexar evidências de carregamento e jornadas. Não declarar nota ou Core Web Vitals sem medição. Registrar exceções e aprendizados usando os protocolos canônicos. Não alterar a biblioteca LF a partir do projeto cliente sem autorização.

## 19. Fontes oficiais e manutenção

Referências consultadas em 18/10/2026. As políticas LF, budgets, modelos e procedimentos propostos são recomendações deste guia. Não representam regras oficiais do Google ou integração já implementada no repositório.

1. Google — [About PageSpeed Insights](https://developers.google.com/speed/docs/insights/v5/about).
2. Chrome Developers — [Lighthouse performance scoring](https://developer.chrome.com/docs/lighthouse/performance/performance-scoring).
3. web.dev — [Web Vitals](https://web.dev/articles/vitals).
4. web.dev — [Image performance](https://web.dev/learn/performance/image-performance).
5. web.dev — [Optimize Largest Contentful Paint](https://web.dev/articles/optimize-lcp).
6. web.dev — [Optimize web fonts](https://web.dev/learn/performance/optimize-web-fonts).
7. web.dev — [Best practices for fonts](https://web.dev/articles/font-best-practices).
8. web.dev — [Optimize Cumulative Layout Shift](https://web.dev/articles/optimize-cls).
9. web.dev — [High-performance CSS animations](https://web.dev/articles/animations-guide).
10. web.dev — [Optimize Interaction to Next Paint](https://web.dev/articles/optimize-inp).
11. web.dev — [Avoid large, complex layouts and layout thrashing](https://web.dev/articles/avoid-large-complex-layouts-and-layout-thrashing).
12. web.dev — [Video performance](https://web.dev/learn/performance/video-performance).
13. W3C — [Understanding contrast minimum](https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html).
14. W3C — [Understanding target size minimum](https://www.w3.org/WAI/WCAG22/Understanding/target-size-minimum.html).
15. web.dev — [Performance budgets 101](https://web.dev/articles/performance-budgets-101).

Revisar o módulo quando Lighthouse, Core Web Vitals, stack, público ou componentes mudarem. Novos aprendizados devem conter contexto, evidência antes/depois e limites de aplicabilidade.
