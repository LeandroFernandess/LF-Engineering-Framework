# Workflow de novo projeto

## Objetivo

Workflow para iniciar um projeto a partir do LF Engineering System e prepará-lo
para a colaboração entre agentes.

Este workflow cobre inicialização do projeto, planejamento, prontidão para
implementação, validação da entrega e extração de conhecimento pós-entrega.

## Etapas

1. Crie o diretório do novo projeto fora do repositório do LF Engineering
   System.
2. Execute o bootstrap nativo com o idioma e adapter selecionados; `generic` é
   o padrão.
3. Se um adapter de fornecedor for selecionado, crie ou valide seu entrypoint
   de projeto e mantenha o LF Engineering System como framework externo somente
   leitura.
4. Confirme que `LF_ENGINEERING.md` e `AGENTS.md` definem as fronteiras do
   projeto, o uso somente leitura do Framework e as regras de atualização de
   estado.
5. Comece com Engineering Manager para classificar a demanda bruta, identificar
   ambiguidades e gerar `MANAGER_BRIEF`.
6. Use Orchestrator para selecionar o workflow, os agentes, a ordem dos handoffs
   e os artefatos necessários a partir do registry e dos contratos.
7. Use Prompt Architect para refinar o contexto inicial e produzir
   `PROJECT_BRIEF.md` quando o prompt for bruto, ambíguo ou incompleto.
8. Use Product Owner para produzir ou atualizar `docs/PRD.md`. Quando evidências
   sobre usuários informarem uma decisão de produto, referencie seu escopo e suas
   limitações nas seções relevantes do PRD; não crie um artefato de pesquisa
   separado obrigatório.
9. Use Design System Analyst para produzir ou atualizar `docs/DESIGN.md` quando
   existirem referências visuais ou quando o usuário/Product Owner solicitar
   explicitamente uma proposta de direção inicial sem referências. Mantenha os
   dois modos e suas evidências distintos; caso contrário, ignore esta etapa
   opcional.
10. Em projetos web ou visuais, use
    `knowledge/ENGINEERING_DESIGN_PERFORMANCE.md` para definir perfis
    mobile/desktop, rotas críticas, candidatos a LCP, estados responsivos e
    orçamentos iniciais antes da aprovação da arquitetura.
    Quando houver movimento ou um simulador visual interativo orientado por
    modelo explicitamente solicitado no escopo, use também
    `knowledge/ENGINEERING_MOTION_DESIGN.md` para as orientações condicionais
    relevantes. Defina propósito do movimento e comportamento para movimento
    reduzido quando aplicável; para simuladores, defina fontes do modelo,
    fidelidade pretendida e evidências de validação. Isso não adiciona uma fase
    ao workflow nem exige animação.
11. Use Software Architect para produzir ou atualizar `docs/ARCHITECTURE.md`,
    decisões de performance/entrega e recomendações de ADR.
12. Use Sprint Planner para produzir ou atualizar `docs/SPRINTS.md`,
    `.ai/tasks.md` e tarefas mensuráveis de baseline/validação de performance
    quando aplicável.
13. Exija um plano contendo arquivos afetados, critérios de aceite, testes,
    riscos, perfis/orçamentos de performance quando aplicável e exclusões; peça
    ao usuário aprovação antes de iniciar a implementação.
14. Execute a implementação somente dentro do repositório do projeto, usando
    um loop test-first quando houver suporte a testes automatizados e uma
    verificação inicial do build de produção para trabalho web/visual.
15. Use Code Reviewer para validar correção da implementação, manutenibilidade,
    risco de regressão, mudanças sensíveis a performance e alinhamento
    arquitetural.
16. Use QA Security para validar qualidade, segurança, comportamento visível ao
    consumidor, evidências de validação e riscos de prontidão; execute
    `protocols/PERFORMANCE_VALIDATION.md` e crie
    `docs/PERFORMANCE_VALIDATION_REPORT.md` em projetos web/visuais, incluindo
    a Revisão de movimento quando houver movimento no escopo e a Revisão de
    modelo interativo quando houver um simulador orientado por modelo no escopo.
17. Use Documentation para manter `README.md`, `docs/`, `.ai/` e `.ai/state/`
    sincronizados com a implementação e os resultados de QA.
18. Use Tech Lead para consolidar evidências, revisar resultados mobile/desktop
    separados e aprovar, bloquear ou redirecionar a entrega.
19. Peça ao usuário validação manual e registre correções, remoções ou melhorias.
20. Encaminhe correções ao agente ou etapa de implementação responsável quando
    afetarem escopo, arquitetura, documentação, qualidade ou risco de entrega.
21. Depois da aprovação do Tech Lead e da validação manual, use Engineering
    Knowledge Extractor para produzir `PROJECT_KNOWLEDGE.md`.
22. Mantenha `.ai/workflow.md`, `.ai/handoff.md`, `.ai/decisions.md`,
    `.ai/tasks.md`, `.ai/artifacts.md` e `.ai/state/` atualizados durante a
    execução.

## Sequência de agentes

