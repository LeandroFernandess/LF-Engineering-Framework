# Guia de início do LF Engineering System — PT-BR

Guia de idioma: [EN-US](../../../START_PROJECTS.en-US.md) | [PT-BR](START_PROJECTS.md)

Este guia mostra como baixar o Framework e instalar sua documentação em um
projeto novo ou existente. O modo `generic` é o padrão e não depende de
OpenCode, Codex, Claude Code, Gemini, Node.js, Python ou plugins.

## 1. Baixar o Framework

Escolha uma release do GitHub ou clone o repositório para uma pasta separada
do projeto:

```sh
git clone https://github.com/LeandroFernandess/LF-Engineering-Framework.git LF-Engineering-Framework
cd LF-Engineering-Framework
```

O nome de destino é opcional e pode ser diferente. Os scripts descobrem a raiz
do Framework a partir da própria localização; use o diretório real do checkout e
execute os comandos abaixo na raiz. Nenhum comando depende de a pasta se chamar
`LF-Engineering-Framework`.

O diretório do Framework deve permanecer externo e somente leitura. O bootstrap
copia a base de coordenação para o projeto, mas mantém `agents/`, `knowledge/`,
`workflows/`, `protocols/` e `schemas/` como biblioteca canônica externa.

O `.gitignore` gerado exclui `/.ai/state/` para manter o estado de coordenação
local por padrão. Projetos existentes preservam seu `.gitignore` durante o
bootstrap e precisam adicionar essa regra manualmente se desejarem a mesma
proteção.

## 2. Escolher idioma e adapter

As opções são independentes:

| Opção | Valores | Padrão |
| --- | --- | --- |
| Idioma | `en-US`, `pt-BR` | `en-US` |
| Adapter | `generic`, `codex`, `claude`, `gemini`, `opencode` | `generic` |

`pt-BR` instala o template de projeto traduzido. `en-US` usa o conteúdo-fonte
técnico. A cobertura de tradução é registrada em
`locales/pt-BR/TRANSLATION_STATUS.md`.

A release pública `v1.5.0` contém os dois templates de idioma e a seleção
acontece no bootstrap. A cobertura da tradução não é integral em módulos
suplementares e documentos públicos extensos; consulte
`locales/pt-BR/TRANSLATION_STATUS.md` antes de tratar PT-BR como equivalente a
todo o conteúdo EN-US.

O modo `generic` instala `LF_ENGINEERING.md`, `AGENTS.md`, `.ai/`, `docs/`,
`README.md` e `.gitignore`. Os adapters adicionam apenas a integração específica
do CLI:

- `codex` (OpenAI): usa o `AGENTS.md` já instalado.
- `claude` (Anthropic): adiciona `CLAUDE.md`.
- `gemini` (Google): adiciona `GEMINI.md`.
- `opencode`: adiciona `opencode.jsonc` e configura a referência somente leitura.

## 3. macOS e Linux

O script é nativo de shell e não exige `rsync`, Node.js ou Python. Na raiz do
Framework clonado, o padrão é dry-run. Execute a revisão primeiro:

```sh
FRAMEWORK_PATH="$(pwd)"
TARGET_PATH="$HOME/Projetos/MeuProjeto"

sh "$FRAMEWORK_PATH/scripts/bootstrap.sh" \
  --framework-path "$FRAMEWORK_PATH" \
  --target "$TARGET_PATH" \
  --language pt-BR \
  --adapter generic \
  --dry-run
```

Depois aplique a instalação:

```sh
sh "$FRAMEWORK_PATH/scripts/bootstrap.sh" \
  --framework-path "$FRAMEWORK_PATH" \
  --target "$TARGET_PATH" \
  --language pt-BR \
  --adapter generic \
  --apply
```

Para instalar no diretório atual, use `--target "$PWD"`. Para inglês, troque
`pt-BR` por `en-US`. Para OpenCode, troque `generic` por `opencode`.

Ao aplicar o bootstrap, diretórios/arquivos `.ai/state` também ficam restritos
ao usuário atual (0700/0600 em POSIX e ACL somente do proprietário no Windows).
Em projetos existentes, o conteúdo do estado é preservado e suas permissões são
restringidas.

## 4. Windows PowerShell

O script usa apenas PowerShell e APIs do .NET. O padrão também é dry-run:

```powershell
$frameworkPath = (Get-Location).Path # Execute na raiz do Framework clonado.
$targetPath = "$HOME\Projetos\MeuProjeto"

& (Join-Path $frameworkPath "scripts\bootstrap.ps1") `
  -FrameworkPath $frameworkPath `
  -TargetPath $targetPath `
  -Language pt-BR `
  -Adapter generic `
  -DryRun
```

Depois aplique a instalação:

```powershell
& (Join-Path $frameworkPath "scripts\bootstrap.ps1") `
  -FrameworkPath $frameworkPath `
  -TargetPath $targetPath `
  -Language pt-BR `
  -Adapter generic `
  -Apply
```

Para inglês, use `-Language en-US`. Para OpenCode, use `-Adapter opencode`.

## 5. Projetos novos e existentes

O mesmo comando funciona nos dois cenários:

- cria o diretório-alvo se ele não existir;
- copia somente arquivos ausentes;
- preserva código, documentos, `.git/`, `.ai/`, `AGENTS.md`, `.gitignore`,
  `README.md` e configurações existentes;
- não mescla automaticamente `AGENTS.md`, `CLAUDE.md`, `GEMINI.md` ou
  `opencode.jsonc` conflitantes;
- registra idioma e adapter em `.ai/framework-installation.md` apenas quando
  esse arquivo ainda não existe;
- recusa instalar no próprio Framework ou em seus subdiretórios.

Revise todas as linhas `ADD` e `PRESERVE` do dry-run antes de usar `--apply`.
Conflitos de configuração devem ser mesclados manualmente, porque uma fusão
automática poderia alterar regras do projeto.

## 6. Modelo de consumo

O projeto instalado contém apenas a base local de coordenação. O assistente de
IA deve consultar a biblioteca externa conforme `LF_ENGINEERING.md` e
`AGENTS.md`, começando por `knowledge/INDEX.md` e `.ai/contracts.md`.

O Framework é a fonte canônica de agentes, conhecimento, workflows, protocolos
e schemas. O projeto cliente é o único local de implementação. Em projetos web
ou visuais, a validação mobile e desktop continua condicional e separada.

## 7. Validação da instalação

Após aplicar:

1. Confirme o idioma em `.ai/framework-installation.md`.
2. Leia `LF_ENGINEERING.md` e `AGENTS.md`.
3. Confirme que `.ai/` e `docs/` existem.
4. Selecione o agente inicial conforme `knowledge/REGISTRY.md`.
5. Para adapters específicos, confirme o arquivo de entrada correspondente.

Consulte `../../../README.pt-BR.md` para a visão geral em português e
`../../../START_PROJECTS.en-US.md` para a versão em inglês.
