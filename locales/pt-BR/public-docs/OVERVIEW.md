# Visão geral do LF Engineering System

Idiomas: [EN-US](../../../OVERVIEW.md) | [PT-BR](OVERVIEW.md)

Baseline publicada: 1.5.0<br>
Status: primeira release pública estável `v1.5.0` publicada em 2026-11-03<br>
Última atualização da fonte: 2026-11-03<br>
Baseline desta tradução: conteúdo publicado em `v1.5.0`; releases anteriores são históricas no repositório predecessor privado<br>
Fonte: `OVERVIEW.md`

## Objetivo

Este documento registra o estado atual e o baseline público do LF Engineering System, as decisões de publicação que moldam o repositório e o contexto para uma futura interface baseada em grafo.

O LF Engineering System é um framework de engenharia de software assistida por IA composto por:

- Princípios de engenharia e governança.
- Módulos de conhecimento compartilhado.
- Agentes especializados de engenharia.
- Workflows e handoffs.
- Contratos de artefatos e schemas.
- Templates de bootstrap de projetos.
- Bootstrap neutro em relação a fornecedores, com adapters de CLI opcionais.
- Documentação-fonte EN-US e pacotes de tradução PT-BR.
- Melhoria contínua por meio da extração de conhecimento de projetos.

O Framework continua sendo a fonte canônica da verdade. Ferramentas externas e agentes de IA são assistentes, não autoridades.

A primeira release pública, `v1.5.0`, inclui o snapshot do Framework e as quatro mudanças de manutenção feitas após a `v1.4.0` no repositório privado predecessor. O histórico, branches, tags e artefatos daquele repositório não foram migrados; `v1.4.0` é contexto histórico e não possui tag neste repositório público. O adapter `generic` continua sendo o padrão, enquanto adapters de CLI nomeados permanecem opcionais e contêm somente integração específica de plataforma.

## Estado atual

O repositório contém o Framework canônico, agentes especializados, módulos de conhecimento, workflows, protocolos, schemas, o `PROJECT_TEMPLATE/` neutro em relação a fornecedores, scripts nativos de bootstrap, pacotes de idioma e adapters opcionais. `.opencode/` é a fonte de compatibilidade do Framework e inclui uma configuração opcional do GitHub MCP, desativada por padrão e não copiada pelo bootstrap. O repositório público é `LeandroFernandess/LF-Engineering-Framework`; ele começa com um único commit limpo na branch `main`, sem o histórico, branches ou tags do repositório predecessor.

Os documentos públicos de contexto da release e os quatro módulos suplementares opcionais aprovados de Knowledge têm espelhos PT-BR no checkout atual. Os espelhos suplementares são verificados separadamente quanto à presença, correspondência de versões, status opcional aprovado e paridade estrutural; permanecem fora do grafo obrigatório de dependências. A aprovação não autoriza instalação ou integração de ferramentas externas. A avaliação independente Goldfish do piloto de motion design passou na compreensão com ressalvas, mas não passou na crítica nem na prontidão para implementação; o piloto não comprova um gate de prontidão bem-sucedido.

O bootstrap padrão copia a base neutra do projeto usando comandos nativos de shell no macOS/Linux ou Windows PowerShell. Aceita a seleção explícita do idioma `en-US` ou `pt-BR` e usa o adapter `generic` por padrão. A configuração OpenCode é gerada somente quando `--adapter opencode` é selecionado; arquivos e configurações existentes são preservados. O servidor GitHub MCP separado, usado no próprio repositório do Framework, fica desativado por padrão, tem a imagem fixada em uma release, é restrito a ferramentas de repositório somente leitura e exige habilitação local explícita. Ele não altera o adapter de projetos clientes nem o caminho `generic`.

