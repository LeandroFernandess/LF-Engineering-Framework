# Registro de alterações

Idiomas: [EN-US](../../../CHANGELOG.md) | [PT-BR](CHANGELOG.md)

Idioma-fonte: EN-US<br>
Versão da fonte: `v1.5.0` mais manutenção pós-tag não lançada<br>
Baseline publicada: `v1.5.0`, primeira release pública<br>
Fonte: `CHANGELOG.md`

Todas as mudanças relevantes no **LF Engineering Framework** são registradas neste arquivo.

Este projeto segue uma estratégia de versionamento estruturada, na qual cada release representa uma evolução significativa da metodologia de engenharia.

As versões anteriores a `v1.5.0` abaixo são registros históricos do repositório
privado predecessor. Seu histórico Git, branches, tags e artefatos de release não
foram migrados para este repositório público limpo.

# Não lançado

## Adicionado

* Adicionadas orientações opcionais e independentes de tecnologia para
  simuladores visuais interativos orientados por modelo, incluindo proveniência
  do modelo, estado compartilhado, revisão numérica, controle do usuário e
  evidências visuais.
* Adicionado um modelo opcional e copiável de primeiro prompt para iniciar
  projetos, com limites explícitos de aprovação e sugestões de MCP do criador não
  obrigatórias.

## Alterado

* Ampliadas as orientações condicionais existentes de motion design e o workflow
  do projeto sem adicionar agente, fase de workflow, dependência externa ou meta
  fixa de performance.

---

# Versão 1.5.0

Status da release

Estável; primeira release pública, publicada em 2026-11-03 após validação multiplataforma

Tipo de release

Snapshot público limpo e distribuição neutra do Framework

## Adicionado

* Publicado o primeiro snapshot público limpo em
  `LeandroFernandess/LF-Engineering-Framework`. Nenhum commit, branch ou tag do
  repositório privado predecessor foi importado; `v1.4.0` permanece histórica e
  não é uma tag deste repositório.
* Adicionado um inspetor de segurança local, somente leitura e preliminar, com
  redação e testes de regressão para links simbólicos; ele não substitui a
  revisão QA-Security.
* Habilitado GitHub Private Vulnerability Reporting e incluído um e-mail público
  autorizado na política de segurança.

## Alterado

* Adicionado `/.ai/state/` ao `.gitignore` de projetos gerados para manter o
  estado de coordenação local por padrão. Arquivos `.gitignore` de projetos
  existentes continuam preservados e exigem adoção manual da regra.
* Renomeados os arquivos de release para `lf-engineering-framework-v<VERSION>`,
  alinhando-os ao repositório público e ao nome do Framework.
* Atualizados os comandos de clone, os metadados de publicação e os baselines de
  release EN-US/PT-BR para o repositório público.

## Corrigido

* Adicionado checkout da tag validada no job de publicação com privilégio
  mínimo antes de `gh release create --verify-tag`, além de conferir se o commit
  local corresponde ao commit testado. Isso corrige a falha de publicação sem
  repositório Git e preserva a verificação da tag remota e o gatilho exclusivo
  por tag.
* O bootstrap passou a recusar gravações por diretórios-pai vinculados no
  projeto-alvo, impedindo a criação de arquivos de template fora do destino
  selecionado; foram adicionados testes de regressão para shell e PowerShell.
* O bootstrap passou a restringir diretórios e arquivos `.ai/state` ao usuário
  atual (0700/0600 em POSIX e ACL somente do proprietário no Windows), inclusive
  entradas existentes durante `--apply`, preservando seu conteúdo.

---

# Versão 1.4.0

Status da release

Release histórica do repositório predecessor; publicada em 2026-11-01; nenhuma tag ou artefato público foi migrado

Tipo de release

Distribuição neutra em relação a fornecedores

## Adicionado

