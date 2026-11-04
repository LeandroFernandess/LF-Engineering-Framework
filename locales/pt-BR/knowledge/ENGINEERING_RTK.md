# Conhecimento de Engenharia: RTK (Rust Token Killer)

Versão: 0.2.0

Status: Opcional aprovado

Categoria: Suplementar / Avaliação de ferramenta externa

Responsável: Leandro Fernandes
Baseline do Framework: LF Engineering Framework 1.3.0; status de adoção atualizado pós-tag

---

# Status de adoção

Este módulo foi aprovado como orientação opcional para avaliar RTK como camada de filtragem de saída de comandos para o LF Engineering System.

Ele não faz parte do grafo obrigatório de dependências do LF. Não deve adicionar silenciosamente hooks, plugins, instruções geradas, telemetria, configurações, requisitos de provedor ou reescrita de comandos ao Framework ou a projetos clientes.

Esta aprovação não autoriza instalar RTK nem habilitar hooks, plugins, telemetria, instruções geradas ou reescrita de comandos. Qualquer instalação ou integração da ferramenta exige aprovação específica e separada do proprietário. Por padrão, as recomendações não se tornam regras do Framework, instruções de agentes, gates de workflow ou etapas obrigatórias de configuração.

---

# Objetivo

RTK (Rust Token Killer) é um proxy CLI escrito em Rust que executa comandos de shell compatíveis, filtra ou resume sua saída e devolve um resultado menor a um agente de IA. Também pode reescrever comandos brutos por meio de hooks de agente, dispensando que o usuário ou agente digite o prefixo `rtk` manualmente.

Seu possível papel no LF é limitado e complementar:

- O LF é responsável por intenção, artefatos, arquitetura, escopo de tarefas, papéis dos agentes, revisão e aprovação humana.
- `agf` pode manter estado opcional de grafo de execução e evidências de tarefas.
- RTK pode reduzir opcionalmente a saída de comandos na fronteira do shell.
- O comando subjacente, repositório, testes e revisão continuam autoritativos.

Portanto, RTK deve ser avaliado como otimização de contexto e observabilidade, não como substituto da governança LF ou do controle de tarefas do `agf`.

---

# Não objetivos

Este módulo não:

- Substitui o LF Engineering Framework ou `.ai/contracts.md`.
- Alega que uma redução de saída de 60–90% equivale a uma redução de 60–90% na conta.
- Exige RTK para todo projeto, agente ou comando.
- Trata saída filtrada como equivalente à saída completa sem caminho de recuperação.
- Trata hooks, permissões ou filtros RTK como sandbox ou fronteira de segurança.
- Instala plugin OpenCode, altera configurações ou habilita telemetria.
- Trata exemplos do site, benchmarks ou totais de `rtk gain` como metas LF.
- Duplica responsabilidades de `PRD.md`, `ARCHITECTURE.md`, `SPRINTS.md`, revisões, relatórios QA ou grafo de tarefas.

---

# Fontes e evidências

## Fontes públicas

- Site oficial: <https://www.rtk-ai.app/>
- Repositório: <https://github.com/rtk-ai/rtk>
- README: <https://raw.githubusercontent.com/rtk-ai/rtk/master/README.md>
- Arquitetura: <https://raw.githubusercontent.com/rtk-ai/rtk/master/docs/contributing/ARCHITECTURE.md>
- Fluxo técnico: <https://raw.githubusercontent.com/rtk-ai/rtk/master/docs/contributing/TECHNICAL.md>
- Política de segurança: <https://raw.githubusercontent.com/rtk-ai/rtk/master/SECURITY.md>
- Instalador: <https://raw.githubusercontent.com/rtk-ai/rtk/master/install.sh>
- Política de telemetria: <https://raw.githubusercontent.com/rtk-ai/rtk/master/docs/TELEMETRY.md>
- Configuração: <https://raw.githubusercontent.com/rtk-ai/rtk/master/docs/guide/getting-started/configuration.md>
- Artefatos de hooks: <https://raw.githubusercontent.com/rtk-ai/rtk/master/hooks/README.md>
- Hook OpenCode: <https://raw.githubusercontent.com/rtk-ai/rtk/master/hooks/opencode/README.md>
- Explicação de economia: <https://raw.githubusercontent.com/rtk-ai/rtk/master/docs/guide/resources/savings-explained.md>
- Benchmarks: <https://www.rtk-ai.app/benchmarks/>
- Página de instalação: <https://www.rtk-ai.app/docs/getting-started/installation/>
- Agentes compatíveis: <https://www.rtk-ai.app/docs/getting-started/supported-agents/>

Consultado em: 2026-09-03.

