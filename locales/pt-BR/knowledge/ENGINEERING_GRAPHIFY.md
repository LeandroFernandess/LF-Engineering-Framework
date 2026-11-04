# Conhecimento de Engenharia: grafo de conhecimento de código Graphify

Versão: 0.2.0

Status: Opcional aprovado

Categoria: Suplementar / Avaliação de ferramenta externa

Responsável: Leandro Fernandes
Baseline do Framework: LF Engineering Framework 1.5.0; status de referência opcional mantido na primeira release pública

---

# Status de adoção

Este módulo foi aprovado como orientação opcional para avaliar Graphify como grafo de conhecimento de código e camada de recuperação de contexto para o LF Engineering System.

Ele não faz parte do grafo obrigatório de dependências do LF. Não deve adicionar silenciosamente pacotes Python, instruções geradas, hooks, plugins, servidores MCP, provedores de modelo, telemetria ou artefatos de grafo ao Framework ou a projetos clientes.

A aprovação desta orientação não resolve a lacuna documentada de proveniência entre fonte e build nem autoriza novas instalações, execuções ou integrações do Graphify. O uso da ferramenta exige aprovação específica e separada do proprietário após a aceitação explícita do limiar de proveniência. Por padrão, as recomendações não se tornam regras do Framework, instruções de agentes, gates de workflow ou etapas obrigatórias de configuração.

---

# Objetivo

Graphify apresenta uma base de código como grafo de conhecimento: arquivos, funções, classes, documentos e outras entidades tornam-se nós, enquanto chamadas, importações, definições, referências e relações semânticas tornam-se arestas tipadas.

Seu possível papel no LF é limitado e complementar:

- O LF é responsável por intenção de produto, arquitetura, artefatos, governança, revisão e aprovação humana.
- `agf` pode manter estado opcional de execução, dependências de tarefas e evidências de conclusão.
- Graphify pode fornecer contexto estrutural opcional sobre a base de código e rastrear relações entre símbolos.
- RTK pode reduzir opcionalmente ruído de saída do shell na fronteira dos comandos.
- O sistema de arquivos do projeto, os testes e as evidências de revisão continuam autoritativos.

A questão útil não é se todo agente LF deve usar Graphify. É se um grafo local-first, com versão fixada, consegue responder perguntas estruturais selecionadas com rastreabilidade melhor e menor custo de contexto do que buscas textuais em arquivos, sem enfraquecer a responsabilidade pelas fontes ou os controles de privacidade.

---

# Não objetivos

Este módulo não:

- Substitui o LF Engineering Framework ou `.ai/contracts.md`.
- Substitui `PROJECT_BRIEF.md`, `PRD.md`, `ARCHITECTURE.md`, `SPRINTS.md`, ADRs, revisões, relatórios de QA ou aprovação humana.
- Trata uma consulta, relatório ou aresta do grafo como prova quando sistema de arquivos, testes ou evidências de revisão divergem.
- Exige Graphify para todo projeto LF, agente ou mudança de manutenção.
- Trata grafo como substituto de recuperação difusa para prosa, embeddings ou leitura direta de arquivos com escopo cuidadoso.
- Instala `graphifyy`, executa `graphify install`, cria hooks ou configura MCP.
- Trata alegações do site público, valores de benchmark, número de estrelas ou downloads como evidências LF.
- Trata a alegação de parsing local do Graphify como prova de que todo o conteúdo permanece local; extração semântica de conteúdo não relacionado a código e ingestão explícita de URLs têm caminhos de dados diferentes.
- Duplica responsabilidades dos artefatos LF existentes ou do ledger opcional de execução do `agf`.

---

# Fontes e evidências

## Fontes fornecidas

- URL de conceitos fornecida: <https://graphiffy.com/concepts>
- URL “o que é” fornecida: <https://graphify.com/what-is-graphify>

A URL fornecida `graphiffy.com/concepts` serviu uma página intitulada “How Graphify works: concepts” em 2026-09-03. A URL fornecida `graphify.com/what-is-graphify` retornou HTTP 404 na mesma data. Posteriormente, o usuário forneceu o conteúdo em linguagem simples atribuído a essa URL. Esse conteúdo está incluído como evidência fornecida pelo usuário abaixo, mas não é tratado como página obtida independentemente nem como prova da URL publicada atual. A página de conceitos contém links para várias páginas `.html` em `graphify.com`, mas essas variantes vinculadas também retornaram 404 durante esta avaliação.

## Outras fontes públicas relacionadas

