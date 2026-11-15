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
- `FIRST_PROMPT_TEMPLATE.md` e `locales/pt-BR/public-docs/FIRST_PROMPT_TEMPLATE.md`:
  modelo opcional de primeiro prompt em EN-US e PT-BR.
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
└── .github/
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

Baixe/clone o Framework. Na raiz, abra o assistente local:

```sh
sh setup.sh
```

No Windows PowerShell:

```powershell
.\setup.ps1
```

Escolha português ou inglês, informe o diretório do projeto e selecione a
integração (`generic` é o padrão). Revise a prévia e confirme a aplicação.
Não exige Node.js ou Python nem instala ferramentas externas. O idioma controla
o terminal e os novos documentos; a biblioteca mantém ambos os idiomas, com
EN-US como fonte canônica. Arquivos existentes são preservados; executar novamente
não migra idioma ou integração.

O adapter `generic` continua sendo o padrão; Codex, Claude, Gemini e OpenCode
podem ser selecionados pelo mesmo assistente. OpenCode usa
`adapters/opencode/` e aponta para agentes e workflows canônicos, sem manter
uma árvore independente na raiz. Consulte `adapters/README.md` para a matriz
de integrações.

Use `--no-animation`/`--no-color` (PowerShell: `-NoAnimation`/`-NoColor`)
para uma apresentação estática. `NO_COLOR` também desativa cores.
O assistente mostra uma assinatura 2D LF breve na abertura e usa a mesma marca
durante o trabalho real do bootstrap; terminais estreitos ou sem suporte recebem
uma assinatura estática.
Consulte o [guia de início](locales/pt-BR/public-docs/START_PROJECTS.md) para detalhes
e automação. Os comandos `scripts/bootstrap.sh` e `scripts/bootstrap.ps1`
continuam não interativos, com dry-run padrão e saída técnica em inglês.

O `.gitignore` gerado exclui `.ai/state/`; projetos existentes preservam seu
`.gitignore` e devem adotar essa regra manualmente, se desejado.

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
