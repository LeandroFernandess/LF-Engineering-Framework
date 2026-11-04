# Conhecimento de Engenharia: Governança de Design Elephant-Goldfish

Versão: 0.2.0

Status: Opcional aprovado

Categoria: Suplementar / Derivado de pesquisa

Responsável: Leandro Fernandes
Baseline do Framework: LF Engineering Framework 1.3.0; status de adoção atualizado pós-tag

---

# Status de adoção

Este módulo de Knowledge, derivado de pesquisa, foi aprovado como orientação opcional para o LF Engineering Framework. Ele permanece fora do grafo obrigatório de dependências e não deve alterar silenciosamente o workflow ativo nem criar um gate universal de design.

Ele preserva as ideias e registra sua adequação ao LF Engineering System. Use-o somente quando o escopo e o risco da tarefa justificarem o trabalho adicional de design e compreensão independente.

A aprovação deste módulo não torna suas recomendações regras do Framework, gates de workflow, instruções obrigatórias de agentes ou artefatos exigidos. Cada uma dessas mudanças requer uma decisão humana separada.

---

# Objetivo

Este módulo descreve um modelo operacional orientado a design para engenharia de software com agentes de programação de IA.

Seu principal objetivo é transferir o julgamento de engenharia humano para artefatos explícitos, revisáveis e reutilizáveis antes que um agente de IA escreva código de implementação. Também define como uma nova sessão de IA pode testar se esses artefatos contêm contexto suficiente para viabilizar uma implementação segura.

O modelo é útil para:

- Novos recursos.
- Mudanças arquiteturais.
- Refatorações de alto risco.
- Integração a bases de código legadas.
- Recuperação após interrupção ou perda de uma sessão de IA.
- Delegação e coordenação de múltiplos agentes de IA.

---

# Não objetivos

Este módulo não:

- Substitui o LF Engineering Framework.
- Substitui `PRD.md`, `ARCHITECTURE.md`, `SPRINTS.md`, ADRs ou relatórios de qualidade.
- Concede aos agentes de IA a responsabilidade pelas decisões de engenharia.
- Trata um documento de design como substituto de testes, revisão de código, QA ou validação de segurança.
- Exige um ciclo completo de design para toda alteração trivial de texto ou manutenção isolada.
- Trata os números anedóticos do artigo como metas de engenharia.

---

# Fonte

Título: *Elephants, Goldfish and the New Golden Age of Software Engineering*

Autor: Dave Rensin

URL: <https://drensin.medium.com/elephants-goldfish-and-the-new-golden-age-of-software-engineering-c33641a48874>

Publicado em: 2026-04-27

Consultado em: 2026-09-03

Posicionamento sobre a fonte: O artigo é um relato pessoal e um conjunto de previsões. Deve ser tratado como relato de experiência e insumo de design, não como padrão validado de forma independente.

---

# Síntese executiva

O artigo argumenta que o desenvolvimento assistido por IA falha quando se pede ao modelo que gere uma saída antes de o ser humano explicitar o problema, as restrições, as compensações e o nível de qualidade esperado.

A solução proposta é um ciclo:

1. Usar uma sessão rica em contexto, o **Elephant**, para interrogar o problema, desafiar premissas e produzir um design completo.
2. Usar uma sessão nova, sem memória, o **Goldfish**, para testar se o design pode ser compreendido e implementado sem depender do histórico oculto da conversa.
3. Implementar somente depois que o design passar pelas verificações de compreensão, crítica, prontidão para implementação e aprovação humana.

A afirmação de engenharia mais importante é:

> Quando a IA produz mais implementação do que os humanos conseguem compreender com confiança, o design explícito passa a ser o principal meio de preservar a intenção e a responsabilidade humanas.

A consequência prática para o LF não é eliminar a revisão de código. É antecipar mais julgamento e validação, tornar o estado da sessão durável e revisar a saída de IA com base em um design explícito e em uma rubrica de avaliação.

---

# Padrão geral de pesquisa

A primeira parte do artigo aplica o mesmo modelo para além da implementação de software. Em qualquer pesquisa ou decisão relevante:

1. Peça à IA que interrogue a solicitação inicial e exponha dimensões ausentes.
2. Transforme a descrição resultante do problema em critérios explícitos de avaliação.
3. Abra uma nova sessão e forneça a ela tanto a descrição do problema quanto a rubrica.
4. Exija evidências, links, premissas, alternativas e limitações no resultado final.
5. Salve a descrição do problema, os critérios de avaliação e o resultado final como conhecimento durável.

Esse padrão impede que o modelo avalie o próprio trabalho com base em um padrão não declarado e cria um registro reutilizável do raciocínio que levou à decisão.

---

# Modelo central

## O Elephant

O Elephant é a sessão de trabalho rica em contexto, junto com os artefatos duráveis que ela produz.

Ele contém:

- Contexto do projeto e do sistema.
- A descrição do problema.
- Perguntas e respostas de esclarecimento.
- Premissas questionadas.
- Alternativas técnicas e opções rejeitadas.
- Microdecisões e suas justificativas.
- O estado atual da implementação.
- O documento de design usado como fonte da verdade para o recurso.

O Elephant não é a transcrição do chat. A parte útil da sessão são os artefatos duráveis. Em geral, a transcrição é ruidosa, longa e dependente demais do contexto conversacional para ser um registro de engenharia confiável.

## O Goldfish

O Goldfish é uma sessão de IA recém-iniciada, sem acesso à conversa anterior. Ela recebe somente o documento de design e os arquivos explicitamente referenciados por esse documento.

O Goldfish é usado como teste independente de contexto. Se não conseguir explicar o sistema, a mudança pretendida ou o caminho de implementação, o design ainda não está completo.

## Regra operacional

**Alimente o Elephant; teste-o com o Goldfish.**

O Elephant cria e refina o design. O Goldfish expõe contexto ausente, premissas ocultas e dependência acidental da conversa original.

---

# Principais conclusões técnicas

## 1. Use a IA como interrogadora antes de usá-la como geradora

Uma solicitação de uma só etapa pede ao modelo que preencha lacunas com premissas. Uma interação melhor pede ao modelo que descubra primeiro quais são as lacunas.

O modelo deve:

- Fazer perguntas de esclarecimento.
- Identificar requisitos ausentes.
- Questionar premissas.
- Explorar casos de borda.
- Expor objetivos conflitantes.
- Perguntar quais evidências sustentariam uma conclusão.

O ser humano deve debater para aprender, não para vencer. Concordância não é evidência de correção.

### Implicação para o LF

As fases de Discovery, Prompt Architect e Product Owner devem permitir explicitamente um ciclo de questionamento antes de os requisitos serem considerados prontos. Um prompt refinado deve registrar perguntas e premissas ainda não resolvidas, em vez de forçar certeza prematura.

## 2. Defina os critérios de avaliação antes de solicitar a saída final

O artigo separa duas atividades que costumam ser misturadas:

1. Descrever o problema ou tema de pesquisa.
2. Definir como a resposta final será avaliada.

Dependendo da tarefa, os critérios de avaliação podem exigir:

- Evidências e citações.
- Cobertura dos requisitos declarados.
- Premissas explícitas.
- Opções alternativas.
- Riscos e limitações.
- Condições de aceite testáveis.
- Rastreabilidade a arquivos autoritativos.

### Implicação para o LF

Os critérios de aceite não devem se limitar ao comportamento do produto. Para designs e implementações produzidos por IA, o LF também deve definir uma rubrica de avaliação da saída: o que precisa estar presente, o que precisa ser referenciado, quais incertezas devem ser escaladas e quais evidências são necessárias para aprovação.

Para tarefas de pesquisa ou análise, de preferência a solicitação final deve ser executada em uma nova sessão, com a descrição completa do problema e a rubrica de avaliação. Isso reduz a ancoragem na conversa exploratória e torna o resultado final reproduzível a partir de entradas duráveis.