* Adicionado um workflow opcional de auditoria de dívida técnica, somente leitura, com schema e template de relatório para projetos clientes, incluindo requisitos de evidências, contraevidências, esforço e priorização.
* Adicionados espelhos PT-BR do workflow, schema e template de relatório da auditoria de dívida técnica, com sincronização do template de projeto, das orientações de qualidade, dos registros e do conhecimento dos agentes afetados.
* Adicionado um caminho opcional, solicitado explicitamente, para proposta inicial de direção visual no Design System Analyst e nos artefatos `DESIGN.md`, com classificação de evidências, aprovação e salvaguardas para tokens existentes.
* Adicionadas orientações condicionais `ENGINEERING_MOTION_DESIGN` sobre intenção de movimento, coreografia, comportamento para movimento reduzido, neutralidade de implementação e revisão baseada em evidências; atualizados o handoff de design e o relatório de performance.
* Sincronizadas em PT-BR as orientações do caminho opcional de direção visual; nenhum catálogo externo foi copiado.
* Adicionadas verificações de qualidade condicionais para workflows de IA, autorização em nível de recurso e confirmação de ações externas consequentes, além de um checklist condicional de integração de APIs no Field Guide existente.
* Sincronizadas em PT-BR as novas orientações de qualidade, QA-Security e APIs; nenhum módulo, agente, dependência, CLI ou fase obrigatória de workflow foi adicionado.
* Aprovados quatro módulos suplementares de Knowledge como referências opcionais na release `v1.4.0`, com limites explícitos contra adoção obrigatória e instalação ou integração de ferramentas externas.
* Adicionado o registro da avaliação independente Elephant-Goldfish: a compreensão em sessão nova passou com ressalvas; crítica e prontidão para implementação não passaram. Não se afirma sucesso do piloto nem prontidão para produção.

## Alterado

* Fortalecidas as orientações de qualidade para operações de ferramentas que transformam arquivos e para revisão de artefatos visuais renderizados; validação estrutural, por si só, não é aprovação visual.
* Retirado o módulo suplementar proposto de pesquisa com usuários antes da release, após uma simulação somente documental; nenhum piloto com participantes reais foi realizado.
* Mantidas inalteradas a sequência padrão de desenvolvimento, a versão da release do Framework e a superfície de dependências neutra em relação a fornecedores. A adoção seletiva foi registrada no ADR-006, a retirada do módulo no ADR-007, a orientação de direção visual no ADR-008, as orientações de workflow de IA, autorização e APIs no ADR-009 e os limites do GitHub MCP opcional no ADR-011. Nenhuma CLI, dependência de runtime ou fase obrigatória de workflow foi adicionada ao caminho padrão `generic`.
* Mantidos `generic` como padrão e `v1.3.0` intacta. A adoção de motion design está registrada no ADR-013; nenhuma CLI, dependência de runtime, skill externa obrigatória ou fase de workflow foi adicionada.
* Tornadas neutras em relação a modelos e harnesses as especificações canônicas de agentes e os perfis de execução; integrações específicas de plataforma permanecem em adapters opcionais.
* Atualizados status, índices, registros e validação de locale dos módulos em EN-US/PT-BR para refletir a adoção opcional aprovada, mantendo inalterados o grafo obrigatório de dependências, o padrão `generic` e a `v1.3.0` publicada.
* Versionados os módulos de Knowledge atualizados e adicionadas verificações de locale para confirmar versões correspondentes nos quatro espelhos opcionais aprovados.
* Mantida opcional e desativada por padrão a configuração GitHub MCP do Framework; quando habilitada explicitamente, usa uma imagem fixada, uma superfície de ferramentas MCP somente leitura e callback OAuth em loopback. Ela não é copiada para projetos clientes.
* Separada a cobertura PT-BR da tag publicada `v1.3.0` das traduções de alterações pós-tag, e alinhado o validador PowerShell ao baseline de tradução `1.3.0`.
* Atualizadas as evidências de identidade e proveniência do Graphify, incluindo a distinção do site oficial sobre `graphiffy.com`; o módulo foi aprovado como opcional, mas a proveniência entre fonte e build permanece sem solução e nenhum uso adicional da ferramenta está autorizado.
* Fortalecido o workflow de release com validação estrita de tags estáveis, verificação do commit testado, gate de CI multiplataforma, empacotamento somente leitura e publicação com privilégio mínimo. Por decisão do responsável, a publicação não usa GitHub Environment nem gate de aprovação manual: o push de uma tag estável correspondente publica automaticamente após a validação. O push exige autorização separada do responsável e é o único gatilho de release do workflow. Como o repositório tem um único responsável, rulesets de branch/tag não são necessários; acesso de escrita/admin exclusivo do responsável e autorização separada antes do push da tag são os controles operacionais. Reavaliar se o acesso de escrita for ampliado.
* Ampliada a suíte de regressão do bootstrap PowerShell no Windows para verificar que omitir `-Adapter` seleciona o padrão `generic`.
* Esclarecido que os validadores locais não exercitam a geração dos archives de release, que depende das verificações multiplataforma do commit marcado.
* Alinhados os exemplos de configuração e o status do roadmap ao baseline publicado `v1.3.0`.
* Identificado o PDF da auditoria de segurança de 2026-10-19 como evidência histórica; sua data e seus achados não são apresentados como auditoria atual.
* Alinhado o status da capa do PDF histórico da auditoria de segurança à conclusão do sumário executivo; o snapshot permanece datado de 2026-10-19.
* Adicionados espelhos PT-BR do overview, roadmap, changelog, registros ADR públicos ativos e dos quatro módulos suplementares de Knowledge. Verificações dedicadas exigem os espelhos suplementares e validam seu status opcional aprovado e sua estrutura, sem incluí-los no grafo obrigatório de dependências.
* Agrupados os documentos públicos traduzidos em `locales/pt-BR/` e atualizada a validação de paridade de locale. A organização da fonte EN-US e dos espelhos PT-BR foi registrada no ADR-015.
* Removidos os aliases PT-BR da raiz e o playbook legado de Framework, já substituído. O guia-fonte de design/performance foi movido para `docs/reference/` porque o Knowledge canônico cita seu racional; validadores e o gerador da auditoria foram atualizados sem reescrever o PDF histórico.
* Mantido um único arquivo de release contendo os dois pacotes de idioma; o bootstrap continua selecionando explicitamente o idioma do projeto.

