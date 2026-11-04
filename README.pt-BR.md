# LF Engineering System

Idiomas: [EN-US](README.md) | [PT-BR](README.pt-BR.md)

O LF Engineering System é um framework de engenharia de software assistida por
IA. Ele define princípios, conhecimento reutilizável, agentes especializados,
workflows, protocolos, schemas e templates de bootstrap.

O Framework é neutro em relação ao fornecedor de IA e deve ser consumido por
projetos clientes como uma biblioteca externa somente leitura.

Este repositório é o primeiro snapshot público limpo, lançado como `v1.5.0`. O
histórico, branches e tags do repositório privado anterior não foram migrados;
`v1.4.0` é contexto histórico, não uma tag de release deste repositório.

## Documentos principais

- `docs/reference/LF_DESIGN_PERFORMANCE_GUIDE.md`: guia detalhado de referência para design e
  performance; os requisitos operacionais adotados estão no módulo e protocolo
  canônicos.
- `locales/pt-BR/public-docs/START_PROJECTS.md`: guia de início em PT-BR.
- `START_PROJECTS.en-US.md`: guia de início em inglês.
- `ROADMAP.md` e `locales/pt-BR/public-docs/ROADMAP.md`: roadmap EN-US e PT-BR.
- `CHANGELOG.md` e `locales/pt-BR/public-docs/CHANGELOG.md`: changelog EN-US e PT-BR.
- `OVERVIEW.md` e `locales/pt-BR/public-docs/OVERVIEW.md`: contexto de publicação EN-US e PT-BR.
- `docs/ADR.md` e `locales/pt-BR/docs/ADR.md`: decisões de arquitetura EN-US e PT-BR.
- `locales/pt-BR/public-docs/CONTRIBUTING.md`: regras para contribuição e validação.
- `locales/pt-BR/public-docs/SECURITY.md`: expectativas e comunicação privada de segurança.
- `locales/pt-BR/public-docs/TESTING.md`: matriz de testes locais e de CI.
- `locales/pt-BR/TRANSLATION_STATUS.md`: cobertura da tradução.

## Estrutura

```text
.
├── README.md
├── README.pt-BR.md
├── PROJECT_TEMPLATE/
├── agents/ knowledge/ workflows/ protocols/ schemas/
├── adapters/
├── scripts/
├── docs/
│   └── ADR.md
├── locales/
│   ├── en-US/README.md
│   └── pt-BR/
│       ├── PROJECT_TEMPLATE/
│       ├── agents/ knowledge/ workflows/ protocols/ schemas/
│       ├── public-docs/
│       └── docs/ADR.md
├── .github/
└── .opencode/
```

- `PROJECT_TEMPLATE/`: base copiada para projetos clientes.
- `adapters/`: integrações opcionais com CLIs específicos.
- `scripts/`: bootstrap nativo para macOS/Linux e Windows PowerShell.
- `locales/`: espelhos técnicos e documentos públicos PT-BR; os arquivos
  técnicos canônicos EN-US permanecem na raiz. `locales/en-US/README.md` é um
  índice, não uma cópia da fonte.
- `agents/`, `knowledge/`, `workflows/`, `protocols/` e `schemas/`: biblioteca
  canônica externa.
- `locales/pt-BR/`: espelhos técnicos e documentos públicos traduzidos para PT-BR.
- `docs/reference/`: guias-fonte não normativos preservados para rastreabilidade.

## Início rápido

O modo `generic` é o padrão e não depende de OpenCode, Codex, Claude Code,
Gemini, Node.js ou Python. Baixe o Framework e execute primeiro um dry-run:

```sh
FRAMEWORK_PATH="$(pwd)" # Execute na raiz do repositório clonado.

sh "$FRAMEWORK_PATH/scripts/bootstrap.sh" \
  --framework-path "$FRAMEWORK_PATH" \
  --language pt-BR \
  --adapter generic \
  --target "$HOME/Projetos/MeuProjeto" \
  --dry-run
```

Depois revise as linhas `ADD` e `PRESERVE` e execute novamente com `--apply`.
No Windows, use `scripts/bootstrap.ps1` conforme
`locales/pt-BR/public-docs/START_PROJECTS.md`.

O `.gitignore` gerado mantém `.ai/state/` local por padrão. Projetos existentes
preservam seu próprio `.gitignore` durante o bootstrap e precisam adotar essa
regra manualmente, se desejado.

Idiomas disponíveis: `en-US` e `pt-BR`. Adapters disponíveis: `generic`,
`codex` (OpenAI), `claude` (Anthropic), `gemini` (Google) e `opencode`.

A release pública `v1.5.0` inclui os dois templates de idioma, os espelhos PT-BR
e as quatro correções pós-`v1.4.0` descritas em `CHANGELOG.md`. A cobertura e as
exclusões intencionais da tradução estão detalhadas em
`locales/pt-BR/TRANSLATION_STATUS.md`.

## Modelo de segurança

O bootstrap copia somente arquivos ausentes, preserva arquivos existentes e
recusa operar dentro do próprio Framework. Conflitos em arquivos de instrução ou
configuração exigem revisão manual. A implementação deve ocorrer somente no
projeto cliente.

Para projetos web ou visuais, a validação de performance e acessibilidade é
condicional, com evidências mobile e desktop separadas.
Quando houver movimento no escopo, use as orientações condicionais de motion
design; nenhuma biblioteca de animação é padrão do Framework.
