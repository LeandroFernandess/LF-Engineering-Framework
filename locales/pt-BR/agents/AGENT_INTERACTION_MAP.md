# Mapa de interação entre agentes

Versão: 1.2.0

Status: Estável

---

# Objetivo

Este documento define como os agentes de IA do LF Engineering System interagem
entre si ao longo do ciclo de vida de desenvolvimento de software.

Ele fornece uma visão sistêmica das responsabilidades, handoffs, fluxo de
artefatos e pontos de decisão entre agentes especializados.

Este documento não define a configuração individual dos agentes.

A configuração individual pertence ao diretório de cada agente.

---

# Pipeline de agentes

```text
Ideia bruta
    │
    ▼
Agente Engineering Manager
    │
    ▼
Orchestrator
    │
    ▼
Agente Prompt Architect (condicional: contexto bruto, ambíguo ou incompleto)
    │
    ▼
Agente Product Owner
    │
    ▼
Agente Design System Analyst (quando houver referências ou solicitação explícita de direção inicial)
    │
    ▼
Agente Software Architect
    │
    ▼
Agente Sprint Planner
    │
    ▼
Checkpoint de aprovação do plano
    │
    ▼
Implementation / selected CLI
    │
    ▼
Agente Code Reviewer
    │
    ▼
Agente Quality Assurance & Security
    │
    ▼
Agente Documentation & Technical Writer
    │
    ▼
Agente Tech Lead
    │
    ▼
Agente Engineering Knowledge Extractor
    │
    ▼
Entrega
```

---

# Camadas de engenharia

| Camada | Agentes | Objetivo |
| --- | --- | --- |
| Intake | Engineering Manager Agent, Orchestrator | Classificar a demanda, selecionar o workflow e estabelecer fronteiras de handoff. |
| Descoberta | Prompt Architect Agent, Product Owner Agent | Transformar ideias em requisitos de produto estruturados. |
| Engenharia | Design System Analyst Agent, Software Architect Agent, Sprint Planner Agent | Transformar requisitos em documentação de design, arquitetura técnica e planos de execução. |
| Execução | Implementation / selected CLI | Transformar planos aprovados em software. |
| Governança | Code Reviewer Agent, QA & Security Agent, Documentation Agent, Tech Lead Agent | Validar, auditar, documentar e aprovar o progresso de engenharia. |
| Evolução | Engineering Knowledge Extractor Agent | Extrair conhecimento de engenharia reutilizável de projetos concluídos. |

---

# Responsabilidades dos agentes

| Agent | Verbo principal | Responsabilidade central |
| --- | --- | --- |
| Prompt Architect Agent | Refinar | Transformar ideias brutas em contexto de engenharia estruturado. |
| Product Owner Agent | Definir | Transformar necessidades de negócio em PRD e requisitos de produto. |
| Design System Analyst Agent | Analisar | Transformar referências visuais em documentação de engenharia estruturada. |
| Software Architect Agent | Projetar | Transformar requisitos em arquitetura técnica. |
| Sprint Planner Agent | Planejar | Transformar arquitetura em sprints executáveis. |
| Implementation / selected CLI | Construir | Implementar o escopo aprovado da Sprint. |
| Code Reviewer Agent | Validar | Revisar correção e manutenibilidade da implementação. |
| QA & Security Agent | Verificar | Auditar segurança, performance, qualidade e prontidão para produção. |
| Documentation Agent | Preservar | Manter a documentação sincronizada com a implementação. |
| Tech Lead Agent | Governar | Consolidar evidências e aprovar ou bloquear a progressão. |
| Engineering Knowledge Extractor Agent | Extrair | Extrair conhecimento reutilizável de engenharia de projetos concluídos. |

---

# Fluxo de artefatos

| Artefato | Produzido por | Consumido por |
| --- | --- | --- |
| Prompt refinado | Prompt Architect Agent | Product Owner Agent, Design System Analyst Agent, Software Architect Agent |
| PROJECT_BRIEF.md | Prompt Architect Agent | Product Owner Agent, Design System Analyst Agent, Software Architect Agent, Sprint Planner Agent |
| PRD.md | Product Owner Agent | Design System Analyst Agent, Software Architect Agent, Sprint Planner Agent, Code Reviewer Agent, QA & Security Agent |
| DESIGN.md | Design System Analyst Agent | Software Architect Agent, Sprint Planner Agent, Code Reviewer Agent |
| ARCHITECTURE.md | Software Architect Agent | Sprint Planner Agent, Code Reviewer Agent, QA & Security Agent, Documentation Agent |
| SPRINTS.md | Sprint Planner Agent | Implementation / selected CLI, Code Reviewer Agent, Tech Lead Agent |
| Código-fonte | Implementation / selected CLI | Code Reviewer Agent, QA & Security Agent, Documentation Agent, Tech Lead Agent |
| REVIEW.md | Code Reviewer Agent | QA & Security Agent, Tech Lead Agent |
| QA_SECURITY_REPORT.md | QA & Security Agent | Documentation Agent, Tech Lead Agent |
| PERFORMANCE_VALIDATION_REPORT.md (condicional) | QA & Security Agent | Documentation Agent, Tech Lead Agent |
| Auditoria de documentação | Documentation Agent | Tech Lead Agent |
| Relatório de governança | Tech Lead Agent | Engineering Knowledge Extractor Agent, Sprints futuras |
| PROJECT_KNOWLEDGE.md | Engineering Knowledge Extractor Agent | Tech Lead Agent, Mantenedor do Framework, projetos futuros |

