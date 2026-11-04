# Conhecimento de Engenharia: Agent Graph Flow (agf)

Versão: 0.2.0

Status: Opcional aprovado

Categoria: Suplementar / Avaliação de ferramenta externa

Responsável: Leandro Fernandes
Baseline do Framework: LF Engineering Framework 1.3.0; status de adoção atualizado pós-tag

---

# Status de adoção

Este módulo foi aprovado como orientação opcional para avaliar `agent-graph-flow` (`agf`) como uma camada de execução e evidências para o LF Engineering System.

Ele não faz parte do grafo obrigatório de dependências do LF. Não deve adicionar silenciosamente requisitos de CLI, gates de grafo, skills, hooks, provedores ou mudanças de ciclo de vida ao Framework.

Esta aprovação não autoriza instalar ou ativar `agf`, suas skills, hooks, provedores ou dashboards. Qualquer instalação ou integração da ferramenta exige aprovação específica e separada do proprietário. Por padrão, as recomendações não se tornam regras do Framework, gates de workflow, instruções de agentes ou artefatos obrigatórios.

---

# Objetivo

Este módulo preserva as ideias úteis por trás do `agf` e avalia sua adequação ao LF Engineering System.

A compatibilidade central é complementar:

- O LF é responsável pela intenção de produto, arquitetura, governança, artefatos, papéis de agentes e aprovação humana.
- O `agf` pode manter um registro operacional ativo de tarefas, estado, dependências, critérios de aceite, evidências de conclusão e medições de custo.
- O repositório do projeto e seus testes continuam sendo a autoridade sobre código e comportamento reais.

Esse limite proposto evita duplicar responsabilidades de `PRD.md`, `ARCHITECTURE.md`, `SPRINTS.md`, ADRs, revisões, relatórios de QA e estado `.ai/`.

---

# Não objetivos

Este módulo não:

- Substitui o LF Engineering Framework nem seus contratos de artefatos.
- Exige `agf` para todo projeto LF ou toda alteração de manutenção.
- Trata o site, README ou alegações de marketing do `agf` como comprovados de forma independente.
- Trata um status no grafo como prova quando o sistema de arquivos, os testes ou as evidências de revisão o contradizem.
- Trata `agf` como sandbox, fronteira de segurança ou substituto de container ou máquina virtual.
- Exige MCP. O projeto público descreve a CLI como interface principal e informa que o transporte MCP é opcional e vem desativado por padrão.
- Copia todo o backlog do LF para uma segunda fonte da verdade sem modelo explícito de responsabilidade e sincronização.
- Ativa stigmergia, ACO, recuperação neural, provedores externos ou entrega autônoma sem piloto revisado.

---

# Fontes e evidências

## Fontes públicas

- Site do produto: <https://graph-flow.cloud/>
- Repositório: <https://github.com/DiegoNogueiraDev/agf>
- README: <https://raw.githubusercontent.com/DiegoNogueiraDev/agf/main/README.md>
- Guia de instalação: <https://raw.githubusercontent.com/DiegoNogueiraDev/agf/main/INSTALL.md>
- Política de segurança: <https://raw.githubusercontent.com/DiegoNogueiraDev/agf/main/SECURITY.md>
- Instruções públicas para agentes: <https://raw.githubusercontent.com/DiegoNogueiraDev/agf/main/AGENTS.md>
- Repositório de skills: <https://github.com/DiegoNogueiraDev/skills-graph>
- README das skills: <https://raw.githubusercontent.com/DiegoNogueiraDev/skills-graph/main/README.md>
- Instalador revisado: <https://graph-flow.cloud/install.sh>

Consultado em: 2026-09-03.

A release pública revisada se identifica como `v0.24.2`.

## Classes de evidência

Use estes rótulos ao se referir ao `agf` nos registros do LF:

| Rótulo | Significado |
| --- | --- |
| Alegação pública | Comportamento ou propriedade descrito pelo site, README, documentação-fonte ou instalador. |
| Observação local | Comportamento observado de fato ao executar a CLI instalada neste workspace LF ou no diretório home do usuário. |
| Recomendação LF | Uso ou limite proposto que ainda exige revisão e evidências de piloto. |

Por padrão, a CLI instalada e a fonte pública não foram tratadas como idênticas. Divergência de versão, arquivos gerados, configuração local e escopo do projeto podem alterar o comportamento.

---

# Síntese executiva

O `agf` transforma a execução de software em um grafo SQLite persistente, em vez de uma conversa efêmera. Seu modelo público contém tarefas, dependências, critérios de aceite e transições de estado. Seu ciclo de execução anunciado é:

1. Estruturar o trabalho em um grafo executável.
2. Buscar uma tarefa desbloqueada por vez.
3. Implementar com desenvolvimento test-first.
4. Validar a Definition of Done e as evidências no sistema de arquivos.
5. Registrar resultado, memória e custo antes de escolher a próxima tarefa.

Isso pode ser útil ao LF porque o Framework já define artefatos, papéis e governança, mas um projeto cliente ainda pode precisar de uma visão operacional persistente da execução entre sessões de agentes.

O candidato mais forte para adoção é a disciplina determinística do grafo: nós de tarefa explícitos, arestas de dependência, controle de WIP, critérios de aceite, comandos de validação, registros de evidência e transições de status honestas.

Os candidatos mais fracos ou de maior risco são entrega autônoma, roteamento baseado em feromônios, integração ampla com provedores, recuperação neural e alegações de velocidade de tokens ou entrega. Exigem evidências medidas em projetos e limites de confiança mais fortes antes da adoção.

A recomendação para o LF é um piloto opcional e delegado usando o ledger manual do `agf` primeiro; só depois avaliar um plugin OpenCode, caso o benefício medido supere os custos semânticos, operacionais e de segurança.

---

# Modelo conceitual

## Grafo persistente

O grafo é apresentado como fonte operacional da verdade para a execução:

- Um requisito, épico, tarefa, risco, interface ou restrição é representado por um nó.
- Uma dependência, relação pai-filho, relação de implementação ou outro vínculo é representado por uma aresta.
- Uma tarefa contém descrição, critérios de aceite, status e metadados.
- Comandos leem e atualizam o grafo pela CLI.
- O armazenamento local é SQLite, normalmente em `workflow-graph/graph.db`.

### Privacidade do estado local

O banco SQLite, arquivos auxiliares WAL/SHM, snapshots, manifestos e memórias podem conter prompts, comandos, saídas de agentes ou contexto do projeto. Trate `workflow-graph/` como estado local sensível: crie diretórios com modo `0700`, arquivos com modo `0600` e um padrão restritivo de criação, como `umask 077`, quando o host oferecer suporte. Verifique os modos depois de executar o grafo, mantenha o diretório ignorado pelo controle de versão e defina a retenção antes de limpar. Não presuma que `.gitignore` protege dados de outros usuários da mesma máquina e não exclua automaticamente o estado histórico.

Em uma integração LF, o grafo deve ser entendido como uma projeção ativa da execução, não como uma duplicação descontrolada de cada artefato canônico.

## Responsabilidade pelas fontes

Recomenda-se a seguinte fronteira de responsabilidade:

| Preocupação | Autoridade do LF | Representação possível no `agf` |
| --- | --- | --- |
| Intenção do usuário e escopo de negócio | `PROJECT_BRIEF.md`, `PRD.md` | Referência a requisito ou épico com link, não uma reescrita independente |
| Arquitetura e trade-offs | `ARCHITECTURE.md`, ADRs | Interface, restrição, risco ou relação de implementação |
| Intenção e prioridade da sprint | `SPRINTS.md` e registros de planejamento aprovados | Nós de tarefa executável e dependências |
| Status ativo de execução | Estado `.ai/` e rastreador de tarefas acordado | Status do nó no grafo e histórico da tarefa |
| Código-fonte e testes | Sistema de arquivos do projeto e executor de testes | Evidências de conclusão e referências aos arquivos alterados |
| Decisão de revisão e qualidade | `REVIEW.md`, relatório de QA e decisão do Tech Lead | Resultado de validação, achado ou referência de handoff |
| Conhecimento reutilizável do Framework | `knowledge/` após revisão humana | Referência opcional de memória, nunca autoridade única |

O contrato exato de responsabilidade precisa ser decidido antes de qualquer importação ou sincronização automática.

---

# Ciclo de vida

## Três pilares públicos

O repositório `skills-graph` descreve três skills como o ciclo completo do produto:

| Skill | Pilar | Uso pretendido | Mapeamento LF |
| --- | --- | --- | --- |
| `graph-backlog-generation` | PLAN | Investigar o projeto e transformar uma ideia ou PRD em épicos, tarefas atômicas e critérios de aceite testáveis. Não deve escrever código de implementação. | Responsabilidades de Prompt Architect, Product Owner, Software Architect e Sprint Planner. |
| `graph-builder-leafcutter` | BUILD | Buscar uma tarefa desbloqueada, implementá-la com TDD, validá-la e continuar até esgotar o backlog atribuído. | Execução de Implementation / selected CLI sob a sprint e os handoffs LF aprovados. |
| `graph-woodpecker` | HARDEN | Encontrar bugs, vulnerabilidades, dívida e lacunas de observabilidade e comprovar correções com testes de regressão. | Validação de Code Reviewer, QA-Security e Tech Lead. |

