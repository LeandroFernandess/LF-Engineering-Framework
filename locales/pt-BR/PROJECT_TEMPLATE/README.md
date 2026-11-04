# Nome do projeto

## Objetivo

Descreva o objetivo do projeto, os usuários-alvo e o resultado principal.

## Stack

Documente as tecnologias principais, requisitos de runtime e serviços externos.

## Estrutura do repositório

```text
.
├── AGENTS.md
├── LF_ENGINEERING.md
├── README.md
├── .ai/
└── docs/
```

O bootstrap registra o idioma, o adapter e o caminho externo do Framework em
`.ai/framework-installation.md` quando esse arquivo não existe.

## Processo de engenharia

Este projeto usa o LF Engineering System para planejamento, documentação,
revisão e validação de entrega assistidos por agentes. O Framework é neutro em
relação ao CLI; OpenCode, Codex, Claude Code, Gemini CLI e outros assistentes
compatíveis podem usar os mesmos documentos por meio de adapters opcionais.
Projetos web ou visuais também usam o módulo de design/performance e validam
mobile e desktop separadamente antes da aprovação.