A release instalada pelo usuário informou ser `rtk 0.47.0`.

## Classes de evidência

Use estes rótulos ao se referir ao RTK nos registros LF:

| Rótulo | Significado |
| --- | --- |
| Alegação pública | Comportamento descrito pelo site, repositório, documentação ou instalador. |
| Observação local | Comportamento observado no binário instalado no workspace LF. |
| Recomendação LF | Limite ou uso proposto que ainda precisa de evidências de piloto. |

A documentação pública e o binário instalado não são presumidos idênticos. O README contém ao menos um exemplo de versão desatualizada, a página de benchmarks do site informa atualmente que nenhum dado foi publicado, e o Disclaimer descreve telemetria de forma diferente do README e da política de telemetria.

---

# Síntese executiva

RTK aborda um gargalo real no desenvolvimento com agentes: comandos de shell frequentemente retornam barras de progresso, testes aprovados repetidos, boilerplate, ruído de diretórios e metadados verbosos que consomem contexto sem melhorar uma decisão.

Suas ideias de engenharia mais fortes são:

- Manter a filtragem em uma fronteira de comando claramente definida.
- Preservar códigos de saída e erros significativos.
- Retornar à saída original quando um filtro não puder processá-la com segurança.
- Preservar uma forma de recuperar a saída completa quando ela for truncada ou um comando falhar.
- Medir a saída bruta e filtrada separadamente da cobrança real do provedor.
- Tornar explícito e simples desabilitar ou excluir um comando.

Seus principais riscos também são importantes:

- Um filtro pode ocultar informação necessária ao agente.
- Um hook pode alterar silenciosamente o comando executado pelo agente.
- Saída bruta de falha e histórico local podem conter dados sensíveis.
- O proxy executa comandos com as permissões do host do usuário.
- Telemetria silenciosa, configuração gerada e instaladores remotos exigem decisões explícitas de confiança.

A posição LF recomendada é um piloto delegado opt-in, começando com comandos RTK manuais; só depois avaliar um plugin OpenCode, se o benefício medido superar os custos semânticos, operacionais e de segurança.

---

# O que RTK faz

## Fronteira do proxy

A arquitetura pública descreve este fluxo:

```text
Comando do agente ou usuário
        |
        v
Hook opcional reescreve `git status` para `rtk git status`
        |
        v
RTK executa o comando subjacente
        |
        v
RTK filtra, agrupa, trunca ou resume a saída
        |
        v
Agente recebe saída compacta e o código de saída do comando subjacente
```

O binário Rust encaminha comandos para módulos especializados. Formatos complexos usam filtros compilados em Rust; texto mais simples e previsível pode usar filtros TOML confiáveis. Comandos desconhecidos ou não compatíveis passam sem alteração.

RTK não é um grafo de execução. Não define dependências de tarefas, requisitos de produto, aprovação arquitetural ou ciclo de entrega.

## Estratégias de filtragem

A arquitetura pública descreve estas estratégias:

| Estratégia | Uso típico | Risco principal |
| --- | --- | --- |
| Extração de estatísticas | `git status`, `git log`, listas de pacotes | Detalhes úteis para diagnóstico podem desaparecer. |
| Foco em erros ou falhas | Testes, builds e linters | Contexto de sucesso ou avisos podem ser relevantes à decisão. |
| Agrupamento | Resultados repetidos de lint ou grep | O agrupamento pode ocultar padrões específicos de localização. |
| Deduplicação | Logs repetidos | Frequência ou ordem podem ser importantes. |
| Somente estrutura | JSON e dados de dependências | Os valores podem ser necessários, não apenas chaves e tipos. |
| Filtragem de código | Leituras inteligentes de arquivos e resumos | Assinaturas não substituem raciocínio sobre a implementação. |
| Compressão de árvore | Saída de `ls`, `find` e diretórios | Ordem dos arquivos ou arquivos ocultos podem importar. |
| Filtragem de progresso | Instalação de pacotes e downloads | Progresso pode revelar travamento ou falha parcial. |
| Parsing JSON ou NDJSON | Ferramentas estruturadas e eventos de testes em fluxo | Divergência do parser pode perder campos ou eventos novos. |
| Parsing de máquina de estados | Executores de teste com fases e resumos | Formatos não reconhecidos precisam de fallback bruto. |

A estratégia correta depende da decisão do consumidor. Compressão agressiva pode ser adequada para contexto repetitivo, mas não automaticamente para evidência de segurança, diagnóstico de produção, saída de migração ou comando verboso solicitado explicitamente.

## Recuperação da saída bruta

O sistema tee documentado salva localmente a saída bruta completa quando um comando falha e imprime um caminho para leitura posterior. A configuração também permite salvar a saída bruta em todo comando ou desativar o tee.