Os protocolos compartilhados incluem um protocolo de delegação, um protocolo de recuperação e regras comuns de contexto, economia e antipadrões.

## Nove fases públicas

As instruções públicas dos agentes agrupam um ciclo de nove fases em SHAPE, BUILD e SHIP:

1. ANALYZE: importar ou criar requisitos e passar verificações de prontidão.
2. DESIGN: criar arquitetura, interfaces, relações com ADRs e restrições.
3. PLAN: decompor o trabalho e tornar os critérios de aceite testáveis.
4. IMPLEMENT: executar uma tarefa por vez com TDD.
5. VALIDATE: executar verificações, gates e métricas da tarefa.
6. REVIEW: exportar evidências e revisar o trabalho concluído.
7. HANDOFF: persistir memória e criar snapshot do resultado.
8. DEPLOY: passar o gate de deployment e exportar o estado final.
9. LISTENING: adicionar achados ou iniciar um novo ciclo a partir dos resultados observados.

O LF tem um ciclo de vida mais longo e mais orientado a artefatos. Os ciclos devem ser mapeados, não mesclados casualmente. Fases do `agf` podem fornecer pontos de verificação de execução dentro de um workflow LF, enquanto o LF continua responsável pelos contratos de artefatos e decisões de aprovação.

## Sequência LF recomendada

```text
Intake e requisitos LF
        |
        v
Arquitetura, ADRs e aprovação de sprint LF
        |
        v
Projeção opcional em grafo agf com referências LF estáveis
        |
        v
agf pull -> implementação TDD -> validação do sistema de arquivos e tarefa
        |
        v
Revisão LF -> QA/Security -> decisão do Tech Lead
        |
        v
Exportação opcional do grafo, memória e métricas de volta para registros LF
```

O grafo não deve ser criado como justificativa para contornar artefatos LF upstream ausentes. Se um artefato upstream for intencionalmente dispensado, registre o motivo em `.ai/decisions.md`, conforme exigido por `.ai/contracts.md`.

---

# Salvaguardas determinísticas

O projeto público enfatiza gates em vez de memória do agente. Os princípios a seguir são a parte mais reutilizável do design.

## Nó antes do código

A implementação precisa ter um nó no grafo com escopo claro e critérios de aceite testáveis. Isso evita trabalho não rastreado e torna a tarefa do agente inspecionável antes de os arquivos mudarem.

Equivalente LF: a tarefa também precisa ser rastreável até `SPRINTS.md` aprovado, à arquitetura e aos critérios de aceite pertinentes. Um nó no grafo, sozinho, não autoriza escopo que o LF não aprovou.

## Buscar, não empurrar

`agf next` ou `agf start` seleciona uma tarefa desbloqueada e a marca como em andamento. O limite de WIP anunciado é uma tarefa por vez.

Isso se alinha à Lei de Little e reduz ambiguidades de paralelismo, mas pode conflitar com trabalho paralelo legítimo do LF entre agentes independentes. Antes de transformar WIP=1 em regra do Framework, o piloto deve medir se é um limite global, por projeto, agente ou fluxo de trabalho.

## Critérios de aceite, código e testes

O invariante público é que critérios de aceite, arquivos de implementação e arquivos de teste devem concordar no disco. Um campo de status ou mensagem de agente não comprova essa condição por si só.

Isso se alinha à exigência do LF por evidências de implementação, revisão e QA. A limitação é importante: a presença no sistema de arquivos não comprova correção semântica, cobertura adequada, segurança ou valor para o usuário. Revisão humana e gates de qualidade do LF continuam necessários.

## Execução test-first

O ciclo BUILD anunciado é:

```text
RED -> GREEN -> REFACTOR
```

O uso proposto pelo LF é manter isso como expectativa de execução no nível da tarefa, permitindo que a estratégia de testes existente do projeto defina os comandos reais e a qualidade dos testes. O `agf` não deve inventar um executor de testes para um projeto que não tenha um.

## Fluxo de status e Definition of Done

O grafo valida transições e expõe verificações como:

- Existem critérios de aceite e eles têm qualidade suficiente.
- Bloqueios foram resolvidos.
- A tarefa passou por `in_progress`.
- Arquivos de implementação e teste existem fisicamente onde exigido.
- O gate apropriado de teste da tarefa ou do projeto passou.
- A tarefa não é grande demais para a decomposição disponível.

Essas verificações são evidências, não aprovação automática. Um `agf done` aprovado ainda precisa ser reconciliado com o diff real, revisão de código, resultado de QA/segurança e decisão humana.