- Página inicial Graphify: <https://graphify.com/>
- Verificação de domínio pelo site oficial: <https://graphify.com/graphify-net-vs-graphify-com>
- Índice completo legível por máquina: <https://graphify.com/llms-full.txt>
- Repositório público: <https://github.com/Graphify-Labs/graphify>
- README v8 revisado: <https://raw.githubusercontent.com/Graphify-Labs/graphify/v8/README.md>
- Metadados do pacote v8 revisados: <https://raw.githubusercontent.com/Graphify-Labs/graphify/v8/pyproject.toml>
- Política de segurança v8 revisada: <https://raw.githubusercontent.com/Graphify-Labs/graphify/v8/SECURITY.md>

O site público e o repositório relacionam `graphify.com`, Graphify Labs e o pacote PyPI `graphifyy`. Uma verificação posterior da página oficial de verificação de domínios do Graphify, em 2026-11-01, encontrou a declaração de que `graphiffy.com` não resolve mais; a página registra sua própria verificação em 2026-10-27. O operador histórico ou a afiliação da página fornecida em `graphiffy.com/concepts` não foram estabelecidos. Mantenha essa página capturada como evidência histórica não verificada, não como autoridade para alegações atuais do produto, identidade do pacote ou proveniência de release.

Consultado em: 2026-09-03; acompanhamento do site oficial: 2026-11-01.

## Classes de evidência

Use estes rótulos ao se referir a Graphify em registros LF:

| Rótulo | Significado |
| --- | --- |
| Alegação pública | Comportamento ou propriedade descrito pelas páginas fornecidas, site público, repositório, README, metadados do pacote ou política de segurança. |
| Observação local | Comportamento observado de fato em um binário Graphify instalado localmente, grafo gerado ou execução em projeto LF. Nenhuma observação local foi feita nesta avaliação. |
| Recomendação LF | Uso ou limite proposto que ainda exige revisão humana e evidência de piloto. |

As páginas fornecidas, o repositório público e um futuro pacote instalado não devem ser presumidos idênticos. Aliases de domínio, versões de branch, skills geradas, metadados do pacote e configuração local podem alterar o comportamento.

---

# Síntese executiva

A ideia central do Graphify é preservar relações de código como arestas explícitas do grafo, em vez de reduzir um repositório a fragmentos de texto independentes. Uma consulta pode percorrer chamadores, importações, definições ou outros vínculos e retornar um subgrafo delimitado e inspecionável.

O candidato mais forte à adoção pelo LF é a disciplina de proveniência:

- Fatos estáticos extraídos do código devem ser distinguidos de relações derivadas por modelo.
- Um resultado deve identificar entidades e localizações-fonte que o sustentam.
- Comportamentos dinâmicos não resolvidos devem permanecer visíveis como incerteza, não virar suposições sem rótulo.
- Um grafo deve ser atualizado quando a fonte mudar e nunca ter precedência sobre o sistema de arquivos atual ou os testes.

As alegações de maior risco são cobertura ampla de linguagens, precisão semântica, economia de tokens, privacidade, atualização automática, segurança de MCP e integração com assistentes. Exigem piloto com versão fixada em projeto representativo.

A posição recomendada para o LF é um experimento opcional, somente de código e local-first, sem hooks nem instruções automáticas para agentes. Use o grafo para descoberta e perguntas de impacto; use artefatos canônicos e o repositório para decisões e comprovação.

---

# Definição em linguagem simples

Graphify é apresentado como ferramenta CLI gratuita, open-source e licenciada Apache 2.0, além de skill para assistentes, que transforma uma base de código em grafo de conhecimento. Analisa código na máquina do usuário, grava arquivos locais do grafo e permite ao assistente consultar a estrutura em vez de repetir buscas textuais no código-fonte.

O conteúdo fornecido pelo usuário e atribuído a `graphify.com/what-is-graphify` dá a descrição operacional mais curta:

1. Instalar o pacote PyPI `graphifyy`, cujo executável é `graphify`.
2. Registrar a skill `/graphify` no assistente de codificação selecionado.
3. Executar `/graphify .` para criar `graphify-out/graph.html`, `graphify-out/GRAPH_REPORT.md` e `graphify-out/graph.json`.
4. Consultar o grafo pelo assistente ou terminal com perguntas estruturais, caminhos e explicações que podem incluir citações `arquivo:linha`.

O conteúdo também declara que o grafo é exposto por MCP e que o grafo estrutural não escreve código nem executa ações. São alegações públicas que devem ser verificadas para a release selecionada, não ações realizadas neste workspace LF.

# O que Graphify deliberadamente não é

## Não é RAG nem busca vetorial

O conteúdo fornecido sobre o produto diz explicitamente que o caminho central do grafo não usa embeddings nem recuperação por similaridade. Graphify extrai relações explícitas, como chamadas, importações e referências, em nós e arestas e responde percorrendo caminhos, em vez de buscar fragmentos mais próximos por vizinhança.

Essa é uma distinção de estratégia de recuperação, não uma promessa de que toda resposta seja exata. Arestas inferidas, lacunas do parser e saída desatualizada ainda podem produzir um caminho incorreto. Embeddings ou RAG continuam apropriados para buscas difusas em grandes coleções de prosa.