As configurações padrão descritas publicamente são:

- Tee habilitado para falhas.
- Máximo de 20 arquivos salvos.
- Tamanho máximo de arquivo de 1 MB.
- Retenção local e histórico de banco normalmente com padrão de 90 dias.

A recuperação bruta é valiosa porque o agente pode inspecionar a falha sem reexecutar um comando potencialmente caro ou com estado. Isso também significa que o diretório tee é um armazenamento de dados sensíveis e precisa integrar as decisões de privacidade e retenção do projeto.

---

# Integração de comandos e hooks

## Prefixo manual

Todo comando compatível pode ser invocado explicitamente, por exemplo:

```bash
rtk git status
rtk git diff
rtk grep "pattern" .
rtk find "*.rs" .
rtk test "cargo test"
rtk vitest
rtk tsc
```

A forma explícita é o primeiro piloto mais seguro, pois a mudança é visível e não altera a configuração de um agente.

## Registro de reescrita

O comando `rtk rewrite` é o único ponto de decisão usado pelos hooks. A documentação pública descreve suporte a comandos de shell simples e compostos, incluindo `&&`, `||`, `;`, pipes e redirecionamentos, com regras conservadoras para heredocs, expressões aritméticas e etapas de pipeline.

Controles importantes incluem:

- `RTK_DISABLED=1` desativa a reescrita para um comando.
- `hooks.exclude_commands` exclui globalmente comandos ou padrões de comando.
- Comandos já prefixados com `rtk` não recebem prefixo recursivamente.
- Flags detalhadas explicitamente devem ser respeitadas, em vez de comprimidas agressivamente.
- Um comando que não possa ser classificado com segurança deve permanecer bruto.

Um piloto LF deve testar comandos compostos, redirecionamentos, pipes, prefixos de ambiente, argumentos entre aspas, falhas e flags verbosas explícitas. Uma reescrita bem-sucedida não basta; o comando subjacente ainda precisa significar a mesma coisa.

## Níveis de hook

O guia público de agentes compatíveis agrupa integrações em três níveis:

| Nível | Mecanismo | Comportamento |
| --- | --- | --- |
| Hook completo | API de hooks do agente ou binário nativo de hook | Reescreve antes de o agente executar o comando. |
| Plugin | Plugin TypeScript, JavaScript ou Python | Altera uma chamada de ferramenta quando o agente oferece suporte. |
| Arquivo de regras | Instruções de agente, como `AGENTS.md` | Depende de o modelo escolher `rtk <command>`. |

As integrações listadas incluem Claude Code, Cursor, GitHub Copilot, Gemini CLI, OpenCode, Pi, OpenClaw, Hermes, Factory Droid, Cline, Windsurf, Codex, Kilo Code, Google Antigravity e Mistral Vibe. Disponibilidade e comportamento variam por agente e não devem ser generalizados a partir de uma implementação de hook.

## Integração com OpenCode

A integração OpenCode documentada é um plugin TypeScript instalado em:

```text
~/.config/opencode/plugins/rtk.ts
```

Ele escuta `tool.execute.before`, invoca `rtk rewrite` por meio de `zx` e altera `args.command` quando o comando reescrito é diferente. Isso é um efeito colateral do plugin na configuração do agente, não uma alteração do LF Framework.

O usuário não executou `rtk init --global --opencode`. A verificação local informou:

- `rtk 0.47.0` está instalado.
- Nenhum hook RTK está instalado.
- O plugin OpenCode não foi encontrado.
- `settings.json` existe, mas não contém hook RTK.
- `RTK.md`, hooks Claude e hooks Cursor não foram encontrados.

O workflow OpenCode atual usa ferramentas dedicadas `Read`, `Grep` e `Glob`, além de comandos de shell. O projeto RTK documenta reescrita automática para chamadas Bash ou da ferramenta de terminal; essas ferramentas dedicadas não passam pelo hook Bash. Portanto, RTK não pode ser descrito como filtrando todo o contexto de uma sessão OpenCode.

## Contrato de falha dos hooks

A documentação pública de hooks diz que eles devem falhar de modo aberto (fail open):

- Binário RTK ausente: avisar e permitir a execução do comando bruto.
- Entrada inválida: repassar sem alterações.
- Falha de reescrita: executar o comando original.
- Falha de filtro: retornar saída bruta.
- Erros do hook não devem bloquear o comando do usuário.

Esse é um invariante de segurança útil, mas deve ser testado em cada agente. A documentação pública de hooks também lista uma lacuna conhecida em que um caminho de JSON inválido do Gemini encerra com status diferente de zero, podendo violar o contrato de não bloqueio. Um piloto não deve presumir que todas as integrações listadas têm comportamento de falha idêntico.

