# Registros de Decisão de Arquitetura

Idiomas: [EN-US](../../../docs/ADR.md) | [PT-BR](ADR.md)

Idioma-fonte: EN-US<br>
Baseline de referência: primeira release pública `v1.5.0`, em 2026-11-03<br>
Fonte: `docs/ADR.md`

Baseline pública: `v1.5.0`. Os ADRs 001 a 018 são mantidos como decisões
históricas do repositório privado predecessor; referências às suas releases são
contexto de arquivo, e nenhuma tag Git predecessora foi importada.

## Índice de ADRs

| ID | Título | Status | Data |
| -- | ----- | ------ | ---- |
| ADR-001 | Segurança de fronteira do Framework e estado local | Aceita | 2026-10-18 |
| ADR-002 | Gate de design e performance mobile/desktop | Aceita | 2026-10-18 |
| ADR-003 | Limpeza da superfície pública do Framework | Aceita | 2026-10-18 |
| ADR-004 | Adoção segura de projetos existentes | Aceita | 2026-10-18 |
| ADR-005 | Distribuição neutra, multilíngue e por adapters | Aceita | 2026-10-19 |
| ADR-006 | Adoção seletiva de práticas de qualidade e pesquisa com usuários | Aceita (parcialmente substituída) | 2026-10-29 |
| ADR-007 | Retirada do módulo suplementar proposto de pesquisa com usuários | Aceita | 2026-10-31 |
| ADR-008 | Adoção seletiva de práticas de direção visual | Aceita | 2026-10-31 |
| ADR-009 | Adoção seletiva de controles de workflow de IA, autorização e APIs | Aceita | 2026-10-31 |
| ADR-010 | Especificações de agentes neutras e alinhamento da publicação | Aceita | 2026-10-31 |
| ADR-011 | Integração opcional e somente leitura do GitHub MCP no OpenCode | Aceita | 2026-11-01 |
| ADR-012 | Escopo de tradução e classificação de referências públicas | Aceita (parcialmente substituída pelos ADR-014 e ADR-016) | 2026-11-01 |
| ADR-013 | Adoção seletiva de motion design e validação visual | Aceita | 2026-11-01 |
| ADR-014 | Adoção opcional dos quatro módulos suplementares | Aceita | 2026-11-01 |
| ADR-015 | Organização da fonte EN-US e dos documentos PT-BR | Aceita (política de compatibilidade substituída pelo ADR-016) | 2026-11-01 |
| ADR-016 | Remoção de referências legadas e caminhos de compatibilidade | Aceita | 2026-11-01 |
| ADR-017 | Publicação de releases sem GitHub Environment | Aceita (política de proteção de branch substituída pelo ADR-019) | 2026-11-01 |
| ADR-018 | Inspeção dinâmica local e independência do nome do checkout | Aceita | 2026-11-01 |
| ADR-019 | Repositório público limpo e primeira release pública | Aceita | 2026-11-03 |
| ADR-020 | Estado `.ai/state/` local e ignorado por padrão | Aceita | 2026-11-03 |
| ADR-021 | Adoção seletiva de princípios de simulação interativa orientada por modelo | Aceita | 2026-11-04 |

## Registros

## ADR-001 - Segurança de fronteira do Framework e estado local

### Status

Aceita

### Data

2026-10-18

### Contexto

A auditoria de segurança constatou que o template de cliente usava o objeto obsoleto `permission` da V1 com uma regra consultiva `ask` para o Framework externo, que a substituição do bootstrap Windows podia gerar JSONC inválido, que a cópia do bootstrap podia sobrescrever um projeto existente e que o estado local de workflow gerado podia ser lido por todos. A auditoria também constatou que o agente QA-Security não tinha um gate explícito de fronteira de confiança e prompt injection.

### Decisão

Usar permissões ordenadas do OpenCode V2 no adapter OpenCode opcional: permitir que o cliente leia o Framework externo e negar edições nele. Manter o bootstrap padrão neutro em relação a fornecedores, copiar somente arquivos ausentes, escapar caminhos específicos de plataforma e gerar a configuração OpenCode somente quando esse adapter for selecionado. Tratar o estado local do workflow como sensível e exigir permissões exclusivas do proprietário quando houver suporte. Tornar obrigatórios os gates de fronteira de confiança, aplicabilidade e evidência do QA-Security.

### Alternativas consideradas

- Manter o objeto `permission` da V1 e depender de aprovação interativa.
- Manter `ask` para edições do Framework e apenas documentar a fronteira.
- Adicionar uma opção destrutiva `--force` ao bootstrap.
- Excluir o estado de workflow gerado imediatamente após a auditoria.

### Consequências

Novos projetos clientes recebem uma fronteira mais forte, somente leitura, para o Framework e um bootstrap não destrutivo; projetos existentes precisam migrar a configuração separadamente. O estado local continua disponível como evidência, mas é protegido de outros usuários locais quando o host oferece suporte a modos Unix. O agente QA-Security pode marcar categorias como não aplicáveis e não deve elevar instruções inseridas em conteúdo do projeto. A execução nativa em Windows e a migração de projetos clientes permanecem como acompanhamentos de validação.

### Artefatos relacionados

- `adapters/opencode/opencode.jsonc`
- `locales/pt-BR/public-docs/START_PROJECTS.md`
- `.opencode/README.md`
- `agents/QA-Security/SPECS.md`
- `knowledge/ENGINEERING_QUALITY.md`
- `knowledge/ENGINEERING_AGENT_GRAPH_FLOW.md`
- `.gitignore`
- `PROJECT_TEMPLATE/.gitignore`
- `scripts/bootstrap.sh`, `scripts/bootstrap.ps1` e seus testes de regressão
- `docs/security-audit/relatorio-auditoria-seguranca.pdf`

## ADR-002 - Gate de design e performance mobile/desktop

### Status

Aceita

### Data

2026-10-18

### Contexto

O guia fornecido `docs/reference/LF_DESIGN_PERFORMANCE_GUIDE.md` define práticas de design e performance para sistemas web e visuais. O workflow existente tinha um gate genérico de performance, mas não exigia cobertura de rotas, evidências separadas para mobile e desktop, execuções reproduzíveis, orçamentos, handoff de design responsivo nem uma decisão sobre as limitações de dados de campo.

### Decisão

Adotar `knowledge/ENGINEERING_DESIGN_PERFORMANCE.md` como módulo condicional de conhecimento para projetos web e visuais. Adicionar `protocols/PERFORMANCE_VALIDATION.md`, seu schema e o template de relatório para clientes. Exigir os pontos de verificação do guia, da definição do produto até a aprovação do Tech Lead: rotas críticas, perfis mobile/desktop, candidato a LCP, orçamentos, cinco execuções válidas comparáveis, medianas, jornadas, acessibilidade manual e status explícito de RUM/CrUX. Usar mediana de Performance `>= 91` como mínimo inicial e `95` como alvo, com exceções rastreáveis; não alegar uma pontuação fixa nem aprovação para toda a aplicação com evidências incompletas.

### Alternativas consideradas

- Manter o gate genérico de performance e deixar a medição a critério de cada projeto.
- Tornar PageSpeed 95 um bloqueio universal, independentemente da rota ou do produto.
- Medir somente a página inicial ou somente o perfil mobile.
- Exigir o protocolo para APIs, CLIs e sistemas não visuais.

### Consequências

Projetos web e visuais futuros recebem requisitos de performance antes da implementação e um gate de entrega separado para mobile/desktop, sem escolher framework frontend ou provedor de hospedagem. O processo adiciona um relatório condicional e o custo de cinco medições. Projetos podem ajustar orçamentos somente com evidências, responsável, mitigação e data de revisão. Projetos não visuais registram a dispensa, em vez de inventar métricas de navegador.

### Artefatos relacionados

- `docs/reference/LF_DESIGN_PERFORMANCE_GUIDE.md`
- `knowledge/ENGINEERING_DESIGN_PERFORMANCE.md`
- `protocols/PERFORMANCE_VALIDATION.md`
- `schemas/PERFORMANCE_VALIDATION_REPORT.schema.md`
- `PROJECT_TEMPLATE/docs/PERFORMANCE_VALIDATION_REPORT.md`
- `workflows/NEW_PROJECT.md`
- `workflows/STANDARD_DEVELOPMENT.md`
- `knowledge/ENGINEERING_WORKFLOW.md`
- `knowledge/ENGINEERING_QUALITY.md`

## ADR-003 - Limpeza da superfície pública do Framework

### Status

Aceita

### Data

2026-10-18

### Contexto

A raiz do Framework continha placeholders de projetos clientes (`docs/PRD.md`, `docs/ARCHITECTURE.md` e `docs/SPRINTS.md`), um prompt de continuidade desatualizado, instalação de dependências locais do OpenCode e estado gerado de cache de workflow/Python. Esses arquivos não eram necessários para o workflow canônico do Framework e podiam confundir os limites de publicação ou expor histórico de execução local.

### Decisão

