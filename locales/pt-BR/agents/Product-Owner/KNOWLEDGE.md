# Knowledge do agente Product Owner

Versão: 1.2.0

Status: Estável

---

# Objetivo

Este documento define os módulos de Knowledge consumidos pelo agente Product
Owner.

O agente é responsável por transformar objetivos de negócio em especificações de
engenharia estruturadas, preservando a consistência com o LF Engineering
Framework.

Ele consome conhecimento de engenharia.

Ele não cria padrões de engenharia.

---

# Filosofia de Knowledge

Software bom começa com requisitos bons.

Toda atividade de engenharia depende de uma definição de produto completa,
mensurável e bem estruturada.

O agente Product Owner garante que a engenharia comece com clareza, não com
premissas.

---

# Módulos obrigatórios

## ENGINEERING_FOUNDATIONS

Finalidade

Fornece a filosofia de engenharia que orienta a definição do produto.

Importância

Crítica

---

## ENGINEERING_WORKFLOW

Finalidade

Fornece compreensão do ciclo de vida de engenharia, permitindo posicionar
corretamente as atividades de produto.

Importância

Crítica

---

## ENGINEERING_ARTIFACTS

Finalidade

Define os artefatos oficiais de engenharia produzidos e mantidos durante a
definição do produto.

Importância

Crítica

---

## ENGINEERING_DECISIONS

Finalidade

Apoia a priorização de requisitos e a análise de trade-offs do produto.

Importância

Crítica

---

## ENGINEERING_STANDARDS

Finalidade

Define qualidade documental, consistência e padrões organizacionais.

Importância

Alta

---

## ENGINEERING_AGENT_GUIDELINES

Finalidade

Define a colaboração entre o agente Product Owner e os demais especialistas de
engenharia.

Importância

Alta

---

# Módulos opcionais

## ENGINEERING_TEMPLATES

Finalidade

Fornece templates padronizados para PRDs e documentos de planejamento.

Importância

Média

---

## ENGINEERING_QUALITY

Finalidade

Apoia a validação da completude dos requisitos antes da implementação.

Importância

Média

---

## ENGINEERING_DESIGN_PERFORMANCE

Finalidade

Apoia requisitos mensuráveis de responsividade, performance e acessibilidade no
escopo de produto web ou visual.

Importância

Alta quando aplicável.

---

## ENGINEERING_MOTION_DESIGN

Finalidade

Define a intenção de movimento para o usuário, expectativas para movimento
reduzido e critérios de aceite mensuráveis quando movimento estiver
explicitamente no escopo do produto.

Importância

Alta quando houver movimento no escopo; caso contrário, não aplicável.

---

## ENGINEERING_FIELD_GUIDE

Finalidade

Auxilia em situações que envolvem requisitos de negócio ambíguos ou conflitantes.

Importância

Média

---

## ENGINEERING_CONTINUOUS_IMPROVEMENT

Finalidade

Apoia a melhoria contínua dos processos de definição do produto.

Importância

Baixa

---

# Artefatos do projeto

Quando disponíveis, o agente Product Owner deve priorizar:

Obrigatório

* PROJECT_BRIEF.md

Recomendados

* refinamentos do prompt;
* PRDs existentes;
* documentação de negócio;
* notas de stakeholders;
* roadmaps anteriores;
* backlog existente.

---

# Prioridade de consumo do Knowledge

Ordem recomendada:

1. Contexto de negócio
2. PROJECT_BRIEF.md
3. ENGINEERING_FOUNDATIONS
4. ENGINEERING_WORKFLOW
5. ENGINEERING_ARTIFACTS
6. ENGINEERING_DECISIONS
7. ENGINEERING_DESIGN_PERFORMANCE (quando aplicável)
8. ENGINEERING_MOTION_DESIGN (quando houver movimento no escopo)
9. Módulos de Knowledge de apoio

A documentação de negócio define o produto.

O LF Engineering Framework define como esse produto é estruturado em artefatos
de engenharia.

---

# Restrições de Knowledge

O agente Product Owner nunca deve:

* inventar requisitos de negócio;
* produzir arquitetura técnica;
* substituir princípios do Framework;
* ignorar objetivos dos stakeholders;
* gerar detalhes de implementação.

Quando o contexto de negócio for insuficiente, as premissas devem ser declaradas
explicitamente.

---

# Evolução futura

Módulos adicionais de Knowledge podem ser incorporados quando melhorarem a
qualidade da definição do produto sem expandir o agente além de sua
especialização pretendida.

---

# Versão

Versão: 1.2.0

Status: Estável

Derivado de:

LF Engineering Knowledge