## 3. Preserve o julgamento humano em artefatos duráveis

A IA pode produzir texto e código plausíveis sem ter o julgamento necessário para assumir a responsabilidade pelas consequências. O ser humano responsável deve manter a responsabilidade por:

- Intenção.
- Escopo.
- Compensações.
- Aceitação de riscos.
- Arquitetura.
- Decisões de aceite.
- Aprovação final.

O artigo recomenda salvar três resultados duráveis de uma sessão importante:

- A descrição completa do problema.
- Os critérios de aceite ou avaliação.
- O resultado final.

### Implicação para o LF

O modelo de fontes da verdade do LF já dá suporte a esse princípio. A melhoria que falta é tornar fácil localizar e vincular a descrição do problema, a rubrica de avaliação e o resultado final aprovado a partir de `.ai/artifacts.md`, decisões e handoffs.

## 4. Trate a perda de contexto como um modo de falha de engenharia

Uma sessão de IA pode falhar, atingir o limite de contexto, perder o estado das ferramentas ou ser transferida a outro agente. Se a intenção existir somente na conversa, a recuperação exigirá reconstruir o trabalho a partir do código-fonte bruto e da memória.

Um documento durável de estado atual deve permitir que uma nova sessão responda:

- O que estamos tentando realizar?
- O que já foi decidido?
- O que foi implementado?
- O que ainda está incompleto?
- Quais arquivos e artefatos são autoritativos?
- Quais perguntas ou riscos continuam sem solução?

### Implicação para o LF

Os arquivos `.ai/state/`, `.ai/handoff.md`, `.ai/decisions.md` e `.ai/tasks.md` existentes são a base correta. Só se deve adicionar um registro de design ou progresso no nível do recurso quando esses arquivos não conseguirem representar o recurso sem duplicação. O estado de recuperação precisa ter um único responsável canônico.

## 5. Antecipe o julgamento de design

Quando uma pessoa escreve código, muitas decisões pequenas de design ficam embutidas na implementação. Quando uma IA escreve código, essas decisões podem ser geradas sem que o ser humano responsável as tome ou revise conscientemente.

A resposta proposta é explicitar o design antes da implementação:

- Definir o comportamento antes da sintaxe.
- Definir os limites antes das abstrações.
- Definir alternativas antes de escolher uma abordagem.
- Definir o escopo de arquivos antes de editar o repositório.
- Definir as evidências de aceite antes de revisar o resultado.

O artigo resume isso como **design é o novo código**. É uma frase provocativa, não um motivo para descartar o código-fonte. Significa que o design passa a ser a principal expressão legível por pessoas da intenção quando o código gerado se torna abundante ou opaco demais para ser revisado linha por linha.

## 6. Mantenha uma alta relação sinal-ruído

A IA aumenta a velocidade com que tanto trabalho útil quanto trabalho ruim podem ser produzidos. Se saídas de baixa qualidade se acumularem mais rápido do que são removidas, o projeto acabará mais difícil de compreender e mais lento de modificar.

Sinais úteis incluem:

- Um vínculo claro ao requisito aprovado.
- Um vínculo claro à decisão de design pertinente.
- Uma lista delimitada de arquivos.
- Premissas explícitas.
- Testes ou evidências de validação.
- Um diff pequeno e explicável.
- Limitações conhecidas e trabalho de acompanhamento.

Ruído inclui:

- Recursos não solicitados.
- Abstrações especulativas.
- Documentação repetida ou contraditória.
- APIs não verificadas.
- Código que passa em um teste superficial, mas viola a arquitetura.
- Saída longa que não melhora a qualidade das decisões.

### Implicação para o LF

O objetivo não é maximizar a saída da IA. É maximizar o valor de engenharia aceito, compreensível e sustentável por unidade de esforço de revisão humana.

## 7. Exija uma fase de design sem código

Antes da implementação, deve-se instruir explicitamente a IA a não escrever código. Isso cria espaço para:

- Verificação de contexto.
- Enquadramento do problema.
- Questionamento de requisitos.
- Discussão de arquitetura.
- Análise de alternativas.
- Descoberta de riscos.

A primeira proposta técnica deve ser produzida pela IA com base no próprio entendimento do problema, em vez de ser limitada pela primeira solução de uma pessoa. Isso aumenta a possibilidade de revelar pontos cegos.

A proposta deve priorizar:

- Prosa simples.
- Relações entre componentes.
- Diagramas de fluxo de dados ou controle.
- Pseudocódigo curto somente quando esclarecer o comportamento.

A sessão de implementação só começa depois que a proposta tiver sido questionada, corrigida e aprovada.

## 8. Use sessões novas como testes adversariais

Uma sessão longa pode criar uma ilusão de correção porque o modelo e a pessoa compartilham contexto oculto. Sessões novas oferecem uma verificação prática de independência.

O artigo propõe três testes Goldfish:

1. **Compreensão:** a sessão consegue explicar o objetivo e o sistema atual com base no design e nos arquivos referenciados?
2. **Crítica:** consegue identificar omissões, premissas incorretas, casos de borda e alternativas rejeitadas que deveriam ter sido consideradas?
3. **Prontidão para implementação:** dispõe de informação suficiente para implementar o recurso corretamente na primeira tentativa?

Esses testes formam um ciclo. Perguntas levantadas por um Goldfish precisam ser respondidas no design ou explicitamente aceitas como risco ainda não resolvido antes da implementação.

## 9. Documente alternativas e caminhos rejeitados

Um plano de implementação sem alternativas rejeitadas não permite que um agente futuro distinga uma escolha intencional de uma omissão.

O design deve registrar:

- Opções consideradas.
- Opção selecionada.
- Motivos para rejeição.
- Compensações aceitas.
- Condições que justificariam reavaliar a decisão.

Alternativas rejeitadas funcionam como salvaguardas contra alucinações futuras e redesign desnecessário.

## 10. Enumere todos os arquivos no plano de implementação

O artigo considera o inventário de arquivos uma salvaguarda crítica. Um design deve declarar:

- Cada arquivo a criar.
- Cada arquivo a alterar.
- A responsabilidade de cada arquivo.
- O motivo da alteração.
- Os testes ou atualizações de documentação esperados.
- Os arquivos explicitamente fora do escopo quando houver chance de confusão.

Isso torna o escopo inspecionável antes da codificação e facilita comparar o diff resultante com a intenção.

## 11. Comprima o contexto em vez de despejar toda a base de código

Enviar uma grande árvore de fontes inteira a uma IA de uma só vez pode sobrecarregar a recuperação e reduzir a compreensão. O artigo propõe resumos de contexto pequenos e estruturados, usando arquivos `README.md` hierárquicos como “amendoins e feno”.

Os resumos devem explicar:

- O propósito de cada diretório.
- A função de cada arquivo naquele diretório.
- Relações e limites importantes.
- A fonte da verdade para comportamento e configuração.

Os resumos são uma estratégia de compressão de contexto, não um substituto do código-fonte. A IA ainda precisa inspecionar os arquivos autoritativos da implementação antes de fazer alterações.

## 12. Trate agentes de IA como trabalho delegado, não como responsáveis autônomos

O artigo compara a gestão de agentes à gestão de pessoas. A analogia técnica útil é a delegação:

- Especificar o resultado desejado.
- Estabelecer salvaguardas.
- Definir a autoridade do agente.
- Definir quando ele deve parar e pedir orientação.
- Exigir evidências de conclusão.
- Revisar o resultado em vez de microgerenciar cada etapa intermediária.

Agentes não são pessoas e não devem receber confiança implícita. A analogia só é útil para definir limites de delegação e coordenação.

## 13. Aumente gradualmente o número de agentes