Preparar a raiz como superfície pública do Framework: preservar agentes, conhecimento, workflows, protocolos, schemas, adapters, `PROJECT_TEMPLATE/`, ADRs reais do Framework, evidências da auditoria de segurança e o guia-fonte de design e performance. Arquivar o estado `.ai/` de manutenção da raiz e o estado `workflow-graph/` em backup externo restrito e removê-los da raiz de publicação, junto com placeholders de clientes, prompt de continuidade desatualizado, arquivos/instalação de dependências locais OpenCode e cache Python gerado. Manter o estado `.ai/` dos projetos clientes e todos os placeholders de projeto dentro de `PROJECT_TEMPLATE/`.

### Alternativas consideradas

- Publicar todo o histórico `.ai/` e workflow-graph da raiz como evidência de uso do próprio Framework.
- Excluir o estado gerado sem arquivamento externo.
- Manter placeholders de clientes na raiz e pedir que leitores os distingam manualmente do template.
- Remover todo o diretório adapter `.opencode/`.

### Consequências

A raiz pública fica menor e seus limites de fonte da verdade mais claros; o estado de workflow de clientes continua disponível por `PROJECT_TEMPLATE/`. O arquivo local preserva recuperação e rastreabilidade de auditoria, mas não faz parte do repositório público. Um bootstrap limpo futuro precisa ser validado novamente, e dependências locais do OpenCode podem ser reinstaladas a partir dos metadados do pacote do adapter, se esses metadados forem mantidos ou recriados pelo mantenedor.

### Artefatos relacionados

- `OVERVIEW.md`
- `README.md`
- `AGENTS.md`
- `PROJECT_TEMPLATE/`
- `.opencode/`
- `docs/security-audit/`
- `.gitignore`

## ADR-004 - Adoção segura de projetos existentes

### Status

Aceita

### Data

2026-10-18

### Contexto

O bootstrap original recusava corretamente diretórios não vazios para evitar sobrescrever um projeto existente. Essa proteção também impedia que um projeto com código, documentos ou diretório `.git` adotasse os arquivos de coordenação ausentes do Framework. Remover a verificação preliminar criaria um caminho de mesclagem inseguro e poderia substituir `AGENTS.md`, documentos ou configuração OpenCode pertencentes ao projeto.

### Decisão

Manter um único bootstrap nativo não destrutivo para projetos novos e existentes. O comando macOS/Linux usa iteração de arquivos em shell portável; o comando Windows usa iteração em PowerShell. Ambos oferecem dry-run, copiam somente arquivos ausentes, nunca substituem arquivos existentes do projeto, preservam `AGENTS.md`, `.gitignore`, documentos, estado `.ai/` e configuração de CLI existentes, geram arquivos de adapter somente quando ausentes e recusam caminhos dentro do Framework.

### Alternativas consideradas

- Remover a verificação de diretório não vazio e copiar o template sobre o projeto.
- Mesclar automaticamente `opencode.jsonc` e `AGENTS.md` existentes.
- Exigir que usuários copiem arquivos individualmente, sem relatório de dry-run.

### Consequências

Projetos novos mantêm um bootstrap reproduzível e não destrutivo. Projetos existentes podem adotar a estrutura ausente do Framework sem perder arquivos próprios. Conflitos de configuração e instruções de agentes continuam sendo uma tarefa explícita de migração manual, pois uma mesclagem automática genérica não consegue preservar com segurança configurações arbitrárias do projeto.

### Artefatos relacionados

- `locales/pt-BR/public-docs/START_PROJECTS.md`
- `PROJECT_TEMPLATE/`
- `scripts/bootstrap.sh`
- `scripts/bootstrap.ps1`
- `AGENTS.md`

## ADR-005 — Distribuição neutra, multilíngue e por adapters

### Status

Aceita

### Data

2026-10-19

### Contexto

O Framework destina-se a download público e precisa funcionar para usuários que escolhem diferentes assistentes de IA, sistemas operacionais e idiomas humanos. Tornar OpenCode o caminho de bootstrap obrigatório criaria uma dependência evitável de fornecedor. Misturar arquivos traduzidos sem um contrato de seleção também deixaria incerto qual documentação um projeto recebeu.

### Decisão

Definir `generic` como adapter padrão e manter o template do projeto independente de qualquer fornecedor de IA. Fornecer bootstraps nativos em shell e PowerShell com seleção explícita de idioma `en-US`/`pt-BR` e adapters opcionais `codex`, `claude`, `gemini` e `opencode`. EN-US é o idioma-fonte técnico; PT-BR é uma tradução versionada com metadados de cobertura. O bootstrap copia somente arquivos ausentes, registra o idioma e o adapter selecionados quando possível e mantém o Framework canônico externo e somente leitura.

### Alternativas consideradas

- Exigir OpenCode como runtime universal.
- Instalar todos os adapters de fornecedores em todos os projetos.
- Inferir o idioma pelo host ou provedor de IA.
- Alegar paridade total PT-BR antes da tradução da biblioteca canônica.

### Consequências

Usuários podem baixar o repositório ou uma release e começar com uma CLI genérica sem dependências de runtime. Configurações específicas de fornecedor são opt-in e podem ser revisadas independentemente. O trabalho de tradução exige rastreamento da versão-fonte e verificações de paridade estrutural. A biblioteca canônica permanece externa; portanto, um assistente de IA precisa receber acesso ao caminho do Framework ou a uma futura cópia empacotada da biblioteca.

### Artefatos relacionados

- `scripts/bootstrap.sh`
- `scripts/bootstrap.ps1`
- `PROJECT_TEMPLATE/LF_ENGINEERING.md`
- `adapters/`
- `locales/`
- `locales/pt-BR/public-docs/START_PROJECTS.md`
- `START_PROJECTS.en-US.md`

## ADR-006 - Adoção seletiva de práticas de qualidade e pesquisa com usuários

### Status

Aceita

### Data

2026-10-29

### Contexto

Uma revisão individual de 20 repositórios externos de Skills identificou práticas úteis para revisão de dívida técnica, operações seguras com ferramentas, verificação de artefatos visuais e pesquisa com usuários. Importar Skills, dependências ou workflows inteiros acrescentaria acoplamento a fornecedores/ferramentas, duplicaria orientações existentes do Framework e poderia tornar obrigatório um trabalho opcional. O Framework já cobre grafos de conhecimento de código, colaboração design-first e performance web/visual em módulos separados.

### Decisão

Adotar somente princípios reutilizáveis compatíveis com os limites existentes do Framework:

- Estender `ENGINEERING_QUALITY` com verificação baseada em evidências para operações que transformam arquivos e artefatos visuais renderizados.
- Adicionar workflow separado e somente leitura de auditoria de dívida técnica, schema e template opcional de relatório para clientes. Executá-lo somente mediante solicitação explícita ou manutenção aprovada; o Tech Lead prioriza os achados antes que virem trabalho de sprint.
- Adicionar `ENGINEERING_USER_RESEARCH` como módulo suplementar proposto. Considerá-lo somente quando uma incerteza relevante sobre usuários puder alterar decisões de produto e as evidências existentes forem insuficientes. Registrar evidências e limitações nas seções existentes do PRD; não adicionar artefato de pesquisa obrigatório nem gate de workflow.
- Manter EN-US como fonte, sincronizar PT-BR, não instalar Skills nem dependências externas e não duplicar `ENGINEERING_GRAPHIFY`, `ENGINEERING_ELEPHANT_GOLDFISH` ou `ENGINEERING_DESIGN_PERFORMANCE`.

### Alternativas consideradas

- Importar Skills externas ou adicionar suas dependências de runtime/ferramenta ao núcleo neutro.
- Tornar auditorias de dívida técnica ou pesquisa com usuários obrigatórias em todos os projetos.
- Adicionar um relatório autônomo de pesquisa com usuários obrigatório.
- Duplicar orientações existentes de grafos, colaboração ou design-performance.
- Adiar todas as mudanças apesar de lacunas de qualidade específicas e reutilizáveis.

### Consequências

A sequência padrão de desenvolvimento permanece inalterada. As equipes recebem uma auditoria de dívida técnica opt-in e rastreável e requisitos de evidência mais claros para artefatos transformados e visuais. Naquele momento, a orientação de pesquisa com usuários era Proposta, suplementar e condicional a revisão humana e piloto delimitado; uma tradução PT-BR não a promovia ao grafo de dependências estável. Os acréscimos criaram manutenção de documentação e tradução, mas nenhuma dependência de runtime. A decisão foi registrada como trabalho não lançado e não alterou a versão do Framework. O módulo de pesquisa com usuários proposto foi posteriormente retirado antes da release pelo ADR-007; as demais decisões deste registro continuam válidas.

### Artefatos relacionados

- `knowledge/ENGINEERING_QUALITY.md`
- `knowledge/ENGINEERING_ARTIFACTS.md`
- `knowledge/ENGINEERING_TEMPLATES.md`
- `knowledge/ENGINEERING_USER_RESEARCH.md`
- `knowledge/INDEX.md`
- `knowledge/REGISTRY.md`
- `workflows/TECH_DEBT_AUDIT.md`
- `schemas/TECH_DEBT_AUDIT.schema.md`
- `PROJECT_TEMPLATE/docs/TECH_DEBT_AUDIT.md`
- `PROJECT_TEMPLATE/.ai/contracts.md`
- `PROJECT_TEMPLATE/.ai/artifacts.md`
- `workflows/NEW_PROJECT.md`
- `workflows/STANDARD_DEVELOPMENT.md`
- `schemas/PRD.schema.md`
- `agents/`
- `locales/pt-BR/`