## Lacunas e harness

`agf gaps` é descrito como detector determinístico de vínculos ausentes, como:

- Rastreabilidade entre requisito, tarefa e teste.
- Critérios de aceite sem forma testável.
- Requisitos não funcionais ausentes.
- Casos de erro ou de borda ausentes.
- Tarefas ambíguas ou grandes demais.
- Divergência entre design, estimativa e implementação.

`agf harness` é descrito como instrumento de fortalecimento e qualidade. Deve ser usado como sinal suplementar até que suas dimensões, limiares e taxa de falsos positivos sejam validados em comparação com relatórios de QA do LF.

---

# Modos de operação

## Modo delegado

Quando nenhum provedor LLM está configurado, as orientações públicas dizem que os comandos podem retornar um resumo `mode: delegated` para o agente externo que realmente conduz o trabalho. O ciclo pretendido é:

```bash
agf next
agf context <id>
agf brief <id>
# O agente externo implementa e testa a tarefa.
agf submit <id> --result '{"arquivos":[],"testes":{"passed":0,"failed":0},"desvios":[]}'
```

Esse modo se encaixa bem com OpenCode e LF porque a CLI pode permanecer como ledger de execução enquanto o agente LF selecionado mantém a responsabilidade pelo raciocínio e pela aprovação.

O payload do resultado precisa ser verdadeiro. Resultado com zero testes não representa implementação de software bem-sucedida, a menos que a tarefa seja realmente somente documental e a exceção esteja registrada.

## Modo com provedor ativo

Com um provedor configurado, o `agf` pode fazer chamadas a modelos e associá-las a uma tarefa. A documentação pública descreve detecção de provedor, seleção de modelo, entrada em cache e contabilização de chamadas.

Esse modo cria preocupações adicionais de confiança, privacidade, disponibilidade e custo. Não deve ser o primeiro modo de piloto do LF. Comece com execução delegada e o provedor de agente já usado pelo usuário; depois avalie se o roteamento direto para provedores agrega valor.

## Entrega autônoma

Comandos como `agf deliver` são anunciados como um pipeline completo, da solicitação ao grafo concluído. São convenientes para experimentos de baixo risco, mas podem ocultar os pontos nos quais o LF espera revisão de artefatos, aprovação ou handoff.

O padrão LF recomendado é execução granular. Use um comando autônomo somente depois de explicitar escopo, ambiente, rollback, responsabilidade pela revisão e requisitos de evidência.

---

# Economia de tokens e recuperação

## Mecanismos públicos

O produto público descreve os seguintes mecanismos de custo e contexto:

- Edições de diff que reescrevem somente regiões alteradas.
- Mapa do repositório ordenado por relevância, em vez de despejar a árvore inteira.
- Marcadores reversíveis de conteúdo frio que podem ser recuperados por hash.
- Compressão na fronteira do comando.
- Entrada em cache e ledger de chamadas do provedor.
- Recuperação RAG de comandos e contexto relevante.
- Mecanismos de economia que podem ser ativados ou desativados e são registrados em um ledger.

O README público também distingue custo direto de modelo de economia delegada. No modo delegado, o agente externo paga a chamada ao modelo e o `agf` pode relatar economia estimada em relação a uma baseline estrutural, em vez de uma fatura direta do provedor.

## Recomendação LF

Adote primeiro a disciplina de medição, antes dos mecanismos:

1. Registre a tarefa, sessão, modo do provedor e contagens de entrada/saída quando disponíveis.
2. Rotule separadamente valores medidos, em cache, estimados e contrafactuais.
3. Compare tarefas equivalentes com e sem o mecanismo.
4. Inclua qualidade, retrabalho e tempo de revisão na avaliação de custo.
5. Nunca cite uma porcentagem de economia sem sua baseline e escopo de medição.

A regra LF para saída de shell já exige filtrar e comprimir saídas grandes de comandos. O `agf` pode ser uma implementação útil desse princípio, mas não deve causar compressão dupla nem ocultar saídas de erro do agente.

## Limite de recuperação

`agf retrieve-command` e recursos de recuperação relacionados devem ser tratados como sugestões de comando, não como autoridade. O comando final deve ser verificado com a versão instalada da CLI, caminho do projeto, contexto de segurança e saída de `--help`.

Memória e recuperação podem acelerar o trabalho, mas código atual, estado do grafo, contratos e artefatos aprovados têm precedência sobre memórias desatualizadas ou contexto gerado.

---

# Stigmergia e aprendizado

## Ideia útil

Resultados persistentes podem tornar roteamentos futuros mais informados. Em princípio, um caminho bem-sucedido pode preservar:

- O tipo de tarefa e a forma do contexto.
- A rota de comando ou skill utilizada.
- As evidências que passaram.
- O custo e o tempo decorrido.
- O motivo pelo qual uma rota foi rejeitada.

Isso é um insumo útil para melhoria contínua e extração de conhecimento do LF.

## Fronteira de segurança

Aprendizado não deve transformar uma afirmação não verificada em verdade do Framework. O README público descreve níveis de proveniência como `claim`, `validated` e `proven`, reservando maior peso para rotas com evidências mais fortes. O LF deve preservar a mesma separação:

- Alegação: um agente ou ferramenta diz que um caminho funcionou.
- Validado: um teste ou gate definido passou.
- Comprovado: o resultado é reproduzível, com evidências determinísticas e revisão.

Somente os dois últimos devem influenciar a conclusão de um piloto, e nenhum deles deve alterar automaticamente uma regra canônica.

## Risco do ACO

O site público descreve reforço, evaporação e aproximadamente 70% de exploração de rotas conhecidas contra 30% de exploração de novas rotas. Isso pode melhorar roteamentos repetidos, mas também reforçar um ótimo local, propagar uma premissa errada ou esconder uma regressão atrás de sucesso histórico.

A recomendação LF é começar com roteamento determinístico. Se ACO for pilotado, mantenha-o opt-in, registre a rota e as alternativas selecionadas, preserve um fallback determinístico e compare os resultados com a baseline.

---

# Limites de segurança e confiança

## Não é um sandbox

O `SECURITY.md` público declara explicitamente que o `agf` não isola o agente em sandbox. Seu sistema de permissões é um recurso de UX, não isolamento de segurança. O documento recomenda Docker ou uma VM quando isolamento real for necessário.

Portanto:

- Nunca apresente permissões do `agf` como controle de segurança.
- Não execute ciclo autônomo não revisado em repositório sensível.
- Use container, VM ou isolamento equivalente para código, ferramentas ou comportamento de provedor não confiáveis.
- Mantenha credenciais, acesso à produção e comandos destrutivos fora do ambiente padrão do piloto.

## Provedores externos e MCP

Os dados do provedor são regidos pela política do provedor configurado. Segundo o documento público de segurança, servidores MCP externos, quando habilitados, ficam fora da fronteira de confiança da ferramenta.

O `AGENTS.md` público diz que o `agf` funciona sem MCP e que o transporte MCP é opcional. A saída local de inicialização relatou uma `DirectMCP bridge`, mas essa observação não comprova que MCP seja necessário ou ativo no uso normal da CLI. A documentação LF deve distinguir a CLI, o transporte opcional e qualquer servidor externo.

## Riscos do instalador e de atualização

O guia de instalação afirma que o instalador verifica SHA256 e aborta em caso de divergência. O `install.sh` revisado baixa o checksum quando disponível, mas seu ramo de divergência apenas emite `checksum nao confere (continuando)` e prossegue. Ele também ignora a verificação quando o checksum não pode ser baixado.

Essa é uma divergência concreta entre documentação e script. Até que seja corrigida ou verificada de modo independente:

- Fixe e inspecione o instalador ou artefato da release antes de usá-lo em ambiente controlado.
- Prefira um espelho interno verificado quando apropriado.
- Não trate `curl ... | bash` como equivalente a uma fonte de pacote revisada.
- Registre versão instalada e checksum nas evidências do piloto.

O instalador também remove o atributo de quarentena do macOS do binário baixado. Isso pode ser intencional para um artefato com checksum verificado, mas reduz um aviso visível ao usuário e deve fazer parte da revisão de segurança local.

## Limite do projeto e proteção por âncora

A CLI usa uma âncora de projeto, como `.git` ou `package.json`, para evitar gravar no armazenamento `workflow-graph` errado. `AGF_ALLOW_NO_ANCHOR=1` desativa essa verificação de segurança e só deve ser usado quando caminho e responsabilidade pelo grafo estiverem explícitos.

Um grafo nunca deve ser compartilhado acidentalmente entre o diretório home do usuário, o Framework LF e um projeto cliente.

## Dados locais sensíveis

O grafo, memórias, manifestos de sessão, configurações de provedores e ledgers de custo podem conter nomes de projetos, descrições de tarefas, caminhos de arquivos, prompts ou histórico operacional. Exigem as mesmas decisões de controle de acesso, backup e retenção que os demais estados do projeto.

---

# Avaliação local no workspace LF

## Inicialização no escopo errado

Os primeiros comandos `agf dashboard` e `agf init` foram executados no diretório home do usuário, não no workspace LF. O guard de segurança detectou um `$HOME/workflow-graph/graph.db` existente sem âncora `.git` ou `package.json` e recusou a operação até que `AGF_ALLOW_NO_ANCHOR=1` fosse definido.