---

# Economia de tokens e medição

## O que é realmente medido

A documentação do RTK limita corretamente sua alegação principal à saída Bash:

```text
saída bruta do shell -> saída filtrada do shell -> entrada do agente
```

A cadeia de economia é mais ampla:

```text
entrada do modelo = saída do shell + prompt + prompt do sistema + histórico
cobrança do modelo = entrada do modelo + saída do modelo + regras de preço do provedor
```

RTK controla somente o primeiro termo. Não reduz tokens de saída do modelo, prompts, instruções de sistema ou histórico da conversa. Uma redução de 90% na saída de um comando não pode ser citada como redução de 90% na conta da sessão.

## Limites do estimador

A fonte pública documenta um estimador equivalente a:

```text
tokens estimados = bytes de saída / 4
```

RTK não inclui tokenizer específico de modelo. A porcentagem é útil para comparar a saída bruta e filtrada usando o mesmo estimador; contagens absolutas de tokens são aproximadas e não devem ser tratadas como dados de fatura do provedor.

Portanto, `rtk gain` é um instrumento operacional de tendência. Sozinho, não prova redução de custo de API, melhoria de raciocínio, extensão de sessão ou retorno sobre investimento.

## Alegações versus evidências

O site apresenta exemplos como economia de aproximadamente 89% na saída e totais elevados de tokens ao longo do tempo. Sua página de benchmarks informa atualmente que nenhum dado de benchmark foi publicado. Esses materiais são hipóteses e demonstrações úteis, não metas de performance do LF.

O repositório público é mais preciso: informa que as porcentagens se referem à saída Bash e que contagens absolutas de tokens são aproximadas. O piloto deve preservar essa formulação e reportar pelo menos:

- Bytes da saída bruta e da saída filtrada.
- Tokens estimados usando o estimador RTK.
- Tokens de entrada e saída informados pelo provedor, quando disponíveis.
- Duração real do comando e sobrecarga do RTK.
- Preservação do código de saída.
- Informações perdidas, pedidos de recuperação e correções do usuário.
- Retrabalho, achados de revisão e defeitos escapados.

Somente após medir esses valores em conjunto a equipe LF deve discutir impacto de custo ou qualidade.

---

# Rastreamento, configuração e confiança

## Rastreamento local

RTK armazena histórico de comandos e métricas de economia em um banco SQLite local. O schema público inclui comando original, comando RTK, caminho do projeto, tokens estimados brutos e filtrados, porcentagem de economia e tempo de execução. A retenção é configurável e costuma ter padrão de 90 dias.

Os dados podem revelar caminhos de projeto, uso de comandos, duração e padrões operacionais mesmo com telemetria desativada. Exigem controle de acesso, retenção e regras de exclusão apropriadas ao projeto.

## Padrões de configuração

A configuração pública descreve opções para:

- Habilitação de rastreamento, dias de histórico e caminho do banco.
- Cores de exibição, emoji e largura máxima.
- Diretórios e arquivos ignorados por filtros orientados a arquivos.
- Recuperação tee, rotação e limites de tamanho.
- Consentimento de telemetria.
- Exclusões de hooks.
- Limites de saída para grep, status e passthrough.

O comando `rtk config` do usuário exibiu uma configuração padrão que não foi gravada em disco. Informou rastreamento habilitado, histórico de 90 dias, tee para falhas habilitado, telemetria desabilitada e nenhuma exclusão de hook.

## Filtros personalizados

RTK oferece filtros TOML locais ao projeto e globais ao usuário. A documentação pública de configuração diz que os filtros passam por controle de confiança baseado em SHA-256 porque podem alterar o que o assistente de IA vê.

Esse é um controle importante: um filtro local ao projeto é comportamento executável na fronteira de contexto, não documentação inofensiva. Revise-o, confie nele explicitamente e volte a validá-lo após edições. Prefira filtros embutidos no primeiro piloto LF.

## Dados brutos e filtrados

Comando bruto, saída filtrada, arquivos tee e banco de rastreamento têm características de privacidade diferentes:

- A saída filtrada pode omitir texto sensível, mas ainda integra o prompt.
- A saída tee bruta pode preservar segredos ou dados pessoais removidos pela filtragem.
- O histórico de rastreamento pode preservar caminhos, nomes de comandos e horários.
- O provedor recebe tudo que o agente enviar, independentemente da política de armazenamento local do RTK.

Não presuma que um comando chamado `env`, `aws`, `curl` ou `docker` seja seguro para enviar por um filtro sem revisar a saída real e o caminho de recuperação.

---

