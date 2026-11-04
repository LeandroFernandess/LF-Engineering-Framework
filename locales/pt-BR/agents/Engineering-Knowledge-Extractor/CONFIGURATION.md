# Configuração do agente Engineering Knowledge Extractor

Versão: 1.0.0

Status: Estável

---

# Objetivo

Este documento descreve a configuração oficial do agente Engineering Knowledge
Extractor dentro do LF Engineering System.

Ele documenta um perfil de execução independente de plataforma; configurações
específicas de harness pertencem aos adapters opcionais.

O arquivo `SPECS.md` correspondente define o comportamento canônico do agente,
independentemente de harness.

---

# Perfil do agente

Nome do agente

Engineering Knowledge Extractor Agent

Descrição

Agente de IA especializado em analisar projetos de software concluídos e
extrair conhecimento de engenharia reutilizável, permitindo a melhoria contínua
do LF Engineering Framework por meio de recomendações baseadas em evidências.

---

# Requisitos independentes de harness

O Framework não prescreve modelo, fornecedor, interface ou CLI. O ambiente consumidor
deve seguir o comportamento canônico de `SPECS.md`, disponibilizar os módulos indicados
em `KNOWLEDGE.md` e respeitar as permissões do projeto. Entrypoints, wrappers de prompt,
sintaxe de ferramentas e configuração de permissões específicas de plataforma pertencem
aos adapters opcionais.

## Capacidades opcionais

- Pesquisa externa: Opcional quando forem necessárias evidências externas atuais;
  prefira fontes oficiais e mantenha os artefatos do projeto como fonte primária.
- Análise de dados estruturados: Não necessária por padrão; implementação e execução
  permanecem com ferramentas autorizadas e workflows responsáveis.

---

# Fonte de Knowledge

Primária

LF Engineering Knowledge

Secundários

Artefatos do projeto

Referência

SPECS.md

---

# Estratégia de instruções

As instruções do agente devem definir:

* metodologia de análise dos artefatos do projeto;
* workflow de identificação de lacunas de conhecimento;
* processo de extração da stack tecnológica;
* metodologia de recomendação de melhorias do Framework;
* fronteiras operacionais;
* handoff para revisão humana.

Os princípios de engenharia se originam no LF Engineering Knowledge.

O contexto do projeto se origina nos artefatos do projeto concluído.

---

# Padrão de saída

Formato principal

Markdown (.md)

Estrutura

Entregáveis típicos incluem:

* PROJECT_KNOWLEDGE.md;
* resumo do projeto;
* stack técnico;
* decisões de engenharia;
* novas tecnologias;
* novo conhecimento de engenharia;
* melhorias sugeridas para o Framework;
* recomendações priorizadas.

---

# Exemplos de solicitação

Mantenha os exemplos de solicitação alinhados ao comportamento canônico do agente; eles
são ilustrativos e não exigem uma interface específica.

Os exemplos de solicitação só devem evoluir quando as responsabilidades do Engineering
Knowledge Extractor ou o workflow de engenharia mudarem.

---

# Princípios de configuração

A configuração deve permanecer:

* mínima;
* explícita;
* estável;
* manutenível;
* consistente.

O conhecimento do projeto pertence aos artefatos de projetos concluídos.

A filosofia de engenharia pertence ao LF Engineering Knowledge.

A configuração define o comportamento operacional.

---

# Versão

Versão: 1.0.0

Status: Estável

Baseado em

Especificação de comportamento do agente (`SPECS.md`)
