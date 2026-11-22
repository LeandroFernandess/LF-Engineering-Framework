# Guia de início do LF Engineering System — PT-BR

Guia de idioma: [EN-US](../../../START_PROJECTS.en-US.md) | [PT-BR](START_PROJECTS.md)

Este guia mostra como baixar o Framework e instalar sua documentação em um
projeto novo ou existente. A base neutra é instalada junto com um adapter de
CLI escolhido explicitamente: Codex, Claude, Gemini ou OpenCode. O bootstrap
nativo não depende de Node.js, Python ou plugins.

Para a instalação prioritária de primeira execução, use o
[GET_STARTED em PT-BR](GET_STARTED.md). Este documento continua sendo a
referência detalhada para checkout do código-fonte, configuração manual e
automação. O checkout completo também é a alternativa até que uma release
publique os novos pacotes por sistema operacional e idioma.

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

## Assistente local recomendado

Após baixar/clonar, execute `sh setup.sh` no macOS/Linux ou `.\setup.ps1`
no Windows PowerShell, na raiz do Framework. Escolha idioma, diretório do projeto
externo e integração; confira os arquivos e permissões da prévia e confirme.
A confirmação padrão é não. EOF ou cancelamento antes da aplicação não alteram
arquivos do projeto. Se a aplicação falhar ou for interrompida, corrija a causa e
execute novamente: arquivos novos já gravados podem permanecer e serão preservados.

O assistente exige entrada e saída interativas e não executa em CI.
Use `--no-animation`/`--no-color` ou `-NoAnimation`/`-NoColor` no PowerShell.
`NO_COLOR` desativa cores; terminais simples ou estreitos usam uma assinatura
estática. Os menus de sistema e idioma aparecem em inglês, com uma opção por
linha. Um sinal de confirmação destaca cada escolha aceita. Digite `b` em
qualquer pergunta para voltar exatamente uma etapa; as respostas anteriores
continuam selecionadas e as etapas seguintes são perguntadas novamente. A
primeira pergunta informa que não há etapa anterior. Voltar não remove uma
biblioteca instalada nem altera arquivos do projeto. A pergunta final de
aplicação é separada e tem resposta padrão não.

A abertura animada 2D LF é breve e executa uma vez (até 600 ms). Durante o
bootstrap, um indicador compacto ocupa uma linha; a prévia alinhada aparece em
seguida, sem um intervalo grande nem percentuais estimados.

A seleção altera as mensagens do assistente e os documentos novos. Não traduz
arquivos existentes nem muda as referências à biblioteca canônica externa.
O registro anterior é preservado; diferenças de idioma/integração geram aviso.
Revise manualmente instruções e configurações preservadas.
As seções seguintes documentam comandos não interativos para automação;
a saída técnica desses comandos permanece em inglês por compatibilidade.

## 2. Escolher idioma e adapter

As opções são independentes:

| Opção | Valores | Padrão |
| --- | --- | --- |
| Idioma | `en-US`, `pt-BR` | `en-US` |
| Adapter | `codex`, `claude`, `gemini`, `opencode` | Obrigatório |

`pt-BR` instala o template de projeto traduzido. `en-US` usa o conteúdo-fonte
técnico. A cobertura de tradução é registrada em
`locales/pt-BR/TRANSLATION_STATUS.md`.

A distribuição mantém ambos os idiomas. Os quatro módulos suplementares opcionais e os documentos públicos ativos têm espelhos PT-BR. Presença e paridade estrutural não certificam equivalência semântica; consulte `locales/pt-BR/TRANSLATION_STATUS.md` para o escopo revisado.

Todos os adapters instalam os arquivos compartilhados e neutros do projeto. O
adapter selecionado fornece o entrypoint ou a configuração específica do CLI:

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
  --adapter codex \
  --dry-run
```

Depois aplique a instalação:

```sh
sh "$FRAMEWORK_PATH/scripts/bootstrap.sh" \
  --framework-path "$FRAMEWORK_PATH" \
  --target "$TARGET_PATH" \
  --language pt-BR \
  --adapter codex \
  --apply
```

Para instalar no diretório atual, use `--target "$PWD"`. Para inglês, troque
`pt-BR` por `en-US`. Informe em `--adapter` o CLI que você selecionou.

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
  -Adapter codex `
  -DryRun
```

Depois aplique a instalação:

```powershell
& (Join-Path $frameworkPath "scripts\bootstrap.ps1") `
  -FrameworkPath $frameworkPath `
  -TargetPath $targetPath `
  -Language pt-BR `
  -Adapter codex `
  -Apply
```

Para inglês, use `-Language en-US`. `-Adapter` é obrigatório; selecione
`codex`, `claude`, `gemini` ou `opencode`.

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

O projeto instalado contém a base local de coordenação, o entrypoint do adapter
selecionado e cópias localizadas de `START_PROJECTS.md` e
`FIRST_PROMPT_TEMPLATE.md`. Ele também recebe quatro skills curtas de projeto:
`lf-project-onboarding`, `lf-project-planning`, `lf-approved-implementation` e
`lf-delivery-review`. Claude as instala em `.claude/skills/`; Codex, Gemini e
OpenCode usam `.agents/skills/`.

As skills encaminham para os agentes, conhecimentos, workflows, protocolos e
schemas canônicos da biblioteca externa. Consulte a fonte pública e a versão em
`.ai/framework-installation.md`; use o repositório de origem para ler
`knowledge/INDEX.md`, `knowledge/REGISTRY.md` e `.ai/contracts.md`. O bootstrap não copia
`GET_STARTED.md`, as pastas completas do Framework ou skills externas para o
projeto e preserva arquivos já existentes nos destinos dos guias e skills. O
projeto cliente é o único local de implementação. Em projetos web ou visuais, a
validação mobile e desktop continua condicional e separada.

Para iniciar descoberta e planejamento com um assistente de IA usando um prompt
copiável, consulte o [modelo de primeiro prompt](FIRST_PROMPT_TEMPLATE.md). O
modelo é opcional e não substitui este guia de configuração nem os gates de
aprovação do projeto.

## 7. Validação da instalação

Após aplicar:

1. Confirme o idioma em `.ai/framework-installation.md`.
2. Leia `LF_ENGINEERING.md` e `AGENTS.md`.
3. Confirme que `.ai/` e `docs/` existem.
4. Selecione o agente inicial conforme `knowledge/REGISTRY.md`.
5. Para adapters específicos, confirme o arquivo de entrada correspondente.

Consulte `README.md` para a visão geral local do projeto. A fonte pública do
Framework em `.ai/framework-installation.md` identifica a versão dos arquivos
canônicos e do guia em inglês.