Vários agentes podem aumentar a produtividade, mas também elevam as interrupções, as premissas conflitantes e o custo de coordenação. O artigo sugere começar com uma pequena quantidade de agentes, semelhante a uma equipe, enquanto se aprende o modelo operacional.

Para o LF, a regra prática deve ser:

- Começar com o menor conjunto de agentes que cubra o trabalho.
- Adicionar agentes paralelos somente quando os limites e resultados forem independentes.
- Manter um coordenador responsável pela síntese.
- Medir se o custo de coordenação é menor que o esforço economizado.

A heurística específica de tamanho de equipe do artigo é um ponto de partida, não um limite rígido do LF.

## 14. Reinvista ganhos de automação em julgamento

O artigo argumenta que a IA remove trabalho repetitivo, mas aumenta a importância do pensamento rigoroso, da arquitetura e do design. A concentração sustentada é tratada como uma habilidade que precisa ser praticada.

A lição operacional de engenharia é proteger tempo para:

- Enquadrar o problema.
- Analisar arquitetura e compensações.
- Revisar riscos.
- Refinar documentos de design.
- Aprender com evidências de produção e de revisão de código.

O artigo também invoca o Paradoxo de Jevons: uma produção mais barata pode gerar demanda por mais produção, em vez de reduzir o trabalho. As equipes não devem interpretar a velocidade da IA como permissão para ampliar o escopo sem fortalecer os controles de qualidade.

Um exercício prático de concentração sugerido pelo artigo é começar cada dia de trabalho com um bloco protegido de 30 a 45 minutos de design ou raciocínio e aumentar sua duração gradualmente, conforme o hábito se desenvolve. Essa é uma prática operacional de equipe, não um gate de qualidade nem uma prescrição universal de produtividade.

---

# Análise de lacunas do LF

| Capacidade | Presente no LF | Lacuna exposta pelo artigo | Ação futura |
| --- | --- | --- | --- |
| Responsabilização humana | Sim | Está declarada, mas deve ser reforçada em cada limite de delegação de IA. | Adicionar campos explícitos de autoridade e escalonamento. |
| Workflow baseado em fases | Sim | O fluxo ativo avança em direção à implementação sem um ciclo dedicado de design sem código. | Adicionar fases de prontidão de design para níveis de risco apropriados. |
| Aceite do produto | Sim | Os critérios do produto não definem completamente a qualidade de designs ou planos gerados por IA. | Adicionar uma rubrica de avaliação da saída. |
| Arquitetura técnica | Sim | Justificativa no nível de recurso, alternativas rejeitadas e inventário de arquivos podem permanecer implícitos. | Incluí-los na arquitetura ou em um artefato opcional de design de recurso. |
| Continuidade de sessão | Parcialmente | Há estado `.ai/` compartilhado, mas requisitos de recuperação específicos do recurso não são padronizados. | Fortalecer os contratos de handoff e progresso. |
| Validação independente | Parcialmente | Revisão e QA ocorrem após a implementação; compreensão do design não é um gate explícito. | Adicionar verificações Goldfish de compreensão, crítica e prontidão. |
| Revisão da implementação | Sim | A revisão pode ter rastreabilidade mais direta à intenção e ao escopo do design. | Adicionar evidências de conformidade ao design. |
| Integração a sistemas legados | Parcialmente | O framework pressupõe contexto de projeto utilizável e não define bootstrap recursivo de contexto. | Adicionar um workflow opcional de contexto para sistemas legados. |
| Coordenação de agentes | Sim | Os papéis existem, mas autoridade, condições de parada e evidências no nível da tarefa poderiam ser mais explícitas. | Adicionar contratos de delegação e orientação para aumento gradual. |
| Evolução do conhecimento | Sim | Relatos externos de experiência precisam de um caminho controlado entre evidência e Framework. | Testar, medir, revisar e versionar antes da adoção. |

---

# Modelo operacional proposto para o LF

O processo a seguir é uma adaptação para o LF Engineering System. É um comportamento proposto, não um requisito ativo do Framework.

## Fase A: Estabelecer o contexto

### Objetivo

Explicitar o sistema atual e a solicitação inicial antes de elaborar uma solução.

### Ações

1. Carregar o conjunto mínimo de artefatos autoritativos.
2. Pedir à IA uma compreensão de alto nível do sistema relevante.
3. Identificar contexto ausente, conflitante ou desatualizado.
4. Corrigir mal-entendidos apontando para arquivos autoritativos.
5. Registrar premissas e perguntas em aberto.

### Critérios de saída

- A pessoa responsável concorda que o resumo do sistema pela IA é materialmente correto.
- Os artefatos referenciados estão identificados.
- As incógnitas estão visíveis, em vez de serem preenchidas silenciosamente com premissas.

### Mapeamento para o LF

- Engineering Manager e Orchestrator classificam o trabalho.
- Prompt Architect refina a intenção inicial.
- `.ai/state/project-summary.md` e os artefatos do projeto fornecem contexto.

## Fase B: Interrogar o problema

### Objetivo

Expandir a solicitação inicial para uma descrição completa do problema, sem escrever código de implementação.

### Ações

1. Instrua a IA a fazer perguntas em vez de gerar código.
2. Explore objetivos, não objetivos, usuários, restrições e casos de borda.
3. Questione premissas e requisitos conflitantes.
4. Peça à IA que explique por que considera válida uma premissa proposta.
5. Pare quando a descrição do problema e as perguntas não resolvidas estiverem explícitas.

### Critérios de saída

- O problema e o resultado desejado estão descritos em linguagem simples.
- Escopo e não objetivos estão claros.
- Casos de borda importantes têm um responsável ou uma decisão.
- Nenhuma implementação foi aceita apenas por ter sido sugerida.

### Mapeamento para o LF

- Prompt Architect produz ou atualiza `PROJECT_BRIEF.md`.
- Product Owner transforma o contexto esclarecido em `PRD.md`.

## Fase C: Definir a rubrica de avaliação

### Objetivo

Definir como o design e a implementação serão avaliados antes de solicitar que um agente de IA os produza.

### A rubrica deve abranger

- Cobertura dos requisitos.
- Aderência à arquitetura e aos limites.
- Condições de segurança e privacidade.
- Expectativas de performance, quando relevantes.
- Comportamento em erros e falhas.
- Evidências de teste e validação.
- Documentação e rastreabilidade.
- Comportamento fora do escopo.
- Condições que exigem escalonamento.

### Critérios de saída

- Os critérios de aceite são testáveis.
- Os revisores sabem quais evidências solicitar.
- Expectativas de qualidade ambíguas foram resolvidas ou registradas como risco.

### Mapeamento para o LF

- Product Owner é responsável pelos critérios de aceite do produto.
- Software Architect e QA Security contribuem com critérios técnicos de qualidade.
- Sprint Planner transforma os critérios em itens de validação executáveis.

## Fase D: Produzir e debater uma proposta técnica

### Objetivo

Criar uma proposta de solução prioritariamente em prosa antes da implementação.

### Ações

1. Peça à IA que proponha a primeira abordagem técnica com base no contexto estabelecido.
2. Exija prosa, diagramas e pseudocódigo limitado em vez de implementação.
3. Examine limites entre componentes, fluxo de dados, interfaces, modos de falha e impacto operacional.
4. Compare alternativas e documente por que foram rejeitadas.
5. Corrija APIs ou arquiteturas alucinadas apontando para arquivos autoritativos.
6. Continue até que a pessoa aceite o raciocínio, não apenas a redação.

### Critérios de saída

- A abordagem selecionada satisfaz o PRD e as restrições de arquitetura.
- Alternativas e compensações estão documentadas.
- Questões de segurança, falha e operação foram tratadas.
- A proposta está pronta para ser expressa como plano de implementação.

### Mapeamento para o LF

