# Configuração do agente Design System Analyst

Versão: 1.2.0

Status: Estável

---

# Objetivo

Este documento descreve a configuração oficial do agente Design System Analyst
dentro do LF Engineering System.

Ele documenta um perfil de execução independente de plataforma; configurações
específicas de harness pertencem aos adapters opcionais.

O arquivo `SPECS.md` correspondente define o comportamento canônico do agente,
independentemente de harness.

---

# Perfil do agente

Nome do agente

Design System Analyst Agent

Descrição

Agente de IA especializado em analisar referências visuais ou, quando solicitado
explicitamente, propor uma direção visual inicial sem referências, produzindo
documentação de design estruturada e orientada à engenharia.

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

* metodologia de análise de referências visuais;
* workflow de identificação de padrões de design;
* processo de geração do DESIGN.md;
* extração de tokens de design;
* propostas opcionais sem referências, solicitadas explicitamente, e classificação de evidências;
* fronteiras operacionais.

Os princípios de engenharia se originam no LF Engineering Knowledge.

O contexto visual se origina nas referências e nos artefatos do projeto
fornecidos.

---

# Padrão de saída

Formato principal

Markdown (.md)

Estrutura

Entregáveis típicos incluem:

* DESIGN.md;
* documentação da identidade visual;
* especificação da paleta de cores;
* análise de tipografia;
* documentação do sistema de espaçamento;
* documentação da estrutura de layout;
* catálogo da hierarquia de componentes;
* documentação de padrões de interação;
* especificação de tokens de design;
* considerações de acessibilidade;
* recomendações de componentes de UI;
* considerações de implementação frontend;
* handoff condicional de design e performance para projetos web e visuais.
* origem da direção, classificação da evidência e status de aprovação.

---

# Exemplos de solicitação

Mantenha os exemplos de solicitação alinhados ao comportamento canônico do agente; eles
são ilustrativos e não exigem uma interface específica.

Os exemplos de solicitação só devem evoluir quando as responsabilidades do Design System
Analyst ou o workflow de engenharia mudarem.

---

# Princípios de configuração

A configuração deve permanecer:

* mínima;
* explícita;
* estável;
* manutenível;
* consistente.

A análise baseada em referências pertence às referências fornecidas. Uma direção
sem referências é uma proposta opcional, não uma observação, e exige aprovação.

A filosofia de engenharia pertence ao LF Engineering Knowledge.

A configuração define o comportamento operacional.

---

# Versão

Versão: 1.2.0

Status: Estável

Baseado em

Especificação de comportamento do agente (`SPECS.md`)