A inicialização subsequente no diretório home criou um projeto chamado `local-user`, um épico/tarefa de exemplo guiado e um dashboard local em `http://127.0.0.1:3000`. A saída também informou que não havia arquivos-fonte reconhecíveis. Esse estado não deve ser interpretado como estado do projeto LF.

## Inicialização do grafo LF

Como o próprio workspace LF não tem âncora Git ou de pacote, o grafo local foi inicializado intencionalmente com:

```bash
AGF_ALLOW_NO_ANCHOR=1 agf init --graph-only --no-serve --skip-neural --no-open
```

Isso criou o `workflow-graph/graph.db` local sem gerar arquivos de contexto do projeto, instalar hooks ou iniciar dashboard. A exceção explícita não é padrão recomendado para projetos clientes.

## Resultados de comandos observados

| Observação | Interpretação |
| --- | --- |
| `agf --version` retornou `0.24.2` | O binário instalado foi identificado. |
| `agf preflight` retornou inicialmente `STORE_NOT_FOUND` | O guard de âncora funcionou; o escopo do workspace era ambíguo para a CLI. |
| `agf status` e `agf stats` relataram inicialmente um grafo não inicializado | O grafo LF não existia antes da inicialização explícita somente de grafo. |
| `agf doctor --store` teve sucesso após a inicialização | O armazenamento SQLite local estava disponível. |
| `agf phase` informou `BUILD` | A CLI expõe fases de ciclo de vida agrupadas; não se trata de transição de fase LF. |
| `agf doctor --providers --no-ping` não encontrou provedor de API configurado | Modo delegado é o modo seguro de avaliação local. |
| `agf skill list` não encontrou skills instaladas no grafo LF | O repositório público de skills foi revisado, mas não instalado no LF. |
| Inicialização relatou falha de instalação neural | A recuperação foi degradada para embeddings por hash; isso não justifica tornar dependências neurais obrigatórias. |
| Inicialização relatou Playwright, Sentrux e Serena indisponíveis | Integrações opcionais não estavam disponíveis no ambiente. |
| Inicialização relatou contexto gerado desatualizado | Contexto gerado não deve ser tratado como autoritativo sem revisão. |
| A CLI relatou `DirectMCP bridge ready` | Uma bridge foi detectada ou preparada; o uso normal da CLI ainda não exige MCP. |

## Tarefa de avaliação rastreada

O grafo LF rastreia `node_a7dcc8d81e6d`, intitulada `Capture agent-graph-flow integration knowledge`, com status `in_progress`, prioridade `2` e tags `documentation`, `graph-flow`, `knowledge`. Seus critérios de aceite cobrem modelo de grafo, ciclo de vida, gates, economia, limites de segurança, riscos de integração, evidências que distinguem alegações de observações e indexação somente como proposta. A tarefa declara o módulo, os índices e registros `.ai/` como arquivos de implementação.

---

# Adequação ao conhecimento LF existente

## Relação com Elephant-Goldfish

O `ENGINEERING_ELEPHANT_GOLDFISH.md`, aprovado como opcional, e este módulo resolvem problemas diferentes:

| Conhecimento LF | Pergunta principal |
| --- | --- |
| Elephant-Goldfish | O problema, design, rubrica de avaliação e contexto de implementação são compreensíveis antes de codificar? |
| Agent Graph Flow | O trabalho aprovado é rastreado, sequenciado, executado, validado e medido entre sessões? |

A sequência recomendada é:

```text
Elephant cria e questiona o design durável
Goldfish testa a compreensão independente
Humano aprova escopo e artefatos
agf projeta o trabalho aprovado em nós executáveis
Agente implementa com TDD e registra evidências
Revisão LF, QA e governança aprovam a entrega
```

Nenhum dos módulos deve duplicar `PRD.md`, `ARCHITECTURE.md` ou `SPRINTS.md`.

## Mapeamento de agentes

As três skills do `agf` podem informar, mas não substituir agentes LF: PLAN mapeia para requisitos, arquitetura e planejamento de sprint; BUILD mapeia para Implementation / selected CLI; HARDEN mapeia para Code Review, QA-Security e Tech Lead. Documentation mantém os artefatos canônicos sincronizados, e o Knowledge Extractor atua somente após entrega aprovada e revisão humana.

---

# Limite de integração recomendado

## Piloto preferido

Use `agf` como ledger opcional e delegado de execução para um recurso representativo e uma alteração legada:

1. Concluir os artefatos normais de intake, requisitos, arquitetura e sprint do LF.
2. Registrar o motivo e escopo do piloto em `.ai/decisions.md`.
3. Criar ou importar somente nós aprovados do grafo, com links estáveis aos artefatos LF.
4. Usar etapas granulares `next`, `context`, `brief`, implementação, `check` e `done`, em vez de entrega autônoma.
5. Manter os gates existentes de revisão de código, QA/Security e Tech Lead.
6. Exportar evidências do grafo e compará-las com as tarefas e registros de handoff LF.
7. Medir se o grafo reduziu retrabalho, perda de contexto, trabalho duplicado ou ambiguidade de revisão sem adicionar sobrecarga desproporcional.

## Regras de integração para um piloto

- Manter um grafo por projeto ou worktree claramente identificado; não reutilizar um grafo do diretório home para um projeto cliente.
- Usar uma âncora real de projeto quando possível e documentar qualquer exceção.
- Cruzar IDs dos artefatos LF com IDs dos nós do grafo; preservar comandos, testes, arquivos alterados e evidências de revisão.
- Usar o executor de testes real e os limites de dados do projeto. Começar no modo delegado, sem servidor MCP externo, e manter ACO e mecanismos experimentais desativados.
- Fixar as versões da CLI e das skills e permitir rollback sem alterar artefatos canônicos LF.

---

# Padrões seguros de comando

O contrato exato da CLI pode mudar. Sempre consulte `agf <command> --help` do binário instalado e verifique primeiro o diretório de trabalho atual.

## Descoberta

```bash
agf --version
agf doctor --store
agf doctor --providers --no-ping
agf preflight "<topic>"
agf stats --select data.byStatus
agf query --search "<topic>"
```

## Avaliação explícita sem âncora

Somente quando o diretório estiver selecionado intencionalmente e não existir âncora de projeto:

```bash
AGF_ALLOW_NO_ANCHOR=1 agf init --graph-only --no-serve --skip-neural --no-open
```

Não copie essa exceção para um guia geral de configuração de projetos sem explicar segurança e escopo.

## Planejamento e execução

```bash
agf import-prd <approved-prd>
agf node add --title "<task>" --type task
agf edge add --from <node> --to <node> --type depends_on
agf gaps --severity required --json
agf next
agf context <id> --compressed
agf brief <id>
```

A implementação e os testes ocorrem no workspace do projeto entre os comandos de grafo. O agente LF selecionado é responsável pelas edições reais e deve respeitar os contratos de artefatos.

## Validação e handoff

```bash
agf check <id>
agf harness --help
agf metrics
agf savings
agf export
agf snapshot create
```

Consulte a ajuda disponível antes de executar um comando com efeitos colaterais. Não alegue que um comando validou o projeto quando somente sua saída de ajuda foi inspecionada.

---

# Medidas do piloto

O piloto deve comparar trabalho equivalente com e sem a camada opcional de grafo. Registre pelo menos:

- Tempo entre tarefa aprovada e resultado pronto para revisão.
- Número de recuperações após perda de contexto.
- Alterações duplicadas ou fora de escopo em arquivos.
- Retrabalho após revisão de código e QA.
- Cobertura dos critérios de aceite e achados de casos de borda ausentes.
- Falhas de teste, defeitos escapados e achados de segurança.
- Tempo gasto mantendo o estado do grafo e sincronizando artefatos LF.
- Tokens de entrada, saída, cache e estimados, com suas baselines.
- Compreensão humana do grafo e das evidências exportadas.
- Falsos positivos de `gaps`, `harness` ou verificações de conclusão.

O piloto só tem sucesso se melhorar a rastreabilidade ou a economia de entrega preservando qualidade, segurança e aprovação humana do LF. Um número alto de economia com mais retrabalho não é um resultado bem-sucedido.

---

# Riscos e mitigações

