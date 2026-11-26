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
- `GET_STARTED.md` e `locales/pt-BR/public-docs/GET_STARTED.md`: comandos de
  instalação por sistema operacional e idioma, em EN-US e PT-BR.
- `locales/pt-BR/public-docs/START_PROJECTS.md` e
  `START_PROJECTS.en-US.md`: guia detalhado de configuração manual e automação.
  O bootstrap também instala uma cópia no idioma selecionado como
  `START_PROJECTS.md` em cada projeto cliente.
- `FIRST_PROMPT_TEMPLATE.md` e `locales/pt-BR/public-docs/FIRST_PROMPT_TEMPLATE.md`:
  modelo opcional de primeiro prompt em EN-US e PT-BR; uma cópia localizada é
  instalada no projeto cliente.
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
├── project-skills/en-US/
├── agents/ knowledge/ workflows/ protocols/ schemas/
├── adapters/
├── scripts/
├── docs/
│   └── ADR.md
├── locales/
│   ├── en-US/README.md
│   └── pt-BR/
│       ├── PROJECT_TEMPLATE/
│       ├── project-skills/
│       ├── agents/ knowledge/ workflows/ protocols/ schemas/
│       ├── public-docs/
│       └── docs/ADR.md
└── .github/
```

- `PROJECT_TEMPLATE/`: base copiada para projetos clientes.
- `project-skills/`: seis skills curtas de orientação para projetos em EN-US;
  as versões PT-BR ficam em `locales/pt-BR/project-skills/`.
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

Comece pelo [guia de início](locales/pt-BR/public-docs/GET_STARTED.md). Ele baixa
um inicializador pequeno, pergunta o sistema operacional e o idioma e instala
o pacote de release correspondente em uma pasta separada para a biblioteca do
Framework. No macOS ou Linux:

```sh
curl -fsSL https://raw.githubusercontent.com/LeandroFernandess/LF-Engineering-Framework/main/setup.sh -o lf-framework-setup.sh
sh ./lf-framework-setup.sh
```

No Windows PowerShell, siga os comandos de download e execução do
[GET_STARTED](locales/pt-BR/public-docs/GET_STARTED.md). O assistente mostra as
mudanças do projeto antes de aplicá-las; arquivos existentes são preservados.

O assistente exige a escolha de um adapter: Codex, Claude, Gemini ou OpenCode.
O OpenCode usa
`adapters/opencode/` e aponta para agentes e workflows canônicos. Consulte
`adapters/README.md` para a matriz de integrações.

A versão publicada atualmente, `v1.5.0`, é anterior aos novos assets por
sistema/idioma. Até que uma release inclua esses pacotes, use a alternativa de
checkout completo documentada no GET_STARTED. O guia detalhado de configuração
manual e automação continua em
[START_PROJECTS](locales/pt-BR/public-docs/START_PROJECTS.md).

O assistente não exige runtime Node.js ou Python. `--no-animation` e
`--no-color` (PowerShell: `-NoAnimation` e `-NoColor`) selecionam uma
apresentação estática, e `NO_COLOR` desativa as cores. Os comandos nativos
`scripts/bootstrap.sh` e `scripts/bootstrap.ps1` continuam não interativos, usam
dry-run por padrão e mantêm a saída técnica em inglês.

O `.gitignore` gerado exclui `.ai/state/`; projetos existentes preservam seu
`.gitignore` e devem adotar essa regra manualmente, se desejado.

O bootstrap também copia os guias localizados `START_PROJECTS.md` e
`FIRST_PROMPT_TEMPLATE.md` para a raiz do projeto e instala seis skills:
`lf-project-onboarding`, `lf-project-planning`, `lf-approved-implementation`,
`lf-delivery-review`, `lf-design` e `lf-security-review`. Claude as recebe em `.claude/skills/`; Codex, Gemini e
OpenCode, em `.agents/skills/`. Cada skill curta encaminha às fontes canônicas
externas do Framework usando a fonte pública versionada registrada em
`.ai/framework-installation.md`. O bootstrap preserva guias e skills existentes,
não copia `GET_STARTED.md`, não importa skills externas nem copia diretórios
completos do Framework para o projeto.

## Modelo de segurança

O bootstrap copia somente arquivos ausentes, preserva arquivos existentes e
recusa operar dentro do próprio Framework. Conflitos em arquivos de instrução ou
configuração exigem revisão manual. A implementação deve ocorrer somente no
projeto cliente.

Para projetos web ou visuais, a validação de performance e acessibilidade é
condicional, com evidências mobile e desktop separadas.
Quando houver movimento ou um simulador visual interativo orientado por modelo
explicitamente solicitado, use as orientações condicionais; nenhuma biblioteca
de animação, pipeline 3D ou simulador é padrão do Framework.