## Não é serviço de nuvem

O conteúdo fornecido descreve a ferramenta local como sem backend hospedado, conta ou telemetria e diz que o parsing de código ocorre na máquina do usuário. Os materiais de conceitos e README qualificam essa afirmação: extração semântica de conteúdo não relacionado a código, backends de modelo configurados e ingestão explícita de URLs podem usar serviços de rede. Portanto, o LF deve dizer “parsing local-first de código”, em vez de alegar sem ressalvas que nenhum dado pode sair da máquina.

## Não é gerador de código nem agente

Graphify é uma superfície de mapa e consulta. O assistente existente continua responsável por interpretar o contexto, editar arquivos, executar comandos e tomar decisões. Graphify não deve ser tratado como implementador autônomo, responsável por tarefas ou substituto da revisão e aprovação LF.

---

# Limites honestos

A saída estrutural do Graphify é contexto útil, não verdade absoluta:

- Arestas inferidas são suposições e precisam ser verificadas no código-fonte atual.
- Extração estática pode não detectar despacho dinâmico, reflexão e vinculação orientada por configuração; relações ambíguas devem permanecer visíveis.
- `graph.json` é um snapshot e fica desatualizado após edições, mudanças de branch, merges ou atualizações incompletas.
- O grafo somente de código pode ser criado sem modelo, mas extração semântica mais profunda de documentos e mídia exige backend de modelo configurado.
- Um caminho no grafo pode delimitar uma investigação; não prova comportamento, segurança, satisfação de requisitos nem cobertura de testes.

Esses limites fazem parte da definição do produto, não são casos excepcionais de falha.

# Modelo conceitual

## Grafo de conhecimento de código

A página de conceitos fornecida define grafo de conhecimento de código como mapa legível por máquina de uma base de código. Exemplos de nós:

- Arquivos e módulos.
- Funções, métodos e classes.
- Tabelas de banco de dados e outras entidades técnicas.
- Conceitos e serviços de documentação.

Exemplos típicos de arestas direcionadas e tipadas:

- `calls` entre símbolos executáveis.
- `imports` entre módulos ou pacotes.
- `defines` entre um arquivo e um símbolo.
- `references` entre código, documentos e conceitos.
- `inherits`, `uses` ou outras relações resolvidas pelo extrator.

O vocabulário de arestas é detalhe de implementação até ser verificado em uma release fixada. O LF deve consumir contratos estáveis de consulta e evidência, em vez de copiar para artefatos do Framework um schema interno presumido.

## Passagens determinísticas e semânticas

A página pública de conceitos descreve dois caminhos distintos de extração:

1. Código é analisado localmente com gramáticas tree-sitter incluídas. Funções, classes, importações e chamadas podem virar entidades do grafo porque um parser as encontrou, sem chamada a LLM.
2. Conteúdo que uma AST não representa, como documentos, PDFs, schemas SQL e Terraform, pode ser conectado por backend de modelo configurado. Essas relações são descritas como inferidas, não como fatos analisados pelo parser.

Essa distinção é valiosa, mas não elimina toda incerteza. Um parser pode não detectar comportamento gerado ou dinâmico, e uma passagem semântica pode produzir uma relação incorreta mesmo com um rótulo de proveniência. Quando extração semântica estiver habilitada, registre nas evidências do piloto o tipo da fonte, versão do extrator, modelo, prompt e horário de atualização.

## Proveniência das arestas

A página de conceitos fornecida cita três estados de aresta:

| Rótulo | Interpretação | Tratamento pelo LF |
| --- | --- | --- |
| `EXTRACTED` | O parser ou evidência direta da fonte estabeleceu a relação. | Fato candidato; verifique na fonte atual para decisões consequentes. |
| `INFERRED` | Um modelo ou resolvedor conectou evidências que não estavam explícitas na estrutura analisada. | Hipótese; exija inspeção da fonte antes de implementação ou aprovação. |
| `AMBIGUOUS` | Há evidências, mas despacho dinâmico, reflexão, nomes gerados ou outra limitação impediram resolução completa. | Preserve como incerteza e investigue; nunca promova silenciosamente a fato. |

O README v8 enfatiza `EXTRACTED` e `INFERRED`, enquanto a página de conceitos também descreve `AMBIGUOUS`. Essa diferença exemplifica por que a versão exata instalada e o schema de saída precisam ser fixados antes da automação.

## Grafo, grep, embeddings e RAG

A comparação pública é útil em termos direcionais:

