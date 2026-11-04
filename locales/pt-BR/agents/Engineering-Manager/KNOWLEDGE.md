# Knowledge do agente Engineering Manager

Versão: 1.0.0

Status: Estável

---

# Objetivo

Este documento define os módulos de Knowledge consumidos pelo agente Engineering
Manager.

O agente é especializado em intake operacional, classificação de demandas e
preparação do `MANAGER_BRIEF` para o Orchestrator.

Ele consome conhecimento de engenharia.

Ele não cria padrões de engenharia.

---

# Filosofia de Knowledge

Uma classificação clara evita execução incorreta.

O agente Engineering Manager deve compreender o LF Engineering System o
suficiente para encaminhar demandas à orquestração, permanecendo fora da
execução técnica.

---

# Módulos obrigatórios

## ENGINEERING_FOUNDATIONS

Importância

Crítica

Finalidade

Define a filosofia de engenharia e os princípios de fronteira usados durante o
intake.

---

## ENGINEERING_WORKFLOW

Importância

Crítica

Finalidade

Define o ciclo de vida e os tipos de workflow aceitos para classificação.

---

## ENGINEERING_AGENT_GUIDELINES

Importância

Crítica

Finalidade

Define as fronteiras dos agentes e a separação entre intake, orquestração e
execução.

---

## ENGINEERING_ARTIFACTS

Importância

Alta

Finalidade

Fornece conhecimento dos artefatos do projeto que podem afetar escopo e
prontidão do handoff.

---

## ENGINEERING_QUALITY

Importância

Alta

Finalidade

Apoia a identificação precoce de riscos de qualidade, segurança e entrega.

---

# Módulos opcionais

## ENGINEERING_DECISIONS

Finalidade

Apoia a classificação quando existem trade-offs ou interpretações conflitantes.

Importância

Média

---

## ENGINEERING_STANDARDS

Finalidade

Apoia o reconhecimento de solicitações que podem afetar padrões do Framework ou
do projeto.

Importância

Média

---

## ENGINEERING_FIELD_GUIDE

Finalidade

Apoia situações ambíguas de intake.

Importância

Média

---

## ENGINEERING_CONTINUOUS_IMPROVEMENT

Finalidade

Apoia melhorias futuras no intake e na classificação.

Importância

Baixa

---

# Artefatos do projeto

Quando disponíveis, o agente Engineering Manager deve priorizar:

Obrigatório

* Prompt bruto do usuário

Recomendados

* Estado existente de `.ai/`
* Documentação existente do projeto
* Estrutura do repositório
* Restrições fornecidas pelo usuário
* Estado atual do workflow

---

# Prioridade de consumo do Knowledge

1. Prompt bruto do usuário
2. Estado existente do projeto
3. ENGINEERING_FOUNDATIONS
4. ENGINEERING_WORKFLOW
5. ENGINEERING_AGENT_GUIDELINES
6. ENGINEERING_ARTIFACTS
7. Módulos de Knowledge de apoio

---

# Restrições de Knowledge

O agente Engineering Manager nunca deve:

* usar módulos de Knowledge para executar trabalho técnico especializado;
* substituir o Orchestrator;
* substituir as responsabilidades de Product Owner, Architect, Reviewer, QA,
  Documentation ou Tech Lead;
* modificar regras do Framework durante a execução de um projeto cliente.

---

# Versão

Versão: 1.0.0

Status: Estável