- Software Architect é responsável pelo design técnico.
- Decisões relevantes são registradas em `docs/ADR.md` e `.ai/decisions.md`.

## Fase E: Ensinar o Elephant por meio de um documento de design durável

### Objetivo

Criar a fonte durável da verdade no nível do recurso, capaz de sobreviver a mudanças de sessão e orientar a implementação.

### Seções obrigatórias

1. Problema.
2. Objetivos e não objetivos.
3. Compreensão do sistema atual.
4. Plano técnico.
5. Diagramas de componentes ou sequência, quando úteis.
6. Restrições, premissas e perguntas em aberto.
7. Alternativas consideradas e rejeitadas.
8. Etapas detalhadas de implementação.
9. Inventário completo de arquivos, com justificativas.
10. Critérios de aceite e avaliação.
11. Testes e evidências de validação.
12. Considerações de segurança, privacidade, performance e observabilidade.
13. Estratégia de rollback ou recuperação, quando relevante.
14. Referências relacionadas a PRD, arquitetura, ADR, sprint e issue.
15. Status, responsável, aprovações e andamento atual.

### Regras para redigir o documento

- Construa o documento seção por seção.
- Revise cada seção antes de gerar a próxima.
- Não dependa da geração de um documento complexo em uma única solicitação.
- Mantenha um único responsável canônico por cada fato.
- Vincule artefatos existentes em vez de copiá-los sem motivo.
- Marque incógnitas explicitamente.
- Atualize o documento quando decisões de implementação mudarem.

### Opções de integração ao LF

Há dois caminhos seguros de adoção:

1. **Caminho incremental:** ampliar `PRD.md`, `ARCHITECTURE.md` e `SPRINTS.md` existentes com as seções e os gates acima.
2. **Caminho de recurso:** adicionar um documento opcional de design de recurso, como `docs/design/<FEATURE-ID>.md`, para mudanças de complexidade média e alta.

O caminho de recurso é preferível quando vários recursos evoluem dentro de um projeto, pois um `ARCHITECTURE.md` no nível do projeto não deve se tornar um diário de implementações sem relação entre si. A adoção precisa ser aprovada para evitar a criação de uma fonte duplicada da verdade.

## Fase F: Executar o protocolo Goldfish

### Teste 1: Compreensão

Forneça a uma sessão nova o documento de design e os arquivos por ele referenciados. Peça que explique a mudança pretendida e o sistema atual.

Condição de aprovação:

- A explicação é materialmente correta.
- A sessão não precisa da conversa original.
- Os limites e as restrições importantes estão presentes.

Ação em caso de falha:

- Adicione o contexto ausente ao design canônico ou ao artefato referenciado.
- Repita o teste.

### Teste 2: Revisão crítica

Forneça o mesmo material a outra sessão nova. Peça que encontre:

- Requisitos ausentes.
- Premissas incorretas.
- Casos de borda.
- Lacunas de segurança ou privacidade.
- Inconsistências arquiteturais.
- Alternativas não consideradas.
- Etapas de implementação ambíguas.

Condição de aprovação:

- Os achados restantes são compreendidos e corrigidos, aceitos ou registrados como riscos explícitos.

### Teste 3: Prontidão para implementação

Pergunte a outra sessão nova se ela tem informação suficiente para implementar o recurso em uma única tentativa.

Condição de aprovação:

- Não resta pergunta material sobre escopo, comportamento, responsabilidade pelos arquivos, interfaces ou validação.
- A pessoa revisora aprova o design.

### Regra de governança

Os testes Goldfish complementam a aprovação humana. Não concedem aprovação por si só e não substituem testes automatizados, Code Review ou QA Security.

## Fase G: Implementar com salvaguardas

### Entradas

- Design de recurso aprovado.
- Artefatos referenciados do projeto.
- Escopo aprovado de sprint ou tarefa.
- Rubrica explícita de avaliação.

### Regras de implementação

- Leia o design e os arquivos referenciados antes de editar.
- Siga o inventário de arquivos listado, salvo se uma divergência for escalada.
- Pare quando um requisito ou uma premissa arquitetural não estiver claro.
- Não invente APIs, dependências ou regras de negócio.
- Mantenha o diff alinhado ao escopo aprovado.
- Atualize o estado de progresso quando a sessão terminar ou mudar de direção.

### Regra de recuperação

Se a sessão falhar, inicie outra com o documento de design, o estado atual e os arquivos referenciados. Não reconstrua a tarefa inteira a partir do histórico bruto do chat, a menos que os artefatos duráveis estejam comprovadamente incompletos.

## Fase H: Executar uma revisão adversarial

A revisão pós-implementação deve tentar refutar a correção, em vez de confirmar a narrativa preferida por quem implementou.

Faça a revisão com base em:

- Design aprovado.
- PRD e critérios de aceite.
- Inventário de arquivos da sprint.
- ADRs e limites de arquitetura.
- Gates de segurança e qualidade.
- Testes e evidências de validação observadas.

Peça ao revisor que priorize achados concretos por severidade, localização, impacto e correção. Repita após as correções quando ainda houver achados relevantes.

O artigo sugere pedir à IA que seja intencionalmente severa. A adaptação do LF deve preservar o objetivo adversarial sem exigir linguagem ofensiva nem reduzir a qualidade da revisão a uma preferência de tom.

### Política de comentários

Não adote uma regra literal que exija um comentário a cada quantidade fixa de linhas de código. O padrão atual do LF favorece comentários para regras de negócio, decisões arquiteturais, limitações e comportamentos não óbvios. O gate é a legibilidade; uma densidade arbitrária de comentários não é.

---

# Contrato do documento de design de recurso

Se o LF adotar um artefato separado de design de recurso, o contrato mínimo a seguir é proposto para `docs/design/<FEATURE-ID>.md`.

## Metadados

- ID do recurso.
- Título.
- Status: Draft, Goldfish Review, Ready, Implementing, Implemented, Superseded.
- Responsável.
- Datas de criação e atualização.
- Referências relacionadas a `PROJECT_BRIEF.md`, `PRD.md`, `ARCHITECTURE.md`, sprint e ADRs.

## Problema

Descreva o problema de negócio ou engenharia em três a cinco frases em linguagem simples.

## Objetivos e não objetivos

Declare o que caracteriza o sucesso e o que está deliberadamente excluído.

## Sistema atual

Explique o comportamento existente relevante e vincule os arquivos autoritativos. Inclua somente o contexto necessário para compreender o recurso.

## Restrições e premissas

Separe fatos verificados de premissas. Atribua um responsável ou caminho de escalonamento a cada premissa não resolvida.

## Plano técnico

Descreva componentes, responsabilidades, interfaces, fluxo de dados, comportamento de erros e aspectos operacionais. Use diagramas quando esclarecerem as relações.

## Alternativas

Liste alternativas relevantes, motivos para rejeição, compensações aceitas e condições que justificariam reconsiderar a escolha.

## Implementação detalhada

Enumere a sequência de implementação e todas as alterações de arquivos esperadas.

| Arquivo | Alteração | Motivo | Validação |
| --- | --- | --- | --- |
| `caminho/do/arquivo` | Criar / Atualizar / Excluir | Por que este arquivo muda | Evidência de teste ou revisão |

Liste também os arquivos explicitamente fora do escopo quando um agente futuro puder supor, de forma razoável, que fazem parte da mudança.

## Critérios de aceite e avaliação

Separe:

- Critérios de aceite do produto.
- Critérios de aceite técnicos.
- Critérios de compreensão do design.
- Critérios de evidência da implementação.
- Critérios de aprovação humana.

## Riscos e operação

Documente os riscos de segurança, privacidade, performance, observabilidade, migração, rollback, recuperação de falhas e manutenção aplicáveis ao recurso.

## Estado de progresso e recuperação

Registre:

- Etapas concluídas.
- Etapa atual.
- Próxima ação.
- Decisões tomadas desde o último handoff.
- Bloqueios e perguntas não resolvidas.
- Validações já executadas.

Esta seção não deve duplicar o `.ai/state` global. Deve conter somente estado específico do recurso e vincular os arquivos de estado compartilhados.

## Registro de aprovação

Registre os resultados Goldfish, a revisão humana, desvios do plano e a decisão final de prontidão para implementação.

---

# Receitas de prompts

Estes prompts são padrões reutilizáveis, não formulações obrigatórias. Devem ser adaptados à ferramenta, ao projeto e ao papel do agente.

## Resumo de contexto

```text
Leia os artefatos relevantes do projeto e os arquivos-fonte antes de propor uma
solução. Não escreva código. Primeiro, resuma como funciona a parte relevante
do sistema, quais arquivos são autoritativos e sobre o que você tem dúvidas.
Aguarde correções antes de continuar.
```

## Modo interrogador

```text
Ainda não implemente nada. Entreviste-me sobre este problema. Faça perguntas
que revelem requisitos ausentes, restrições conflitantes, casos de borda,
preocupações de segurança e premissas ocultas. Questione minhas propostas em
vez de concordar automaticamente. Quando fizer uma premissa, identifique-a e
explique por que a fez. Continue até que o problema e seus limites estejam
explícitos.
```

## Reinicialização contra a bajulação

```text
Concordância não é evidência de que a ideia está correta. Seu papel mais útil é
questionar o raciocínio. Diga o que pode estar errado, o que está faltando e
por que você acredita em cada conclusão. Pergunte "por quê?" sempre que a
justificativa for fraca.
```

## Rubrica de avaliação

```text
Antes de produzir o design ou relatório final, ajude-me a definir os critérios
pelos quais ele será avaliado. Inclua cobertura, evidências, premissas,
alternativas, riscos, validação, rastreabilidade e condições que exigem
escalonamento. Não presuma que uma resposta fluente seja uma resposta correta.
```

## Primeira proposta técnica

```text
Com base somente no contexto aprovado e em nossa discussão, proponha a primeira
abordagem técnica em prosa. Não escreva código de implementação. Explique os
componentes principais, limites, fluxo de dados, comportamento em falhas,
alternativas e compensações. Use um diagrama ou pseudocódigo curto somente se
isso melhorar a clareza. Espera-se que a proposta seja imperfeita e ela será
revisada criticamente.
```

## Teste de compreensão Goldfish

```text
Você é uma sessão nova, sem acesso a conversas anteriores. Leia este documento
de design e todos os arquivos que ele referencia. Explique o problema, o
comportamento atual do sistema, a mudança proposta, as restrições, os arquivos
esperados e os critérios de aceite. Identifique tudo o que não consegue
determinar com o material fornecido. Não invente contexto ausente.
```

## Revisão crítica Goldfish

```text
Atue como revisor sênior independente. Leia o documento de design e os arquivos
referenciados. Encontre omissões, premissas falhas, casos de borda, riscos de
segurança ou privacidade, conflitos arquiteturais, etapas ambíguas, APIs sem
suporte e alternativas que deveriam ter sido consideradas. Classifique os
achados por severidade e indique a evidência ou pergunta por trás de cada um.
```

## Prontidão para implementação

```text
Você é uma pessoa engenheira experiente que está se juntando a este trabalho
pela primeira vez. Leia o documento de design e suas referências. Você consegue
implementar o recurso corretamente em uma única etapa? Liste cada decisão
ausente, comportamento ambíguo, arquivo faltante, contrato de interface ausente
e condição de validação faltante. Não implemente até que a lista seja resolvida
ou explicitamente aceita como risco.
```

## Implementação com salvaguardas

```text
Leia o documento de design aprovado e todos os arquivos referenciados.
Implemente somente o escopo descrito e siga o inventário de arquivos. Se o
repositório contradisser o design ou faltar uma decisão importante, pare e
relate o problema em vez de adivinhar. Ao final, informe os arquivos alterados,
os testes executados, as evidências, os desvios, as limitações conhecidas e os
riscos restantes.
```

## Revisão adversarial de código

```text
Revise esta implementação em relação ao design aprovado, aos requisitos, à
arquitetura, aos critérios de aceite e aos testes. Presuma que podem existir
defeitos graves. Procure comportamento incorreto, problemas de segurança,
regressões, acoplamento oculto, complexidade desnecessária, falhas não tratadas,
documentação desatualizada e desvios de escopo. Relate achados concretos com
severidade, localização, impacto, evidências e correção. Não elogie a
implementação, a menos que isso ajude a explicar um achado.
```

## Recuperação de sessão

```text
Esta é uma continuação após uma sessão perdida ou interrompida. Leia o design
do recurso, o estado atual do progresso e todos os arquivos referenciados.
Resuma o trabalho concluído, o estado atual do repositório, o trabalho pendente,
as decisões, os bloqueios e a próxima ação segura. Não repita trabalho concluído
nem infira decisões que não estejam documentadas.
```

---

# Bootstrap de contexto para sistemas legados

O artigo propõe um processo recursivo de documentação para uma base de código grande ou mal documentada.

## Etapa 1: Comece pelas folhas

Distribua diretórios ou módulos pequenos entre as pessoas engenheiras. Evite enviar o repositório inteiro a uma única sessão de IA.

## Etapa 2: Gere um resumo local de contexto

Para cada diretório, gere ou atualize um `README.md` que explique:

- A finalidade do diretório.
- Os arquivos que ele contém.
- A responsabilidade de cada arquivo.
- Dependências e limites importantes.
- A fonte da verdade para comportamento ou configuração.

## Etapa 3: Verificação humana

O primeiro resumo é um rascunho. Uma pessoa engenheira responsável deve verificá-lo em relação ao código e corrigir informações incorretas ou ausentes.

Contexto gerado nunca se torna autoritativo apenas por ter sido escrito por uma IA.

## Etapa 4: Suba um nível por vez

No diretório pai:

1. Leia os resumos verificados dos diretórios filhos.
2. Leia diretamente o código do diretório pai.
3. Crie ou atualize o resumo do diretório pai.
4. Verifique o resultado.

Repita até que a raiz do repositório tenha um mapa de contexto útil.

## Etapa 5: Acompanhe cobertura e desatualização

Quando útil, cada resumo deve ter:

- Responsável.
- Data da última verificação.
- Escopo dos arquivos cobertos.
- Lacunas conhecidas.
- Links para documentos de design.

Quando os documentos de design cobrirem todos os arquivos-fonte relevantes, a hierarquia pode ser mantida como navegação ou retirada para reduzir manutenção. Não mantenha resumos duplicados indefinidamente sem benefício claro.

## Restrições de segurança

- Exclua segredos, credenciais, dados privados e conteúdo gerado ou de fornecedores.
- Não envie o repositório inteiro a um modelo externo por padrão.
- Verifique os resumos antes de usá-los para arquitetura ou implementação.
- Trate resumos desatualizados como pistas, não como autoridade.
- Prefira READMEs e artefatos de design existentes do projeto quando estiverem atualizados.

## Oportunidade de integração ao LF

Esse processo poderia se tornar um workflow opcional `LEGACY_CONTEXT_BOOTSTRAP` ou integrar o field guide, em vez de ser uma etapa obrigatória em todos os projetos. É mais valioso quando o projeto não tem documentação de arquitetura confiável e possui atividade de manutenção suficiente para justificar o investimento inicial.

---

# Modelo de onboarding e contribuição

O artigo identifica um segundo uso para contexto durável: integração de pessoas e avaliação de contribuições propostas.

## Onboarding com pacote de conhecimento