## ADR-007 - Retirada do módulo suplementar proposto de pesquisa com usuários

### Status

Aceita

### Data

2026-10-31

### Contexto

O módulo proposto `ENGINEERING_USER_RESEARCH` foi exercitado somente por meio de uma simulação documental com cenário fictício e fixtures sintéticas. As verificações direcionadas do processo passaram, mas nenhum participante foi recrutado e nenhuma evidência real de usuários ou resultado de pesquisa foi avaliado. Portanto, a simulação não satisfez a condição proposta para o piloto nem justificou manter o módulo como referência suplementar ativa.

### Decisão

- Retirar o módulo de pesquisa com usuários proposto antes da release e remover seus arquivos EN-US e PT-BR e referências ativas dos índices de Knowledge, do registro de agentes, do conhecimento do Product Owner e dos workflows.
- Manter orientações gerais no PRD para registrar o escopo e as limitações das evidências que informam decisões de produto, evitar identificar dados de participantes e não exigir um relatório de pesquisa separado.
- Reconsiderar um módulo dedicado somente por meio de nova proposta e de piloto aprovado e adequadamente delimitado com participantes reais.

### Alternativas consideradas

- Manter o módulo como Proposto enquanto se aguarda um piloto com participantes reais.
- Promovê-lo com base na simulação sintética do workflow.
- Remover todas as orientações gerais de rastreabilidade de evidências do PRD junto com o módulo.

A primeira alternativa manteria a manutenção e descoberta ativa de orientações que ainda não concluíram o piloto. A segunda exageraria o que fixtures sintéticas podem validar. A terceira removeria desnecessariamente orientações úteis e gerais de rastreabilidade no PRD.

### Consequências

O módulo deixa de estar disponível como referência ativa do Framework e não é incluído na superfície da release. Equipes de produto ainda podem registrar no PRD evidências relevantes de usuários e suas limitações sem tratar pesquisa como fase ou artefato obrigatório. A parte de pesquisa com usuários do ADR-006 é substituída; as demais decisões daquele registro permanecem em vigor.

### Artefatos relacionados

- `knowledge/ENGINEERING_USER_RESEARCH.md` (retirado)
- `locales/pt-BR/knowledge/ENGINEERING_USER_RESEARCH.md` (retirado)
- `knowledge/INDEX.md`
- `knowledge/REGISTRY.md`
- `agents/Product-Owner/KNOWLEDGE.md`
- `workflows/NEW_PROJECT.md`
- `workflows/STANDARD_DEVELOPMENT.md`
- `schemas/PRD.schema.md`
- `PROJECT_TEMPLATE/docs/PRD.md`
- `CHANGELOG.md`

## ADR-008 - Adoção seletiva de práticas de direção visual

### Status

Aceita

### Data

2026-10-31

### Contexto

Atualmente o Design System Analyst documenta referências visuais, mas alguns produtos visuais começam sem capturas de tela ou mockups. UI UX Pro Max v2.15.0 (`bf41cbc3ce63e30c922e58ef48741ba6133f9aa9`, 2026-10-31) demonstra práticas úteis para compor e governar recomendações de design, mas seus catálogos e heurísticas não estabelecem necessidades ou preferências dos usuários do projeto. O LF Framework já define comportamento responsivo, acessibilidade, performance, estados de interação e tokens de design; importar outra skill completa duplicaria políticas e adicionaria manutenção ou dependências de runtime.

### Decisão

- Estender o módulo de Knowledge existente, Design System Analyst, workflows, contratos, schema e template `DESIGN.md`; não criar um novo módulo de Knowledge.
- Permitir uma direção visual inicial sem referências somente quando o usuário ou Product Owner a solicitar explicitamente para um produto visual. Mantê-la opcional, separada de observações baseadas em referências, classificá-la como `Proposed` e exigir aprovação antes que se torne baseline de implementação.
- Classificar declarações de design como `Observed`, `Derived`, `Proposed` ou `Unverified`, declarar sua base e não apresentar heurísticas como pesquisa de usuários, preferência, demanda ou validação de usabilidade.
- Preservar tokens de design aprovados como fonte da verdade. Documentar overrides específicos de página somente quando necessário, com escopo, fundamento, justificativa e aprovação.
- Manter acessibilidade, responsividade, performance e funcionalidade como gates existentes. Não adicionar CLI, dependência, catálogo externo copiado ou etapa obrigatória de proposta.
- Sincronizar os documentos afetados em EN-US e PT-BR.

### Alternativas consideradas

- Importar UI UX Pro Max e seus catálogos/CLI para o Framework.
- Limitar o Design System Analyst a referências mesmo quando uma direção inicial for solicitada explicitamente.
- Gerar uma direção por padrão para todo projeto visual sem referências.

A primeira opção adiciona manutenção, conteúdo específico de stack e superfície de runtime desnecessários ao Framework. A segunda impede um handoff útil e solicitado. A terceira transforma uma proposta heurística em trabalho padrão desnecessário e pode sugerir evidências inexistentes.

### Consequências

Projetos podem solicitar uma direção visual inicial sem apresentá-la como observada ou validada por usuários. Sistemas aprovados permanecem autoritativos e as exceções continuam delimitadas. Isso adiciona manutenção de documentação e tradução, mas nenhuma dependência de runtime. A versão da release e a sequência padrão de desenvolvimento do Framework permanecem inalteradas.

### Artefatos relacionados

- `knowledge/ENGINEERING_DESIGN_PERFORMANCE.md`
- `knowledge/ENGINEERING_ARTIFACTS.md`
- `knowledge/REGISTRY.md`
- `agents/Design-System-Analyst/`
- `agents/AGENT_INTERACTION_MAP.md`
- `workflows/NEW_PROJECT.md`
- `workflows/STANDARD_DEVELOPMENT.md`
- `schemas/DESIGN.schema.md`
- `PROJECT_TEMPLATE/.ai/contracts.md`
- `PROJECT_TEMPLATE/docs/DESIGN.md`
- `.opencode/`
- `locales/pt-BR/`
- Referência externa: [UI UX Pro Max v2.15.0](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill/tree/bf41cbc3ce63e30c922e58ef48741ba6133f9aa9)
- `CHANGELOG.md`

## ADR-009 - Adoção seletiva de controles de workflow de IA, autorização e APIs

### Status

Aceita

### Data

2026-10-31

### Contexto

Uma revisão de dez repositórios externos identificou práticas reutilizáveis para avaliar workflows de IA, aplicar autorização na fronteira do recurso, confirmar ações externas consequentes e projetar integrações de API. O Framework já possui um gate condicional de segurança e confiança em IA, um agente QA-Security e um Field Guide prático de engenharia. Importar produtos completos, dependências ou CLIs, ou tornar trabalho com IA/APIs uma fase obrigatória, expandiria o Framework além do escopo aprovado e criaria manutenção desnecessária.

A revisão também encontrou orientações específicas para casos de uso de vídeo, voz e OSINT que não são amplamente aplicáveis ao Framework. As informações de licenciamento do Fincept são inconsistentes entre materiais do repositório; portanto, a reutilização não pode ser avaliada de modo confiável até que a divergência seja esclarecida.

### Decisão

- Estender as orientações existentes de `ENGINEERING_QUALITY` e QA-Security com avaliação condicional de workflows de IA e permissões de ferramentas. Quando aplicável, verificar privilégio mínimo, autorização para o recurso e tenant específicos, caminhos de acesso negado e proteção contra entrada não confiável.
- Exigir confirmação explícita e atual antes de efeitos externos consequentes, exceto quando uma política documentada autorizar automação delimitada e pré-aprovada. Vincular a aprovação à ação e ao alvo exatos; chamadas somente leitura não exigem confirmação por requisição.
- Adicionar um checklist de integração de APIs ao `ENGINEERING_FIELD_GUIDE` existente, abrangendo contratos e versões autoritativos, autenticação e autorização de recursos, retries/idempotência delimitados, limites, minimização de dados, validação de webhooks, comportamento de falhas e testes proporcionais.
- Manter essas verificações condicionais à existência, no projeto, do workflow de IA, operação com controle de acesso, efeito externo ou integração de API relevante. Não adicionar módulos, agentes, produtos, dependências, CLIs ou fases obrigatórias de workflow.
- Sincronizar os documentos EN-US e PT-BR afetados. Adiar orientações especializadas de vídeo, voz e OSINT e não reutilizar material específico do Fincept até que a divergência de licença seja resolvida.

### Alternativas consideradas

- Importar repositórios, produtos, dependências ou CLIs externos completos.
- Adicionar uma fase obrigatória de avaliação de workflow de IA ou integração de API para todo projeto.
- Adiar todas as práticas selecionadas até que o Framework crie módulos ou agentes novos.