| Abordagem | Forte em | Fraca em | Uso LF |
| --- | --- | --- | --- |
| Grep ou busca direta | Strings exatas, verificações locais rápidas e confirmação na fonte | Relações com múltiplos saltos e conceitos renomeados ou indiretos | Manter como ferramenta autoritativa de verificação. |
| Embeddings ou busca vetorial | Recuperação difusa em grandes coleções de prosa | Caminhos exatos de chamada, relações tipadas e proveniência determinística | Usar quando a necessidade real for similaridade semântica. |
| RAG baseado em fragmentos | Combinar texto recuperado com resposta do modelo | Vínculos rompidos por limites de fragmentos e perguntas de impacto com múltiplos saltos | Usar com citações explícitas e verificação da fonte. |
| Travessia ao estilo Graphify | Chamadores, importações, caminhos, vizinhanças e explicações de relações | Prosa difusa, parsing incompleto e comportamento dinâmico não resolvido | Considerar para descoberta estrutural delimitada após piloto. |

Travessia de grafo não é automaticamente uma recuperação melhor. É mais adequada a uma pergunta como “o que chama este serviço?” do que a “qual documento expressa a mesma política?”. Uma estratégia híbrida pode ser adequada, mas responsabilidade e comportamento de fallback precisam permanecer explícitos.

---

# Pipeline e saídas

## Pipeline público

Os materiais públicos descrevem um fluxo semelhante a:

```text
Arquivos do projeto
    |
    +--> detecção local e extração de AST
    |
    +--> extração semântica opcional para conteúdo não relacionado a código
    |
    +--> construção do grafo e análise opcional de comunidades
    |
    +--> graph.json, GRAPH_REPORT.md e graph.html
    |
    +--> consulta, caminho, explicação ou contexto do assistente
```

O comando de assistente documentado é `/graphify .` ou, em algumas plataformas, `$graphify`. Comando de terminal e sintaxe de skill variam por host e devem ser testados no assistente selecionado, em vez de copiados globalmente.

## Artefatos gerados

O README público descreve um diretório `graphify-out/` contendo:

- `graph.html`: visualização interativa.
- `GRAPH_REPORT.md`: destaques amplos de arquitetura, comunidades e perguntas sugeridas.
- `graph.json`: grafo usado em consultas subsequentes.

A saída pode conter caminhos de fontes, nomes de símbolos, texto de documentação e relações. Portanto, é um artefato de projeto com implicações de privacidade, retenção e atualidade, não uma saída descartável de agente por padrão.

O repositório recomenda fazer commit do grafo para reutilização pela equipe, excluindo dados locais de custo e possivelmente arquivos de cache. O LF não deve adotar essa política sem decidir se dados gerados do grafo são artefato canônico, cache derivado ou estado local sensível. Um primeiro piloto deve manter saídas em diretório descartável e documentar a decisão de retenção.

## Atualização e desatualização

As instruções públicas descrevem `--update`, `graphify update .`, modo watch e hooks Git opcionais. Um grafo pode ficar desatualizado após edição de fonte, troca de branch, merge, alteração de código gerado ou falha de extração incremental.

O invariante mínimo LF é:

```text
timestamp do grafo e revisão do código-fonte precisam ser conhecidos antes de confiar em uma consulta
```

Se o grafo estiver desatualizado ou incompleto, volte à inspeção direta da fonte e registre a limitação. Resultado de consulta sem informações sobre a revisão do código-fonte não é evidência suficiente de conclusão.

---

# Limites de assistente e MCP

## Instalação da skill

O fluxo público de instalação é:

```bash
uv tool install graphifyy
```

Instalação com escopo de projeto pode gravar arquivos de skill ou instruções de assistente. Comandos específicos de plataforma também podem gravar hooks, plugins ou configurações. O README público lista OpenCode entre as plataformas compatíveis e descreve uma instalação OpenCode que grava um arquivo de instruções e um plugin de execução de ferramentas.

Nenhuma dessas mudanças foi feita no workspace LF. Permanecem fora do módulo proposto até que um piloto aprovado pelo usuário defina responsabilidade exata pelos arquivos, rollback e processo de revisão.

## Superfície de consulta

Os exemplos públicos incluem:

```bash
```

Essas operações devem ser tratadas como descoberta de contexto. A resposta ainda precisa ser verificada na fonte atual, nos testes e nos artefatos LF aprovados antes de ser usada para arquitetura, implementação ou governança.

## MCP

O README público descreve um servidor MCP opcional com operações estruturadas como `query_graph`, `get_node`, `get_neighbors` e `shortest_path`. Oferece stdio local e transporte HTTP opt-in, com padrão em loopback e opção de chave de API para servidores expostos.

MCP é uma fronteira de integração, não uma fronteira de confiança. Antes de habilitá-lo, o piloto precisa verificar:

- O caminho exato do grafo aceito pelo servidor.
- Se uma consulta consegue ler fora do diretório de projeto pretendido.
- Autenticação, endereço de bind, tratamento de sessão e logs no modo HTTP.
- Comportamento de erro para dados malformados ou corrompidos do grafo.
- Caminho de dados do provedor e assistente depois que um resultado do grafo é retornado.