1. Reúna a hierarquia pertinente de resumos `README.md` verificados e documentos de design.
2. Carregue-os em um espaço de conhecimento pesquisável, como um notebook ou ferramenta interna equivalente.
3. Forneça instruções que concentrem a pessoa aprendiz no subsistema que será alterado.
4. Peça à pessoa aprendiz que escreva um design de recurso aprovado nas verificações de compreensão e prontidão Goldfish antes de escrever código de implementação.

Isso transforma o onboarding, antes baseado em leitura passiva ou acompanhamento prolongado, em um exercício observável de compreensão. A aprovação no exercício é uma evidência de que a pessoa consegue raciocinar sobre o sistema relevante; não substitui mentoria humana nem revisão específica do domínio.

## Propostas distribuídas de recursos

Product Managers, Program Managers e outras pessoas colaboradoras que compreendam o domínio do problema podem usar o mesmo pacote de conhecimento para redigir designs de recursos. Uma pessoa responsável pela área técnica revisa o design antes de a implementação ser aceita.

O gate de contribuição é a qualidade do design e das evidências, não a quantidade de código gerada pela pessoa colaboradora ou pela IA.

## Oportunidade de integração ao LF

`workflows/NEW_PROJECT.md` ou `ENGINEERING_FIELD_GUIDE.md` poderia definir futuramente um caminho leve de onboarding. Esse caminho deve exigir contexto atualizado, revisão do design de recurso e responsabilidade clara, mantendo as responsabilidades de implementação e aprovação com os agentes LF apropriados.

---

# Contrato de delegação a agentes

Antes de delegar trabalho a um agente de IA, defina o seguinte contrato.

| Elemento do contrato | Pergunta obrigatória |
| --- | --- |
| Resultado | Que resultado precisa existir quando o agente parar? |
| Contexto | Quais artefatos e arquivos são autoritativos? |
| Escopo | O que o agente pode alterar ou inspecionar? |
| Autoridade | Quais decisões ele pode tomar sem escalonamento? |
| Salvaguardas | Quais padrões, arquitetura e restrições se aplicam? |
| Condições de parada | Quando ele deve parar e pedir orientação? |
| Evidências | Quais testes, relatórios ou referências comprovam a conclusão? |
| Handoff | Qual resumo e próxima ação ele deve deixar? |

## Mapeamento proposto para o LF

- **Engineering Manager:** resultado, classificação, riscos e ambiguidades.
- **Orchestrator:** workflow, sequência de agentes, limites e handoffs.
- **Prompt Architect:** contexto do problema, premissas e informações ausentes.
- **Product Owner:** resultados do produto e critérios de aceite.
- **Software Architect:** limites técnicos, alternativas e decisões.
- **Sprint Planner:** escopo executável, inventário de arquivos e tarefas de validação.
- **Implementation / selected CLI:** implementação dentro da autoridade aprovada.
- **Code Reviewer:** conformidade adversarial e sustentabilidade.
- **QA Security:** evidências independentes de qualidade, segurança e prontidão.
- **Documentation:** sincronização durável e preservação de contexto.
- **Tech Lead:** síntese final, aceitação de riscos e aprovação ou bloqueio.
- **Engineering Knowledge Extractor:** lições reutilizáveis após a aprovação.

Nenhum agente deve inferir autoridade a partir da capacidade de editar um arquivo. A autoridade deve vir do workflow, da responsabilidade pelo artefato e de um handoff explícito.

---

# Gates de qualidade propostos para adoção futura

Esses gates complementam os gates de qualidade atuais do LF.

| Gate | Pergunta | Evidência | Condição de bloqueio |
| --- | --- | --- | --- |
| Contexto do design | A IA compreende o sistema relevante? | Resumo de contexto corrigido | Permanece um mal-entendido material |
| Prontidão do problema | O problema e o escopo estão explícitos? | Problema, objetivos, não objetivos e perguntas em aberto | Requisitos ocultos ou conflitantes |
| Prontidão da avaliação | O nível de qualidade está definido? | Rubrica de aceite e avaliação | A revisão dependeria de gosto ou fluência |
| Design técnico | A solução foi fundamentada antes do código? | Proposta, diagrama, alternativas e decisões | Código proposto antes de o design estar definido |
| Compreensão Goldfish | Uma sessão nova consegue explicar o design? | Resultado de compreensão e correções | Contexto importante existe somente no chat |
| Crítica Goldfish | Omissões e casos de borda foram questionados? | Achados críticos e encaminhamentos | Restam achados materiais sem explicação |
| Prontidão para implementação | O recurso pode ser implementado sem adivinhação? | Resultado de prontidão e aprovação humana | Escopo, arquivos ou comportamento continuam ambíguos |
| Conformidade da implementação | O código corresponde ao plano aprovado? | Diff, testes e registro de desvios | Escopo ou arquitetura divergente sem aprovação |
| Revisão adversarial | O resultado foi efetivamente questionado? | Achados de revisão e correções | Permanecem defeitos críticos ou de alto risco |

Os gates existentes de funcionalidade, segurança, arquitetura, qualidade de código, documentação, performance e experiência do usuário continuam em vigor.

---

# Mapeamento de artefatos e workflow

| Recurso LF existente | Uso alinhado ao artigo | Refinamento futuro recomendado |
| --- | --- | --- |
| `PROJECT_BRIEF.md` | Contexto durável do problema | Incluir premissas explícitas, não objetivos e perguntas em aberto |
| `PRD.md` | Problema do produto e aceite | Separar o aceite do produto da avaliação da saída da IA |
| `ARCHITECTURE.md` | Design técnico no nível do sistema | Vincular designs de recursos e registrar alternativas quando relevante |
| `SPRINTS.md` | Escopo executável e testes | Exigir arquivos esperados, justificativa e tratamento de desvios |
| `docs/ADR.md` | Decisões arquiteturais duráveis | Vincular alternativas rejeitadas e condições para reavaliação |
| `.ai/decisions.md` | Rastreabilidade das decisões atuais | Registrar microdecisões importantes antes que desapareçam no chat |
| `.ai/handoff.md` | Continuidade entre sessões | Exigir estado atual, bloqueios e próxima ação segura |
| `.ai/state/project-summary.md` | Contexto no nível do projeto | Manter estado específico do recurso em artefato vinculado |
| `.ai/state/next-actions.md` | Recuperação e coordenação | Manter uma próxima etapa acionável por handoff ativo |
| `.ai/tasks.md` | Contrato de execução do agente | Acrescentar evidências e condições de parada para tarefas complexas |
| `.ai/artifacts.md` | Inventário de artefatos | Vincular documentos de design, rubricas e resultados Goldfish |
| `REVIEW.md` | Análise após implementação | Comparar explicitamente a implementação com o design e a rubrica |
| Relatório de QA | Validação independente | Incluir evidências de que os riscos do design foram testados |
| `knowledge/INDEX.md` | Descoberta de módulos | Manter módulos opcionais aprovados separados da cadeia obrigatória de dependências |
| `.opencode/orchestrator.md` | Roteamento de agentes | Adicionar encaminhamento de prontidão de design e recuperação após aprovação |

---

# Melhorias propostas para o Framework

As recomendações a seguir estão priorizadas para revisão futura.

## Prioridade alta: Adicionar um ciclo de prontidão de design ao desenvolvimento padrão

Alvos:

- `workflows/STANDARD_DEVELOPMENT.md`
- `knowledge/ENGINEERING_WORKFLOW.md`
- `knowledge/ENGINEERING_QUALITY.md`

Recomendação:

Adicionar um ciclo anterior à implementação que cubra verificação de contexto, questionamento sem código, proposta técnica, completude do design, testes Goldfish e aprovação humana.

Justificativa:

O workflow atual vai de arquitetura e planejamento de sprint diretamente à implementação. Há gates de qualidade após a implementação, mas não um teste independente que verifique se o design se sustenta sem a conversa original com a IA.