A primeira alternativa adicionaria superfície de produto e manutenção desnecessária. A segunda imporia verificações a projetos nos quais não se aplicam. A terceira duplicaria responsabilidades existentes em vez de estender o gate de qualidade e o Field Guide estabelecidos.

### Consequências

Projetos com workflows de IA ou APIs recebem verificações explícitas e proporcionais ao risco para acesso em nível de recurso e efeitos externos; projetos sem essas superfícies não recebem novos requisitos. As mudanças adicionam manutenção de documentação e tradução, mas nenhuma dependência de runtime, novo agente ou fase obrigatória de desenvolvimento. A versão da release do Framework e a sequência padrão de desenvolvimento permanecem inalteradas.

### Artefatos relacionados

- `knowledge/ENGINEERING_QUALITY.md`
- `knowledge/ENGINEERING_FIELD_GUIDE.md`
- `agents/QA-Security/SPECS.md`
- `locales/pt-BR/knowledge/ENGINEERING_QUALITY.md`
- `locales/pt-BR/knowledge/ENGINEERING_FIELD_GUIDE.md`
- `locales/pt-BR/agents/QA-Security/SPECS.md`
- `CHANGELOG.md`

## ADR-010 - Especificações de agentes neutras e alinhamento da publicação

### Status

Aceita

### Data

2026-10-31

### Contexto

A distribuição publicada `v1.3.0` é neutra em relação a fornecedores por padrão, mas vários arquivos canônicos `SPECS.md` e `CONFIGURATION.md` de agentes ainda prescreviam modelos específicos de fornecedores e descreviam configurações de uma interface de assistente. Exemplos de configuração também pressupunham um caminho local específico do Framework, enquanto o roadmap e o status de tradução ainda descreviam `v1.3.0` como pré-release no momento desta decisão. O PDF versionado da auditoria de segurança contém achados e gates de release de 2026-10-19 que não são mais atuais.

### Decisão

- Definir `SPECS.md` como especificação canônica de comportamento, neutra em relação a harnesses; definir `CONFIGURATION.md` como perfil de execução independente de plataforma. Nenhum dos arquivos prescreve modelo, fornecedor, interface ou CLI.
- Expressar necessidades úteis de runtime como capacidades genéricas opcionais. Manter pontos de entrada, sintaxe de ferramentas e configurações de permissões específicas de fornecedor/CLI em adapters opcionais, com `generic` como padrão.
- Sincronizar os espelhos PT-BR dos agentes e atualizar documentação de agentes, exemplos de configuração, status de release e cobertura de tradução sem alterar a tag publicada `v1.3.0`.
- Preservar o PDF da auditoria de segurança como evidência histórica datada de 2026-10-19. Identificá-lo como não atual em sua documentação pública e gerador; não apresentar sua regeneração ou mudanças de apresentação como uma nova auditoria.
- Substituir datas legadas desconhecidas no changelog por um status explícito de data não registrada, em vez de inventar datas. Manter módulos suplementares propostos e adapters opcionais no repositório; esta decisão não os promove nem remove.

### Alternativas consideradas

- Manter configurações específicas de modelos e interfaces como snapshots históricos nas especificações canônicas dos agentes.
- Remover adapters opcionais e todos os módulos suplementares propostos da superfície de publicação.
- Redatar ou regenerar o PDF de auditoria antigo como se refletisse evidências atuais do repositório.

Essas alternativas manteriam uma dependência enganosa, removeriam material opcional intencional ou exagerariam a data e o escopo da auditoria.

### Consequências

O comportamento dos agentes pode ser implementado por qualquer harness ou CLI compatível, enquanto adapters opcionais carregam detalhes de integração. A manutenção de documentação e tradução aumenta ligeiramente; nenhuma dependência de runtime, responsabilidade de agente ou fase obrigatória de workflow é adicionada. A `v1.3.0` já publicada permanece inalterada. Na época desta decisão, estas atualizações ainda não haviam sido lançadas e dependiam de uma tag posterior; a execução atual da release `v1.4.0` está registrada no plano de execução e na proposta de contribuição.

### Artefatos relacionados

- `agents/README.md` e `locales/pt-BR/agents/README.md`
- `agents/*/SPECS.md` e `agents/*/CONFIGURATION.md`
- `agents/*/CHANGELOG.md` e espelhos PT-BR
- `README.md`, `README.pt-BR.md`, `START_PROJECTS.en-US.md` e
  `locales/pt-BR/public-docs/START_PROJECTS.md`
- `ROADMAP.md`, `OVERVIEW.md` e `locales/pt-BR/TRANSLATION_STATUS.md`
- `docs/security-audit/`
- `CHANGELOG.md`

## ADR-011 - Integração opcional e somente leitura do GitHub MCP no OpenCode

### Status

Aceita

### Data

2026-11-01

### Contexto

O repositório do Framework contém uma configuração OpenCode local ao projeto para o GitHub MCP Server. Servidores MCP se conectam automaticamente, a menos que sejam desativados, e os toolsets padrão do servidor upstream incluem operações de repositórios, issues e pull requests. Iniciar Docker e autorizar acesso ao GitHub implicitamente excederia o limite de integração opt-in e neutro em relação a fornecedores do Framework. O servidor GitHub também exige uma porta de callback fixa para OAuth no Docker.

### Decisão

- Manter a configuração GitHub MCP somente como configuração opcional do lado do Framework em `.opencode/opencode.jsonc`; não adicioná-la ao template genérico nem ao adapter OpenCode gerado para clientes.
- Definir `disabled: true` por padrão. Um mantenedor precisa habilitar o servidor explicitamente após revisar o acesso concedido.
- Fixar a imagem Docker na release upstream `v2.0.3`, restringi-la ao toolset `repos`, habilitar o modo somente leitura do servidor e solicitar somente o escopo OAuth `public_repo` neste exemplo.
- Vincular o callback OAuth do Docker a `127.0.0.1:8085`, de acordo com a porta registrada upstream. Não armazenar credenciais no repositório.
- Validar estaticamente a configuração nos dois validadores nativos do Framework; a validação não deve iniciar Docker nem iniciar OAuth.

### Alternativas consideradas

- Conectar automaticamente o GitHub MCP padrão com os toolsets e escopos padrão upstream.
- Remover toda configuração GitHub MCP do repositório do Framework.
- Instalar GitHub MCP automaticamente sempre que um cliente selecionar o adapter OpenCode.

A primeira alternativa adiciona execução implícita e acesso mais amplo. A segunda remove uma integração útil e explicitamente opcional para mantenedores. A terceira faria o acesso ao GitHub parecer requisito do adapter OpenCode.

### Consequências

Abrir o Framework no OpenCode não inicia Docker nem autoriza o GitHub, a menos que um mantenedor habilite o servidor explicitamente. Quando habilitada, a superfície de ferramentas MCP fica restrita a operações de repositório somente leitura, enquanto o acesso real continua dependendo da autorização GitHub do usuário. A concessão OAuth `public_repo` em si não é somente leitura; mantenedores devem tratá-la também como acesso a repositórios públicos, fora do filtro de ferramentas MCP. A integração não adiciona dependência ao bootstrap genérico e não é instalada em projetos clientes.

### Artefatos relacionados

- `.opencode/opencode.jsonc`
- `.opencode/README.md`
- `adapters/opencode/README.md`
- `scripts/validate-framework.sh`
- `scripts/validate-framework.ps1`
- `TESTING.md` e `locales/pt-BR/public-docs/TESTING.md`
- `OVERVIEW.md`
- `ROADMAP.md`
- `CHANGELOG.md`

## ADR-012 - Escopo de tradução e classificação de referências públicas

### Status

Aceita; o status de adoção dos módulos suplementares foi substituído pelo
ADR-014, e a decisão de manter o playbook legado foi substituída pelo ADR-016.
Seu escopo de tradução e os limites contra inclusão no grafo obrigatório e no
gate obrigatório de locale continuam vigentes.

### Data

2026-11-01

### Contexto

O backlog de tradução PT-BR misturava documentação pública ativa, quatro avaliações suplementares propostas de Knowledge e dois documentos de referência em português com autoridades diferentes. Traduzir um módulo proposto não deve promovê-lo ao grafo de dependências estável. Tratar o playbook histórico já removido como atual criaria uma fonte concorrente da verdade, enquanto traduzir cada detalhe de `docs/reference/LF_DESIGN_PERFORMANCE_GUIDE.md` como política excederia a adoção seletiva registrada no ADR-002. A tag publicada `v1.3.0` também precisa continuar distinta do trabalho pós-tag no checkout.

### Decisão