O LF deve começar com consultas diretas de CLI em projeto descartável. Não adicionar servidor MCP ou plugin de assistente ao Framework por padrão.

---

# Segurança e privacidade

## Alegações públicas de segurança

A política de segurança v8 revisada descreve Graphify como ferramenta de desenvolvimento local que não faz chamadas de rede durante análise do grafo, exceto para ingestão explícita de URLs. Documenta mitigações alegadas para:

- Validação de esquema de URL, bloqueio de endereços privados e verificações de redirecionamento.
- Limites de tamanho de download e tratamento de respostas não 2xx.
- Validação de caminho do grafo para o servidor MCP.
- Sanitização de rótulos HTML e limites de caracteres de controle.
- Delimitadores contra prompt injection para extração semântica.
- Escaping de YAML, decodificação de substituição e desabilitação de seguimento de symlinks.
- Recuperação de grafo corrompido e ausência de execução de código-fonte durante parsing de AST.

São alegações públicas sobre um snapshot específico da fonte. Não substituem uma revisão QA-Security do pacote selecionado e da configuração gerada.

## Caminhos dos dados

O caminho de dados varia por tipo de entrada:

| Entrada | Caminho alegado | Preocupação LF |
| --- | --- | --- |
| Corpus somente de código | Parsing local tree-sitter; nenhuma API de modelo necessária. | Preferir primeiro para repositórios sensíveis e verificar se realmente funciona offline. |
| Documentos, PDFs, imagens ou outro conteúdo não relacionado a código | Passagem semântica pelo modelo do assistente ou backend configurado. | Classificar dados antes de enviá-los ao provedor; registrar backend e residência. |
| URLs explícitas ou ingestão de mídia | Busca de rede iniciada por comando do usuário. | Tratar como entrada não confiável; verificar controles de SSRF, tamanho, redirecionamento e conteúdo. |
| Grafo e relatório locais | Arquivos no diretório de saída do projeto. | Aplicar regras de acesso, retenção, ignore e commit. |
| MCP stdio | Comunicação com processo local. | Revisar permissões do processo e resolução do caminho do grafo. |
| MCP HTTP | Servidor de rede quando habilitado explicitamente. | Exigir loopback ou exposição revisada, autenticação e monitoramento. |

O site alega que a ferramenta local não exige conta, índice hospedado nem telemetria, enquanto o rodapé da página menciona analytics do site que preserva privacidade. A distinção entre analytics do site, telemetria da ferramenta local e serviços empresariais precisa ser confirmada antes de uma alegação ampla de privacidade.

## Prompt injection e conteúdo não confiável

Documentação e comentários de código podem ser entradas controladas por atacantes. Um grafo que envia esse conteúdo a um modelo pode transportar texto de prompt injection por nós, rótulos, resumos ou arestas inferidas. Delimitadores e sanitização reduzem riscos, mas não tornam confiável por padrão a extração semântica.

O piloto deve:

- Começar com corpus somente de código, sem URLs ou mídia não confiáveis.
- Manter extração baseada em modelo desativada até que o caminho de dados seja aprovado.
- Tratar toda aresta inferida e frase de relatório gerado como saída não confiável.
- Testar rótulos, comentários, nomes de arquivo, Markdown, YAML e HTML maliciosos.
- Evitar expor um servidor MCP HTTP na primeira execução.

## Risco de instalação e hooks

Comandos públicos de instalação executam um gerenciador de pacotes ou instalador e podem gravar instruções de assistente, plugins ou hooks Git. Esses arquivos gerados podem alterar como um agente lê fontes ou quais comandos executa.

Antes de qualquer instalação:

- Fixar a versão do pacote e registrar proveniência e hashes do pacote.
- Inspecionar o pacote e o diff gerado em ambiente descartável.
- Não instalar hooks globais ou plugins OpenCode durante a baseline.
- Manter caminho explícito de desinstalação e rollback.
- Executar a ferramenta com o mínimo prático de permissões sobre repositório e host.

---

# Incerteza de fonte e versão

Os materiais públicos contêm inconsistências não resolvidas que afetam a confiança:

| Item | Valores ou declarações observadas | Resposta necessária |
| --- | --- | --- |
| Domínios fornecidos | A captura de 2026-09-03 encontrou página de conceitos em `graphiffy.com` e HTTP 404 em `graphify.com/what-is-graphify`; a página oficial de verificação de domínio do Graphify agora diz que `graphiffy.com` não resolve mais (sua verificação é datada de 2026-10-27). A afiliação histórica não foi verificada. | Não tratar o domínio fornecido como oficial nem usá-lo para proveniência de pacote/release. Preferir site oficial, repositório e pacote fixado. |
| Identidade do projeto | Repositório público é `Graphify-Labs/graphify`; README ou metadados antigos podem citar outro proprietário. | Registrar repositório, branch, commit e fonte do pacote exatos usados. |
| Versão | Banner do site informa `v0.9.35`; metadados do pacote v8 revisados informam `0.9.53`; política de segurança cobre `0.3.x`. | Não generalizar segurança ou comportamento entre versões. Fixar e verificar a release escolhida. |
| Contagem de linguagens | Páginas públicas descrevem 36 linguagens ou 37 gramáticas tree-sitter em lugares diferentes. | Tratar cobertura como alegação até ser testada com a stack LF/cliente. |
| Schema de arestas | A página de conceitos descreve `EXTRACTED`, `INFERRED` e `AMBIGUOUS`; exemplos do README enfatizam dois rótulos. | Validar o schema de saída antes de escrever integrações ou gates. |
| Privacidade | Ferramenta local é descrita sem telemetria, enquanto o site público tem analytics e modelo de serviço separado. | Separar caminhos de dados do núcleo, site e oferta empresarial na decisão de privacidade. |
| Benchmarks | Valores públicos de benchmark e marketing não foram reproduzidos independentemente no LF. | Usá-los como hipóteses, não critérios de aceite. |

Esses pontos não são motivos para rejeitar a ferramenta. São motivos para explicitar identidade da release e escopo das evidências antes de depender dela.

---

# Adequação ao LF, agf e RTK

## Modelo em camadas

O modelo combinado proposto é:

```text
Artefatos e governança LF
        |
        +--> estado opcional de tarefas e evidências de execução do agf
        |
        +--> estrutura de código e contexto relacional opcional do Graphify
        |
        +--> redução opcional de saída de shell do RTK
        |
        v
Sistema de arquivos, comandos, testes, revisão e aprovação humana atuais
```

As ferramentas são complementares somente quando cada uma tem responsável único. Graphify não deve virar um segundo PRD, registro de arquitetura, rastreador de tarefas ou comprovação de conclusão. RTK não deve ocultar a fonte ou evidências de teste necessárias a Graphify ou `agf`.

## Limites de responsabilidade

| Preocupação | Autoridade LF | Representação possível no Graphify |
| --- | --- | --- |
| Intenção do usuário e escopo do produto | `PROJECT_BRIEF.md`, `PRD.md` | Nós de documentos referenciados; nunca fonte independente de requisitos. |
| Arquitetura e decisões | `ARCHITECTURE.md`, `docs/ADR.md` | Justificativa vinculada ou referências a fontes; registros aprovados por humanos continuam canônicos. |
| Sprint e estado de tarefas | `SPRINTS.md`, `.ai/`, grafo opcional `agf` | Arquivos e símbolos relacionados; nenhum status de tarefa inferido do grau do grafo. |
| Código e comportamento | Repositório atual e testes | Nós, arestas, caminhos e citações analisados. |
| Revisão e qualidade | `REVIEW.md`, relatório QA e decisão do Tech Lead | Contexto somente para descoberta; saída do grafo não substitui relatórios. |
| Conhecimento reutilizável | `knowledge/` após revisão | Referência opcional a conceitos verificados e lições do piloto. |

## Consumidores candidatos

- Software Architect: rastrear dependências e prováveis caminhos de impacto antes de consultar registros canônicos de arquitetura.
- Sprint Planner: identificar símbolos candidatos e módulos afetados ao decompor trabalho aprovado.
- Implementation / selected CLI: responder perguntas delimitadas de chamadas, importações e responsabilidade antes de ler uma grande superfície de código.
- Code-Reviewer: comparar símbolos alterados com chamadores, importações e testes.
- QA-Security: inspecionar a atualidade do grafo, proveniência, entradas não confiáveis e comportamento dinâmico não detectado.
- Documentation: usar localizações de fonte para melhorar navegação sem duplicar o Framework.

Graphify deve continuar um auxílio opcional de contexto. Não deve ser carregado por todo agente ou tarefa apenas porque está instalado.

---

# Limite de integração recomendado

## Sequência do piloto

1. Selecionar um projeto de código de complexidade média e uma mudança com chamadores, importações ou impacto entre módulos conhecidos.
2. Registrar escopo, classificação de dados e não objetivos do piloto em `.ai/decisions.md`.
3. Fixar pacote Graphify, versão Python, commit do repositório e extras opcionais; registrar hashes e comando exato utilizado.
4. Executar extração somente de código em diretório descartável, sem hook de assistente, servidor MCP ou credenciais de nuvem.
5. Registrar a revisão do código-fonte, o timestamp do grafo, as contagens de nós e arestas, os avisos, as saídas e o tempo de execução.
6. Fazer um conjunto fixo de perguntas estruturais e comparar resultados com inspeção direta da fonte, testes e julgamento de revisores.
7. Incluir na fixture despacho dinâmico, código gerado, reflexão, símbolos renomeados, arquivos ignorados, arquivos excluídos e cenários de grafo desatualizado.
8. Se a baseline for positiva, testar documentos semânticos separadamente com backend local ou organizacional aprovado e regras explícitas de residência de dados.
9. Somente após sucesso da baseline manual, avaliar skill de assistente ou integração MCP com escopo de projeto em configuração descartável.
10. Remover a integração se rastreabilidade, privacidade, atualidade ou custo de manutenção forem piores que a baseline de código-fonte bruto.