O agente QA-Security agora inclui uma etapa obrigatória de fronteira de confiança e resistência a prompt injection, uma matriz de aplicabilidade das categorias de segurança solicitadas e verificações de privacidade do estado local e de artefatos temporários. Essas regras distinguem evidência de autoridade e não inventam vulnerabilidades quando uma superfície não existe. Projetos web e visuais também usam `ENGINEERING_DESIGN_PERFORMANCE`, `PERFORMANCE_VALIDATION.md` e evidências de aceite separadas para mobile e desktop. A release `v1.4.0` do repositório privado predecessor adicionou orientações condicionais `ENGINEERING_MOTION_DESIGN` e uma Revisão de movimento para projetos com movimento; isso não adiciona uma fase obrigatória nem dependência de animação.

Práticas selecionadas das avaliações suplementares informaram orientações canônicas. Isso não afirma que cada módulo ou piloto completo foi validado independentemente quanto à eficácia:

- Esclarecer o problema antes de gerar uma solução.
- Classificar a demanda e selecionar o workflow antes da execução especializada.
- Exigir que planos não triviais explicitem escopo, arquivos afetados, testes, critérios de aceite, riscos e exclusões.
- Exigir aprovação humana antes da implementação.
- Manter explícitas as evidências, premissas, limitações e transferências de trabalho.
- Preferir validação test-first quando houver testes automatizados disponíveis.
- Validar o comportamento percebido pelo consumidor, não somente APIs isoladas ou documentação.
- Manter os quatro módulos suplementares opcionais; instalar ou integrar ferramentas externas exige aprovação explícita e separada do proprietário.

## Workflow canônico

```text
Usuário
  -> Engineering Manager
  -> Orchestrator
  -> Prompt Architect (condicional)
  -> Product Owner
  -> Design System Analyst (condicional)
  -> Software Architect
  -> Sprint Planner
  -> Aprovação do plano
  -> Implementação e testes
  -> Code Reviewer
  -> QA/Security
  -> Documentation
  -> Tech Lead e validação manual
  -> Entrega
  -> Extração de conhecimento e melhoria do Framework
```

Etapas condicionais devem ser registradas explicitamente. O Design System Analyst analisa referências visuais fornecidas ou prepara uma proposta inicial somente quando o usuário/Product Owner solicita explicitamente isso para um produto visual sem referências. A proposta continua opcional, é rotulada como `Proposed` e exige aprovação antes da adoção. O Prompt Architect atua quando o contexto inicial é bruto, ambíguo ou incompleto, ou precisa ser preservado como `PROJECT_BRIEF.md`.

## Artefatos canônicos

```text
Prompt original
  -> PROJECT_BRIEF.md
  -> docs/PRD.md
  -> docs/DESIGN.md (quando existem referências ou uma direção inicial é solicitada explicitamente)
  -> docs/ARCHITECTURE.md
  -> docs/SPRINTS.md
  -> implementação e testes
  -> REVIEW.md
  -> docs/PERFORMANCE_VALIDATION_REPORT.md (quando existe interface web ou visual)
  -> QA_SECURITY_REPORT.md
  -> auditoria de documentação
  -> decisão do Tech Lead
  -> PROJECT_KNOWLEDGE.md
```

Esta cadeia se aplica a um projeto cliente inicializado a partir de `PROJECT_TEMPLATE/`; a raiz do Framework não precisa conter esses placeholders de cliente.

Cada artefato tem um responsável e uma finalidade. Artefatos posteriores podem referenciar decisões anteriores, mas não devem redefini-las silenciosamente.

## Status da limpeza de publicação

### Artefatos de projeto vazios na raiz

Os placeholders de artefatos de projeto da raiz foram removidos. O diretório `PROJECT_TEMPLATE/docs/` continua sendo a fonte dos arquivos `PRD.md`, `ARCHITECTURE.md` e `SPRINTS.md` dos projetos clientes; a raiz do Framework mantém apenas documentos reais de governança e auditoria.

O `docs/ADR.md` da raiz foi mantido porque contém decisões reais do Framework, incluindo a decisão de limpeza da publicação.

### Estado interno de execução

O estado `.ai/` de manutenção na raiz e os dados de execução `workflow-graph/` não fazem parte do Framework publicado. O diretório local `workflow-graph/` da raiz foi removido deste checkout. O estado de workflow dos projetos clientes permanece em `PROJECT_TEMPLATE/.ai/`; o histórico privado de manutenção não é dependência de runtime nem fonte pública da verdade.

