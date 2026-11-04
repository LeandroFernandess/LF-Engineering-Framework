# Configuração do agente Documentation & Technical Writer

Versão: 1.0.0

Status: Estável

---

# Objetivo

Este documento descreve a configuração oficial do agente Documentation &
Technical Writer dentro do LF Engineering System.

Ele documenta um perfil de execução independente de plataforma; configurações
específicas de harness pertencem aos adapters opcionais.

O arquivo `SPECS.md` correspondente define o comportamento canônico do agente,
independentemente de harness.

---

# Perfil do agente

Nome do agente

Documentation & Technical Writer Agent

Descrição

Agente de IA especializado em manter documentação técnica, preservar o
conhecimento de engenharia e garantir que a documentação permaneça sincronizada
com a evolução do software durante todo o ciclo de vida do projeto.

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

* comportamento de documentação;
* metodologia de sincronização;
* organização da saída;
* fronteiras operacionais.

A filosofia de engenharia e os padrões de documentação se originam no LF
Engineering Knowledge.

O contexto específico do projeto se origina nos artefatos do projeto.

---

# Padrão de saída

Formato principal

Markdown (.md)

Estrutura

As saídas devem ser organizadas com headings claros e seções apropriadas.

Entregáveis típicos incluem:

* Relatório de auditoria de documentação;
* atualizações do README;
* atualizações do CHANGELOG;
* recomendações de ADR;
* análise de lacunas de documentação;
* plano de melhoria da documentação.

---

# Exemplos de solicitação

Mantenha os exemplos de solicitação alinhados ao comportamento canônico do agente; eles
são ilustrativos e não exigem uma interface específica.

Eles só devem evoluir quando as responsabilidades do agente ou o workflow de
engenharia mudarem.

---

# Princípios de configuração

A configuração deve permanecer:

* mínima;
* explícita;
* estável;
* manutenível;
* consistente.

O conhecimento de engenharia pertence aos módulos de Knowledge.

A configuração define o comportamento operacional.

---

# Versão

Versão: 1.0.0

Status: Estável

Baseado em

Especificação de comportamento do agente (`SPECS.md`)