---

# Regras de handoff

## Prompt Architect → Product Owner

O agente Prompt Architect deve fornecer contexto estruturado suficiente para que
o Product Owner Agent defina os requisitos do produto.

Handoff esperado:

* Prompt refinado
* PROJECT_BRIEF.md
* Premissas
* Informações ausentes
* Restrições

---

## Product Owner → Software Architect

O Product Owner Agent deve fornecer um PRD que defina claramente o que deve ser
construído.

Handoff esperado:

* PRD.md
* requisitos funcionais;
* requisitos não funcionais;
* critérios de aceite;
* escopo do produto;
* roadmap;
* rotas críticas, perfis-alvo e requisitos de experiência quando o projeto tiver
  interface web ou visual.

---

## Product Owner → Design System Analyst (condicional)

O Product Owner Agent deve fornecer contexto de produto que informe a análise de
design.

Handoff esperado:

* PRD.md;
* escopo do produto;
* requisitos funcionais que afetam a UI;
* personas de usuário (quando disponíveis).
* solicitação explícita e expectativas de aprovação para uma proposta sem
  referências;
* fontes existentes de design system/tokens, quando disponíveis.

Este handoff ocorre quando referências visuais exigem análise ou quando o
usuário/Product Owner solicita explicitamente uma direção inicial sem referências
para um produto visual. Este último caso é opcional e deve permanecer como
proposta até aprovação.

---

## Design System Analyst → Software Architect

O agente Design System Analyst deve fornecer documentação de design estruturada
que possa ser consumida pelo Software Architect.

Handoff esperado:

* DESIGN.md;
* especificação da paleta de cores;
* análise de tipografia;
* hierarquia de componentes;
* documentação de padrões de interação;
* tokens de design;
* considerações de acessibilidade;
* estados responsivos, contratos de assets/fontes e elementos LCP candidatos
  quando o projeto tiver interface web ou visual;
* considerações de implementação frontend.

Quando não existirem referências visuais nem solicitação explícita de direção
inicial, este handoff é ignorado e o Product Owner faz handoff diretamente para o
Software Architect.

---

## Software Architect → Sprint Planner

O agente Software Architect deve fornecer uma arquitetura técnica que possa ser
convertida em etapas de execução.

Handoff esperado:

* ARCHITECTURE.md;
* definições de componentes;
* estrutura de diretórios;
* decisões técnicas;
* riscos;
* trade-offs;
* estratégia de renderização/entrega, orçamentos de performance e plano de
  medição quando o projeto tiver interface web ou visual.

---

## Sprint Planner → Implementation / selected CLI

O agente Sprint Planner deve fornecer documentação de Sprint executável.

Handoff esperado:

* SPRINTS.md;
* escopo;
* entregáveis;
* arquivos esperados;
* critérios de aceite;
* fora de escopo;
* checklist de validação;
* baseline de performance e tarefas de validação mobile/desktop quando aplicável.

---

## Implementation / selected CLI → Code Reviewer

A implementação deve ser revisada em relação ao escopo aprovado da Sprint.

Handoff esperado:

* mudanças de código;
* resumo do resultado da Sprint;
* arquivos modificados;
* limitações conhecidas;
* observações da implementação.

---

## Code Reviewer → QA & Security

O agente Code Reviewer deve fornecer uma revisão técnica que apoie a validação
mais profunda de qualidade.

Handoff esperado:

* REVIEW.md;
* achados;
* classificação de severidade;
* riscos técnicos;
* recomendações de correção;
* observações de regressão sensível a performance quando aplicável.

---

## QA & Security → Documentation

O agente QA & Security deve fornecer achados de qualidade que possam afetar a
documentação.

Handoff esperado:

* relatório de QA;
* achados de segurança;
* achados de performance;
* `PERFORMANCE_VALIDATION_REPORT.md` quando aplicável;
* avaliação de prontidão para produção;
* atualizações de documentação necessárias.

---

## Documentation → Tech Lead

O agente Documentation deve confirmar se a documentação do projeto está
sincronizada com a implementação atual.

Handoff esperado:

* auditoria de documentação;
* recomendações de documentação atualizadas;
* documentação ausente;
* sugestões de CHANGELOG;
* recomendações de ADR.

---

## Tech Lead → Engineering Knowledge Extractor

O agente Tech Lead deve fornecer o contexto completo do projeto para extração de
conhecimento.