### Prompt de continuidade

`CONTINUATION_PROMPT.md` era um artefato de continuidade de sessão, não um componente do Framework, e foi removido da superfície pública porque descrevia somente oito agentes. As orientações públicas atuais estão em `README.md`, `README.pt-BR.md`, `START_PROJECTS.en-US.md`, `locales/pt-BR/public-docs/START_PROJECTS.md` e `OVERVIEW.md`.

### Dependências locais

`.opencode/node_modules/`, `package.json` e `package-lock.json` eram ferramentas locais do adapter e foram removidos da superfície de publicação. A documentação canônica do adapter `.opencode/` e os arquivos de agentes permanecem.

## Documentação de publicação

### README

O README público é a entrada concisa. Mantenha-o atualizado quanto a:

- O que é o Framework.
- Quem deve usá-lo.
- Como inicializar um projeto cliente.
- Como agentes e artefatos se relacionam.
- O que é obrigatório, condicional ou experimental.
- Como funcionam o bootstrap genérico e os adapters de CLI opcionais.
- Como contribuir e relatar problemas.

O README deve apontar para `OVERVIEW.md` para o contexto completo de arquitetura e publicação.

### Status de release e versionamento

A primeira release pública `v1.5.0` está publicada, com arquivos compactados e checksums verificados após validação Ubuntu/macOS/Windows do commit exato da tag. Ela inclui verificação de checkout/tag do publicador, proteção do bootstrap contra diretórios-pai vinculados, permissões somente do proprietário em `.ai/state`, o inspetor local preliminar de segurança e a regra padrão para ignorar estado local no Git. A release `v1.4.0` anterior pertence ao repositório privado predecessor; nenhuma tag nem artefato anterior foi migrado para cá. Mantenha as entradas alinhadas ao comportamento real do template, dos agentes e do bootstrap:

- Práticas de workflow promovidas.
- Bootstrap multilíngue nativo e adapters de CLI opcionais.
- Correções nos nomes canônicos de artefatos.
- Remoção de referências duplicadas e obsoletas.
- Ferramentas suplementares e adapters de CLI nomeados permanecem opcionais, com `generic` como padrão.

O repositório publica um único arquivo de release que contém os dois pacotes de
idioma. O bootstrap seleciona explicitamente o idioma do projeto; arquivos de
release separados por idioma não fazem parte da política de publicação.

### Limites das fontes da verdade

As mesmas orientações aparecem no Framework, em `AGENTS.md`, nos módulos de conhecimento, documentos de agentes, adapters, workflows e nos guias de início EN-US/PT-BR.

Use estes limites para reduzir divergências futuras:

- `docs/reference/LF_DESIGN_PERFORMANCE_GUIDE.md`: guia detalhado de referência; somente os requisitos adotados explicitamente nos módulos, protocolos, schemas e ADRs canônicos são operacionais.
- `knowledge/`: orientações estruturadas para consumo por IA.
- `agents/`: responsabilidades e comportamento especializado.
- `workflows/`: sequência de fases e transições.
- `protocols/`: formatos de atualização e regras de handoff.
- `schemas/`: estrutura dos artefatos.
- `adapters/`: adapters opcionais de CLI; `.opencode/` é somente a fonte de compatibilidade OpenCode do Framework.
- `PROJECT_TEMPLATE/`: arquivos copiados para projetos clientes.
- `README.md`: explicação pública concisa.

### Validação automatizada de consistência

O repositório oferece validadores nativos leves que verificam:

- existência dos diretórios e arquivos obrigatórios do Framework;
- isolamento do adapter OpenCode opcional em relação a `PROJECT_TEMPLATE/`;
- presença de placeholders operacionais somente nos dois arquivos-fonte esperados;
- correspondência entre os conjuntos de arquivos dos templates EN-US e PT-BR;
- paridade estrutural de cabeçalhos, separadores de tabela, blocos de código e limites de comentários HTML nos templates;
- correspondência de arquivos e paridade estrutural dos espelhos canônicos de agentes, workflows, protocolos, schemas e Knowledge estável, bem como dos quatro espelhos suplementares propostos de Knowledge, em seus grupos de validação separados;
- sintaxe válida do bootstrap shell e parsing da configuração OpenCode opcional quando há runtime compatível com JSON;
- parsing da configuração GitHub MCP do Framework, que permanece desativada por padrão, fixada em versão, restrita a ferramentas de repositório e configurada como somente leitura; a validação não inicia Docker nem autentica no GitHub.
- paridade estrutural dos espelhos ativos de `OVERVIEW`, `ROADMAP`, `CHANGELOG` e ADRs quanto a hierarquia de títulos, tabelas, blocos de código e comentários HTML.
- presença de um único arquivo de release com os dois pacotes de idioma; a seleção do idioma continua sendo explícita no bootstrap.

As suítes de teste do bootstrap também cobrem dry-run, adoção que copia somente arquivos ausentes, arquivos ocultos, caminhos com espaços, seleção de adapters, opções inválidas, proteção de fronteira do Framework incluindo links de diretório e substituição de placeholders OpenCode. Verificações mais amplas do repositório — como links Markdown, estrutura de agentes, busca por segredos e `git diff --check` — continuam sendo verificações de release, não promessas do validador nativo do Framework.

Esta continua sendo uma camada pequena de validação, não um novo runtime do framework.

## Checklist de prontidão para publicação

- [x] Decidir qual estado `.ai/` da raiz é público; arquivar o estado de manutenção fora da raiz e manter `.ai/` em `PROJECT_TEMPLATE/`.
- [x] Remover artefatos vazios de projeto em `docs/` na raiz, preservando ADRs reais e evidências de auditoria.
- [x] Remover o `CONTINUATION_PROMPT.md` desatualizado.
- [x] Revisar o changelog 1.2.0 em relação ao escopo final de segurança, workflow, performance e limpeza.
- [x] Confirmar que `ROADMAP.md` corresponde à versão atual e às prioridades futuras.
- [x] Confirmar licença e informações de autoria; a política de contribuição continua aberta.
- [x] Adicionar templates públicos de issues para bugs e solicitações de recursos.
- [x] Adicionar template de pull request com verificações de validação e documentação.
- [x] Inicializar Git e inspecionar o primeiro commit completo.
- [x] Confirmar que arquivos locais ignorados não estão incluídos.
- [x] Validar um bootstrap de projeto novo em shell macOS/Linux.
- [x] Validar o bootstrap documentado por PowerShell no host de auditoria.
- [x] Confirmar o mesmo comportamento PowerShell em Windows nativo no runner `windows-latest` do GitHub Actions.
- [x] Validar adoção de projeto existente com documentos, estado `.ai/` e conflitos de configuração de CLI existentes.
- [x] Adicionar validadores nativos do Framework e bootstrap, com CI em Ubuntu/macOS/Windows.
- [x] Adicionar fluxo reproduzível de arquivos de release e checksums para releases marcadas.
- [x] Adicionar documentação bilíngue de testes e cenários reproduzíveis de bootstrap.
- [x] Preservar a auditoria de segurança de 2026-10-19 como evidência histórica e identificá-la como não atual; remover caminhos específicos do mantenedor do snapshot público.
- [x] Traduzir `workflows/`, `protocols/` e `schemas/` canônicos para PT-BR com metadados de versão-fonte e verificações de paridade estrutural.
- [x] Completar traduções PT-BR dos agentes canônicos e do Knowledge estável com verificações de versão-fonte e paridade estrutural; módulos suplementares opcionais aprovados permanecem explicitamente fora do gate obrigatório de locale estável.
- [x] Gerar e verificar arquivos de release e checksums a partir de um clone limpo.
- [x] Verificar execução em Windows nativo e o status resultante do GitHub Actions.
- [x] Publicar o primeiro snapshot público limpo na branch `main` como `v1.5.0`, sem migrar histórico, branches ou tags do repositório predecessor.
- [x] Usar identidade GitHub noreply no commit e revisar o snapshot público quanto a caminhos privados, credenciais e contatos não autorizados.
- [x] Ignorar `.ai/state/` de projetos clientes por padrão, preservando o `.gitignore` de projetos existentes.
- [x] Habilitar GitHub Private Vulnerability Reporting e publicar o contato de segurança autorizado em `SECURITY.md`.
- [x] Proteger `main` com requisitos de pull request e CI multiplataforma.