- Traduzir para PT-BR os quatro módulos suplementares propostos de Knowledge e validar paridade estrutural, mantendo o status `Proposed` e excluindo-os do grafo estável de dependências, do gate obrigatório de locale para Knowledge estável e dos requisitos de agentes.
- A decisão, à época, de manter o playbook histórico congelado em PT-BR foi substituída pelo ADR-016; os princípios normativos atuais continuam nos módulos canônicos do Framework.
- Manter `docs/reference/LF_DESIGN_PERFORMANCE_GUIDE.md` como referência detalhada, não como autoridade operacional completa. Revisar seletivamente orientações adicionais; somente conteúdo adotado explicitamente por módulos, protocolos, schemas ou ADRs canônicos é operacional. Não traduzir o guia inteiro apenas para alegar paridade de locale.
- Traduzir para PT-BR o overview, roadmap, changelog e registros ADR públicos ativos, com metadados do baseline-fonte e distinção clara entre a tag publicada `v1.3.0` e a manutenção ainda não lançada.
- Acompanhar exclusões deliberadas separadamente de traduções incompletas em `locales/pt-BR/TRANSLATION_STATUS.md` e `locales/README.md`.
- Manter um único arquivo de release com os dois pacotes de idioma; usuários
  selecionam o idioma do projeto durante o bootstrap. Não criar arquivos de
  release separados para EN-US e PT-BR.
- Não alterar a tag `v1.3.0`, seus arquivos de release nem checksums. Na época desta decisão, todas as mudanças resultantes ainda não haviam sido lançadas e dependiam de uma futura release autorizada separadamente.

### Alternativas consideradas

- Traduzir todos os arquivos públicos sem distinguir autoridade ou status.
- Promover as quatro avaliações suplementares porque possuem espelhos PT-BR.
- Manter a referência legada do Framework como segunda fonte normativa.
- Tratar todas as recomendações do guia detalhado de design/performance como requisitos adotados.
- Omitir a tradução de decisões públicas ativas e contexto de release sem registrar a limitação de acesso por idioma.

Essas alternativas criariam divergência entre fontes da verdade, alterariam silenciosamente o escopo do Framework ou deixariam ambígua a cobertura de idiomas.

### Consequências

O limite de tradução acompanha a autoridade dos documentos, não sua localização ou extensão. Módulos propostos ficam acessíveis em PT-BR sem mudar seu status de adoção. Referências históricas e detalhadas continuam disponíveis sem criar uma política duplicada e não revisada. Registros públicos ativos ganham espelhos de idioma, que exigem sincronização contínua. Verificações estruturais não certificam a qualidade semântica da tradução. O baseline publicado permanece inalterado.

### Artefatos relacionados

- `docs/reference/LF_DESIGN_PERFORMANCE_GUIDE.md`
- `knowledge/INDEX.md` e `knowledge/REGISTRY.md`
- `knowledge/ENGINEERING_ELEPHANT_GOLDFISH.md`
- `knowledge/ENGINEERING_AGENT_GRAPH_FLOW.md`
- `knowledge/ENGINEERING_RTK.md`
- `knowledge/ENGINEERING_GRAPHIFY.md`
- `OVERVIEW.md`, `ROADMAP.md`, `CHANGELOG.md` e `docs/ADR.md`
- `locales/README.md`
- `locales/pt-BR/TRANSLATION_STATUS.md`
- `scripts/check-locales.sh`
- `scripts/validate-framework.ps1`

## ADR-013 - Adoção seletiva de motion design e validação visual

### Status

Aceita

### Data

2026-11-01

### Contexto

As orientações atuais de design visual e performance já exigem acessibilidade
para movimento reduzido e evidências separadas para mobile/desktop, mas não
oferecem um contrato independente de tecnologia para intenção, coreografia,
comportamento de interação ou revisão específica de movimento. A Skill de
Motion Design analisada oferece princípios neutros em relação a bibliotecas; as
skills de GSAP oferecem orientações úteis, mas específicas de biblioteca;
img2threejs demonstra criação de assets visuais em etapas, com gates de qualidade
e comparação baseada em evidências. Suas instruções de instalação, ferramentas
padrão e heurísticas fixas não se alinham ao padrão `generic` neutro em relação a
fornecedores do Framework.

### Decisão

- Adicionar `ENGINEERING_MOTION_DESIGN` como módulo estável e condicional de
  Knowledge para projetos que planejam, implementam ou avaliam movimento. Ele
  não exige movimento, não adiciona fase ao workflow nem prescreve biblioteca de
  implementação.
- Registrar intenção, comportamento e expectativas para movimento reduzido no
  handoff aplicável de produto/design. Adicionar uma Revisão de movimento
  condicional ao protocolo existente de validação de performance, schema e
  template de relatório; registrar `Não aplicável` quando movimento estiver
  fora do escopo.
- Adotar princípios independentes de ferramenta para intenção, hierarquia,
  acessibilidade, controle do usuário, limpeza em runtime, evidências de
  performance e revisão visual. Tratar sugestões publicadas de timing e
  quantidade de elementos como heurísticas, não gates fixos.
- Manter instruções específicas do GSAP condicionadas à escolha do GSAP pelo
  projeto. Manter a reconstrução procedural 3D como pipeline opt-in delimitado;
  exigir aprovação explícita do projeto antes de instalar skills, plugins ou
  dependências externas.
- Manter `generic` como padrão, preservar o guia legado de design como referência
  não normativa e não alterar a tag publicada `v1.3.0`, seus arquivos ou
  checksums.

### Alternativas consideradas

- Copiar as skills dos três repositórios e adicioná-las ao workflow padrão.
- Recomendar GSAP como implementação de animação para todo o Framework.
- Tornar a modelagem procedural 3D ou um novo workflow de animação obrigatório
  para projetos visuais.
- Depender somente das verificações genéricas atuais de performance e
  acessibilidade sem registrar comportamento ou evidências do movimento.

Essas alternativas criariam dependência de ferramentas, expansão de escopo,
riscos desnecessários de instalação ou aceite de movimento sem rastreabilidade
suficiente.

### Consequências

Projetos visuais com movimento recebem um contrato de design reutilizável e
evidências explícitas de revisão, incluindo o comportamento para movimento
reduzido. Projetos sem movimento registram a dispensa condicional. O Framework
permanece neutro em relação a tecnologias e não ganha dependência de runtime,
skill externa obrigatória, CLI ou fase de workflow. São necessárias
manutenções do novo módulo, protocolo, template, decisão e traduções. Na época
desta decisão, essas mudanças ainda não haviam sido lançadas e dependiam de uma
tag futura autorizada.

### Artefatos relacionados

