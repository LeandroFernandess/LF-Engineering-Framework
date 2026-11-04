# Knowledge do agente Prompt Architect

Versão: 1.0.0

Status: Estável

---

# Objetivo

Este documento define os módulos de Knowledge consumidos pelo agente Prompt
Architect.

O agente é especializado em engenharia de contexto e refinamento de prompts.

Sua responsabilidade é preparar contexto de engenharia completo antes do início
da definição do produto.

---

# Filosofia de Knowledge

Contexto claro produz engenharia melhor.

Toda atividade de engenharia depende de informação estruturada, não de premissas.

O agente Prompt Architect prepara o contexto.

Ele não cria decisões de engenharia.

---

# Módulos obrigatórios

## ENGINEERING_FOUNDATIONS

Importância

Crítica

Finalidade

Define a filosofia de engenharia.

---

## ENGINEERING_WORKFLOW

Importância

Crítica

Finalidade

Define onde a Engenharia de Contexto se encaixa no ciclo de vida do software.

---

## ENGINEERING_ARTIFACTS

Importância

Crítica

Finalidade

Define PROJECT_BRIEF.md e os demais artefatos de engenharia gerados depois do
refinamento do prompt.

---

## ENGINEERING_STANDARDS

Importância

Alta

Finalidade

Define organização da documentação e consistência de engenharia.

---

## ENGINEERING_AGENT_GUIDELINES

Importância

Alta

Finalidade

Define a colaboração com os agentes Product Owner e Software Architect.

---

# Módulos opcionais

## ENGINEERING_TEMPLATES

Finalidade

Fornece templates para refinamento de prompts e geração do PROJECT_BRIEF.

Importância

Média

---

## ENGINEERING_DECISIONS

Finalidade

Apoia a documentação de trade-offs quando existem várias interpretações.

Importância

Média

---

## ENGINEERING_FIELD_GUIDE

Finalidade

Apoia situações de contexto ambíguo.

Importância

Média

---

## ENGINEERING_CONTINUOUS_IMPROVEMENT

Finalidade

Melhora a metodologia de refinamento de prompts ao longo do tempo.

Importância

Baixa

---

# Artefatos do projeto

Prioridade

Obrigatória

- Descrição inicial do projeto

Recomendados

- notas existentes;
- referências de design;
- stack técnica;
- requisitos do usuário;
- documentação existente.

---

# Prioridade de consumo do Knowledge

1. Contexto de negócio

2. Descrição inicial do projeto

3. ENGINEERING_FOUNDATIONS

4. ENGINEERING_WORKFLOW

5. ENGINEERING_ARTIFACTS

6. ENGINEERING_STANDARDS

7. Módulos de Knowledge de apoio

---

# Restrições de Knowledge

O agente Prompt Architect nunca deve:

- inventar requisitos de negócio;
- produzir arquitetura;
- produzir implementação;
- ignorar contexto ausente.

Quando existirem premissas, elas devem ser sempre documentadas explicitamente.

---

# Evolução futura

O agente Prompt Architect deve evoluir junto com as boas práticas de engenharia
de prompts, mantendo-se alinhado ao LF Engineering Framework.

---

# Versão

Versão: 1.0.0

Status: Estável

Derivado de:

LF Engineering Knowledge
