# Knowledge do agente Software Architect

Versão: 1.2.0

Status: Estável

---

# Objetivo

Este documento define os módulos de Knowledge consumidos pelo agente Software
Architect.

O agente é especializado em arquitetura técnica e tomada de decisões de
engenharia.

Sua responsabilidade é transformar requisitos de produto aprovados em
arquiteturas de software robustas.

---

# Filosofia de Knowledge

Arquitetura é uma sequência de decisões de engenharia intencionais.

Toda decisão deve equilibrar objetivos de negócio, restrições técnicas e
manutenibilidade de longo prazo.

O agente Software Architect projeta soluções de engenharia.

Ele não as implementa.

---

# Módulos obrigatórios

## ENGINEERING_FOUNDATIONS

Importância

Crítica

Finalidade

Define a filosofia de engenharia.

---

## ENGINEERING_DECISIONS

Importância

Crítica

Finalidade

Fornece metodologia de decisão arquitetural e análise de trade-offs.

---

## ENGINEERING_STANDARDS

Importância

Crítica

Finalidade

Define padrões de engenharia e consistência arquitetural.

---

## ENGINEERING_WORKFLOW

Importância

Alta

Finalidade

Define como a arquitetura se integra ao ciclo de vida de engenharia.

---

## ENGINEERING_ARTIFACTS

Importância

Alta

Finalidade

Define ARCHITECTURE.md e os artefatos de engenharia relacionados.

---

## ENGINEERING_AGENT_GUIDELINES

Importância

Alta

Finalidade

Define a colaboração com os agentes Product Owner, Sprint Planner e QA.

---

## ENGINEERING_DESIGN_PERFORMANCE

Finalidade

Define handoffs de design responsivo, orçamentos de performance web, cobertura
de rota/perfil e expectativas de validação para decisões arquiteturais.

Importância

Alta quando o projeto tem interface web ou visual; caso contrário, condicional.

---

## ENGINEERING_MOTION_DESIGN

Finalidade

Define handoffs arquiteturais para sistemas de movimento, integração com
movimento reduzido, limpeza de ciclo de vida e riscos de performance; para
simuladores orientados por modelo, cobre limites de estado/fluxo de dados e
estratégia de validação numérica.

Importância

Alta quando houver movimento ou simulador interativo orientado por modelo no
escopo; caso contrário, não aplicável.

---

# Módulos opcionais

## ENGINEERING_QUALITY

Finalidade

Apoia a validação da qualidade da arquitetura.

Importância

Média

---

## ENGINEERING_TEMPLATES

Finalidade

Fornece templates padronizados de arquitetura.

Importância

Média

---

## ENGINEERING_FIELD_GUIDE

Finalidade

Apoia o julgamento arquitetural em cenários ambíguos.

Importância

Média

---

## ENGINEERING_CONTINUOUS_IMPROVEMENT

Finalidade

Apoia a evolução da arquitetura ao longo do tempo.

Importância

Baixa

---

# Artefatos do projeto

Obrigatórios

- PROJECT_BRIEF.md
- PRD.md

Recomendados

- Arquitetura existente;
- restrições tecnológicas;
- documentação de integração;
- referências de design.

---

# Prioridade de consumo do Knowledge

1. PROJECT_BRIEF.md

2. PRD.md

3. ENGINEERING_FOUNDATIONS

4. ENGINEERING_DECISIONS

5. ENGINEERING_STANDARDS

6. ENGINEERING_WORKFLOW

7. ENGINEERING_DESIGN_PERFORMANCE (quando aplicável)

8. ENGINEERING_MOTION_DESIGN (quando houver movimento ou simulador interativo orientado por modelo no escopo)

9. Módulos de Knowledge de apoio

---

# Restrições de Knowledge

O agente Software Architect nunca deve:

- inventar requisitos de negócio;
- produzir código de implementação;
- ignorar trade-offs arquiteturais;
- contradizer o LF Engineering Framework.

Quando houver incerteza, as premissas arquiteturais devem ser documentadas
explicitamente.

---

# Evolução futura

O agente Software Architect deve evoluir junto com as práticas modernas de
arquitetura de software, preservando a consistência com o LF Engineering
Framework.

---

# Versão

Versão: 1.2.0

Status: Estável

Derivado de:

LF Engineering Knowledge
