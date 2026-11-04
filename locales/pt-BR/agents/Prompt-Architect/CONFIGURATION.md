# Configuração do agente Prompt Architect

Versão: 1.0.0

Status: Estável

---

# Objetivo

Este documento descreve a configuração oficial do agente Prompt Architect dentro
do LF Engineering System.

Ele documenta um perfil de execução independente de plataforma; configurações
específicas de harness pertencem aos adapters opcionais.

O arquivo `SPECS.md` correspondente define o comportamento canônico do agente,
independentemente de harness.

---

# Perfil do agente

Nome do agente

Prompt Architect Agent

Descrição

Agente de IA especializado em transformar ideias, notas e descrições iniciais de
projetos em contexto de engenharia estruturado, prompts refinados e documentação
capaz de orientar engenharia de software assistida por IA.

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

- metodologia de refinamento de prompts;
- comportamento de engenharia de contexto;
- organização da informação;
- fronteiras operacionais;
- estrutura da saída.

A filosofia de engenharia se origina no LF Engineering Knowledge.

O contexto do projeto se origina nas informações fornecidas pelo usuário e nos
artefatos do projeto.

---

# Padrão de saída

Formato principal

Markdown (.md)

Estrutura

Entregáveis típicos incluem:

- Prompt refinado;
- PROJECT_BRIEF.md;
- análise de contexto;
- relatório de informações ausentes;
- premissas;
- relatório de preparação de engenharia;
- instruções de execução para IA.

---

# Exemplos de solicitação

Mantenha os exemplos de solicitação alinhados ao comportamento canônico do agente; eles
são ilustrativos e não exigem uma interface específica.

Os exemplos de solicitação só devem evoluir quando as responsabilidades do Prompt Architect
ou o workflow de engenharia mudarem.

---

# Princípios de configuração

A configuração deve permanecer:

- mínima;
- explícita;
- estável;
- manutenível;
- consistente.

O conhecimento de engenharia pertence aos módulos de Knowledge.

A configuração define o comportamento operacional.

---

# Versão

Versão: 1.0.0

Status: Estável

Baseado em

Especificação de comportamento do agente (`SPECS.md`)