## Defaults recomendados

- Manter o módulo aprovado como orientação opcional e a ferramenta separadamente opt-in.
- Preferir parsing local somente de código no primeiro experimento.
- Manter extração semântica baseada em modelo e ingestão de URL desativadas por padrão.
- Não instalar hooks globais ou de projeto durante a baseline.
- Não gravar instruções Graphify em `AGENTS.md`, `.opencode/` ou registros de agentes sem decisão explícita do Framework.
- Tratar `graph.json`, `GRAPH_REPORT.md` e `graph.html` como artefatos derivados sensíveis até que política de retenção e commit seja decidida.
- Exigir a revisão do código-fonte e a atualidade do grafo em toda evidência de consulta.
- Tratar arestas `INFERRED` e `AMBIGUOUS` como hipóteses, não evidência de aceite.
- Para perguntas consequentes, recorrer à fonte e aos testes atuais.
- Manter disponíveis desinstalação, rollback e caminho sem Graphify.

## Medidas do piloto

Compare trabalho equivalente com Graphify indisponível e disponível. Registre:

- Precisão, revocação e correção de citações para um conjunto fixo de perguntas.
- Correção de resultados de `calls`, `imports`, `defines`, `inherits` e caminhos.
- Falsos positivos, falsos negativos e relações dinâmicas não resolvidas.
- Atualidade do grafo após edições, mudanças de branch, merges e falhas parciais.
- Contagens de nós e arestas, duração da extração e duração de atualização incremental.
- Bytes de contexto ou tokens do provedor com e sem recuperação delimitada pelo grafo.
- Número de leituras diretas da fonte ainda necessárias para tomar uma decisão segura.
- Tempo para responder, retrabalho, achados de revisão e defeitos escapados.
- Chamadas a modelos, provedor, residência de dados e exposição de conteúdo sensível.
- Falhas de MCP ou hooks, permissões, mudanças em arquivos gerados e esforço de rollback.
- Custo de manutenção de upgrades, arquivos ignorados e mudanças de schema.

Sucesso significa melhorar a descoberta estrutural sem perda semântica oculta, respostas desatualizadas, fluxo de dados inseguro ou duplicação de fontes da verdade. Um grafo grande, rápido ou visualmente impressionante não é automaticamente útil.

---

# Riscos e mitigações

| Risco | Impacto | Mitigação |
| --- | --- | --- |
| Grafo desatualizado | Agente segue relações excluídas, renomeadas ou não commitadas. | Registrar a revisão do código-fonte e o estado de atualização do grafo; atualizar o grafo ou voltar à inspeção da fonte. |
| Ponto cego de análise estática | Despacho dinâmico, reflexão ou código gerado não são detectados. | Incluir casos difíceis conhecidos e exigir verificação direta da fonte/testes. |
| Aresta inferida incorreta | Relação derivada por modelo causa análise de impacto errada. | Rotular proveniência, expor confiança e tratar inferências como hipóteses. |
| Prompt injection em conteúdo | Relatórios ou extração semântica alteram comportamento do agente. | Começar somente com código; delimitar conteúdo não confiável; revisar saída gerada. |
| Conteúdo sensível enviado a provedor | Código, documentos ou mídia saem da residência aprovada. | Classificar entradas, desativar passagem semântica por padrão e fixar backend aprovado. |
| Abuso de ingestão de URL | SSRF, downloads excessivos ou conteúdo malicioso chegam ao processo. | Manter ingestão desativada; revisar validação de URL e fronteiras de rede antes do uso. |
| Exposição de MCP | Grafo local fica legível por interface insegura. | Começar com stdio ou loopback; exigir autenticação e testes de caminho para HTTP. |
| Hook ou plugin gerado | Comportamento do agente muda silenciosamente e fica difícil de reverter. | Baseline manual primeiro; inspecionar diffs e manter rollback por projeto. |
| Artefatos de saída vazam dados | `graph.json`, HTML ou relatórios expõem caminhos e conceitos da fonte. | Definir regras de acesso, retenção, ignore e commit antes de uso em equipe. |
| Comprometimento de pacote ou instalador | Código remoto executa com permissões do usuário. | Fixar proveniência, inspecionar pacote, verificar hashes e usar isolamento. |
| Divergência de schema/versão | Integrações quebram ou interpretam silenciosamente tipos de aresta de forma incorreta. | Fixar release, testar schema de saída e revalidar após upgrades. |
| Alegações de marketing exageradas | LF adota expectativas de qualidade ou performance sem suporte. | Usar fixtures fixas de projeto e dados de cobrança de provedor, não manchetes. |
| Duplicação de fonte da verdade | Achados do grafo são confundidos com requisitos ou arquitetura. | Manter explícitos a matriz de responsabilidade e os links para artefatos canônicos. |
| Cobertura parcial de assistente | Algumas ferramentas usam o grafo enquanto leituras diretas o ignoram. | Documentar fronteira real da integração e nunca alegar cobertura universal. |

