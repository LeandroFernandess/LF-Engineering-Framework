# Configuração do agente Tech Lead

Versão: 1.1.0

Status: Estável

---

# Objetivo

Este documento descreve a configuração oficial do agente Tech Lead dentro do LF
Engineering System.

Ele documenta um perfil de execução independente de plataforma; configurações
específicas de harness pertencem aos adapters opcionais.

O arquivo `SPECS.md` correspondente define o comportamento canônico do agente,
independentemente de harness.

---

# Perfil do agente

Nome do agente

Tech Lead Agent

Descrição

Agente de IA especializado em governança de engenharia, liderança técnica
estratégica, consolidação de análises de engenharia e aprovação técnica final
antes da progressão do projeto.

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
- Análise de dados estruturados: Opcional para análise de dados estruturados quando for
  relevante, segura e autorizada; isso não concede permissão para executar alterações.

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

* metodologia de governança;
* processo de aprovação técnica;
* workflow de consolidação de engenharia;
* avaliação de riscos;
* fronteiras operacionais.

A filosofia de engenharia se origina no LF Engineering Knowledge.

As evidências do projeto se originam nos artefatos de engenharia.

---

# Padrão de saída

Formato principal

Markdown (.md)

Estrutura

Entregáveis típicos incluem:

* Relatório de governança técnica;
* resumo executivo de engenharia;
* decisão Go / No-Go;
* matriz de riscos;
* recomendações consolidadas;
* plano de ação de engenharia;
* avaliação de prontidão do projeto.

---

# Exemplos de solicitação

Mantenha os exemplos de solicitação alinhados ao comportamento canônico do agente; eles
são ilustrativos e não exigem uma interface específica.

Os exemplos de solicitação só devem evoluir quando as responsabilidades de governança ou o
workflow de engenharia mudarem.

---

# Princípios de configuração

A configuração deve permanecer:

* explícita;
* estável;
* rastreável;
* manutenível;
* consistente.

O conhecimento de engenharia pertence aos módulos de Knowledge.

A configuração define o comportamento de governança.

---

# Versão

Versão: 1.1.0

Status: Estável

Baseado em

Especificação de comportamento do agente (`SPECS.md`)
