# Protocolo de validação de performance

## Objetivo

Definir um gate repetível e baseado em evidências para performance e experiência
responsiva em projetos com interfaces web ou visuais. O protocolo valida mobile
e desktop de forma independente, preservando acessibilidade, funcionalidade e
identidade visual.

## Quando usar

Use este protocolo quando o projeto tiver UI web, site público, interface
autenticada, dashboard, checkout, catálogo, busca, formulário ou outra rota
visual. Para sistemas não visuais, registre `Não aplicável` (`Not applicable`) e identifique a
superfície inspecionada em vez de inventar medições de navegador.

## Responsáveis e handoffs

- Design System Analyst: contrato de design, estados responsivos e candidatos a
  LCP.
- Software Architect: estratégia de runtime, renderização, entrega e orçamento.
- Sprint Planner: tarefas executáveis de medição e correção.
- Implementation / selected CLI: implementação e configuração de testes
  repetíveis.
- Code Reviewer: revisão de regressão e cobertura de rotas.
- QA-Security: execução, evidências, revisão de acessibilidade e responsável pelo
  relatório.
- Tech Lead: aceite, bloqueio ou exceção documentada.

## Entradas obrigatórias

- `docs/PRD.md` aprovado com rotas críticas e requisitos de experiência.
- `docs/DESIGN.md` quando disponível (análise de referências ou direção inicial solicitada explicitamente); não é obrigatório quando não houver referências nem solicitação de proposta.
- `docs/ARCHITECTURE.md` aprovado com decisões de renderização e entrega.
- `docs/SPRINTS.md` com tarefas de performance e critérios de aceite.
- Build de produção e dados representativos.
- Ferramenta/versão de medição controlada, como Lighthouse ou PageSpeed
  Insights, registrada no relatório.
- Quando houver movimento no escopo, contrato de movimento aprovado ou critérios
  de aceite do produto em `docs/DESIGN.md` ou `docs/PRD.md`, além das restrições
  relevantes de implementação em `docs/ARCHITECTURE.md`.

Se faltar uma entrada, registre a limitação e não marque o gate relacionado como
concluído sem uma exceção aprovada.

## Seleção de rotas e perfis

Selecione a página inicial e uma rota representativa para cada template crítico,
como produto, conteúdo, busca, formulário, dashboard ou checkout. Inclua rotas
autenticadas com uma sessão de teste; nunca publique telas privadas apenas para
torna-las visíveis ao PageSpeed Insights.

Para cada rota selecionada, execute os dois perfis:

| Perfil | Contexto obrigatório |
| --- | --- |
| Mobile | viewport, throttling de CPU/rede, emulação de dispositivo ou dispositivo real e região quando disponível. |
| Desktop | viewport, condições de CPU/rede, dispositivo ou ambiente e região quando disponível. |

Não combine perfis, rotas, versões da ferramenta ou condições de rede
materialmente diferentes como se fossem comparáveis.

## Preparação

1. Use o build de produção publicado ou um build de produção equivalente.
2. Registre commit/build, URL ou rota, data UTC, versão da ferramenta, versão do
   navegador, perfil, região, estado do cache, throttling, extensões e dados de
   teste.
3. Confirme que os recursos estão íntegros e que a rota testada contém conteúdo
   real e representativo e terceiros ativos.
4. Identifique e registre o elemento LCP candidato separadamente para mobile e
   desktop.
5. Meça navegação inicial e, quando aplicável, navegação interna, rolagem,
   filtros, formulários, grandes conjuntos de dados e estados de erro/retry.

## Execução

1. Faça cinco execuções válidas para cada rota e perfil selecionados em condições
   comparáveis. Cinco execuções são a convenção de baseline do LF, não uma
   garantia estatística.
2. Preserve todas as execuções válidas, inclusive as lentas. Invalide apenas
   falhas da ferramenta ou capturas inutilizáveis, com o motivo no relatório.
3. Registre Performance score, LCP, FCP, Speed Index, TBT, CLS e o elemento LCP
   em cada execução. Registre TTFB como diagnóstico de resposta do servidor e
   evidências de interação e INP quando disponíveis.
4. Calcule e informe a mediana por rota/perfil; nunca selecione a melhor execução.
5. Investigue dispersões relevantes, incluindo resposta do servidor,
   redirecionamentos, terceiros, contenção de CPU e recursos variáveis.
6. Repita após mudanças que possam afetar performance. Não repita até aparecer
   uma pontuação conveniente.

## Gate de aceite

Para cada rota crítica e cada perfil:

- [ ] A mediana do Performance score é `>= 91`; a meta `>= 95` é informada
      separadamente.
- [ ] Nenhuma execução válida abaixo de `90` permanece sem investigação e sem
      responsável, mitigação, risco e decisão registrados.