# Telemetria e privacidade

## Política documentada

O README e a política de telemetria afirmam que a telemetria vem desativada por padrão e exige consentimento explícito. Se habilitada, a política pública descreve um ping HTTPS diário com informações agregadas ou anonimizadas, como:

- Hash de dispositivo com salt, versão RTK, sistema operacional e arquitetura.
- Método de instalação, contagem de comandos e nomes dos principais comandos.
- Economia estimada e falhas de parsing de filtros.
- Distribuição do ecossistema, tipo de hook e contagem de configurações.

A política afirma que não coleta código-fonte, conteúdo de arquivos, argumentos completos de comandos, caminhos, segredos, nomes de repositórios ou valores de ambiente. São declarações públicas que ainda exigem uma decisão organizacional de privacidade.

## Observação local

Em 2026-09-03, `rtk telemetry status` informou:

```text
consent: never asked
enabled: no
device hash: (no salt file)
```

A configuração padrão exibida também informou `[telemetry] enabled = false`. Nenhum consentimento de telemetria ou salt de dispositivo foi criado durante a avaliação.

## Conflito na documentação

O Disclaimer do repositório afirma que o software coleta métricas agregadas anônimas “por padrão”, enquanto README, FAQ do site, saída de configuração e política de telemetria descrevem comportamento opt-in ou desativado por padrão. O LF deve tratar isso como conflito documental não resolvido, sem escolher silenciosamente a interpretação mais favorável.

Antes de um piloto, confirme o comportamento efetivo do binário instalado, registre se a telemetria está desativada por ambiente e configuração e obtenha a aprovação de privacidade necessária. Controle explícito recomendado:

```bash
export RTK_TELEMETRY_DISABLED=1
```

---

# Segurança e cadeia de suprimentos

## Execução de comandos

RTK executa ferramentas de shell subjacentes e pode lidar com comandos de arquivos, rede, nuvem, containers e gerenciadores de pacotes. Portanto, opera com as permissões disponíveis para o usuário ou agente.

Filtragem e permissões de hooks melhoram consciência e correção; não isolam código do host. Use container, VM ou outro isolamento aprovado quando o comando, repositório ou provedor não for confiável. Mantenha credenciais de produção e operações destrutivas fora do primeiro piloto.

## Instalador

O usuário instalou RTK com:

```bash
curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh
```

O instalador observado:

- Detectou `darwin aarch64` e destino `aarch64-apple-darwin`.
- Selecionou a versão `v0.47.0`.
- Baixou o arquivo da release pelo GitHub.
- Baixou e verificou checksums SHA-256.
- Verificou o conteúdo do arquivo antes da extração.
- Instalou o binário em `$HOME/.local/bin/rtk`.
- Informou `rtk 0.47.0` após a instalação.

O script revisado falha quando os checksums estão indisponíveis ou divergem, a menos que seja usada a exceção explícita `RTK_SKIP_CHECKSUM=1`. Também rejeita caminhos absolutos e traversal de diretórios no arquivo e instala sem `sudo`.

Isso é evidência mais forte do que um download de binário não verificado, mas o comando ainda executa código de shell remoto da branch móvel `master`. Em ambiente controlado, inspecione e fixe instalador ou release, registre versão e checksum e prefira um caminho de distribuição revisado.

## Integridade de hooks

O sistema público de hooks armazena uma baseline SHA-256 e pode verificar se o hook instalado foi modificado. `rtk verify` local informou:

- Nenhum hook RTK instalado.
- Diretório de dados exclusivo do proprietário.
- `154/154 tests passed` para o comando de verificação.

Esses 154 testes validam o caminho de verificação local do RTK; não são testes de um projeto LF nem prova de que todo filtro preserva semântica.

## Configuração gerada

`rtk init` pode criar ou modificar arquivos de hook, configurações de agentes e documentos de instruções, como `RTK.md`. Trate-os como alterações de código:

- Inspecione o diff gerado antes de aceitá-lo.
- Mantenha backups e conheça o comando de desinstalação.
- Revise permissões do hook e comportamento de reescrita de comandos.
- Não instale globalmente durante avaliação de projeto cliente sem aprovação explícita.

---

# Avaliação local no LF

## Instalação e saída de ajuda

O instalador foi executado no diretório home do usuário e produziu uma instalação bem-sucedida, com checksum verificado. O `rtk --help` fornecido mostrou uma ampla superfície de comandos, incluindo:

- Comandos de arquivo e busca: `ls`, `tree`, `read`, `smart`, `find`, `grep`, `diff`, `json`, `deps`, `env`.
- Comandos Git e de hospedagem: `git`, `gh`, `glab`, `gt`.
- Comandos de build e teste: `cargo`, `npm`, `npx`, `pnpm`, `vitest`, `jest`, `pytest`, `go`, `tsc`, `playwright`, `next`, `mvn`, `dotnet`, `php` e outros.
- Comandos de infraestrutura: `aws`, `docker`, `kubectl`, `oc`.
- Controle e análise: `err`, `test`, `summary`, `gain`, `discover`, `session`, `telemetry`, `config`, `trust`, `verify`, `rewrite`, `hook` e `proxy`.

Essa ampla superfície aumenta o valor potencial e também o número de semânticas específicas de comando que um piloto precisa validar.

## Verificações locais seguras

As seguintes verificações sem instalação foram executadas no workspace LF:

| Comando | Resultado | Significado |
| --- | --- | --- |
| `rtk --version` | `rtk 0.47.0` | Binário instalado confirmado. |
| `rtk verify` | Sem hook; diretório de dados exclusivo do proprietário; 154/154 verificações passaram | Caminho de integridade funciona localmente; nenhuma integração de agente está ativa. |
| `rtk telemetry status` | Nunca perguntado; desativado; sem salt | Nenhum consentimento de telemetria foi criado. |
| `rtk config` | Configuração padrão exibida; arquivo não criado; telemetria desativada | Defaults inspecionados sem alterar configuração. |
| `rtk init --show` | Hook e plugin OpenCode não encontrados; settings existe sem hook RTK | Integração automática não está ativa. |
| `rtk rewrite "git status"` | Retornou `rtk git status` | Reescrita do registro funciona para comando simples. |
| `rtk rewrite "cargo test --all && git diff"` | Reescreveu ambos os segmentos compatíveis | Reescrita composta funciona neste caso. |
| `rtk rewrite "RTK_DISABLED=1 git status"` | Informou desativado e não reescreveu | Exceção por comando é visível. |

Não foram executados `rtk init`, `rtk init --global`, instalação de plugin OpenCode, habilitação de telemetria nem operação de confiança de filtro local ao projeto.

## Limitação de escopo

A raiz LF é um Framework documental e não tem metadados Git nem executor de testes de aplicação. As verificações locais comprovam somente observações de instalação, reescrita e configuração. Não estabelecem economia, equivalência semântica, sobrecarga de performance ou comportamento de agente em projeto cliente real.

---

# Adequação ao LF e ao agf

## Modelo em camadas

O modelo combinado mais seguro é:

```text
Artefatos e governança LF
        |
        v
Grafo opcional de tarefas e evidências de execução do agf
        |
        v
Comando shell do agente
        |
        v
Reescrita e filtragem opcional de saída do RTK
        |
        v
Comando subjacente, testes e sistema de arquivos
```

Cada camada tem responsabilidade diferente. RTK não deve ocultar um teste com falha do `agf` ou do LF; o `agf` não deve tratar um resumo compacto como evidência completa; o LF deve manter a capacidade de solicitar ou recuperar a saída completa.

## Princípios LF existentes que reforça

Quando configurado com cuidado, RTK pode apoiar estes princípios LF existentes:

- Filtrar saída ruidosa de shell antes de carregá-la no contexto.
- Preferir ferramentas determinísticas a memória de agente.
- Manter reais o comando central e o caminho de evidência, em vez de simulá-los.
- Registrar economias medidas e limitações.
- Preservar limites de fontes da verdade e handoffs explícitos.
- Recuperar a saída completa quando um resumo não for suficiente.

Ele não substitui o ciclo de design Elephant-Goldfish. Esse módulo testa se intenção e design são compreensíveis; RTK somente altera a forma da saída de comandos.

## Responsabilidades dos agentes

- Engineering-Manager decide se RTK é adequado ao risco do projeto.
- Prompt-Architect e Product-Owner definem quais evidências precisam permanecer visíveis.
- Software-Architect identifica comandos em que filtragem pode alterar decisões técnicas ou ocultar sinais de segurança.
- Sprint-Planner registra a ferramenta opcional e sua versão no escopo do piloto.
- Implementation / selected CLI usa comandos RTK explícitos ou hook aprovado e informa quando foi necessária saída bruta.
- Code-Reviewer verifica reescritas, configuração alterada e evidências de recuperação.
- QA-Security valida códigos de saída, falhas ocultas, tratamento de dados sensíveis, telemetria e confiança nos hooks.
- Documentation mantém sincronizados os artefatos canônicos e registros de integração opcional.
- Tech-Lead decide se o benefício medido justifica o risco operacional.

---

# Limite de integração recomendado

## Sequência do piloto