## Interface gráfica futura

A interface gráfica deve visualizar o Framework sem se tornar uma fonte concorrente da verdade. Markdown, schemas e artefatos de projeto continuam autoritativos; o grafo é uma visão de navegação, status e dependências.

### Entidades sugeridas para o grafo

- Agente.
- Responsabilidade.
- Workflow.
- Fase.
- Artefato.
- Requisito.
- Tarefa.
- Decisão.
- Risco.
- Handoff.
- Critério de aceite.
- Teste.
- Evidência.

### Relações sugeridas

```text
Agente --produz--> Artefato
Artefato --depende-de--> Artefato
Agente --transfere-para--> Agente
Tarefa --implementa--> Requisito
Decisão --afeta--> Artefato
Risco --bloqueia--> Tarefa
Evidência --valida--> Critério de aceite
Teste --verifica--> Requisito
```

### Recursos úteis da interface

- Exibir o pipeline de agentes de ponta a ponta.
- Mostrar a fase atual do projeto e o handoff ativo.
- Identificar tarefas bloqueadas e riscos não resolvidos.
- Navegar de requisito a tarefa, artefato, código, teste e decisão.
- Filtrar por agente, projeto, fase, status ou risco.
- Mostrar quais regras são obrigatórias, condicionais ou propostas.
- Exibir proveniência e evidências de validação.
- Preservar um histórico auditável de alterações e aprovações.

### Ordem de implementação

1. Estabilizar schemas de artefatos e tarefas.
2. Definir tipos de nós e arestas do grafo.
3. Criar uma projeção somente leitura do grafo a partir de Markdown e arquivos estruturados.
4. Adicionar busca, filtros e travessia de dependências.
5. Adicionar visualizações de status e risco.
6. Adicionar edição somente depois que as regras de fonte da verdade e resolução de conflitos estiverem comprovadas.

Evite começar por autenticação, colaboração, extração semântica, MCP ou um backend grande. Um visualizador local somente leitura é o menor primeiro produto útil.

## Não objetivos explícitos

Os seguintes itens não fazem parte atualmente do Framework obrigatório:

- Instalação ou integração MCP do Graphify.
- AGF como único sistema de tarefas ou status.
- Hooks globais ou telemetria do RTK.
- Reescrita automática de comandos sem controles explícitos.
- Indexação semântica de código baseada em modelos.
- Banco de dados de grafo como substituto dos artefatos do projeto.
- Um novo agente para cada ferramenta externa.

Qualquer adoção futura exige piloto delimitado, fixação de fonte e versão, revisão de segurança/privacidade, valor mensurável e decisão explícita do Framework.

## Limitações atuais

- O Framework é um projeto de documentação e bootstrap, não uma aplicação; não possui runner de testes de aplicação de produto.
- As avaliações de ferramentas suplementares não substituem evidências de projetos clientes reais.
- A proveniência histórica do material fornecido a partir de `graphiffy.com` continua sem verificação. O site oficial do Graphify informa que o domínio não resolve mais; ele não é usado como evidência da identidade do pacote ou da release da proposta.

## Próxima sessão sugerida

1. Manter sincronizados os documentos públicos que definem a fonte da verdade à medida que o Framework evolui.
2. Tratar qualquer modelo de dados de grafo como uma tarefa de design separada.
3. Criar um protótipo de grafo somente leitura apenas depois que os schemas estiverem estáveis e houver uma necessidade delimitada aprovada.