- [ ] Os orçamentos de recursos foram atendidos ou existe exceção aprovada e
      rastreável.
- [ ] O LCP candidato e o conteúdo crítico foram confirmados sem atraso
      artificial.
- [ ] Imagens responsivas, fontes, ordem de carregamento e waterfall de rede
      foram revisados.
- [ ] O layout permanece estável com conteúdo assíncrono, textos longos, zoom e
      dados lentos.
- [ ] As jornadas críticas respondem adequadamente; INP não é inferido a partir
      de TBT.
- [ ] A revisão manual de teclado, foco, contraste, zoom, reflow, formulários e
      movimento reduzido foi concluída.
- [ ] A Revisão de movimento condicional foi concluída quando houver movimento
      no escopo ou explicitamente marcada como não aplicável com a superfície
      inspecionada.
- [ ] Terceiros foram testados no cenário em que estão realmente ativos.
- [ ] O status de campo é explícito: aprovado com dados suficientes ou amostragem
      pendente com responsável pelo monitoramento e data de acompanhamento.

Performance, acessibilidade, Best Practices e SEO devem ser reportados como
dimensões separadas. Pontuações automatizadas não substituem revisão manual de
acessibilidade nem validação funcional do produto.

## Revisão de movimento

Quando animações, transições, microinterações, efeitos vinculados à rolagem ou
assets visuais animados fizerem parte do escopo, inclua uma Revisão de movimento
em `docs/PERFORMANCE_VALIDATION_REPORT.md`. Registre rotas e estados
representativos, o propósito e o comportamento aprovados, resultados normal e
com movimento reduzido, acesso por teclado/toque, diferenças responsivas,
evidências e riscos não resolvidos. Use uma gravação ou evidência temporal
equivalente quando imagens estáticas não mostrarem o comportamento. Meça a
performance quando o efeito for identificado como risco; não invente uma meta
universal de taxa de quadros nem trate uma verificação do código-fonte como
prova de fluidez.

Se não houver movimento no escopo, registre `Não aplicável` e a superfície
inspecionada. A revisão de movimento não substitui os gates separados de
performance mobile/desktop, acessibilidade ou aceite funcional.

Resumos de métricas de laboratório na tabela de resultados devem ser rotulados
como medianas de laboratório (ou outro resumo explicitamente declarado). Core
Web Vitals de campo devem ser reportados como valores p75 com fonte, escopo,
período móvel e suficiência da amostra; não substitua p75 de campo por medianas
de laboratório.

## Evidências de campo

Quando CrUX ou RUM estiver disponível, registre se o resultado cobre a URL ou a
origem, seu período móvel, suficiência da amostra e segmento mobile/desktop. Os
dados de campo do CrUX podem refletir uma janela móvel de 28 dias. Ausência de
dados é `Evidência insuficiente` (`Insufficient evidence`), não `Aprovado`
(`Approved`).

Para áreas autenticadas, use Lighthouse com uma sessão de teste e RUM do
projeto. Não exponha dados privados a um serviço público de auditoria.

## Relatório obrigatório

Crie `docs/PERFORMANCE_VALIDATION_REPORT.md` quando aplicável. Ele deve incluir:

```markdown
# Relatório de validação de performance

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
- Condições de cache/rede/CPU:
- Região:
- Dados representativos e terceiros ativos:

## Metas e orçamentos
- Mínimo de Performance mediana: 91
- Meta de engenharia: 95
- Orçamentos por rota e exceções aprovadas:

## Resultados
<!-- Salvo indicação diferente, os valores desta tabela são medianas de laboratório nas execuções válidas. -->
| Rota | Perfil | Execuções válidas | Scores (cada execução válida) | Mediana | LCP | INP | CLS | TBT | TTFB | FCP | Speed Index | Elemento LCP | Decisão |
|---|---|---:|---|---:|---:|---:|---:|---:|---:|---:|---:|---|---|

## Revisão de jornada e acessibilidade
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
- Status: Aprovado (`Approved`) / Aprovado com recomendações / Ajustes necessários / Bloqueado
- Responsável:
- Acompanhamento:
```

## Regras contra manipulação

- Não remova funcionalidade, conteúdo ou terceiros reais apenas para o teste.
- Não sirva uma experiência especial para o auditor.
- Não use skeleton vazio ou placeholder como conteúdo bem-sucedido.
- Não esconda mídia mobile ou desktop supondo que isso elimine seu custo de
  transferência.
- Não faça preload ou priorize todos os recursos.
- Não declare aprovação da aplicação inteira com base em uma rota ou perfil.

## Protocolos relacionados

- `protocols/ARTIFACT_UPDATE.md`
- `protocols/DECISION_RECORD.md`
- `protocols/TASK_UPDATE.md`
- `protocols/WORKFLOW_UPDATE.md`