| Risco | Impacto | Mitigação |
| --- | --- | --- |
| Sem sandbox | Ações destrutivas ou não confiáveis do agente podem alcançar o host. | Usar isolamento; manter o piloto longe de credenciais de produção e sistemas sensíveis. |
| Escopo incorreto do grafo | Tarefas do home, Framework e cliente podem se misturar. | Exigir âncoras, caminhos explícitos e armazenamentos separados; registrar exceções. |
| Divergência entre grafo e artefatos | O status vira uma segunda fonte inconsistente da verdade. | Definir responsabilidade, IDs estáveis e contrato de sincronização antes da automação. |
| Exagero no marketing ou README | Equipes adotam comportamento ou metas não verificados. | Rotular evidências, inspecionar a fonte e medir no piloto. |
| Divergência de checksum do instalador | Um artefato adulterado ou truncado pode ser instalado. | Verificar independentemente, fixar artefatos de release e revisar o comportamento do instalador. |
| Exposição de dados ao provedor | Prompts, caminhos e código podem sair do ambiente local. | Começar delegado/local, classificar dados e revisar termos do provedor. |
| Confiança em MCP externo | Servidores configurados podem executar ações ou receber dados fora da fronteira da ferramenta. | Desabilitar no piloto ou revisar cada servidor e isolar a execução. |
| Ciclo de reforço | Uma rota ruim pode ganhar peso histórico e ser difícil de substituir. | Manter roteamento determinístico ou opt-in, preservar exploração e comparar com baseline. |
| Contexto gerado desatualizado | Agentes seguem instruções obsoletas. | Dar precedência ao código atual, grafo e artefatos canônicos; regenerar e revisar. |
| Ausência de infraestrutura de testes | Um gate de conclusão pode não provar a qualidade da implementação. | Configurar os testes reais do projeto ou classificar explicitamente o trabalho somente documental. |
| Divergência de versão | O comportamento da CLI e das skills muda entre execuções. | Fixar versões, registrar `agf --version` e revisar mudanças da release. |
| Perda do banco local | Histórico de execução e evidências de custo desaparecem. | Definir retenção, backup e exportação antes de depender do grafo. |

---

# Recomendações priorizadas

## Prioridade alta

1. Manter este módulo como opcional e fora do grafo obrigatório de dependências do LF.
2. Pilotar o ledger determinístico de execução em modo delegado, em trabalho representativo de recurso e legado.
3. Definir responsabilidade pelas fontes e referências cruzadas antes de importar ou sincronizar artefatos LF.
4. Tratar ausência de sandbox, fronteiras de provedores, escopo do grafo e verificação do instalador como itens explícitos da revisão de segurança.
5. Manter revisão LF, QA/Security e aprovação do Tech Lead independentes de `agf done`.

## Prioridade média

1. Adicionar campos opcionais de ID do grafo e evidência a handoffs ou tarefas somente se o piloto demonstrar valor na referência cruzada manual.
2. Comparar achados de `gaps` e `harness` com relatórios de qualidade LF existentes.
3. Avaliar o ledger de economia separando valores medidos e estimados.
4. Fixar e revisar o repositório público de skills antes de colocá-lo em `.agents/skills/` de qualquer projeto.
5. Definir um formato pequeno de exportação de evidências do grafo, em vez de copiar o banco inteiro para artefatos Markdown.

## Prioridade baixa

1. Testar roteamento por feromônios ou ACO somente depois de existir uma baseline determinística.
2. Avaliar recuperação neural somente quando o repositório tiver necessidade real e configuração reproduzível de dependências.
3. Considerar roteamento direto para provedores ou entrega autônoma somente depois que a execução delegada demonstrar benefício claro.

---

# Gate de decisão de adoção

Antes que qualquer recomendação se torne obrigatória, o mantenedor do Framework deve responder:

- Qual artefato ou protocolo LF é responsável pela informação representada por cada campo do grafo?
- Quais tipos exatos de projeto se beneficiam o suficiente para justificar a CLI e o estado SQLite?
- Quais evidências provam que o grafo reduz retrabalho ou perda de contexto?
- Qual é o fallback quando CLI, armazenamento, provedor ou rede ficam indisponíveis?
- Como os dados do grafo, prompts, caminhos, credenciais e chamadas a provedores são protegidos?
- Quem revisa e resolve divergências entre grafo e artefatos?
- Quais verificações são gates determinísticos e quais continuam consultivas?
- A integração pode ser removida sem alterar entregáveis canônicos do LF?
- Quais versão, commit de skill e contrato de comando são suportados?

Nenhuma adoção obrigatória deve ser aprovada sem respostas claras e decisão registrada em `docs/ADR.md` ou no registro de decisão LF apropriado.

---

# Princípio final

A lição mais forte do `agf` não são agentes autônomos nem a marca biológica. É a insistência de que estado de execução, escopo de tarefa, critérios de aceite, testes e evidências de custo sobrevivam à conversa que os produziu.

Para o LF, portanto, o uso mais seguro é aditivo:

```text
Artefatos e governança LF permanecem canônicos.
agf torna opcionalmente explícita e mensurável a execução aprovada.
O sistema de arquivos, os testes, a revisão e a decisão humana continuam sendo as evidências finais.
```

Este módulo foi aprovado como orientação opcional; a instalação e a integração operacional do `agf` continuam sob controle separado e não são dependências do Framework.

---

## Histórico de versões

- `0.2.0` — 2026-11-01: Aprovado como orientação suplementar opcional e
  esclarecido que esse status não autoriza instalar ou integrar `agf`.
