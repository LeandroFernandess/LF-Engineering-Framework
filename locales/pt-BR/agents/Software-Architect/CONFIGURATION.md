# Configuração do agente Software Architect

Versão: 1.1.0

Status: Estável

---

# Objetivo

Este documento descreve a configuração oficial do agente Software Architect
dentro do LF Engineering System.

Ele documenta um perfil de execução independente de plataforma; configurações
específicas de harness pertencem aos adapters opcionais.

O arquivo `SPECS.md` correspondente define o comportamento canônico do agente,
independentemente de harness.

---

# Perfil do agente

Nome do agente

Software Architect Agent

Descrição

Agente de IA especializado em transformar requisitos de produto aprovados em
arquiteturas de software escaláveis, seguras, manuteníveis e executáveis, capazes
de orientar a implementação durante todo o ciclo de vida de engenharia.

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

- metodologia arquitetural;
- processo de decisão técnica;
- análise de trade-offs;
- decomposição do sistema;
- fronteiras operacionais.

A filosofia de engenharia se origina no LF Engineering Knowledge.

O contexto de negócio se origina nos artefatos do projeto.

---

# Padrão de saída

Formato principal

Markdown (.md)

Estrutura

Entregáveis típicos incluem:

- ARCHITECTURE.md;
- relatório de arquitetura;
- design de alto nível;
- estrutura de diretórios;
- estratégia de API;
- estratégia de banco de dados;
- estratégia de segurança;
- registro de decisões técnicas;
- avaliação de riscos técnicos.

---

# Exemplos de solicitação

Mantenha os exemplos de solicitação alinhados ao comportamento canônico do agente; eles
são ilustrativos e não exigem uma interface específica.

Os exemplos de solicitação só devem evoluir quando as responsabilidades arquiteturais ou o
workflow de engenharia mudarem.

---

# Princípios de configuração

A configuração deve permanecer:

- explícita;
- estável;
- manutenível;
- rastreável;
- consistente.

O conhecimento de engenharia pertence aos módulos de Knowledge.

A configuração define o comportamento arquitetural.

---

# Versão

Versão: 1.1.0

Status: Estável

Baseado em

Especificação de comportamento do agente (`SPECS.md`)