```text
Engineering Manager
  -> Orchestrator
  -> Prompt Architect (condicional)
  -> Product Owner
  -> Design System Analyst (condicional)
  -> Software Architect
  -> Sprint Planner
  -> Aprovação do plano
  -> Implementation / selected CLI
  -> Code Reviewer
  -> QA Security
  -> Documentation
  -> Tech Lead
  -> Engineering Knowledge Extractor
  -> Revisão humana / mantenedor do Framework
```

## Regras condicionais

- Prompt Architect é necessário quando o contexto inicial é bruto, ambíguo,
  incompleto ou precisa ser preservado como `PROJECT_BRIEF.md`.
- Design System Analyst executa análise de referências quando existirem
  referências visuais, ou propõe uma direção inicial sem referências somente
  quando o usuário/Product Owner solicitar explicitamente para um produto visual.
- Uma direção inicial solicitada é opcional, deve ser identificada como
  `Proposed`, fundamentada em contexto aprovado do produto e aprovada antes de se
  tornar um baseline. Heurísticas não são evidências sobre usuários.
- `docs/DESIGN.md` é condicional; ignore-o em projetos não visuais e quando não
  houver referências nem solicitação explícita de proposta.
- Carregue `ENGINEERING_MOTION_DESIGN` quando movimento for planejado ou
  revisado, ou quando houver um simulador visual interativo orientado por modelo
  explicitamente solicitado no escopo. Caso contrário, registre a dispensa
  condicional; não introduza uma biblioteca nem uma nova fase de workflow.
- Engineering Knowledge Extractor executa após a aprovação da entrega. Ele
  recomenda melhorias para o Framework, mas não o modifica.
- O adapter `generic` é suficiente para qualquer assistente de IA compatível.
  Codex, Claude Code, Gemini CLI e OpenCode são opcionais.
- Se um artefato upstream estiver ausente, crie-o primeiro ou registre a
  exceção em `.ai/decisions.md`.
- Não modifique o LF Engineering System ao operar dentro de um projeto cliente,
  salvo quando houver aprovação explícita.

## Arquivos obrigatórios do projeto

- `AGENTS.md`
- `LF_ENGINEERING.md`
- `README.md`
- `.ai/workflow.md`
- `.ai/handoff.md`
- `.ai/decisions.md`
- `.ai/tasks.md`
- `.ai/artifacts.md`
- `.ai/state/current-phase.md`
- `.ai/state/current-agent.md`
- `.ai/state/project-summary.md`
- `.ai/state/next-actions.md`
- `.ai/state/risks.md`
- `PROJECT_BRIEF.md`, quando aplicável
- `docs/PRD.md`
- `docs/DESIGN.md`, quando houver referências visuais ou solicitação explícita de
  direção inicial
- `docs/PERFORMANCE_VALIDATION_REPORT.md`, quando houver interface web ou visual
- `docs/ARCHITECTURE.md`
- `docs/SPRINTS.md`
- `docs/ADR.md`
- `PROJECT_KNOWLEDGE.md`, após aprovação da entrega e extração de conhecimento
- `CLAUDE.md`, `GEMINI.md` ou `opencode.jsonc`, somente quando o adapter
  correspondente estiver selecionado

## Fluxo pós-implementação

1. Compare a implementação com o plano aprovado e `docs/SPRINTS.md`.
2. Valide a coerência de `PROJECT_BRIEF.md`, `docs/PRD.md`,
   `docs/ARCHITECTURE.md` e `docs/DESIGN.md` quando presentes.
3. Faça a revisão da implementação com Code Reviewer.
4. Valide qualidade e segurança com QA Security.
5. Sincronize a documentação com Documentation.
6. Consolide as evidências da entrega com Tech Lead.
7. Solicite validação manual ao usuário.
8. Aplique correções ou remoções aprovadas dentro do projeto cliente.
9. Gere `PROJECT_KNOWLEDGE.md` com Engineering Knowledge Extractor.
10. Envie recomendações de melhoria do Framework para revisão humana.

## Checklist de prontidão

- O propósito do projeto está claro.
- O escopo do produto está documentado.
- As restrições arquiteturais estão documentadas.
- A primeira sprint ou conjunto de tarefas é executável.
- O estado dos handoffs está atualizado.
- O bootstrap copiou o template de idioma selecionado para a raiz do projeto.
- O entrypoint do adapter selecionado, quando houver, referencia ou carrega o
  LF Engineering System como framework externo somente leitura.
- `AGENTS.md` confirma as fronteiras do projeto e o uso somente leitura do
  Framework.
- Os arquivos necessários de `.ai/` e `.ai/state/` existem e não contêm
  placeholders operacionais `TBD` sem resolução.
- A análise de design condicional foi concluída ou explicitamente ignorada.
- A análise de performance condicional foi concluída para mobile e desktop ou
  explicitamente marcada como não aplicável para projeto não visual; a Revisão
  de modelo interativo foi concluída ou marcada como não aplicável conforme o
  escopo do simulador.
- A aprovação do usuário está registrada antes da implementação.
- Revisão, QA/Security, documentação e validação do Tech Lead estão planejadas;
  projetos web/visuais incluem o protocolo e o relatório de performance.
- A extração de conhecimento pós-entrega está planejada por meio de
  `PROJECT_KNOWLEDGE.md`.