## Prioridade alta: Definir uma rubrica de avaliação da saída de IA

Alvos:

- `knowledge/ENGINEERING_AI_COLLABORATION.md`
- `knowledge/ENGINEERING_QUALITY.md`
- `knowledge/ENGINEERING_TEMPLATES.md`

Recomendação:

Adicionar critérios reutilizáveis para avaliar análises, designs, planos e resumos de implementação gerados por IA antes de solicitar a saída.

Justificativa:

As regras de validação existentes dizem que as saídas devem ser revisadas, mas não padronizam quais evidências ou cobertura caracterizam uma boa saída.

## Prioridade alta: Adicionar um artefato opcional de design de recurso

Alvos:

- `schemas/FEATURE_DESIGN.schema.md`
- `knowledge/ENGINEERING_ARTIFACTS.md`
- `knowledge/ENGINEERING_TEMPLATES.md`
- `agents/Software-Architect/`
- `agents/Sprint-Planner/`

Recomendação:

Definir um artefato opcional `docs/design/<FEATURE-ID>.md` para trabalho de complexidade média e alta. Manter requisitos de produto e arquitetura no nível do projeto como fontes da verdade separadas.

Justificativa:

Os artefatos existentes cobrem intenção e arquitetura no nível do projeto, mas um design no nível do recurso é mais adequado ao inventário de arquivos, alternativas, progresso atual e recuperação de sessão.

## Prioridade alta: Tornar a compreensão independente um gate

Alvos:

- `knowledge/ENGINEERING_QUALITY.md`
- `agents/Code-Reviewer/`
- `agents/Software-Architect/`
- `agents/Tech-Lead/`

Recomendação:

Exigir um resultado de compreensão e prontidão em uma sessão nova para mudanças complexas lideradas por IA antes da aprovação da implementação.

Justificativa:

Isso detecta contexto oculto na sessão original antes que ele vire código e reduz a chance de aceitar um design fluente, porém incompleto.

## Prioridade média: Padronizar contratos de delegação de agentes

Alvos:

- `.opencode/orchestrator.md`
- `knowledge/ENGINEERING_AGENT_GUIDELINES.md`
- `knowledge/ENGINEERING_AI_COLLABORATION.md`
- `protocols/AGENT_HANDOFF.md`

Recomendação:

Ampliar os handoffs de agentes para incluir resultado, autoridade, escopo, salvaguardas, condições de parada e evidências exigidas.

Justificativa:

O sistema atual define papéis e responsabilidade por artefatos, mas ainda não padroniza completamente o limite de autonomia de cada tarefa delegada.

## Prioridade média: Adicionar um workflow de bootstrap de contexto legado

Alvos:

- `workflows/`
- `knowledge/ENGINEERING_FIELD_GUIDE.md`
- `knowledge/ENGINEERING_TEMPLATES.md`

Recomendação:

Criar um workflow opcional para gerar recursivamente resumos de contexto de diretórios e verificá-los por revisão humana em projetos legados.

Justificativa:

O framework atual pressupõe que o contexto e os artefatos de arquitetura do projeto já existam. Esse workflow oferece um caminho prático quando eles não existem.

## Prioridade média: Fortalecer requisitos de recuperação de sessão

Alvos:

- `protocols/AGENT_HANDOFF.md`
- `protocols/WORKFLOW_UPDATE.md`
- `.ai/state/`
- `knowledge/ENGINEERING_AI_COLLABORATION.md`

Recomendação:

Exigir que todo handoff ativo declare o trabalho concluído, o trabalho atual, a próxima ação segura, perguntas não resolvidas, decisões e evidências de validação.

Justificativa:

O LF já tem os arquivos de estado adequados. Um formato mínimo de handoff mais forte os tornaria mais úteis após falhas, limites de contexto ou mudanças de agente.

## Prioridade média: Adicionar revisão de conformidade ao design

Alvos:

- `agents/Code-Reviewer/`
- `knowledge/ENGINEERING_QUALITY.md`
- `workflows/STANDARD_DEVELOPMENT.md`

Recomendação:

Exigir que os achados de revisão identifiquem divergências em relação ao design aprovado, ao inventário de arquivos esperado e à rubrica de avaliação.

Justificativa:

O modelo atual de revisão verifica a qualidade da implementação e a arquitetura, mas uma dimensão explícita de conformidade ao design facilita detectar desvios de escopo.

## Prioridade baixa: Adicionar onboarding baseado em design

Alvos:

- `workflows/NEW_PROJECT.md`
- `knowledge/ENGINEERING_FIELD_GUIDE.md`
- `agents/Engineering-Knowledge-Extractor/`

Recomendação:

Usar um exercício de compreensão Goldfish como um sinal opcional de onboarding para pessoas engenheiras ou colaboradoras que trabalhem em um subsistema desconhecido.

Justificativa:

O artigo mostra que compreender o design pode ser um sinal de prontidão mais útil do que a capacidade de produzir rapidamente uma grande quantidade de código.

## Prioridade baixa: Proteger capacidade deliberada para design

Alvos:

- `knowledge/ENGINEERING_FOUNDATIONS.md`
- `knowledge/ENGINEERING_CONTINUOUS_IMPROVEMENT.md`

Recomendação:

Registrar o trabalho concentrado de design e melhoria de qualidade como capacidade legítima de engenharia, em vez de medir a adoção de IA somente por linhas geradas ou tarefas concluídas.

Justificativa:

A produtividade da IA pode aumentar a demanda e o volume de saída. Sem tempo protegido para design, o sistema pode otimizar a geração e subinvestir no julgamento.

---

# Notas de adoção específicas por agente

Estas notas são recomendações para uma futura atualização da documentação canônica dos agentes.

## Prompt Architect

- Conduza o ciclo de questionamento.
- Registre premissas e perguntas sem resposta.
- Resista a transformar ambiguidade em certeza artificial.

## Product Owner

- Defina os critérios de aceite do produto antes da implementação.
- Diferencie resultados desejados de soluções propostas.
- Inclua casos negativos e não objetivos explícitos.

## Software Architect

- Peça à IA a primeira proposta em prosa.
- Exija alternativas, compensações e impacto no nível de arquivos.
- Mantenha decisões de arquitetura separadas de especulações de implementação.

## Sprint Planner

- Transforme o design aprovado em tarefas sequenciadas.
- Preserve o inventário esperado de arquivos e as evidências de validação.
- Defina condições de parada para trabalho de implementação ambíguo.

## Implementation / selected CLI

- Trate o design aprovado como contrato de implementação.
- Pare em vez de adivinhar quando o design e o repositório divergirem.
- Deixe um resumo de recuperação após cada sessão de implementação relevante.

## Code Reviewer

- Revise em relação ao design, não somente ao diff.
- Use perguntas adversariais e evidências.
- Evite regras de estilo arbitrárias que não melhorem a compreensão.

## QA Security

- Valide os riscos identificados durante o design.
- Verifique se os critérios de aceite têm evidências.
- Trate resultados Goldfish como evidência complementar, nunca como substituto de QA.

## Documentation

- Mantenha sincronizados design, estado da implementação e artefatos do projeto.
- Detecte resumos de contexto desatualizados.
- Preserve alternativas rejeitadas e justificativas de decisão.

## Tech Lead

- Aprove o design antes da implementação de alto risco.
- Decida se a ambiguidade restante constitui um risco aceitável.
- Controle quantos agentes estão ativos e se a coordenação está funcionando.

## Engineering Knowledge Extractor

- Registre quais práticas orientadas a design reduziram retrabalho ou melhoraram a compreensão.
- Separe evidências observadas no projeto de hipóteses derivadas do artigo.
- Recomende mudanças no Framework somente após revisão humana das evidências.

---

# Riscos e contrapontos

