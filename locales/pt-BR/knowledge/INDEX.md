# Índice de Knowledge de engenharia LF

## Objetivo

Este documento é o entrypoint do Knowledge de engenharia.

Ele fornece uma visão estruturada de cada módulo de conhecimento, suas
responsabilidades, dependências e consumidores.

Este documento deve ser consultado antes de adicionar, modificar ou consumir
qualquer módulo de Knowledge.

---

# Arquitetura do Knowledge

O LF Engineering Knowledge é organizado em módulos independentes.

Cada módulo representa um domínio específico de engenharia.

Os módulos devem ser consumidos de acordo com as responsabilidades de cada
agente de IA.

O LF Engineering Framework continua sendo a fonte única da verdade.

Os módulos de Knowledge são representações otimizadas do Framework para consumo
por IA.

---

# Fluxo do Knowledge

```text
LF Engineering Framework
        ↓
LF Engineering Knowledge
        ↓
Agentes de engenharia de IA
```

---

# Módulos de Knowledge

| Módulo | Objetivo | Consumidores principais |
| --- | --- | --- |
| ENGINEERING_FOUNDATIONS | Filosofia, missão e princípios de engenharia | Todos os agentes |
| ENGINEERING_WORKFLOW | Ciclo de vida e workflow de desenvolvimento | Todos os agentes |
| ENGINEERING_ARTIFACTS | Artefatos oficiais de engenharia | Product Owner, Design System Analyst, Architect, Documentation |
| ENGINEERING_DECISIONS | Framework de tomada de decisão | Architect, Tech Lead, Knowledge Extractor |
| ENGINEERING_STANDARDS | Padrões de código, arquitetura e engenharia | Architect, Design System Analyst, Reviewer, QA, Knowledge Extractor |
| ENGINEERING_QUALITY | Gates de qualidade, validação e auditorias | QA, Reviewer, Tech Lead, Knowledge Extractor |
| ENGINEERING_DESIGN_PERFORMANCE | Design responsivo, orçamentos web e validação mobile/desktop | Product Owner, Design System Analyst, Architect, Sprint Planner, QA, Tech Lead |
| ENGINEERING_MOTION_DESIGN | Motion design independente de tecnologia, acessibilidade e validação condicional | Product Owner, Design System Analyst, Architect, Sprint Planner, QA, Tech Lead |
| ENGINEERING_AI_COLLABORATION | Modelo de colaboração entre humanos e IA | Todos os agentes |
| ENGINEERING_AGENT_GUIDELINES | Responsabilidades e fronteiras de cada agente | Todos os agentes |
| ENGINEERING_TEMPLATES | Templates oficiais de engenharia | Product Owner, Design System Analyst, Architect, Documentation |
| ENGINEERING_FIELD_GUIDE | Orientação prática de engenharia | Architect, Design System Analyst, Reviewer, Tech Lead, Knowledge Extractor |
| ENGINEERING_CONTINUOUS_IMPROVEMENT | Processo de evolução do conhecimento | Tech Lead, Knowledge Extractor |

---

# Módulos suplementares opcionais aprovados

Estes módulos foram aprovados como referências suplementares opcionais.
Permanecem fora do grafo obrigatório de dependências e são selecionados somente
quando forem relevantes para uma tarefa. A aprovação não autoriza instalar ou
ativar ferramentas externas.

| Módulo | Objetivo | Consumidores previstos |
| --- | --- | --- |
| ENGINEERING_ELEPHANT_GOLDFISH | Colaboração de IA orientada a design, testes independentes de compreensão e recuperação de contexto | Software Architect, Sprint Planner, Code Reviewer, QA, Tech Lead, Documentation |
| ENGINEERING_AGENT_GRAPH_FLOW | Acompanhamento opcional de execução em grafo, gates de tarefas, evidências e medição de custo | Engineering-Manager, Software Architect, Sprint Planner, Implementation / selected CLI, Code Reviewer, QA, Documentation, Tech Lead |
| ENGINEERING_RTK | Filtragem opcional de saída de shell, reescrita de comandos, otimização de contexto e avaliação de tokens | Engineering-Manager, Software Architect, Implementation / selected CLI, Code Reviewer, QA, Documentation, Tech Lead |
| ENGINEERING_GRAPHIFY | Grafo opcional local-first de conhecimento de código, travessia estrutural, proveniência e avaliação de contexto | Software Architect, Sprint Planner, Implementation / selected CLI, Code Reviewer, QA, Documentation, Tech Lead |

---

# Grafo de dependências

ENGINEERING_FOUNDATIONS

↓

ENGINEERING_WORKFLOW

↓

ENGINEERING_ARTIFACTS

↓

ENGINEERING_DECISIONS

↓

ENGINEERING_STANDARDS

↓

ENGINEERING_QUALITY

↓

ENGINEERING_DESIGN_PERFORMANCE (condicional para projetos web e visuais)

↓

ENGINEERING_AI_COLLABORATION

↓

ENGINEERING_AGENT_GUIDELINES

↓

ENGINEERING_TEMPLATES

↓

ENGINEERING_FIELD_GUIDE

↓

ENGINEERING_CONTINUOUS_IMPROVEMENT

---

# Módulo condicional (fora do fluxo de dependências)

`ENGINEERING_MOTION_DESIGN` é carregado somente quando houver movimento no
escopo. Ele não adiciona dependência ao fluxo obrigatório de Knowledge nem uma
fase de workflow.

---

# Princípios do Knowledge

* O Framework é a única fonte da verdade.
* Os módulos de Knowledge derivam do Framework.
* Os módulos não devem duplicar informação.
* Cada módulo tem uma única responsabilidade.
* O Knowledge é otimizado para consumo por IA.
* Explicações legíveis por humanos pertencem ao Framework.

---

# Versão

Baseline publicada do Framework: 1.5.0

Status do checkout: corresponde à primeira release pública `v1.5.0`; o histórico
do repositório privado predecessor e suas tags anteriores não foram migrados.

Responsável: Leandro Fernandes

Framework: LF Engineering Framework