Handoff esperado:

* relatório de governança;
* todos os artefatos do projeto (PRD, DESIGN, ARCHITECTURE, SPRINTS);
* código-fonte;
* REVIEW.md;
* relatório de QA;
* `PERFORMANCE_VALIDATION_REPORT.md` quando aplicável;
* auditoria de documentação;
* CHANGELOG;
* ADRs.

---

## Engineering Knowledge Extractor → Evolução do Framework

O agente Engineering Knowledge Extractor produz conhecimento acionável para a
melhoria do Framework.

Handoff esperado:

* PROJECT_KNOWLEDGE.md;
* resumo da stack técnica;
* novo conhecimento de engenharia identificado;
* melhorias sugeridas para o Framework;
* recomendações priorizadas.

Todas as recomendações exigem revisão humana antes que mudanças no Framework
sejam aplicadas.

---

## Tech Lead → Entrega ou correção

O agente Tech Lead consolida todas as evidências e decide se o projeto pode
prosseguir.

Resultados possíveis:

* Aprovado
* Bloqueado

Nenhum status final intermediário deve ser usado.

---

# Pontos de decisão

| Ponto de decisão | Agente responsável | Resultado possível |
| --- | --- | --- |
| Contexto pronto para PRD | Prompt Architect Agent | Prosseguir / Solicitar esclarecimento |
| PRD pronto para arquitetura | Product Owner Agent | Prosseguir / Refinar requisitos |
| Existem referências ou uma direção inicial foi solicitada explicitamente | Design System Analyst Agent | Prosseguir / Ignorar (nenhuma condição se aplica) |
| Design pronto para arquitetura | Design System Analyst Agent | Prosseguir / Solicitar esclarecimento ou aprovação |
| Arquitetura pronta para planejamento | Software Architect Agent | Prosseguir / Resolver lacunas técnicas |
| Sprint pronta para implementação | Sprint Planner Agent | Prosseguir / Ajustar escopo da Sprint |
| Implementação pronta para QA | Code Reviewer Agent | Aprovado / Requer correção |
| Sprint pronta para governança | QA & Security Agent | Aprovado / Requer ajuste |
| Documentação sincronizada | Documentation Agent | Atualizada / Requer atualização |
| Projeto pode prosseguir | Tech Lead Agent | Aprovado / Bloqueado |
| Extração de conhecimento concluída | Engineering Knowledge Extractor Agent | Pronta para revisão / Artefatos insuficientes |

---

# Modelo de governança

O agente Tech Lead é a autoridade técnica final dentro do workflow de agentes.

Entretanto, o Tech Lead Agent não substitui os agentes especializados.

Ele consolida evidências produzidas por:

* Product Owner Agent;
* Software Architect Agent;
* Sprint Planner Agent;
* Code Reviewer Agent;
* QA & Security Agent;
* Documentation Agent.

Uma Sprint só deve avançar quando o Tech Lead Agent emitir uma aprovação
explícita.

---

# Resolução de conflitos

Quando as saídas dos agentes entrarem em conflito:

1. Preserve o LF Engineering Framework.
2. Priorize os artefatos aprovados do projeto.
3. Siga as prioridades de decisão de engenharia.
4. Escalone para o Tech Lead Agent.
5. Documente a decisão final quando relevante.

---

# Relação com o Knowledge

Os agentes não são proprietários do conhecimento de engenharia.

Os agentes consomem módulos de Knowledge do diretório `knowledge/`.

Cada agente declara os módulos de Knowledge necessários em seu próprio
`KNOWLEDGE.md`.

O `AGENT_INTERACTION_MAP.md` descreve a interação.

Ele não duplica regras do Knowledge.

---

# Diretrizes de expansão

Novos agentes podem ser adicionados quando uma nova especialização se tornar
necessária.

Antes de criar um novo agente, verifique:

* a responsabilidade não está coberta;
* o agente tem um verbo principal claro;
* o agente produz ou valida um artefato específico;
* o agente pode ser integrado ao workflow existente;
* o agente consome módulos de Knowledge existentes;
* o agente pode ser condicional (executa somente quando determinadas entradas
  existirem).

O Design System Analyst Agent e o Engineering Knowledge Extractor Agent são
exemplos de expansão adequada: cada um tem um verbo principal único (Analyze,
Extract), produz um artefato principal único (DESIGN.md,
PROJECT_KNOWLEDGE.md) e se integra de forma limpa ao pipeline existente sem
sobrepor responsabilidades.

---

# Declaração final

Os agentes de engenharia LF operam como um sistema de engenharia coordenado.

Cada agente tem uma responsabilidade principal, uma posição clara no workflow e
uma contribuição específica para a qualidade do software.

O valor do sistema vem da interação entre papéis especializados, não de um único
agente operando sozinho.

O sistema foi projetado para evoluir. Novos agentes podem ser adicionados quando
novas especializações se tornarem necessárias, desde que preservem os princípios
arquiteturais que definem o ecossistema.
