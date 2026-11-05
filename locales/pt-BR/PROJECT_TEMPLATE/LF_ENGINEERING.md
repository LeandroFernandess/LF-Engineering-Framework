# Contexto do LF Engineering System

Este projeto usa o LF Engineering System como uma biblioteca externa de
engenharia, somente leitura.

## Localização do Framework

O Framework canônico está instalado em
`__LF_ENGINEERING_SYSTEM_PATH__`. Use esse caminho ao carregar os diretórios de
agentes, conhecimento, workflows, protocolos e schemas listados abaixo.

## Fontes canônicas

Consulte `knowledge/INDEX.md` antes de carregar conhecimento específico,
`knowledge/REGISTRY.md` antes de selecionar agentes ou handoffs e
`.ai/contracts.md` antes de criar ou validar artefatos.

Os diretórios canônicos do Framework são:

- `agents/`: responsabilidades e comportamento dos agentes.
- `knowledge/`: orientações reutilizáveis de engenharia.
- `workflows/`: workflows do ciclo de vida.
- `protocols/`: regras de handoff, tarefas, decisões e atualização de artefatos.
- `schemas/`: estruturas e expectativas de validação dos artefatos.

## Fronteira do projeto

- Trabalhe somente dentro do projeto cliente.
- Trate o LF Engineering System como somente leitura.
- Mantenha o estado específico do projeto em `.ai/` e os artefatos em `docs/`.
- Peça confirmação antes de operações destrutivas.
- Exija um plano aprovado antes de mudanças não triviais.

## Workflow

Use Engineering Manager e Orchestrator para classificar a demanda e selecionar
o workflow. Use agentes especializados quando necessário e encaminhe revisão,
QA/segurança, documentação e prontidão de entrega ao Tech Lead.

Em projetos web ou visuais, use o módulo de design/performance e valide as
evidências mobile e desktop separadamente. Em projetos não visuais, registre a
validação de performance como não aplicável em vez de inventar métricas.

Quando houver movimento ou um simulador visual interativo orientado por modelo
explicitamente solicitado no escopo, use também
`knowledge/ENGINEERING_MOTION_DESIGN.md` para as orientações condicionais e a
revisão de QA aplicáveis. Para simuladores, use as seções existentes de PRD,
DESIGN e ARCHITECTURE para registrar fidelidade pretendida, fontes do modelo e
evidências de validação. O módulo não prescreve uma biblioteca nem adiciona uma
fase ao workflow.

Este contexto pode ser carregado por qualquer assistente ou CLI de IA. Adapters
específicos de fornecedor são opcionais e não substituem este documento.