1. Selecionar um recurso de complexidade média e uma alteração legada com suíte de testes conhecida e saída significativa de comandos.
2. Registrar escopo e não objetivos do piloto em `.ai/decisions.md`.
3. Fixar RTK `0.47.0` ou release revisada e registrar seu checksum.
4. Estabelecer baseline de saída bruta para comandos representativos.
5. Usar primeiro comandos RTK manuais; ainda não instalar hooks.
6. Comparar saída bruta e filtrada, códigos de saída, duração, perda de informação, esforço de recuperação, achados de revisão e dados de tokens do provedor.
7. Se a baseline for positiva, testar o plugin OpenCode em configuração isolada ou descartável e inspecionar cada arquivo gerado.
8. Manter decisões de revisão LF, QA-Security e Tech Lead independentes de `rtk gain`.
9. Desabilitar ou desinstalar a integração se o custo semântico ou operacional superar o benefício medido.

## Defaults recomendados

- Começar com uso manual/delegado, não reescrita global silenciosa.
- Manter telemetria desativada por controles de configuração e ambiente.
- Usar filtros embutidos antes de revisar filtros TOML personalizados.
- Manter recuperação tee habilitada, proteger seu diretório e definir retenção.
- Excluir comandos nos quais saída completa ou sintaxe exata sejam críticos para a segurança.
- Usar `RTK_DISABLED=1` quando o resultado bruto completo for necessário.
- Usar `rtk run` para execução bruta sem filtragem ou rastreamento quando compatível; usar `rtk proxy` quando for necessária saída bruta, mas o rastreamento de uso for útil.
- Tratar `rtk gain` como tendência local de redução de saída, não como fatura de custo.
- Quando um hook estiver ativo, manter visíveis nas evidências da tarefa o comando original, o reescrito e o caminho de recuperação.

---

# Medidas do piloto

Compare trabalho equivalente com RTK desabilitado e habilitado. Registre:

- Bytes brutos e filtrados por comando e por tarefa.
- Tokens estimados e tokens informados pelo provedor, separadamente.
- Custo real, se dados do provedor estiverem disponíveis, incluindo modelo e base de preço.
- Tempo de execução do comando, sobrecarga RTK e custo de inicialização.
- Igualdade do código de saída e preservação de sinais.
- Número de recuperações manuais de saída bruta.
- Falhas de parsing do filtro, passthroughs e comandos desabilitados.
- Taxa de reescrita do hook e comandos que precisaram de correção.
- Achados de revisão, QA, segurança e defeitos escapados.
- Perda de contexto, repetição de comandos e duração da sessão do agente.
- Tempo de manutenção de configuração, filtros e hooks gerados.
- Compreensão do usuário sobre comando reescrito e saída compacta.

Sucesso significa maior eficiência de contexto sem perda semântica oculta, aumento de retrabalho, enfraquecimento da segurança ou economia enganosa. Uma alta proporção de redução de bytes, sozinha, não é sucesso.

---

# Riscos e mitigações

| Risco | Impacto | Mitigação |
| --- | --- | --- |
| Filtro oculta informação necessária | Implementação ou diagnóstico incorreto | Preservar recuperação bruta, testar comandos críticos para decisões e permitir bypass explícito. |
| Reescrita silenciosa de comando | Agente executa comando diferente do revisado | Inspecionar reescritas, registrá-las nas evidências do piloto e facilitar exclusões e bypasses. |
| Falha de hook bloqueia comando | Fluxo de desenvolvimento ou CI quebrado | Verificar comportamento fail-open por agente e testar entradas malformadas e binário ausente. |
| Falha do hook permite reescrita insegura | Argumentos ou permissões incorretos chegam à ferramenta | Preferir não reescrever de forma conservadora e revisar semântica de permissões específica do agente. |
| Sem isolamento do host | RTK e comandos subjacentes podem afetar a máquina do usuário | Usar container ou VM para trabalho não confiável; manter credenciais fora do escopo do piloto. |
| Tee bruto contém segredos | Saída sensível persiste localmente | Proteger e rotacionar arquivos tee; definir retenção e política de exclusão. |
| Rastreamento contém caminhos e uso | Metadados locais expõem comportamento do projeto | Restringir permissões do banco e incluí-lo na revisão de privacidade. |
| Conflito na política de telemetria | Processamento de dados inesperado | Forçar telemetria desativada, confirmar comportamento efetivo do binário e obter aprovação de privacidade. |
| Filtro personalizado altera contexto | Arquivo do projeto pode manipular a saída vista pelo agente | Usar controle de confiança, revisar hashes e começar com filtros embutidos. |
| Risco de cadeia de suprimentos do instalador | Comprometimento de script remoto ou release | Fixar release, inspecionar script, verificar SHA-256 e registrar proveniência. |
| Estimador exagera economia | Decisão falsa de custo ou ROI | Reportar bytes, tokens estimados e cobrança do provedor como métricas separadas. |
| Divergência de parser específico de ferramenta | Novo formato de saída é resumido incorretamente sem aviso | Manter fallback bruto, monitorar falhas de parsing e testar fixtures reais. |
| Ferramentas diretas ignoram hooks | Otimização parcial é confundida com cobertura total | Declarar a fronteira de ferramentas compatíveis e medir a cobertura Bash real. |
| Divergência de versão | Reescritas ou hooks mudam entre sessões | Fixar versões do RTK e da configuração; verificar após upgrades. |
| Arquivos gerados conflitam com LF | Instruções de agente ou configurações divergem | Inspecionar diffs, registrar responsabilidade e garantir que a integração possa ser removida. |

