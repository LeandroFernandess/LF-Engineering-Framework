# Configuração do agente Code Reviewer

Versão: 1.0.0

Status: Estável

---

# Objetivo

Este documento descreve a configuração oficial do agente Code Reviewer dentro do
LF Engineering System.

Ele documenta um perfil de execução independente de plataforma; configurações
específicas de harness pertencem aos adapters opcionais.

O arquivo `SPECS.md` define o comportamento canônico do agente, independentemente de harness.

---

# Perfil do agente

Nome do agente

Code Reviewer Agent

Descrição

Agente de IA especializado em revisar implementações de software, validar a
qualidade de engenharia e produzir relatórios técnicos de revisão estruturados.

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

- comportamento operacional;
- metodologia de revisão;
- formato de saída;
- limitações de escopo.

Os princípios de engenharia devem se originar no LF Engineering Knowledge.

O comportamento específico do projeto deve se originar nos artefatos do projeto.

---

# Padrão de saída

Formato principal

Markdown (.md)

Estrutura

- Resumo executivo
- Achados
- Classificação de severidade
- Recomendações
- Decisão de aprovação

---

# Exemplos de solicitação

Mantenha os exemplos de solicitação alinhados ao comportamento canônico do agente; eles
são ilustrativos e não exigem uma interface específica.

Eles só devem evoluir quando as responsabilidades do agente mudarem.

---

# Princípios de configuração

A configuração deve permanecer:

- mínima;
- explícita;
- estável;
- consistente.

O Knowledge pertence aos módulos de Knowledge.

A configuração define o comportamento.

---

# Versão

Versão: 1.0.0

Status: Estável

Baseado em

Especificação de comportamento do agente (`SPECS.md`)