---

# Recomendações priorizadas

## Prioridade alta

1. Manter Graphify como módulo suplementar aprovado como opcional, não dependência obrigatória do LF.
2. Resolver proveniência de pacote, repositório, branch, versão e domínio antes de instalar ou integrar.
3. Começar com parsing local somente de código em projeto descartável e sem hooks, plugins, MCP ou telemetria.
4. Exigir a revisão do código-fonte, a atualidade do grafo e a proveniência em cada resultado de piloto.
5. Medir correção estrutural e qualidade de revisão separadamente da redução de contexto ou tokens.
6. Manter arquivos atuais, testes, artefatos LF e revisão humana acima da saída do grafo.

## Prioridade média

1. Definir registro pequeno de evidências contendo identidade do pacote, revisão do código-fonte, timestamp do grafo, consulta, caminhos retornados, proveniência, verificação direta e resultado.
2. Comparar recuperação Graphify com busca direta, regras de contexto LF existentes, pacotes de contexto `agf` e comandos filtrados pelo RTK, para detectar informação duplicada ou ocultada.
3. Testar regras locais de ignore do projeto, atualização incremental e retenção de saída gerada antes de compartilhar com a equipe.
4. Revisar extração semântica e MCP separadamente do parsing determinístico de código; um teste bem-sucedido somente de código não deve aprovar ambos.

## Prioridade baixa

1. Avaliar instruções de OpenCode ou outro assistente com escopo de projeto somente após uma baseline manual positiva.
2. Avaliar MCP HTTP ou serviço de grafo compartilhado somente depois de comprovar comportamento local por stdio, autenticação e isolamento de caminhos.
3. Considerar artefatos de grafo commitados somente depois de decidir se são dados canônicos, cacheáveis ou derivados sensíveis.

---

# Gate de decisão de adoção

Antes que Graphify se torne integração padrão do LF, o mantenedor do Framework deve responder:

- Quais repositório, pacote, branch, versão e checksum estão aprovados?
- É possível estabelecer independentemente o operador ou a afiliação histórica do conteúdo fornecido de `graphiffy.com`, caso esse conteúdo seja reconsiderado?
- Quais dados do grafo podem sair da máquina, se algum?
- Quais classes de entrada exigem extração semântica e quais são somente código?
- Quem é responsável por manter o grafo atualizado e por sua saída gerada, retenção e exclusão?
- Quais arestas são aceitáveis como contexto e quais exigem verificação direta?
- Como resultados dinâmicos, ambíguos, desatualizados ou parciais são apresentados aos agentes?
- Qual métrica exata prova valor: correção, tempo, tokens de contexto, custo ou redução de retrabalho?
- Como uma skill, hook, plugin ou servidor MCP é auditado, desativado, atualizado e removido?
- A integração pode ser removida sem alterar artefatos canônicos LF?

A decisão deve ser registrada em `docs/ADR.md` ou no registro de decisão LF apropriado. Uma criação bem-sucedida do grafo, visualização atraente ou resposta de consulta não basta para adoção obrigatória.

---

# Princípio final

A lição duradoura do Graphify é que relações de código devem ser representadas e rastreadas, em vez de redescobertas repetidamente em textos desconectados. Para o LF, o limite seguro é aditivo:

```text
LF governa intenção, artefatos, qualidade e aprovação.
agf governa opcionalmente estado executável de tarefas e evidências.
Graphify expõe opcionalmente estrutura de código e contexto relacional.
RTK reduz opcionalmente ruído de saída de shell sem ocultar sinais necessários.
O sistema de arquivos atual, os testes e a revisão humana permanecem autoritativos.
```

Graphify foi aprovado como referência opcional de camada de contexto, não como requisito do Framework. A lacuna documentada de proveniência entre fonte e build permanece sem solução; não instale, execute ou integre mais a ferramenta sem aprovação específica do proprietário para um limiar explícito de proveniência.

---

## Histórico de versões

- `0.2.0` — 2026-11-01: Aprovado como orientação suplementar opcional;
  atualizadas as evidências do domínio oficial e do publicador PyPI, mantendo a
  lacuna de proveniência entre fonte e build e o gate separado para uso da
  ferramenta.