---

# Recomendações priorizadas

## Prioridade alta

1. Manter RTK opcional e fora do grafo obrigatório de dependências do LF.
2. Pilotar comandos manuais antes de instalar hook global ou plugin OpenCode.
3. Medir redução da saída Bash separadamente de tokens do provedor, custo e qualidade de engenharia.
4. Tratar execução de comandos, arquivos tee, rastreamento, telemetria e filtros personalizados como superfícies explícitas de segurança e privacidade.
5. Preservar recuperação bruta e bypass imediato para todo comando crítico a decisões.
6. Fixar a release e registrar checksum e configuração nas evidências do piloto.

## Prioridade média

1. Adicionar versão RTK opcional, status do hook e nota de bypass a registros de tarefa ou handoff somente se o piloto demonstrar valor operacional.
2. Comparar a saída RTK com compressão de contexto do `agf` e regras LF de saída de shell para evitar filtragem dupla ou ocultação de erros.
3. Definir formato pequeno de evidência com comando original e reescrito, local da saída bruta, resultado filtrado, código de saída e redução medida.
4. Revisar conflito documentado de telemetria e lacuna conhecida de falha de hook com QA-Security antes da adoção pela equipe.
5. Avaliar filtros personalizados por projeto somente depois de compreender o comportamento dos filtros embutidos.

## Prioridade baixa

1. Considerar integração OpenCode automatizada após sucesso da baseline manual.
2. Avaliar autoria de filtros personalizados para saídas específicas de projeto que se repetem.
3. Considerar integração mais ampla de agentes somente quando o contrato de hook e caminho de rollback de cada agente tiverem sido testados independentemente.

---

# Gate de decisão de adoção

Antes que RTK se torne integração padrão do LF, o mantenedor do Framework deve responder:

- Qual camada LF é responsável pelo comando original, comando reescrito e evidência compacta?
- Quais comandos são seguros para filtrar e quais devem permanecer brutos por política?
- Qual métrica exata comprova valor: bytes, tokens de contexto, custo do provedor, tempo ou redução de retrabalho?
- Como saída filtrada, arquivos tee, bancos de rastreamento e telemetria são governados?
- Como um hook é desativado, auditado, atualizado e removido?
- O que ocorre quando RTK está ausente, desatualizado, adulterado ou incompatível?
- Como são tratadas ferramentas diretas `Read`, `Grep` e `Glob` quando hooks cobrem somente Bash?
- O projeto tem isolamento para comandos que podem alterar host ou nuvem?
- Quais versão, checksum, conjunto de filtros e integração de agente são compatíveis?
- A integração pode ser removida sem alterar artefatos canônicos LF?

A decisão deve ser registrada em `docs/ADR.md` ou no registro LF apropriado. Um `rtk verify` aprovado ou porcentagem alta de `rtk gain` não é suficiente para adoção obrigatória.

---

# Princípio final

A lição duradoura do RTK não é que menos saída é sempre melhor. É que o agente deve receber a menor saída que ainda sustente a decisão de engenharia atual, com caminho honesto de recuperação quando isso não ocorrer.

Para o LF, o modelo seguro é aditivo:

```text
LF governa intenção, artefatos, qualidade e aprovação.
agf governa opcionalmente estado executável de tarefas e evidências.
RTK reduz opcionalmente ruído da saída de shell sem ocultar sinais necessários.
O comando subjacente, sistema de arquivos, testes e revisão humana permanecem autoritativos.
```

RTK foi aprovado como orientação opcional de otimização de contexto, não como requisito do Framework. Instalar ou integrar operacionalmente a ferramenta continua sendo uma decisão de aprovação separada.

---

## Histórico de versões

- `0.2.0` — 2026-11-01: Aprovado como orientação suplementar opcional e
  esclarecido que esse status não autoriza instalar RTK nem habilitar
  integrações.
