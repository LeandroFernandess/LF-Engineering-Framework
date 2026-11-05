# Workflow de desenvolvimento padrão

## Objetivo

Workflow padrão para transformar uma ideia em uma mudança de software revisada,
documentada e pronta para entrega.

## Sequência de agentes

1. Engineering Manager classifica a demanda e registra ambiguidades, restrições
   e riscos.
2. Orchestrator seleciona o workflow, os agentes e os handoffs de artefatos.
3. Prompt Architect refina o contexto inicial quando necessário.
4. Product Owner define escopo do produto, requisitos e critérios de aceite
   observáveis. Quando evidências sobre usuários informarem uma decisão de
   produto, referencie seu escopo e suas limitações nas seções relevantes do PRD;
   não crie um artefato de pesquisa separado obrigatório.
5. Design System Analyst analisa referências visuais fornecidas ou, somente
   quando solicitado explicitamente pelo usuário/Product Owner, propõe uma
   direção inicial sem referências e a registra em `DESIGN.md` como `Proposed`,
   aguardando aprovação. Ignore a etapa quando nenhuma condição se aplicar.
6. Em projetos web ou visuais, use
   `knowledge/ENGINEERING_DESIGN_PERFORMANCE.md` para definir rotas críticas,
   perfis mobile/desktop, estados responsivos, candidatos a LCP e metas de
   experiência. Product Owner é responsável pelos requisitos de produto; Design
   System Analyst contribui para `DESIGN.md` quando houver referências ou uma
   direção inicial tiver sido solicitada explicitamente.
   Quando houver movimento ou um simulador visual interativo orientado por
   modelo explicitamente solicitado no escopo, use
   `knowledge/ENGINEERING_MOTION_DESIGN.md` para as orientações condicionais
   relevantes. Documente propósito do movimento e comportamento para movimento
   reduzido quando aplicável; para simuladores, registre fontes do modelo,
   fidelidade pretendida, consistência de estado e evidências de validação, sem
   prescrever uma biblioteca de implementação.
7. Software Architect projeta a solução técnica, a estratégia de
   renderização/entrega e os orçamentos de performance, registrando trade-offs
   relevantes.
8. Sprint Planner divide o trabalho em tarefas executáveis, arquivos afetados,
   testes, baselines de performance, orçamentos e exclusões.
9. O usuário ou aprovador designado aprova o plano antes da implementação.
10. A implementação é realizada pela equipe do projeto ou agente de código,
    usando validação test-first quando houver suporte e um baseline inicial do
    build de produção quando aplicável.
11. Code Reviewer valida manutenibilidade, correção, risco de regressão,
    mudanças sensíveis a performance e alinhamento ao plano.
12. QA Security valida qualidade, comportamento visível ao consumidor, riscos,
    segurança e evidências; em projetos web/visuais executa
    `protocols/PERFORMANCE_VALIDATION.md` e produz
    `docs/PERFORMANCE_VALIDATION_REPORT.md`, incluindo a Revisão de movimento
    quando houver movimento no escopo e a Revisão de modelo interativo quando
    houver um simulador orientado por modelo no escopo.
13. Documentation registra os artefatos de produto, técnicos e de performance e
    os sincroniza com os resultados de revisão e QA.
14. Tech Lead toma as decisões finais de engenharia e avalia a entrega usando
    evidências mobile e desktop separadas quando aplicável.
15. Engineering Knowledge Extractor analisa o projeto concluído e produz
    `PROJECT_KNOWLEDGE.md`.

## Arquivos obrigatórios do projeto

- `.ai/workflow.md`
- `.ai/handoff.md`
- `.ai/decisions.md`
- `.ai/tasks.md`
- `.ai/artifacts.md`
- `docs/PRD.md`
- `docs/DESIGN.md` (quando houver referências visuais ou solicitação explícita de
  direção inicial)
- `docs/PERFORMANCE_VALIDATION_REPORT.md` (quando houver interface web ou visual)
- `docs/ARCHITECTURE.md`
- `docs/SPRINTS.md`
- `docs/ADR.md`

## Regras de operação

- Consulte `knowledge/INDEX.md` antes de carregar módulos específicos.
- Mantenha as saídas dos agentes concisas, rastreáveis e ligadas aos artefatos
  do projeto.
- Exija que cada plano não trivial identifique arquivos afetados, testes,
  critérios de aceite, riscos e não objetivos explícitos.
- Em projetos web ou visuais, exija cobertura de rotas/perfis, evidência de
  build de produção, orçamentos de performance e decisão de aceite mobile/desktop
  separada.
- Trate afirmações desconhecidas ou não verificadas como questões abertas, não
  como trabalho concluído.
- Atualize os arquivos `.ai/` de comunicação quando o trabalho alterar escopo,
  decisões, tarefas ou estado do handoff.
- Não ignore revisão, QA ou validação do Tech Lead nas decisões de entrega.
- Não trate uma rota, um perfil de dispositivo, a melhor execução de cinco ou a
  ausência de dados de campo como aprovação de performance da aplicação inteira.