- `knowledge/ENGINEERING_MOTION_DESIGN.md` e seu espelho PT-BR
- `knowledge/INDEX.md`, `knowledge/REGISTRY.md` e `knowledge/ENGINEERING_DESIGN_PERFORMANCE.md`
- `protocols/PERFORMANCE_VALIDATION.md`
- `schemas/PERFORMANCE_VALIDATION_REPORT.schema.md`
- `PROJECT_TEMPLATE/docs/DESIGN.md` e `PROJECT_TEMPLATE/docs/PERFORMANCE_VALIDATION_REPORT.md`
- `workflows/NEW_PROJECT.md` e `workflows/STANDARD_DEVELOPMENT.md`
- `OVERVIEW.md`, `ROADMAP.md`, `CHANGELOG.md` e espelhos PT-BR
- [Motion Design Skill](https://github.com/lottiefiles/motion-design-skill)
- [GSAP Skills](https://github.com/greensock/gsap-skills)
- [img2threejs](https://github.com/img2threejs/img2threejs)

## ADR-014 - Adoção opcional dos quatro módulos suplementares

### Status

Aceita

### Data

2026-11-01

### Contexto

Quatro módulos suplementares de Knowledge têm evidências delimitadas de piloto.
A avaliação independente Elephant-Goldfish, em sessões novas, do piloto de
motion design passou na compreensão com ressalvas, mas não passou nas verificações
de crítica nem de prontidão para implementação. Os pilotos AGF e RTK foram
pequenos e sintéticos; a proveniência de Graphify entre fonte e build continua
incompleta. O Project Owner aprovou seu avanço para a candidata `v1.4.0` e
esclareceu que devem ser aprovados como referências opcionais, não dependências
obrigatórias. Esta decisão não implica eficácia geral, prontidão para produção
nem autorização para instalar ferramentas externas.

### Decisão

- Aprovar `ENGINEERING_ELEPHANT_GOLDFISH`, `ENGINEERING_AGENT_GRAPH_FLOW`,
  `ENGINEERING_RTK` e `ENGINEERING_GRAPHIFY` como referências suplementares
  opcionais para a candidata `v1.4.0`. Marcar cada módulo como `Opcional aprovado`.
- Manter os módulos fora do grafo obrigatório de dependências, do Knowledge
  padrão dos agentes, de gates obrigatórios de workflow e de artefatos exigidos.
  Selecionar um módulo somente quando for relevante para uma tarefa e seus
  limites forem compreendidos.
- Tratar esta decisão como aprovação da orientação. Ela não autoriza instalar
  ou ativar `agf`, RTK ou Graphify, nem adicionar suas CLIs, pacotes, hooks,
  plugins, skills, servidores MCP, provedores, telemetria ou estado gerado. Cada
  uso desse tipo exige aprovação específica e separada do proprietário.
- Preservar o limite explícito do Graphify: o módulo opcional foi aprovado, mas
  a lacuna de proveniência entre fonte e build continua sem solução; não instalar,
  executar ou integrar mais a ferramenta sem aprovação separada de um limiar de
  proveniência.
- Registrar a avaliação Elephant-Goldfish sem chamar o piloto de bem-sucedido
  nem o design de pronto para implementação. Os achados não criam um gate
  universal e não substituem aprovação humana, Code Review, QA ou revisão de
  segurança.
- Manter `generic` como padrão e deixar inalteradas a tag publicada `v1.3.0`,
  seus arquivos e checksums. A preparação da candidata `v1.4.0` está aprovada;
  este ADR não autoriza empacotamento, criação de tag ou publicação.

### Alternativas consideradas

- Manter todos os módulos com status `Proposed` até concluir pilotos maiores ou
  representativos.
- Promover os módulos ao grafo estável obrigatório de dependências ou tornar
  suas práticas requisitos universais de workflow.
- Tratar a aprovação do módulo Graphify como autorização para instalar ou
  integrar a ferramenta Graphify, ou tratar os pilotos de AGF/RTK como
  autorização para configuração automática.

A primeira alternativa desconsideraria a decisão explícita de escopo do Project
Owner. As demais exagerariam as evidências, introduziriam riscos de ferramentas
não aprovados e alterariam o padrão neutro em relação a fornecedores.

### Consequências

Os quatro módulos passam a ser referências opcionais aprovadas, descobríveis em
EN-US e PT-BR. Os registros e a validação de locale passam a verificar o status
opcional aprovado; o grafo estável de dependências, o workflow padrão e o
bootstrap `generic` permanecem inalterados. Evidências dos pilotos e achados sem
solução continuam explícitos, e instalação ou integração de ferramentas externas
permanece sob gate separado. Na época desta decisão, a candidata ainda não havia
sido lançada e dependia da autorização final e dos gates de release; a execução
posterior está registrada na proposta de contribuição e no plano de execução.

### Artefatos relacionados

- `knowledge/ENGINEERING_ELEPHANT_GOLDFISH.md` e seu espelho PT-BR
- `knowledge/ENGINEERING_AGENT_GRAPH_FLOW.md` e seu espelho PT-BR
- `knowledge/ENGINEERING_RTK.md` e seu espelho PT-BR
- `knowledge/ENGINEERING_GRAPHIFY.md` e seu espelho PT-BR
- `knowledge/INDEX.md`, `knowledge/REGISTRY.md` e seus espelhos PT-BR
- `docs/evaluations/ELEPHANT_GOLDFISH_MOTION_DESIGN_2026-11-01.md`
- `docs/proposals/V1.4.0_CONTRIBUTION_PROPOSAL.md`
- `docs/plans/V1.4.0_EXECUTION_PLAN.md`
- `CHANGELOG.md`, `OVERVIEW.md`, `ROADMAP.md` e espelhos PT-BR
- `scripts/check-locales.sh` e `scripts/validate-framework.ps1`

## ADR-015 - Organização da fonte EN-US e dos documentos PT-BR

### Status

Aceita; a decisão de manter caminhos de compatibilidade foi substituída pelo ADR-016.

### Data

2026-11-01

### Contexto

A biblioteca técnica canônica EN-US já fica na raiz do repositório, enquanto a
maioria dos espelhos PT-BR fica em `locales/pt-BR/`. Alguns documentos públicos
traduzidos permaneciam misturados à raiz e a `docs/`, e `locales/en-US/`
continha somente um README. Isso reduzia a clareza sobre a responsabilidade de
idioma e criava ambiguidade no caminho `START_PROJECTS.md`. Mover a biblioteca
canônica para uma segunda árvore de locale exigiria alterar bootstrap, adapters,
validadores e muitas referências sem melhorar a fronteira da fonte da verdade.

### Decisão

- Manter EN-US como idioma-fonte técnico. Agentes, Knowledge, workflows,
  protocolos, schemas e o `PROJECT_TEMPLATE/` padrão permanecem na raiz.
- Agrupar documentos públicos traduzidos em `locales/pt-BR/public-docs/` e o
  espelho PT-BR do ADR em `locales/pt-BR/docs/ADR.md`. Manter os espelhos
  técnicos PT-BR e o template traduzido nos caminhos existentes de
  `locales/pt-BR/`.
- Manter `locales/en-US/README.md` como índice que explica que as fontes EN-US
  canônicas ficam na raiz; não duplicar ali a árvore de fontes.
- Manter `README.pt-BR.md` como página inicial do repositório em PT-BR. A decisão
  de reter páginas PT-BR de compatibilidade na raiz foi substituída pelo ADR-016.
- Atualizar verificações de locale, validadores de plataforma, seletores de
  idioma e índices para usar os caminhos canônicos de locale. A mudança é apenas
  organizacional: não altera a seleção de idioma do bootstrap, o padrão
  `generic`, os limites dos módulos opcionais ou o conteúdo da release.
- Manter inalteradas a tag publicada `v1.3.0`, seus archives e checksums. Este
  ADR não autoriza empacotamento, criação de tag ou publicação.

### Alternativas consideradas

- Mover todos os módulos canônicos EN-US para `locales/en-US/` e atualizar cada
  caminho consumidor.
- Manter documentos públicos traduzidos misturados entre a raiz e `locales/`.
- Remover imediatamente os caminhos públicos antigos e exigir que usuários
  descubram a nova organização de locale.

A primeira opção gera ampla alteração de caminhos sem melhorar a propriedade
canônica; a segunda mantém a ambiguidade atual; a terceira quebra links
existentes sem necessidade. A organização escolhida torna os documentos por
idioma mais fáceis de localizar e mantém compatibilidade.

### Consequências

O conteúdo dos documentos públicos PT-BR agora tem um local canônico em
`locales/pt-BR/`. À época da aceitação deste ADR, páginas na raiz preservavam
caminhos de entrada antigos; o ADR-016 remove esses aliases. O validador compara
os documentos públicos ativos diretamente com as fontes EN-US. A paridade
estrutural continua sendo uma verificação mecânica e não certifica a qualidade
semântica da tradução. Não há alteração na release nem no baseline publicado.

### Artefatos relacionados

- `locales/README.md`, `locales/en-US/README.md` e
  `locales/pt-BR/TRANSLATION_STATUS.md`
- `locales/pt-BR/public-docs/` e `locales/pt-BR/docs/ADR.md`
- `README.pt-BR.md` e os antigos caminhos PT-BR de compatibilidade (removidos pelo ADR-016)
- `scripts/check-locales.sh`, `scripts/validate-framework.sh` e
  `scripts/validate-framework.ps1`
- `README.md`, `README.pt-BR.md`, `CHANGELOG.md` e seu espelho PT-BR

## ADR-016 - Remoção de referências legadas e caminhos de compatibilidade

### Status

Aceita

### Data

2026-11-01

### Contexto

O ADR-012 manteve um playbook congelado em português como referência pública
histórica, e o ADR-015 preservou páginas de compatibilidade na raiz depois que
os documentos públicos PT-BR foram agrupados em `locales/pt-BR/`. O playbook
legado não é uma fonte operacional; a biblioteca normativa atual está nos
módulos canônicos. As páginas de compatibilidade duplicam a navegação para os
documentos de locale e não são consumidas pelo bootstrap. O guia detalhado de
design/performance é diferente: o módulo canônico de Knowledge o cita como
racional de origem.

### Decisão

- Remover os caminhos de compatibilidade PT-BR obsoletos na raiz:
  `CONTRIBUTING.pt-BR.md`, `SECURITY.pt-BR.md`, `TESTING.pt-BR.md`,
  `CHANGELOG.pt-BR.md`, `OVERVIEW.pt-BR.md`, `ROADMAP.pt-BR.md`,
  `docs/ADR.pt-BR.md` e o seletor ambíguo `START_PROJECTS.md`. O conteúdo PT-BR
  canônico permanece em `locales/pt-BR/`. Manter a página inicial completa do
  repositório `README.pt-BR.md`.
- Remover o playbook de Framework legado e substituído
  `LF_ENGINEERING_FRAMEWORK.md`. As orientações normativas atuais permanecem em
  `agents/`, `knowledge/`, `workflows/`, `protocols/` e `schemas/`.
- Mover `LF_DESIGN_PERFORMANCE_GUIDE.md` para
  `docs/reference/LF_DESIGN_PERFORMANCE_GUIDE.md`. Mantê-lo como referência
  detalhada e não normativa porque o módulo canônico de design/performance cita
  sua proveniência. Somente requisitos adotados explicitamente por artefatos
  canônicos são operacionais.
- Atualizar documentação, validadores de locale e de plataforma e o gerador do
  relatório de auditoria para os caminhos canônicos. Manter inalterado o PDF de
  auditoria existente como snapshot histórico; não o regenerar nesta decisão.
- Aceitar que links para caminhos de compatibilidade removidos na branch atual
  deixarão de resolver. Isso não altera o bootstrap, o padrão `generic`, os
  limites dos módulos opcionais nem a tag publicada `v1.3.0` e seus
  archives/checksums.

### Alternativas consideradas

- Manter indefinidamente todas as páginas de compatibilidade na raiz para
  preservar URLs antigas.
- Apagar também o guia detalhado de design/performance, perdendo o racional de
  origem citado pelo Knowledge canônico.
- Mover todas as fontes técnicas EN-US para uma árvore paralela
  `locales/en-US/`.

A primeira alternativa mantém caminhos duplicados sem consumidor de runtime; a
segunda romperia a proveniência; a terceira criaria ampla alteração de caminhos.
A decisão remove aliases obsoletos e preserva o único guia-fonte que ainda
sustenta a rastreabilidade canônica.

### Consequências

Links e validadores atuais apontam somente para caminhos canônicos de locale, e o
playbook português obsoleto deixa de ser apresentado como referência pública
atual. Links externos para os caminhos removidos podem quebrar; tags históricas
permanecem inalteradas. O guia de design/performance continua disponível em
`docs/reference/`, sem se tornar autoridade operacional.

### Artefatos relacionados

- `README.md`, `README.pt-BR.md`, `OVERVIEW.md` e seu espelho PT-BR
- `locales/README.md` e `locales/pt-BR/TRANSLATION_STATUS.md`
- `locales/pt-BR/public-docs/` e `locales/pt-BR/docs/ADR.md`
- `docs/reference/LF_DESIGN_PERFORMANCE_GUIDE.md`
- `knowledge/ENGINEERING_DESIGN_PERFORMANCE.md` e seu espelho PT-BR
- `scripts/validate-framework.sh`, `scripts/validate-framework.ps1` e
  `docs/security-audit/gerar_relatorio.py`

## ADR-017 - Publicação de releases sem GitHub Environment

### Status

Aceita (política de proteção da branch pública substituída pelo ADR-019)

### Data

2026-11-01

### Contexto

No repositório privado predecessor, o workflow de release referenciava um GitHub Environment chamado `release` no
job de publicação. O responsável pelo repositório decidiu não usar proteções de
ambiente nem aprovação manual por revisores. Apagar o ambiente no GitHub, por si
só, não basta: uma execução futura pode recriar um ambiente referenciado pelo
workflow sem regras de proteção. Manter essa referência representaria
incorretamente a política de release e criaria um ambiente implicitamente
desprotegido.

### Decisão

- Não usar nem exigir um GitHub Environment para publicar releases do Framework;
  remover a declaração `environment` do job de publicação.
- Depois que o commit exato da tag de release passar pela matriz Ubuntu/macOS/
  Windows e o job de empacotamento somente leitura terminar, o job de publicação
  será executado automaticamente com `contents: write`.
- Um push de tag estável correspondente é o único gatilho de publicação do
  workflow. Remover `workflow_dispatch` para que uma tag existente não possa ser
  republicada por um caminho manual separado.
- Tratar a criação/envio de uma tag de release correspondente como a ação
  consequente e explícita de release. Ela ainda exige autorização separada do
  responsável; esta decisão não autoriza criar ou enviar uma tag de release.
- Para o repositório privado predecessor, rulesets de branch/tag não eram gates
  obrigatórios de release porque havia um único responsável. O ADR-019 define a
  política de proteção separada do novo repositório público. Regras de deployment
  e revisores obrigatórios do environment não são gates de release para este
  Framework.

### Alternativas consideradas

- Manter o environment `release` e configurar revisores obrigatórios no GitHub.
- Apagar o environment, mas deixar a referência no workflow, permitindo que o
  GitHub o recrie sem regras de proteção.
- Remover a referência ao environment enquanto se afirma que a publicação ainda
  aguarda aprovação manual de revisor.
- Manter `workflow_dispatch` como segundo gatilho de publicação para tags
  existentes.
- Exigir rulesets pagos de branch/tag para um repositório mantido por uma pessoa.

A primeira alternativa conflita com a decisão do responsável, para o repositório
predecessor, de que environments não são aplicáveis. A segunda deixa um ambiente desprotegido e enganoso. A
terceira documentaria um gate que o workflow não impõe. A quarta permitiria um
caminho manual separado de publicação. A quinta adicionaria custo e administração
sem separar a autoridade de release no repositório predecessor de responsável único.

### Consequências

O workflow deixa de criar ou depender de um environment `release`, e somente um
push de tag estável correspondente pode iniciar a publicação. Após as
verificações multiplataforma obrigatórias e o empacotamento, a publicação
prossegue automaticamente; nenhum revisor do environment pausa o job. A política
de acesso e proteção de branch do repositório público está registrada
separadamente no ADR-019. Este ADR não cria uma release.

### Artefatos relacionados

- `.github/workflows/release.yml`
- `TESTING.md` e seu espelho PT-BR
- `CHANGELOG.md` e seu espelho PT-BR
- `docs/plans/V1.4.0_EXECUTION_PLAN.md`
- `docs/proposals/V1.4.0_CONTRIBUTION_PROPOSAL.md`
- `locales/pt-BR/TRANSLATION_STATUS.md`

## ADR-018 - Inspeção dinâmica local e independência do nome do checkout

### Status

Aceita

### Data

2026-11-01

### Contexto

O gerador do relatório de segurança continha achados e data de avaliação fixos;
executá-lo novamente não descrevia o projeto atual. O PDF histórico também podia
ser confundido com uma avaliação vigente. Além disso, os comandos documentados
podiam parecer depender do nome padrão do diretório de clone, embora usuários
possam usar `LF-Engineering-Framework` ou outro nome no checkout.

### Decisão

- Tornar `docs/security-audit/gerar_relatorio.py` um inspetor local, somente
  leitura e preliminar. Por padrão, ele inspeciona o diretório atual e aceita
  `--project CAMINHO` para indicar outro diretório.
- Gravar o PDF por padrão em
  `<projeto>/docs/security-audit/relatorio-auditoria-seguranca.pdf`, sobrescrevê-lo
  a cada execução e permitir um `--output CAMINHO` explícito.
- Não executar código ou comandos do projeto, acessar a rede, alterar permissões
  ou apagar arquivos do projeto. Ignorar links simbólicos e diretórios comuns de
  dependências/build. Reportar correspondências de formatos de credenciais apenas
  pelo tipo e localização, nunca pelo valor.
- Identificar o relatório como preliminar e heurístico. Ele não deve alegar ser
  uma auditoria de segurança completa, certificar ausência de vulnerabilidades
  ou aprovar um projeto; a revisão QA-Security continua obrigatória.
- Identificar o PDF de 19/10/2026 como evidência histórica, não como auditoria
  atual. A tag `v1.4.0` do repositório privado predecessor não foi importada; o
  PDF rastreado permanece como arquivo histórico preservado.
- Derivar os caminhos do Framework a partir da localização dos scripts ou de
  caminhos explícitos, sem depender de um nome fixo de checkout. Documentar e
  testar comandos com o checkout chamado `LF-Engineering-Framework`.

### Alternativas consideradas

- Continuar renderizando dados históricos fixos, o que não atende à necessidade
  de evidências atuais do projeto.
- Criar um segundo inspetor, deixando dois comandos semelhantes e aumentando o
  risco de regenerar o relatório errado.
- Incluir os valores de credenciais encontrados por conveniência, expondo
  desnecessariamente segredos no PDF gerado.

A primeira alternativa mantém a limitação original; a segunda cria uma fronteira
ambígua entre ferramentas; a terceira aumenta o impacto de divulgação do relatório.

### Consequências

O relatório muda conforme a árvore de trabalho inspecionada e é sobrescrito no
destino configurado. A inspeção é local e evita executar o projeto ou acessar a
rede, mas suas assinaturas e heurísticas limitadas podem produzir falsos positivos
e falsos negativos. A revisão humana QA-Security e os testes específicos do projeto
continuam necessários. A tag `v1.4.0` do repositório privado predecessor não faz
parte do repositório público; seu PDF histórico rastreado não é modificado. Os
comandos de bootstrap e validação independem do nome da pasta do checkout.

### Artefatos relacionados

- `docs/security-audit/gerar_relatorio.py` e `test_gerar_relatorio.py`
- `docs/security-audit/README.md` e seu espelho PT-BR
- `TESTING.md` e seu espelho PT-BR
- `CONTRIBUTING.md` e seu espelho PT-BR; `.github/PULL_REQUEST_TEMPLATE.md`
- `START_PROJECTS.en-US.md` e seu espelho PT-BR
- `scripts/validate-framework.sh`, `scripts/validate-framework.ps1` e
  `scripts/check-locales.sh`
- `scripts/bootstrap.sh`, `scripts/bootstrap.ps1`, `scripts/test-bootstrap.sh` e
  `scripts/test-bootstrap.ps1` (estado local somente do proprietário implementa o ADR-001)
- `.github/workflows/validate.yml`
- `CHANGELOG.md` e seu espelho PT-BR

## ADR-019 - Repositório público limpo e primeira release pública

### Status

Aceita

### Data

2026-11-03

### Contexto

O repositório privado predecessor contém metadados históricos de commits e
caminhos locais do mantenedor que não devem ser expostos em um repositório
público. O responsável também decidiu preservar aquele repositório privado e
suas tags publicadas. Reescrever seu histórico violaria esse limite, enquanto
importar histórico, branches ou tags exporia metadados privados desnecessários e
deixaria o baseline público ambíguo.

### Decisão

- Criar `LeandroFernandess/LF-Engineering-Framework` como repositório público
  separado, a partir de um snapshot de fonte revisado, inicializado com um único
  commit raiz limpo na branch `main`.
- Não copiar o diretório `.git`, histórico, branches ou tags do repositório
  privado predecessor. Manter inalterados sua árvore de trabalho, remoto,
  branches e tags.
- Fazer de `v1.5.0` a primeira release pública. Descrever `v1.4.0` e versões
  anteriores somente como releases históricas do predecessor; não criar nem
  importar suas tags ou artefatos públicos.
- Usar o endereço GitHub noreply da conta na identidade do commit público.
- Proteger `main` exigindo pull requests e validações bem-sucedidas em Ubuntu,
  macOS e Windows. Não exigir aprovação de revisor enquanto houver um único
  mantenedor; reavaliar se o acesso de escrita for ampliado.
- Manter a publicação de tags estáveis condicionada à validação da tag exata e
  ao workflow de empacotamento; uma tag de release continua exigindo autorização
  separada do responsável.

### Alternativas consideradas

- Reescrever e migrar o histórico predecessor, arriscando alterar o limite de
  releases do repositório privado e reter metadados desnecessários.
- Publicar somente o conteúdo antigo da `v1.4.0`, excluindo correções de
  acompanhamento já revisadas e deixando o baseline público defasado.
- Publicar o repositório atual como está, expondo metadados históricos do Git e
  a estrutura privada de branches/tags.

O snapshot limpo preserva o repositório privado e torna o baseline público
explícito e verificável de forma independente.

### Consequências

O repositório público não tem histórico Git nem tags herdadas anteriores à
`v1.5.0`. Registros históricos de planejamento e avaliação só são mantidos quando
explicitamente aprovados e sanitizados; links privados de execução, caminhos
locais e identificadores de sessão não fazem parte do registro público. O
repositório privado continua sendo a fonte histórica mantida pelo responsável.
Pull requests e verificações multiplataforma protegem `main`, enquanto tags de
release continuam sendo ações consequentes com autorização separada.

### Artefatos relacionados

- `.github/workflows/validate.yml` e `.github/workflows/release.yml`
- `CHANGELOG.md`, `OVERVIEW.md`, `ROADMAP.md` e seus espelhos PT-BR
- `README.md` e `README.pt-BR.md`
- `SECURITY.md` e seu espelho PT-BR

## ADR-020 - Manter `.ai/state/` local e ignorado por padrão

### Status

Aceita

### Data

2026-11-03

### Contexto

Arquivos de estado do projeto apoiam recuperação e coordenação, mas podem conter
contexto operacional privado. Permissões exclusivas do proprietário no sistema
de arquivos não impedem que o Git publique um arquivo, e o bootstrap preserva o
`.gitignore` existente em vez de substituí-lo.

### Decisão

- Adicionar `/.ai/state/` aos arquivos `.gitignore` da raiz e dos projetos
  gerados, para que o estado copiado para um projeto novo permaneça local por
  padrão.
- Manter as restrições de permissões do bootstrap para diretórios e arquivos
  `.ai/state/`; ignore do Git e permissões locais tratam riscos diferentes.
- Preservar arquivos `.gitignore` existentes. Documentar que projetos existentes
  precisam adotar a regra manualmente se desejarem a mesma proteção padrão.
- Compartilhar estado somente após revisão e aprovação explícitas por arquivo;
  não adicionar `.ai/state/` inteiro com `git add -f`.

### Alternativas consideradas

- Deixar `.ai/state/` versionável e depender de revisão manual antes de cada
  commit.
- Ignorar todo `.ai/`, o que também excluiria contratos de coordenação e decisões
  de projeto que devem poder ser versionados.
- Reescrever `.gitignore` existentes durante o bootstrap, violando o contrato de
  preservação e cópia somente de arquivos ausentes.

A regra selecionada protege projetos novos sem alterar o comportamento de adoção
de projetos existentes nem ocultar o restante de `.ai/`.

### Consequências

Projetos novos não rastreiam acidentalmente o estado local com operações Git
comuns. Projetos existentes mantêm sua política atual até que os mantenedores
adotem a regra. Ainda é possível forçar a inclusão de arquivos específicos após
revisão, portanto o ignore do Git é uma proteção padrão, não uma fronteira de
controle de acesso. As permissões locais exclusivas do proprietário continuam
valendo independentemente.

### Artefatos relacionados

- `.gitignore` e `PROJECT_TEMPLATE/.gitignore`
- `scripts/bootstrap.sh`, `scripts/bootstrap.ps1` e suas suítes de teste
- `PROJECT_TEMPLATE/AGENTS.md` e seu espelho PT-BR
- `START_PROJECTS.en-US.md` e seu espelho PT-BR
- `SECURITY.md` e seu espelho PT-BR

## ADR-021 - Adoção seletiva de princípios de simulação interativa orientada por modelo

### Status

Aceita

### Data

2026-11-04

### Contexto

As orientações condicionais existentes de motion design cobrem intenção do
movimento, acessibilidade, performance e revisão de assets 3D procedurais, mas
não explicam como um simulador interativo deve manter coerentes o comportamento
modelado, a geometria renderizada e os valores exibidos. O repositório
`elvarofficial/teardown` e o artigo relacionado descrevem um fluxo de simulador
orientado pelo modelo, com referências, estado compartilhado, inspeção interativa
e revisão visual. Detalhes de implementação, ferramentas, alegações de
performance e heurísticas fixas são fontes de informação, não requisitos do
Framework.

### Decisão

- Ampliar `ENGINEERING_MOTION_DESIGN` com orientações opcionais e independentes de
  tecnologia para simuladores visuais interativos explicitamente solicitados e
  orientados por modelo.
- Exigir que projetos que usem essas orientações declarem, nos artefatos
  existentes de PRD, DESIGN e ARCHITECTURE conforme aplicável, uso pretendido,
  fidelidade, limitações, fontes de dados importantes, unidades, premissas e
  status das evidências.
- Tratar um estado do modelo como fonte para a geometria renderizada e seus
  rótulos, medidores, gráficos ou esquemas relacionados; exigir verificações
  numéricas independentes quando a correção for importante e revisão visual de
  estados representativos.
- Adicionar uma Revisão de modelo interativo condicional ao relatório existente
  de validação de performance. Ela não substitui validação de performance por
  rota/perfil, acessibilidade, funcionalidade ou especialista de domínio.
- Preservar o controle do usuário e o acesso com movimento reduzido. Manter
  captura, áudio, 3D, ferramentas de implementação e empacotamento como opcionais;
  não prescrever metas fixas de taxa de quadros ou tamanho de pacote.
- Não adicionar agente, fase obrigatória ao workflow, dependência externa ou
  instalação padrão de ferramenta. Reavaliar módulo ou artefato independente
  somente se evidências recorrentes de projetos demonstrarem uma necessidade
  distinta e reutilizável.

### Alternativas consideradas

- Instalar ou copiar o skill `teardown` e sua cadeia de ferramentas como padrão
  do Framework.
- Tornar simulação 3D ou animação parte de todo projeto visual.
- Criar uma fase obrigatória de workflow, um agente ou um artefato independente
  de simulador antes de haver evidências recorrentes de projetos.
- Adotar heurísticas fixas de performance, layout, animação ou empacotamento das
  fontes como metas universais do Framework.
- Tratar uma renderização realista como prova suficiente da precisão numérica do
  modelo subjacente.

Essas alternativas introduziriam dependência de ferramenta, escopo desnecessário,
metas universais sem sustentação ou falsa confiança na precisão do modelo.

### Consequências

Projetos que precisarem explicitamente de um simulador interativo terão um
contrato rastreável de modelo e validação, mantendo o workflow e a cadeia de
artefatos existentes. As orientações aumentam a manutenção de documentação e
traduções; o trabalho de revisão do modelo é condicional ao escopo do simulador.
A release publicada `v1.5.0` permanece inalterada; este ADR registra somente
manutenção pós-tag e não autoriza uma release.

### Artefatos relacionados

- `knowledge/ENGINEERING_MOTION_DESIGN.md` e seu espelho PT-BR
- `knowledge/INDEX.md`, `knowledge/REGISTRY.md` e seus espelhos PT-BR
- `workflows/NEW_PROJECT.md`, `workflows/STANDARD_DEVELOPMENT.md` e espelhos PT-BR
- `protocols/PERFORMANCE_VALIDATION.md`, seu schema e template de relatório
- Instruções, contratos e templates de PRD/ARCHITECTURE em `PROJECT_TEMPLATE/`
- `CHANGELOG.md`, `OVERVIEW.md` e espelhos PT-BR
- [teardown](https://github.com/elvarofficial/teardown)
- [Como transformo qualquer máquina em um simulador 3D que você pode desmontar](https://teapawt.org/elvar_official/article/2116174609355571402)