## Documentos de design podem ficar desatualizados

Um design preciso que não é atualizado pode induzir agentes ao erro de forma mais eficaz do que a ausência de documentação. Todo artefato de design precisa de responsável, status e gatilho de atualização.

## Um Goldfish ainda pode estar errado

Um contexto novo reduz o viés conversacional, mas não garante correção. O modelo pode interpretar incorretamente os arquivos fornecidos, aceitar uma premissa falha ou deixar passar um risco específico do domínio. Revisão humana, testes e QA continuam obrigatórios.

## Mais documentação pode criar duplicação

Adicionar um arquivo de design de recurso sem atribuir responsabilidade pode duplicar PRD, arquitetura e sprint. A adoção deve definir qual artefato é responsável por cada fato e usar links para informações compartilhadas.

## Prompts adversariais podem reduzir a qualidade da colaboração

O objetivo é uma crítica rigorosa, não hostilidade. O LF deve exigir evidências concretas, severidade e correção, em vez de um tom ofensivo específico.

## Resumos de contexto podem registrar uma arquitetura incorreta

A geração recursiva de READMEs é útil, mas resumos gerados podem estar errados, especialmente nos diretórios folha. Verificação humana e metadados de atualização são necessários.

## Inventários extensos de arquivos podem virar burocracia

O inventário é valioso para trabalho de alto risco. Para uma alteração trivial, basta uma declaração compacta de escopo. O workflow deve dimensionar a profundidade da documentação de acordo com risco e complexidade.

## Mais agentes podem reduzir a produtividade

Paralelismo não é automaticamente mais rápido. Conflitos de edição, sincronização e carga de revisão podem superar o tempo economizado. Adicione agentes somente quando os limites de trabalho forem independentes e houver um coordenador capaz de sintetizar os resultados.

## As alegações do artigo não são métricas universais

Alegações como produtividade dez vezes maior, bootstrap em uma semana ou precisão aproximada de modelos são anedóticas e dependem do contexto. O LF deve medir seus próprios resultados por meio de retrabalho, defeitos que escapam, tempo de revisão, compreensão e capacidade de manutenção.

## Design não elimina código

O código continua sendo evidência executável e precisa ser testado, revisado e protegido. A afirmação do artigo de que “design é o novo código” deve ser interpretada como uma mudança na principal responsabilidade humana, não como permissão para deixar de inspecionar a implementação.

---

# Plano de piloto antes da adoção pelo Framework

## Escopo do piloto

Execute o modelo em um ou dois recursos de complexidade média e em uma alteração legada. Não altere primeiro o Framework canônico.

## Etapas do piloto

1. Crie um design de recurso usando o contrato proposto.
2. Registre uma rubrica de avaliação antes da implementação.
3. Execute os testes de compreensão, crítica e prontidão em sessões novas.
4. Obtenha aprovação humana.
5. Implemente dentro do escopo de arquivos enumerado.
6. Execute a revisão de conformidade ao design, Code Review e QA Security.
7. Registre retrabalho, premissas não detectadas, achados de revisão e tempo gasto.
8. Compare os resultados com uma mudança semelhante que não tenha usado o modelo.
9. Decida quais recomendações merecem adoção canônica.

## Sinais de sucesso sugeridos

- Menos reinícios de implementação causados por contexto ausente.
- Menos arquivos não planejados ou mudanças de escopo.
- Menos desvios de arquitetura.
- Descoberta mais antecipada de casos de borda.
- Recuperação mais rápida após interrupção de sessão.
- Menos retrabalho de revisão em código gerado por IA.
- Maior concordância entre design, implementação e testes.
- Novas pessoas colaboradoras conseguem explicar o sistema relevante mais cedo.

## Não usar como métricas primárias de sucesso

- Linhas de código geradas.
- Quantidade de prompts.
- Extensão do documento de design.
- Confiança ou fluência do modelo.
- Quantidade de agentes ativos simultaneamente.

---

# Sequência de integração futura

A ordem mais segura para adoção é:

1. Revisão humana deste módulo opcional e de suas evidências.
2. Piloto sem alterar regras obrigatórias do Framework.
3. Adicionar um template de design de recurso e schema opcional.
4. Adicionar verificações Goldfish a caminhos de workflow de alto risco.
5. Adicionar evidências de conformidade ao design a Code Review e QA.
6. Adicionar contratos de delegação e requisitos de recuperação aos protocolos.
7. Adicionar o workflow opcional de bootstrap de contexto legado.
8. Atualizar adapters e registros de agentes somente depois que o modelo operacional estiver estável.
9. Versionar os módulos canônicos afetados e registrar um ADR quando a cadeia de artefatos ou o workflow mudar.

---

# Relação com o Knowledge existente do LF

## Complementos

- `ENGINEERING_FOUNDATIONS.md`: reforça clareza, responsabilidade, capacidade de manutenção e responsabilização humana.
- `ENGINEERING_WORKFLOW.md`: acrescenta design pré-implementação e ciclos independentes de compreensão.
- `ENGINEERING_ARTIFACTS.md`: propõe um contrato de design no nível do recurso sem substituir a responsabilidade pelos artefatos existentes.
- `ENGINEERING_DECISIONS.md`: explicita premissas, alternativas e compensações mais cedo.
- `ENGINEERING_AI_COLLABORATION.md`: acrescenta práticas de questionamento, salvaguardas, recuperação e avaliação de saída.
- `ENGINEERING_AGENT_GUIDELINES.md`: acrescenta contratos de trabalho delegado e condições de parada.
- `ENGINEERING_QUALITY.md`: acrescenta evidências de prontidão e conformidade ao design.
- `ENGINEERING_CONTINUOUS_IMPROVEMENT.md`: fornece um caminho de piloto e medição para a evolução do Framework.

## Ausência de contradições importantes

- A aprovação humana continua obrigatória.
- Após a adoção, o Framework continua sendo a fonte da verdade.
- As prioridades de qualidade existentes permanecem inalteradas.
- Code Review e QA continuam obrigatórios.
- A responsabilidade pela documentação e os contratos de artefatos continuam válidos.
- Este módulo opcional não autoriza um agente a modificar o Framework.

---

# Glossário

**Elephant:** uma sessão de trabalho de IA rica em contexto e os artefatos duráveis de design, decisões e progresso que ela produz.

**Goldfish:** uma sessão nova de IA, sem acesso à conversa anterior, usada para testar se os artefatos explícitos contêm contexto suficiente.

**Orientado a design:** workflow no qual o enquadramento do problema, o raciocínio técnico, as alternativas e os critérios de avaliação precedem a implementação.

**Rubrica de avaliação:** critérios e evidências explícitos usados para julgar uma saída, design ou implementação de IA.

**Compressão de contexto:** redução deliberada de uma base de código extensa a resumos precisos e navegáveis, sem descartar os arquivos-fonte autoritativos.

**Relação sinal-ruído:** relação entre a saída de engenharia útil e verificável e a saída não solicitada, especulativa ou enganosa.

**Tempo sem supervisão:** período durante o qual um agente delegado pode trabalhar com segurança dentro de seu contrato antes que seja necessária intervenção humana. É uma medida operacional da qualidade da delegação, não uma alegação de responsabilidade independente.

---

# Princípio final

A IA deve acelerar a implementação sem dificultar a recuperação da intenção.

A contribuição humana se desloca para o enquadramento do problema, o julgamento de design, a delegação, as evidências e a responsabilização. O LF Engineering System deve adotar essas ideias gradualmente, preservando uma única fonte da verdade e exigindo evidências antes de transformar um relato de experiência em regra obrigatória de engenharia.

---

## Histórico de versões

- `0.2.0` — 2026-11-01: Aprovado como orientação suplementar opcional e
  esclarecido que esse status não cria gates universais nem artefatos
  obrigatórios.