---

# Versão 1.3.0

Status da release

Estável

Tipo de release

Distribuição neutra em relação a fornecedores

---

## Adicionado

* Adicionados scripts nativos de bootstrap para macOS/Linux e Windows PowerShell, com comportamento seguro de dry-run e cópia somente de arquivos ausentes em projetos novos e existentes.
* Adicionadas seleção explícita dos idiomas `en-US`/`pt-BR` e informações sobre cobertura de tradução.
* Adicionados adapters opcionais `generic`, `codex`, `claude`, `gemini` e `opencode`.
* Adicionado o ponto de entrada neutro `LF_ENGINEERING.md` para projetos e um template de projeto traduzido para PT-BR.
* Adicionados validadores nativos do Framework/bootstrap, testes reproduzíveis do bootstrap e matriz do GitHub Actions para Ubuntu, macOS e Windows.
* Adicionadas orientações de contribuição, segurança, issues e pull requests em EN-US e PT-BR.
* Adicionada documentação bilíngue de testes que cobre a matriz local e de CI.
* Adicionadas verificações estruturais de paridade do template PT-BR para hierarquia de títulos, tabelas, blocos de código e limites de comentários HTML.
* Adicionadas traduções PT-BR dos workflows, protocolos e schemas canônicos, com validação de paridade estrutural.
* Adicionadas traduções PT-BR da documentação canônica dos agentes e dos módulos de Knowledge estáveis, com validação de correspondência de arquivos e paridade estrutural.
* Atualizadas as etapas de checkout do GitHub Actions para `actions/checkout@v5`, para o runtime Node.js 24.
* Tornada determinística entre localidades de runners a validação de placeholders e fortalecida a resolução de fronteiras do PowerShell em raízes do sistema de arquivos.
* Ajustada a asserção de preservação do bootstrap Windows para aceitar separadores de caminho nativos.
* Adicionados testes de regressão de fronteira com symlinks/junctions aos bootstraps nativos, para impedir acesso a caminhos do Framework por links de diretório.
* Adicionado um workflow reproduzível de release com tag que cria arquivos compactados e checksums SHA-256.
* Atualizada a auditoria de segurança regenerável para o template neutro em relação a fornecedores, o adapter OpenCode V2 atual e o bootstrap que copia somente arquivos ausentes.
* Removidos dos exemplos de conhecimento publicados os caminhos de sistema de arquivos específicos do mantenedor.

## Alterado

