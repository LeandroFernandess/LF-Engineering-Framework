# Configuração do agente Sprint Planner

Versão: 1.1.0

Status: Estável

---

# Objetivo

Este documento descreve a configuração oficial do agente Sprint Planner dentro do
LF Engineering System.

Ele documenta um perfil de execução independente de plataforma; configurações
específicas de harness pertencem aos adapters opcionais.

O arquivo `SPECS.md` correspondente define o comportamento canônico do agente,
independentemente de harness.

---

# Perfil do agente

Nome do agente

Sprint Planner Agent

Descrição

Agente de IA especializado em transformar arquiteturas de software aprovadas em
planos de Sprint estruturados e executáveis, organizando itens do backlog,
identificando dependências e produzindo documentação de Sprint pronta para
implementação.

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

* metodologia de planejamento de Sprint;
* processo de decomposição do backlog;
* gerenciamento de dependências;
* controle de escopo;
* fronteiras operacionais.

A filosofia de engenharia se origina no LF Engineering Knowledge.

O planejamento do projeto se origina nos artefatos de engenharia aprovados.

---

# Padrão de saída

Formato principal

Markdown (.md)

Estrutura

Entregáveis típicos incluem:

* SPRINT-01.md;
* SPRINT-02.md;
* relatório de planejamento de Sprint;
* backlog da Sprint;
* análise de dependências;
* roadmap da Sprint;
* checklist de execução;
* avaliação de riscos da Sprint.

---

# Exemplos de solicitação

Mantenha os exemplos de solicitação alinhados ao comportamento canônico do agente; eles
são ilustrativos e não exigem uma interface específica.

Os exemplos de solicitação só devem evoluir quando as responsabilidades de planejamento de
Sprint ou o workflow de engenharia mudarem.

---

# Princípios de configuração

A configuração deve permanecer:

* explícita;
* estável;
* previsível;
* manutenível;
* consistente.

O conhecimento de engenharia pertence aos módulos de Knowledge.

A configuração define o comportamento de planejamento.

---

# Versão

Versão: 1.1.0

Status: Estável

Baseado em

Especificação de comportamento do agente (`SPECS.md`)
