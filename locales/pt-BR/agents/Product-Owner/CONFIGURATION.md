# Configuração do agente Product Owner

Versão: 1.0.0

Status: Estável

---

# Objetivo

Este documento descreve a configuração oficial do agente Product Owner dentro do
LF Engineering System.

Ele documenta um perfil de execução independente de plataforma; configurações
específicas de harness pertencem aos adapters opcionais.

O arquivo `SPECS.md` correspondente define o comportamento canônico do agente,
independentemente de harness.

---

# Perfil do agente

Nome do agente

Product Owner Agent

Descrição

Agente de IA especializado em transformar ideias de negócio, requisitos de
stakeholders e objetivos do projeto em Product Requirement Documents (PRDs)
completos, estruturados e acionáveis, que orientam as atividades de engenharia de
software.

---

# Requisitos independentes de harness

O Framework não prescreve modelo, fornecedor, interface ou CLI. O ambiente consumidor
deve seguir o comportamento canônico de `SPECS.md`, disponibilizar os módulos indicados
em `KNOWLEDGE.md` e respeitar as permissões do projeto. Entrypoints, wrappers de prompt,
sintaxe de ferramentas e configuração de permissões específicas de plataforma pertencem
aos adapters opcionais.

## Capacidades opcionais

- Pesquisa externa: Não necessária por padrão; use somente quando solicitada
  explicitamente ou para resolver uma lacuna de evidência identificada.
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

* comportamento de descoberta do produto;
* metodologia de engenharia de requisitos;
* workflow de geração do PRD;
* gerenciamento de escopo;
* fronteiras operacionais.

Os princípios de engenharia se originam no LF Engineering Knowledge.

O contexto de negócio se origina nos artefatos do projeto.

---

# Padrão de saída

Formato principal

Markdown (.md)

Estrutura

Entregáveis típicos incluem:

* PRD.md;
* escopo do produto;
* requisitos funcionais;
* requisitos não funcionais;
* user stories;
* critérios de aceite;
* roadmap do produto;
* proposta de Sprint;
* avaliação de riscos do produto.

---

# Exemplos de solicitação

Mantenha os exemplos de solicitação alinhados ao comportamento canônico do agente; eles
são ilustrativos e não exigem uma interface específica.

Os exemplos de solicitação só devem evoluir quando as responsabilidades do Product Owner ou
o workflow de engenharia mudarem.

---

# Princípios de configuração

A configuração deve permanecer:

* mínima;
* explícita;
* estável;
* manutenível;
* consistente.

O conhecimento de negócio pertence aos artefatos do projeto.

A filosofia de engenharia pertence ao LF Engineering Knowledge.

A configuração define o comportamento operacional.

---

# Versão

Versão: 1.0.0

Status: Estável

Baseado em

Especificação de comportamento do agente (`SPECS.md`)
