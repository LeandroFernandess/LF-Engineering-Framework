# Knowledge do agente Sprint Planner

Versão: 1.2.0

Status: Estável

---

# Objetivo

Este documento define os módulos de Knowledge consumidos pelo agente Sprint
Planner.

O agente é especializado em planejamento de execução, organização de backlog e
decomposição de Sprints.

Sua responsabilidade é transformar arquitetura em um roadmap de engenharia
executável.

---

# Filosofia de Knowledge

Boa execução começa com bom planejamento.

A implementação deve seguir uma sequência lógica de entregáveis pequenos,
independentes e verificáveis.

O agente Sprint Planner organiza a execução de engenharia.

Ele não redesenha decisões de engenharia.

---

# Módulos obrigatórios

## ENGINEERING_FOUNDATIONS

Importância

Crítica

Finalidade

Define a filosofia de engenharia que orienta o planejamento da execução.

---

## ENGINEERING_WORKFLOW

Importância

Crítica

Finalidade

Define como o Planejamento de Sprint se integra ao ciclo de vida de engenharia de
software.

---

## ENGINEERING_ARTIFACTS

Importância

Crítica

Finalidade

Define a documentação da Sprint e os artefatos de implementação.

---

## ENGINEERING_DECISIONS

Importância

Alta

Finalidade

Apoia decisões de planejamento envolvendo sequência de implementação e análise
de dependências.

---

## ENGINEERING_STANDARDS

Importância

Alta

Finalidade

Define consistência de planejamento, padrões de documentação e organização da
engenharia.

---

## ENGINEERING_AGENT_GUIDELINES

Importância

Alta

Finalidade

Define a colaboração com os agentes Software Architect, Product Owner e Code
Reviewer.

---

## ENGINEERING_DESIGN_PERFORMANCE

Finalidade

Fornece cobertura de rota/perfil, orçamento, baseline e orientação de aceite para
tarefas de performance em projetos web e visuais.

Importância

Alta quando aplicável.

---

## ENGINEERING_MOTION_DESIGN

Finalidade

Fornece orientação condicional para tarefas e evidências de aceite de
comportamento de movimento, alternativas para movimento reduzido e validação
visual representativa.

Importância

Alta quando houver movimento no escopo; caso contrário, não aplicável.

---

# Módulos opcionais

## ENGINEERING_QUALITY

Finalidade

Apoia o planejamento da validação de qualidade antes da implementação.

Importância

Média

---

## ENGINEERING_TEMPLATES

Finalidade

Fornece templates padronizados de documentação de Sprint.

Importância

Média

---

## ENGINEERING_FIELD_GUIDE

Finalidade

Apoia decisões de planejamento sob incerteza.

Importância

Média

---

## ENGINEERING_CONTINUOUS_IMPROVEMENT

Finalidade

Melhora a metodologia de planejamento de Sprint ao longo do tempo.

Importância

Baixa

---

# Artefatos do projeto

Obrigatórios

* PROJECT_BRIEF.md
* PRD.md
* ARCHITECTURE.md

Recomendados

* backlog existente;
* relatórios de Sprints anteriores;
* restrições técnicas;
* prioridades de engenharia.

---

# Prioridade de consumo do Knowledge

1. PROJECT_BRIEF.md

2. PRD.md

3. ARCHITECTURE.md

4. ENGINEERING_FOUNDATIONS

5. ENGINEERING_WORKFLOW

6. ENGINEERING_ARTIFACTS

7. ENGINEERING_DESIGN_PERFORMANCE (quando aplicável)

8. ENGINEERING_MOTION_DESIGN (quando houver movimento no escopo)

9. Módulos de Knowledge de apoio

---

# Restrições de Knowledge

O agente Sprint Planner nunca deve:

* modificar requisitos de negócio;
* redesenhar a arquitetura;
* inventar detalhes de implementação;
* ignorar dependências de engenharia.

Quando existirem premissas de planejamento, elas devem ser sempre documentadas
explicitamente.

---

# Evolução futura

O agente Sprint Planner deve evoluir junto com as práticas ágeis de engenharia,
preservando a consistência com o LF Engineering Framework.

---

# Versão

Versão: 1.2.0

Status: Estável

Derivado de:

LF Engineering Knowledge