* Definido `generic` como modo padrão do bootstrap; `PROJECT_TEMPLATE/` não exige mais OpenCode.
* Documentado EN-US como idioma-fonte técnico e PT-BR como tradução sincronizada.
* Alinhados o workflow canônico e o playbook legado com `Implementation / selected CLI` em vez de uma implementação específica de fornecedor.

## Nota de escopo

As bibliotecas canônicas `agents/` e de Knowledge estável possuem espelhos PT-BR. As quatro avaliações suplementares propostas de Knowledge permanecem fora do gate obrigatório de locale e são identificadas explicitamente no status de tradução. Prompts legados de `SPECS.md` em português são espelhados como artefatos de configuração, não apresentados como traduções da fonte inglesa. A execução nativa em Windows, a verificação autenticada do repositório/Actions e os arquivos/checksums da release foram confirmados para a release estável `v1.3.0`.

---

# Versão 1.2.0

Status da release

Em revisão

Tipo de release

Segurança, workflow, performance e limpeza da publicação

---

## Adicionado

* Gate de fronteira de confiança e prompt injection para QA-Security.
* Matriz de aplicabilidade de segurança para injection, XSS, identidade/acesso, segredos e deployment/configuração.
* Verificações de estado local, artefatos temporários, retenção e permissões do sistema de arquivos.
* ADR-001 documentando as decisões de fronteira do Framework, bootstrap e estado local.
* Workflow condicional de design-performance para projetos web e visuais, com validação mobile/desktop separada e protocolo reutilizável de relatório.

## Alterado

* Migrado o template de projeto do objeto obsoleto `permission` do OpenCode V1 para regras ordenadas `permissions` do OpenCode V2.
* Leituras do Framework são permitidas para projetos clientes, enquanto edições nele são negadas pelo template.
* Bootstrap de macOS e PowerShell agora recusa destinos não vazios, preserva arquivos ocultos do template, escapa caminhos, valida JSON e substitui somente a configuração gerada.
* Adicionadas regras de ignore na raiz e no template para caches locais de workflow e validação.
* Restringido o estado atual de `workflow-graph/` a permissões Unix exclusivas do proprietário.
* Adicionados `ENGINEERING_DESIGN_PERFORMANCE`, `PERFORMANCE_VALIDATION.md`, schema/template do relatório de performance e pontos de aceite por rota/perfil em todo o workflow.
* Limpa a superfície de publicação removendo placeholders de projetos clientes na raiz, material de continuidade desatualizado, dependências locais de OpenCode e cache Python gerado; estado do mantenedor e de workflow-graph foi arquivado fora da raiz, preservando o template de cliente e as evidências de auditoria.
* Adicionados comandos nativos de adoção por dry-run e cópia somente de arquivos ausentes para macOS/Linux e Windows PowerShell; arquivos existentes do projeto e configuração OpenCode são preservados.

## Observações

Projetos clientes existentes podem usar os comandos seguros de adoção, mas ainda precisam migrar ou mesclar manualmente uma configuração OpenCode existente. A execução nativa em Windows permanece como acompanhamento, pois a validação usou PowerShell multiplataforma no host de auditoria.

---

# Versão 1.1.0

Status da release

Estável

Tipo de release

Evolução menor do Framework

---

## Adicionado

### Agentes de IA

Adicionados dois novos agentes especializados de engenharia:

* Agente Design System Analyst.
* Agente Engineering Knowledge Extractor.

Cada agente inclui:

* README.
* CONTEXT.
* KNOWLEDGE.
* CONFIGURATION.
* SPECS.
* CHANGELOG.

### Agente Design System Analyst

* Analisa referências visuais (capturas de tela, mockups, interfaces) e produz documentação de engenharia estruturada.
* Artefato principal: `DESIGN.md`.
* Posicionado condicionalmente entre Product Owner e Software Architect.
* Abrange identidade visual, paleta de cores, tipografia, espaçamento, layout, componentes, interações, acessibilidade, design tokens e considerações de implementação frontend.

### Agente Engineering Knowledge Extractor

* Transforma projetos concluídos em conhecimento de engenharia reutilizável.
* Artefato principal: `PROJECT_KNOWLEDGE.md`.
* Posicionado após a aprovação de entrega pelo Tech Lead.
* Abrange resumo do projeto, stack técnica, decisões de engenharia, novas tecnologias, novo conhecimento de engenharia e recomendações de melhoria do Framework.

