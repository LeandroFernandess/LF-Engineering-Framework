# Knowledge do agente Documentation & Technical Writer

Versão: 1.0.0

Status: Estável

---

# Objetivo

Este documento define os módulos de Knowledge consumidos pelo agente
Documentation & Technical Writer.

O agente é responsável por preservar a consistência do conhecimento de
engenharia em todo o LF Engineering System.

Ele consome módulos oficiais de Knowledge para garantir que todo artefato de
engenharia reflita com precisão o sistema implementado.

O agente nunca cria princípios de engenharia.

Ele os documenta e sincroniza.

---

# Filosofia de Knowledge

Documentação é um artefato de engenharia.

O conhecimento deve permanecer:

* preciso;
* consistente;
* atual;
* rastreável;
* acessível.

O agente Documentation preserva o conhecimento.

Ele não o redefine.

---

# Módulos obrigatórios

## ENGINEERING_FOUNDATIONS

Finalidade

Fornece a filosofia de engenharia que orienta todas as atividades de
documentação.

Importância

Crítica

---

## ENGINEERING_WORKFLOW

Finalidade

Fornece conhecimento do ciclo de vida de engenharia, garantindo que a
documentação permaneça sincronizada em todas as fases do projeto.

Importância

Crítica

---

## ENGINEERING_ARTIFACTS

Finalidade

Define os artefatos oficiais de engenharia mantidos pelo agente Documentation.

Importância

Crítica

---

## ENGINEERING_STANDARDS

Finalidade

Fornece padrões de documentação, convenções de nomenclatura e princípios de
organização.

Importância

Crítica

---

## ENGINEERING_TEMPLATES

Finalidade

Define os templates oficiais de documentação adotados pelo LF Engineering
System.

Importância

Crítica

---

## ENGINEERING_AGENT_GUIDELINES

Finalidade

Define como o agente Documentation colabora com os demais agentes especializados.

Importância

Alta

---

# Módulos opcionais

## ENGINEERING_QUALITY

Finalidade

Apoia a validação da qualidade da documentação e da prontidão de engenharia.

Importância

Média

---

## ENGINEERING_DECISIONS

Finalidade

Fornece contexto para documentar decisões arquiteturais e de engenharia.

Importância

Média

---

## ENGINEERING_CONTINUOUS_IMPROVEMENT

Finalidade

Apoia a evolução da documentação e as melhorias no conhecimento de engenharia.

Importância

Média

---

## ENGINEERING_FIELD_GUIDE

Finalidade

Auxilia atividades de documentação que envolvem ambiguidade ou cenários
excepcionais de engenharia.

Importância

Baixa

---

# Artefatos do projeto

Quando disponíveis, o agente Documentation deve priorizar:

Obrigatórios

* PROJECT_BRIEF.md
* PRD.md
* ARCHITECTURE.md
* README.md

Recomendados

* CHANGELOG.md
* ADRs
* documentação da Sprint
* relatórios de revisão
* documentação da API
* documentação do banco de dados
* estrutura de diretórios do projeto

---

# Prioridade de consumo do Knowledge

Ordem recomendada:

1. Artefatos do projeto
2. ENGINEERING_FOUNDATIONS
3. ENGINEERING_WORKFLOW
4. ENGINEERING_ARTIFACTS
5. ENGINEERING_STANDARDS
6. ENGINEERING_TEMPLATES
7. Módulos de Knowledge de apoio

A documentação do projeto sempre prevalece ao descrever a implementação atual.

O LF Engineering Framework permanece como fonte autorizada quando existirem
inconsistências.

---

# Restrições de Knowledge

O agente Documentation nunca deve:

* inventar funcionalidades não documentadas;
* modificar princípios de engenharia aprovados;
* contradizer o LF Engineering Framework;
* ignorar artefatos do projeto;
* produzir documentação sem suporte na implementação.

Quando inconsistências forem identificadas, elas devem ser reportadas, não
corrigidas silenciosamente.

---

# Evolução futura

Conforme o LF Engineering System evoluir, módulos adicionais de Knowledge podem
ser incorporados quando melhorarem a qualidade da documentação sem introduzir
complexidade desnecessária.

---

# Versão

Versão: 1.0.0

Status: Estável

Derivado de:

LF Engineering Knowledge
