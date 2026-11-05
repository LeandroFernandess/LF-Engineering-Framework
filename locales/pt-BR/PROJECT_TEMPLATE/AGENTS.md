# Instruções dos agentes do projeto

## Objetivo

Este arquivo é o entrypoint padrão de instruções para assistentes de IA. Ele
explica como os agentes do LF Engineering System devem operar neste projeto.
Leia `LF_ENGINEERING.md` para conhecer o contexto neutro de fornecedor.

## Fonte dos agentes

Use as definições canônicas de agentes do LF Engineering System no caminho
registrado em `LF_ENGINEERING.md`:

- `agents/Prompt-Architect/`
- `agents/Engineering-Manager/`
- `agents/Product-Owner/`
- `agents/Design-System-Analyst/`
- `agents/Software-Architect/`
- `agents/Sprint-Planner/`
- `agents/Documentation/`
- `agents/Code-Reviewer/`
- `agents/QA-Security/`
- `agents/Tech-Lead/`
- `agents/Engineering-Knowledge-Extractor/`

## Regras de operação

- Leia `LF_ENGINEERING.md` antes de iniciar o trabalho.
- Consulte `knowledge/INDEX.md` antes de carregar módulos específicos.
- Consulte `.ai/contracts.md` antes de criar, atualizar ou validar artefatos.
- Mantenha os arquivos de `.ai/` atualizados durante o trabalho.
- Atualize `.ai/state/` após cada etapa do workflow.
- `.ai/state/` é local e ignorado pelo Git por padrão; não force sua inclusão
  sem revisar e aprovar explicitamente os arquivos específicos a compartilhar.
- Mantenha as decisões rastreáveis a `docs/ADR.md` quando afetarem arquitetura,
  escopo ou risco de entrega.
- Prefira handoffs objetivos entre agentes a repetir todo o contexto.
- Em projetos web ou visuais, use
  `knowledge/ENGINEERING_DESIGN_PERFORMANCE.md` e
  `protocols/PERFORMANCE_VALIDATION.md` para manter separadas as evidências
  mobile e desktop.
- Quando houver movimento ou um simulador visual interativo orientado por modelo
  explicitamente solicitado no escopo, carregue também
  `knowledge/ENGINEERING_MOTION_DESIGN.md` e registre a revisão condicional
  aplicável no relatório de performance; não adicione movimento nem escolha uma
  biblioteca por padrão.
- Para mudanças não triviais, exija um plano aprovado que identifique arquivos
  afetados, testes, critérios de aceite, riscos e exclusões antes de editar.
- Trate `ENGINEERING_ELEPHANT_GOLDFISH`, `ENGINEERING_AGENT_GRAPH_FLOW`,
  `ENGINEERING_RTK` e `ENGINEERING_GRAPHIFY` somente como referências
  suplementares opcionais aprovadas; não são dependências obrigatórias nem
  ferramentas padrão, e esse status não autoriza instalação ou integração
  externa.

## Fronteiras do projeto

- O repositório do projeto é a única área editável por padrão.
- Trate LF-ENGINEERING-SYSTEM como biblioteca de engenharia externa e somente
  leitura.
- Consulte LF-ENGINEERING-SYSTEM somente quando precisar de orientação sobre
  Framework, workflow, protocolo, schema ou agente.
- Não altere arquivos do LF-ENGINEERING-SYSTEM durante o trabalho neste projeto.
- Se uma mudança no Framework parecer necessária, pare e peça confirmação fora
  do workflow do projeto cliente.

## Atualização do estado

Após cada etapa, atualize os arquivos relevantes:

- `.ai/state/current-phase.md`
- `.ai/state/current-agent.md`
- `.ai/state/project-summary.md`
- `.ai/state/next-actions.md`
- `.ai/state/risks.md`

Use `protocols/` do LF-ENGINEERING-SYSTEM para manter consistentes os formatos
de workflow, handoff, tarefas, decisões e artefatos. O projeto pode usar
qualquer assistente ou CLI compatível; não presuma comandos nem configurações
específicos de fornecedor, a menos que um adapter esteja instalado
explicitamente.

## Contratos de artefatos

Antes de selecionar ou executar uma etapa de agente, leia `.ai/contracts.md` e
confirme que os artefatos upstream obrigatórios existem ou que a exceção foi
registrada em `.ai/decisions.md`.
