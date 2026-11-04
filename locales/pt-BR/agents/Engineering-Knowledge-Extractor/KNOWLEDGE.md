# Knowledge do agente Engineering Knowledge Extractor

Versão: 1.0.0

Status: Estável

---

# Objetivo

Este documento define os módulos de Knowledge consumidos pelo agente Engineering
Knowledge Extractor.

O agente é responsável por analisar projetos concluídos e extrair conhecimento
de engenharia reutilizável que possa melhorar o LF Engineering Framework.

Ele consome conhecimento de engenharia para identificar o que é novo.

Ele não cria padrões de engenharia.

---

# Filosofia de Knowledge

Todo projeto concluído contém conhecimento de engenharia.

Parte desse conhecimento já está representada no Framework.

Outra parte é nova.

O agente Engineering Knowledge Extractor distingue os dois, garantindo que o
Framework evolua com base em experiência real, não em premissas.

---

# Módulos obrigatórios

## ENGINEERING_FOUNDATIONS

Finalidade

Fornece a filosofia de engenharia que orienta a extração de conhecimento e a
evolução do Framework.

Importância

Crítica

---

## ENGINEERING_WORKFLOW

Finalidade

Fornece compreensão do ciclo completo de engenharia, permitindo análise
abrangente entre fases.

Importância

Crítica

---

## ENGINEERING_CONTINUOUS_IMPROVEMENT

Finalidade

Define o processo de evolução do Framework, os workflows de melhoria e as regras
de governança que orientam a extração de conhecimento.

Importância

Crítica

---

## ENGINEERING_ARTIFACTS

Finalidade

Define os artefatos oficiais de engenharia, permitindo avaliar completude e
cobertura dos artefatos.

Importância

Alta

---

## ENGINEERING_STANDARDS

Finalidade

Fornece os padrões-base com os quais novas práticas de engenharia podem ser
comparadas.

Importância

Alta

---

## ENGINEERING_DECISIONS

Finalidade

Apoia a análise de decisões de engenharia e trade-offs documentados no projeto.

Importância

Alta

---

## ENGINEERING_AGENT_GUIDELINES

Finalidade

Define responsabilidades dos agentes, permitindo avaliar se os agentes
existentes cobrem necessidades emergentes de engenharia.

Importância

Alta

---

# Módulos opcionais

## ENGINEERING_TEMPLATES

Finalidade

Fornece estruturas de templates que podem ser comparadas aos padrões de
documentação do projeto.

Importância

Média

---

## ENGINEERING_FIELD_GUIDE

Finalidade

Auxilia na avaliação das abordagens práticas de engenharia usadas no projeto.

Importância

Média

---

## ENGINEERING_QUALITY

Finalidade

Apoia a análise das práticas e gates de qualidade aplicados durante o projeto.

Importância

Média

---

## ENGINEERING_AI_COLLABORATION

Finalidade

Apoia a análise de como os agentes de IA foram usados durante o projeto e se os
padrões de colaboração podem melhorar.

Importância

Baixa

---

# Artefatos do projeto

Quando disponíveis, o agente Engineering Knowledge Extractor deve priorizar:

Obrigatórios

* PROJECT_BRIEF.md
* PRD.md
* ARCHITECTURE.md
* SPRINTS.md
* código-fonte
* CHANGELOG

Recomendados

* DESIGN.md
* REVIEW.md
* Relatório de QA
* Auditoria de documentação
* ADRs
* manifesto de pacotes
* configuração de build
* configuração de deploy

---

# Prioridade de consumo do Knowledge

Ordem recomendada:

1. Artefatos do projeto (evidência principal)
2. ENGINEERING_FOUNDATIONS
3. ENGINEERING_WORKFLOW
4. ENGINEERING_CONTINUOUS_IMPROVEMENT
5. ENGINEERING_ARTIFACTS
6. ENGINEERING_STANDARDS
7. ENGINEERING_DECISIONS
8. Módulos de Knowledge de apoio

Os artefatos do projeto definem o que foi construído.

O LF Engineering Framework define o que já é conhecido.

A lacuna entre ambos define o que deve ser extraído.

---

# Restrições de Knowledge

O agente Engineering Knowledge Extractor nunca deve:

* modificar módulos de Knowledge;
* inventar conhecimento de engenharia;
* substituir princípios do Framework;
* gerar conteúdo do Framework;
* substituir o processo de revisão humana.

Quando a evidência for insuficiente, as limitações devem ser declaradas
explicitamente.

---

# Evolução futura

Módulos adicionais de Knowledge podem ser incorporados quando melhorarem a
qualidade da extração sem expandir o agente além de sua especialização
pretendida.

O próprio agente pode se tornar fonte de melhoria contínua para a metodologia de
extração de conhecimento do Framework.

---

# Versão

Versão: 1.0.0

Status: Estável

Derivado de:

LF Engineering Knowledge
