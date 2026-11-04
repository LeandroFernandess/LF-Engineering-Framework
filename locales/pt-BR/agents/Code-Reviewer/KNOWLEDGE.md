# Knowledge do agente Code Reviewer

Versão: 1.0.0

Status: Estável

---

# Objetivo

Este documento define os módulos de Knowledge consumidos pelo agente Code
Reviewer.

O agente não é proprietário do conhecimento de engenharia.

Em vez disso, consome os módulos oficiais de Knowledge publicados pelo LF
Engineering System.

O LF Engineering Framework permanece como fonte única da verdade.

---

# Filosofia de Knowledge

O agente Code Reviewer é especializado em validação técnica.

Seu conhecimento deve se concentrar em:

* consistência de engenharia;
* correção técnica;
* avaliação de qualidade;
* alinhamento arquitetural.

O agente deve evitar consumir conhecimento fora de sua especialização, salvo
quando explicitamente necessário.

---

# Módulos obrigatórios

## ENGINEERING_FOUNDATIONS

Finalidade

Fornece a filosofia de engenharia e as prioridades globais que orientam toda
revisão.

Importância

Crítica

---

## ENGINEERING_DECISIONS

Finalidade

Apoia o julgamento de engenharia ao avaliar trade-offs e escolhas de
implementação.

Importância

Crítica

---

## ENGINEERING_STANDARDS

Finalidade

Define os padrões de engenharia usados para avaliar organização do código,
documentação, modularidade e consistência.

Importância

Crítica

---

## ENGINEERING_QUALITY

Finalidade

Define gates de qualidade, critérios de validação e requisitos de aprovação de
engenharia.

Importância

Crítica

---

## ENGINEERING_AGENT_GUIDELINES

Finalidade

Define como o agente Code Reviewer opera dentro do LF Engineering System e
colabora com outros agentes especializados.

Importância

Alta

---

# Módulos opcionais

## ENGINEERING_WORKFLOW

Finalidade

Fornece conhecimento do workflow para entender a fase atual do projeto e validar
se a implementação está pronta para revisão.

Importância

Média

---

## ENGINEERING_ARTIFACTS

Finalidade

Ajuda a identificar quais artefatos de engenharia devem existir e se permanecem
sincronizados.

Importância

Média

---

## ENGINEERING_FIELD_GUIDE

Finalidade

Apoia o julgamento de engenharia em situações ambíguas nas quais existem várias
soluções tecnicamente válidas.

Importância

Média

---

## ENGINEERING_CONTINUOUS_IMPROVEMENT

Finalidade

Fornece orientação para identificar problemas recorrentes e oportunidades de
melhoria do processo de engenharia.

Importância

Baixa

---

# Artefatos do projeto

Quando disponíveis, o agente Code Reviewer deve priorizar os seguintes artefatos:

Obrigatórios

* PRD.md
* ARCHITECTURE.md

Recomendados

* README.md
* CHANGELOG.md
* Documentação da Sprint
* ADRs
* Notas do desenvolvedor

---

# Prioridade de consumo do Knowledge

A ordem recomendada de consumo é:

1. Artefatos do projeto
2. ENGINEERING_FOUNDATIONS
3. ENGINEERING_DECISIONS
4. ENGINEERING_STANDARDS
5. ENGINEERING_QUALITY
6. Demais módulos de apoio

A documentação específica do projeto deve sempre prevalecer sobre o conhecimento
genérico de engenharia quando não houver conflito.

Se houver conflito, o LF Engineering Framework permanece como autoridade.

---

# Restrições de Knowledge

O agente Code Reviewer nunca deve:

* inventar padrões de engenharia;
* substituir princípios do Framework;
* ignorar documentação aprovada do projeto;
* presumir requisitos não documentados.

Quando o conhecimento for insuficiente, o agente deve identificar explicitamente
as informações ausentes antes de produzir conclusões.

---

# Evolução futura

Módulos adicionais de Knowledge podem ser incorporados conforme o LF Engineering
System evoluir.

Novos módulos só devem ser adicionados quando melhorarem claramente o agente Code
Reviewer sem aumentar contexto desnecessário.

---

# Versão

Versão: 1.0.0

Status: Estável

Derivado de:

LF Engineering Knowledge
