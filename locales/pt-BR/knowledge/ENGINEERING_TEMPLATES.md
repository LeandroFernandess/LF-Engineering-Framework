# Templates de engenharia

Versão: 0.2.0
Status: Rascunho
Categoria: Operacional

---

# Objetivo

Este módulo define a estratégia oficial de templates adotada pelo LF
Engineering System.

Seu objetivo é padronizar artefatos de engenharia reutilizáveis, garantindo
consistência entre os projetos.

Os templates aceleram a engenharia sem reduzir a qualidade.

---

# Escopo

Define:

- filosofia de templates;
- ciclo de vida dos templates;
- categorias oficiais de templates;
- regras de uso;
- responsabilidade.

---

# Consumidores

Principais:

- Prompt Architect Agent
- Product Owner Agent
- Software Architect Agent
- Sprint Planner Agent
- Documentation Agent

Secundário:

- Tech Lead Agent

---

# Dependências

Obrigatórias:

- ENGINEERING_FOUNDATIONS
- ENGINEERING_ARTIFACTS
- ENGINEERING_WORKFLOW

Relacionada:

- ENGINEERING_STANDARDS

---

# Fonte

Derivado de:

LF Engineering Framework 1.3.0; manutenção pós-tag

---

## Histórico de versões

- `0.2.0` — 2026-11-01: Adicionado o template opcional de relatório de auditoria
  de dívida técnica e esclarecido que ele não é criado por padrão.

Seções:

- Artefatos de engenharia
- Workflow
- Padrões de documentação

---

# Responsabilidades

Este módulo define:

- quais templates são considerados oficiais;
- como os templates evoluem;
- como os templates devem ser aplicados;
- a responsabilidade pelos templates.

---

# Filosofia de templates

Os templates existem para:

- padronizar artefatos de engenharia;
- reduzir trabalho repetitivo;
- preservar a consistência;
- melhorar a manutenibilidade.

Os templates devem acelerar a engenharia, permanecendo adaptáveis ao contexto do
projeto.

---

# Categorias oficiais de templates

## Templates de projeto

Exemplos:

- Brief do projeto
- PRD
- Arquitetura
- Planejamento de sprint

---

## Templates de documentação

Exemplos:

- README
- CHANGELOG
- Notas de release
- ADR

---

## Templates de revisão

Exemplos:

- Code Review
- Relatório de QA
- Revisão de segurança
- Relatório de validação de performance (condicional para projetos web e
  visuais)
- Relatório de auditoria de dívida técnica (somente quando solicitado
  explicitamente ou incluído em manutenção aprovada; não é criado por padrão)

---

## Templates de planejamento

Exemplos:

- Planejamento de sprint
- Backlog
- Roadmap

---

## Templates de prompt

Exemplos:

- Refinamento de prompt
- Criação de contexto
- Instruções de IA

---

# Regras de templates

Todo template de plano executável deve incluir:

* objetivo e resultado visível para o usuário;
* requisitos de origem e premissas;
* arquivos afetados ou estratégia de descoberta de arquivos;
* critérios de aceite e comandos de validação;
* dependências, riscos e não objetivos explícitos;
* responsável pelo handoff e evidência de conclusão.

Valores desconhecidos devem ser marcados como questões abertas ou deixados como
campos vazios intencionais. Templates não devem usar `TBD` como estado
operacional que possa ser confundido com planejamento concluído.

Regra 01

Artefatos oficiais de engenharia devem usar templates aprovados sempre que
existirem.

Tipo

Obrigatória

Prioridade

Alta

---

Regra 02

Templates fornecem estrutura, não conteúdo obrigatório.

Tipo

Obrigatória

Prioridade

Alta

---

Regra 03

Templates podem evoluir independentemente dos projetos.

Tipo

Recomendada

Prioridade

Média

---

Regra 04

Adaptações específicas do projeto são permitidas quando justificadas.

Tipo

Contextual

Prioridade

Média

---

# Ciclo de vida do template

Criar

↓

Revisar

↓

Aprovar

↓

Publicar

↓

Usar

↓

Melhorar

↓

Versionar

---

# Boas práticas

- Mantenha os templates simples.
- Minimize seções duplicadas.
- Preserve nomenclatura consistente.
- Versione templates importantes.
- Revise os templates periodicamente.

---

# Antipadrões

Evite:

- templates específicos de projeto se tornando oficiais;
- templates excessivamente complexos;
- templates duplicados;
- templates desatualizados;
- campos obrigatórios sem finalidade.

---

# Matriz de decisão

| Situação | Ação recomendada |
| --- | --- |
| Novo artefato de engenharia | Usar um template oficial |
| Template ausente | Criar e validar antes da adoção |
| Template existente insuficiente | Estender preservando a compatibilidade |
| Template duplicado | Consolidar em uma versão |
| Melhoria significativa | Publicar nova versão do template |

---

# Módulos relacionados

ENGINEERING_ARTIFACTS

ENGINEERING_STANDARDS

ENGINEERING_WORKFLOW

ENGINEERING_CONTINUOUS_IMPROVEMENT

---

# Versionamento

Versão: 0.2.0

Status: Rascunho

Derivado de:

LF Engineering Framework 1.3.0; manutenção pós-tag
