# Workflow de engenharia

Versão: 0.3.0
Status: Rascunho
Responsável: Leandro Fernandes

---

# Objetivo

Este módulo define o workflow oficial de engenharia adotado pelo LF Engineering
System.

Seu objetivo é padronizar como os projetos evoluem de uma ideia inicial até um
produto de software concluído e documentado.

Este módulo define somente o processo.

Detalhes de implementação pertencem a outros módulos de Knowledge.

---

# Escopo

Este módulo define:

* ciclo de vida de engenharia;
* fases de desenvolvimento;
* transições entre fases;
* entradas e saídas;
* fluxo de entrega.

---

# Consumidores

Consumidores principais:

* Prompt Architect Agent
* Product Owner Agent
* Sprint Planner Agent
* Documentation Agent
* Tech Lead Agent

Consumidores secundários:

* Software Architect Agent
* Code Reviewer Agent
* QA & Security Agent

---

# Dependências

Obrigatória:

* ENGINEERING_FOUNDATIONS

Relacionadas:

* ENGINEERING_ARTIFACTS
* ENGINEERING_TEMPLATES
* ENGINEERING_QUALITY

---

# Fonte

Derivado de:

LF Engineering Framework

Seções:

* Workflow
* Processo de sprint
* Ciclo de vida de engenharia

---

# Responsabilidades

Este módulo define:

* o ciclo de vida oficial de desenvolvimento;
* como os artefatos de engenharia evoluem;
* quando um projeto avança para a próxima fase.

---

# Ciclo de vida de engenharia

Todo projeto segue o mesmo ciclo de vida:

1. Descoberta
2. Refinamento
3. Planejamento
4. Arquitetura
5. Planejamento de sprint
6. Implementação
7. Revisão de código
8. Garantia de qualidade
9. Documentação
10. Aprovação técnica
11. Entrega
12. Melhoria contínua

Projetos não devem ignorar fases do ciclo de vida sem justificativa técnica
explícita.

---

# Descrição das fases

## Descoberta

Objetivo:

Entender o problema.

Saída:

Contexto bruto do projeto.

Responsável:

Engineering Manager / Prompt Architect Agent quando necessário

---

## Refinamento

Objetivo:

Transformar ideias em requisitos estruturados.

Saída:

Prompt refinado

Visão do projeto

Responsável:

Prompt Architect Agent

---

## Planejamento

Objetivo:

Criar o PRD oficial.

Saída:

PRD.md

Responsável:

Product Owner Agent

---

## Arquitetura

Objetivo:

Definir a solução técnica.

Saída:

ARCHITECTURE.md

Responsável:

Software Architect Agent

---

## Planejamento de sprint

Objetivo:

Dividir o projeto em incrementos executáveis.

Saída:

Backlog da sprint

Responsável:

Sprint Planner Agent

---

## Implementação

Objetivo:

Desenvolver a sprint aprovada.

Saída:

Software funcional

Responsável:

Implementation / selected CLI

---

## Revisão de código

Objetivo:

Validar a qualidade da implementação.

Saída:

Relatório de revisão

Responsável:

Code Reviewer Agent

---

## Garantia de qualidade

Objetivo:

Validar a qualidade funcional e técnica.

Saída:

Relatório de qualidade

Responsável:

QA & Security Agent

---

## Documentação

Objetivo:

Atualizar os artefatos de engenharia.

Saída:

README

CHANGELOG

Documentação

Responsável:

Documentation Agent

---

## Aprovação técnica

Objetivo:

Validar a prontidão para release.

Saída:

Decisão de aprovação

Responsável:

Tech Lead Agent

Implementation / selected CLI

---

## Entrega

Objetivo:

Publicar a versão aprovada.

Saída:

Release

Tag de versão

---

## Melhoria contínua

Objetivo:

Capturar aprendizados.

Saída:

Melhorias do Framework

Melhorias do Knowledge

Responsável:

Implementation / selected CLI

Tech Lead Agent

---

# Regras do workflow

## Prontidão de intake e design

Antes de selecionar uma abordagem de implementação, o agente responsável deve
declarar o problema, o resultado desejado, restrições, premissas, questões
abertas e evidências disponíveis. Se o resultado não estiver suficientemente
entendido, pause e peça esclarecimentos em vez de gerar implementação.