### Schemas

* `DESIGN.schema.md`.
* `PROJECT_KNOWLEDGE.schema.md`.

### Adapters OpenCode

* `.opencode/agents/design-system-analyst.md`.
* `.opencode/agents/engineering-knowledge-extractor.md`.

### Atualizações de documentação

* Atualizado `AGENT_INTERACTION_MAP.md` com os dois novos agentes, novo pipeline, regras de handoff e pontos de decisão.
* Atualizado `knowledge/REGISTRY.md` com os dois novos agentes.
* Atualizado `knowledge/INDEX.md` com os novos consumidores primários.
* Atualizado `.ai/contracts.md` com `DESIGN.md` e `PROJECT_KNOWLEDGE.md`.
* Atualizado `workflows/STANDARD_DEVELOPMENT.md` com os dois novos agentes.
* Atualizado `.opencode/orchestrator.md` com os dois novos agentes e regras de seleção.
* Atualizado `ROADMAP.md` com as entregas da v1.1.

---

## Alterado

Nenhuma alteração.

Todas as mudanças são aditivas. Nenhum comportamento existente foi alterado.

---

## Removido

Nada.

---

## Observações

A versão 1.1.0 introduz dois agentes especializados e preserva compatibilidade retroativa completa com a v1.0.0.

O Design System Analyst é condicional: atua somente quando existem referências visuais.

O Engineering Knowledge Extractor atua após a entrega: não bloqueia a entrega e suas recomendações exigem revisão humana.

Todos os agentes, workflows, módulos de conhecimento e regras de governança existentes permanecem inalterados.

---

# Releases futuras

Versões subsequentes devem registrar somente mudanças de engenharia concluídas.

Ideias planejadas pertencem ao documento `ROADMAP.md`.

O CHANGELOG deve permanecer um registro histórico somente de melhorias implementadas.

---

# Versão 1.0.0

Status da release

Estável

Tipo de release

Release inicial do Framework

---

## Adicionado

### Fundação de engenharia

* Release inicial do LF Engineering Framework.
* Filosofia de engenharia e princípios fundamentais.
* Workflow padronizado de engenharia assistida por IA.
* Modelo de governança do Framework.
* Estratégia de versionamento.

### Sistema de conhecimento

* Arquitetura completa de Engineering Knowledge.
* Módulo Engineering Foundations.
* Módulo Engineering Workflow.
* Módulo Engineering Standards.
* Módulo Engineering Quality.
* Módulo Engineering Decisions.
* Módulo Engineering Artifacts.
* Módulo Engineering Templates.
* Módulo Engineering Continuous Improvement.
* Módulo Engineering AI Collaboration.
* Módulo Engineering Agent Guidelines.
* Módulo Engineering Field Guide.

### Agentes de IA

Adicionados os primeiros agentes especializados oficiais de engenharia:

* Agente Prompt Architect.
* Agente Product Owner.
* Agente Software Architect.
* Agente Sprint Planner.
* Agente Code Reviewer.
* Agente Quality Assurance & Security.
* Agente Documentation & Technical Writer.
* Agente Tech Lead.

Cada agente inclui:

* README.
* CONTEXT.
* KNOWLEDGE.
* CONFIGURATION.
* CHANGELOG.

### Documentação

* Documentação do projeto na raiz.
* Mapa de interação entre agentes.
* Documentação do Framework.
* Roadmap.
* Organização do repositório.

---

## Alterado

Nenhuma alteração.

Esta é a release pública inicial.

---

## Removido

Nada.

---

## Observações

A versão 1.0.0 estabelece a primeira implementação completa do LF Engineering Framework.

Esta release concentra-se em criar uma metodologia estruturada de engenharia, apoiada por agentes de IA especializados e uma base compartilhada de conhecimento de engenharia.

Versões futuras priorizarão refinamento em vez de expansão, preservando a simplicidade e a capacidade de manutenção do framework.

---

# Releases futuras

Versões subsequentes devem registrar somente mudanças de engenharia concluídas.

Ideias planejadas pertencem ao documento `ROADMAP.md`.

O CHANGELOG deve permanecer um registro histórico somente de melhorias implementadas.
