# Knowledge do agente Tech Lead

Versão: 1.3.0

Status: Estável

---

# Objetivo

Este documento define os módulos de Knowledge consumidos pelo agente Tech Lead.

O agente é especializado em governança de engenharia, tomada de decisões
estratégicas e consolidação técnica.

Sua responsabilidade é avaliar o ecossistema de engenharia como um todo antes de
aprovar a progressão do projeto.

---

# Filosofia de Knowledge

Liderança de engenharia exige pensamento sistêmico.

Toda aprovação deve considerar o contexto completo de engenharia, não achados
técnicos isolados.

O agente Tech Lead governa a engenharia.

Ele não substitui a expertise especializada.

---

# Módulos obrigatórios

## ENGINEERING_FOUNDATIONS

Importância

Crítica

Finalidade

Define a filosofia de engenharia que orienta decisões de governança.

---

## ENGINEERING_DECISIONS

Importância

Crítica

Finalidade

Fornece metodologia de tomada de decisão e análise de trade-offs de engenharia.

---

## ENGINEERING_QUALITY

Importância

Crítica

Finalidade

Define gates de qualidade de engenharia e critérios de prontidão para produção.

---

## ENGINEERING_DESIGN_PERFORMANCE

Finalidade

Define aceite de performance mobile/desktop, cobertura de rotas, orçamentos,
acessibilidade e limitações de evidência de campo para decisões de governança.

Importância

Alta quando o projeto tem interface web ou visual; caso contrário, condicional.

---

## ENGINEERING_MOTION_DESIGN

Finalidade

Define expectativas condicionais de aceite de movimento e evidências, além de
fidelidade do simulador, validação do modelo e riscos residuais para governança.

Importância

Alta quando houver movimento ou simulador interativo orientado por modelo no
escopo; caso contrário, não aplicável.

---

## ENGINEERING_WORKFLOW

Importância

Crítica

Finalidade

Define o ciclo completo de engenharia e os checkpoints de governança.

---

## ENGINEERING_ARTIFACTS

Importância

Alta

Finalidade

Define os artefatos de engenharia avaliados durante a governança.

---

## ENGINEERING_AGENT_GUIDELINES

Importância

Alta

Finalidade

Define a colaboração com todos os agentes especializados do LF Engineering
System.

---

# Módulos opcionais

## ENGINEERING_STANDARDS

Finalidade

Apoia a validação da consistência entre os artefatos de engenharia.

Importância

Média

---

## ENGINEERING_CONTINUOUS_IMPROVEMENT

Finalidade

Apoia a evolução de engenharia de longo prazo.

Importância

Média

---

## ENGINEERING_FIELD_GUIDE

Finalidade

Apoia o julgamento de engenharia em cenários complexos de governança.

Importância

Média

---

## ENGINEERING_TEMPLATES

Finalidade

Apoia relatórios de governança padronizados.

Importância

Baixa

---

# Artefatos do projeto

Obrigatórios

* PROJECT_BRIEF.md
* PRD.md
* ARCHITECTURE.md
* `docs/SPRINTS.md`
* REVIEW.md
* Relatório de QA
* Relatório de documentação
* `PERFORMANCE_VALIDATION_REPORT.md` quando existir interface web ou visual

Recomendados

* CHANGELOG.md
* código-fonte
* notas técnicas
* ADRs
* `docs/TECH_DEBT_AUDIT.md` quando uma auditoria for solicitada explicitamente
  ou aprovada

---

# Prioridade de consumo do Knowledge

1. Artefatos de engenharia
2. ENGINEERING_FOUNDATIONS
3. ENGINEERING_DECISIONS
4. ENGINEERING_QUALITY
5. ENGINEERING_WORKFLOW
6. ENGINEERING_DESIGN_PERFORMANCE (quando aplicável)
7. ENGINEERING_MOTION_DESIGN (quando houver movimento ou simulador interativo orientado por modelo no escopo)
8. Módulos de Knowledge de apoio

---

# Restrições de Knowledge

O agente Tech Lead nunca deve:

* ignorar riscos críticos de engenharia;
* substituir evidências técnicas especializadas sem justificativa;
* modificar o escopo de negócio;
* produzir implementação.
* tratar achados opcionais de dívida técnica como defeitos ou bloqueios
  automáticos de entrega; avaliar explicitamente evidência, impacto e prioridade.

Quando as evidências de governança forem insuficientes, a progressão do projeto
deve ser adiada até que a validação adicional seja concluída.

---

# Evolução futura

O agente Tech Lead deve evoluir junto com as práticas de governança de engenharia,
preservando a consistência com o LF Engineering Framework.

---

# Versão

Versão: 1.3.0

Status: Estável

Derivado de:

LF Engineering Knowledge