Antes da implementação, o plano deve identificar arquivos afetados, critérios
de aceite, testes, dependências, riscos e exclusões explícitas. O usuário ou
aprovador técnico designado deve aprovar o plano.

## Loop de validação

A implementação segue um loop test-first sempre que o projeto oferecer testes
automatizados: defina o comportamento esperado, observe o teste ou validação que
falha, implemente a menor mudança e execute as verificações relevantes. Revisão e
QA validam o comportamento visível ao consumidor e as evidências reais, não
somente a API ou documentação pretendida.

## Completude do handoff

Todo handoff registra a fase atual, responsável, status do artefato, decisões,
riscos, próxima ação e a evidência exata necessária para continuar. Um handoff
não deve sugerir conclusão quando código, testes ou evidências de validação
estiverem ausentes.

## Trilha condicional de performance web e de interfaces

Quando um projeto tiver interface web ou visual, a performance é projetada e
validada durante todo o ciclo de vida, em vez de ser adiada para a auditoria
final:

1. **Descoberta e definição do produto:** identifique rotas críticas, público,
   perfis mobile/desktop, jornadas representativas e metas de experiência.
2. **Design:** documente composição responsiva, estados de carregamento,
   contratos de assets/fontes, elementos LCP candidatos, acessibilidade e estados
   de movimento reduzido.
3. **Arquitetura:** defina estratégias de renderização, bundle, rede, servidor,
   cache, terceiros e observabilidade, além de orçamentos por rota.
4. **Planejamento de sprint:** crie tarefas mensuráveis de performance e um
   baseline inicial do build de produção; inclua mobile e desktop.
5. **Implementação:** preserve os orçamentos aprovados e meça rotas
   representativas antes do acabamento final.
6. **Revisão de código e QA:** revise regressões e execute
   `protocols/PERFORMANCE_VALIDATION.md`, produzindo o
   `PERFORMANCE_VALIDATION_REPORT.md` condicional.
7. **Aprovação técnica:** o Tech Lead aprova, bloqueia ou registra uma exceção
   rastreável usando evidências mobile e desktop separadas.
8. **Pós-publicação:** monitore RUM/CrUX quando disponível e registre limitações
   de amostragem; dados de campo ausentes não são aprovação.

Projetos não visuais registram a dispensa condicional e seu escopo na decisão e
no relatório de QA do projeto. Não devem inventar evidências de performance de
navegador.

Regra 01

Todo projeto começa com Descoberta.

Prioridade:
Crítica

---

Regra 02

Toda implementação exige PRD e Arquitetura aprovados.

Prioridade:
Crítica

---

Regra 03

Nenhuma sprint deve começar sem planejamento.

Prioridade:
Crítica

---

Regra 04

Toda implementação deve passar por Code Review.

Prioridade:
Crítica

---

Regra 05

Todo projeto deve concluir QA antes da entrega.

Prioridade:
Crítica

---

Regra 06

A documentação deve ser atualizada antes da aprovação técnica.

Prioridade:
Alta

---

Regra 07

Todo projeto concluído deve contribuir para a melhoria contínua.

Prioridade:
Média

---

# Boas práticas

* Conclua uma fase antes de iniciar a próxima.
* Mantenha os artefatos de engenharia sincronizados.
* Documente decisões significativas.
* Valide as saídas em cada transição.
* Preserve a consistência do workflow.

---

# Antipadrões

Evite:

* ignorar o planejamento;
* implementar sem arquitetura;
* entregar sem QA;
* atualizar a documentação depois da release;
* ignorar aprendizados da retrospectiva.

---

# Matriz de decisão do workflow

| Situação | Ação |
| --- | --- |
| Novo projeto | Começar em Descoberta |
| Projeto existente | Validar a fase atual do ciclo de vida |
| Mudança grande de escopo | Retornar ao Planejamento |
| Mudança arquitetural | Revisitar Arquitetura |
| Revisão reprovada | Retornar à Implementação |
| QA reprovado | Corrigir antes da Entrega |
| Conclusão do projeto | Executar Melhoria Contínua |

---

# Módulos relacionados

ENGINEERING_FOUNDATIONS

ENGINEERING_ARTIFACTS

ENGINEERING_QUALITY

ENGINEERING_TEMPLATES

ENGINEERING_CONTINUOUS_IMPROVEMENT

---

# Versionamento

Versão: 0.3.0

Status: Rascunho

Derivado de:

LF Engineering Framework

Última atualização:

2026
