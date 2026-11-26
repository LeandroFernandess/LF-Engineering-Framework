# LF Engineering Framework — Guia de início

Idioma: [EN-US](../../../GET_STARTED.md) | [Português (Brasil)](GET_STARTED.md)

Este guia instala a biblioteca do Framework separadamente do projeto que irá
utilizá-la. O assistente pergunta primeiro o sistema operacional e depois o
idioma. Essas duas perguntas permanecem em inglês para que a primeira tela seja
clara antes da escolha do idioma.

> **Disponibilidade dos pacotes:** a release `v1.5.0` antecede os seis pacotes por
> sistema/idioma. O instalador funciona quando a release mais recente contém o
> asset correspondente; se não houver um pacote compatível, use a
> [alternativa por checkout completo](#disponibilidade-da-release-e-alternativa-por-checkout).

O instalador de pacotes precisa de conexão com a internet, `curl`, `tar` e uma
ferramenta SHA-256 (`shasum` no macOS; normalmente `sha256sum` no Linux). A
alternativa por checkout completo precisa do Git.

## Instalação recomendada: macOS e Linux

Abra o terminal e baixe o pequeno inicializador do repositório oficial:

```sh
curl -fsSL https://raw.githubusercontent.com/LeandroFernandess/LF-Engineering-Framework/main/setup.sh -o lf-framework-setup.sh
```

Execute-o com o shell do sistema. `sh` funciona no macOS e no Linux; não é
necessário executar `chmod`:

```sh
sh ./lf-framework-setup.sh
```

O inicializador pede que você confirme o sistema detectado, escolha English ou
Português (Brasil), informe uma nova pasta para a biblioteca do Framework e
selecione a pasta do projeto. Em seguida, exige a escolha entre Codex, Claude,
Gemini ou OpenCode. A biblioteca e o projeto devem ficar em pastas
separadas, sem sobreposição.

O assistente lê a lista de checksums da release mais recente, mostra a versão
exata do pacote e o destino e aguarda sua confirmação antes de baixar o arquivo
correspondente ao sistema e idioma. Ele verifica o checksum e o manifesto antes
de instalar. Depois, apresenta uma prévia das mudanças no projeto e pede uma
segunda confirmação, cujo padrão é não. Responda `s` em Português (Brasil) ou
`y` em inglês. Arquivos existentes do projeto são preservados.

Remova o inicializador temporário ao terminar:

```sh
rm -f ./lf-framework-setup.sh
```

Use `--no-animation` para desativar a animação de atividade e `--no-color` para desativar as cores:

```sh
sh ./lf-framework-setup.sh --no-animation --no-color
```

`NO_COLOR` também é respeitado. O cabeçalho exibe os contatos e links do responsável.

## Instalação recomendada: Windows PowerShell

Use Windows PowerShell 5.1 ou PowerShell 7. `Invoke-WebRequest`, `Expand-Archive`
e `Get-FileHash` já fazem parte da instalação PowerShell suportada. Abra o
PowerShell e baixe o inicializador para a pasta temporária:

```powershell
$installer = Join-Path $env:TEMP 'lf-framework-setup.ps1'
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/LeandroFernandess/LF-Engineering-Framework/main/setup.ps1' -OutFile $installer
```

Permita a execução de scripts somente no processo atual do PowerShell, execute
o inicializador e remova o arquivo temporário mesmo se o assistente terminar
com erro:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
try { & $installer } finally { Remove-Item -LiteralPath $installer -Force -ErrorAction SilentlyContinue }
```

Isso não altera a política da máquina nem do usuário. Políticas da organização
ainda podem bloquear scripts. Nesse caso, siga o processo aprovado pelo
administrador em vez de alterar um escopo mais amplo. Consulte a
[referência de políticas de execução da Microsoft](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-7.5).

O assistente pergunta pelo sistema operacional, idioma, uma nova pasta para a
biblioteca do Framework e uma pasta separada para o projeto. Ele mostra versão e
destino antes do download, verifica o checksum e o manifesto e apresenta uma
prévia antes de perguntar se deve aplicar as mudanças. Responda `s` em Português
(Brasil) ou `y` em inglês; a resposta padrão é não. Arquivos existentes do
projeto são preservados.

Para uma interface estática, acrescente `-NoAnimation -NoColor` depois do
caminho do script:

```powershell
try { & $installer -NoAnimation -NoColor } finally { Remove-Item -LiteralPath $installer -Force -ErrorAction SilentlyContinue }
```

## Disponibilidade da release e alternativa por checkout

O instalador por sistema e idioma requer uma release do GitHub com `SHA256SUMS`
e os seis assets correspondentes: macOS, Linux e Windows, cada um em `en-US` e
`pt-BR`. A release `v1.5.0` é anterior a esses assets. Se não houver pacote
compatível, use um checkout completo do código-fonte fora do projeto cliente.

macOS/Linux:

```sh
git clone https://github.com/LeandroFernandess/LF-Engineering-Framework.git "$HOME/Documents/LF-Engineering-Framework"
cd "$HOME/Documents/LF-Engineering-Framework"
sh setup.sh
```

Windows PowerShell:

```powershell
git clone https://github.com/LeandroFernandess/LF-Engineering-Framework.git "$HOME\Documents\LF-Engineering-Framework"
Set-Location "$HOME\Documents\LF-Engineering-Framework"
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\setup.ps1
```

## O que as perguntas significam

Os menus de sistema operacional e idioma aparecem em inglês, com uma opção por
linha. Depois de uma escolha válida, um sinal de confirmação destaca o valor
selecionado. Digite `b` em qualquer pergunta para voltar uma etapa; as respostas
anteriores são mantidas e as etapas posteriores são perguntadas novamente. A
primeira pergunta de sistema informa que não há etapa
anterior. Voltar não remove uma biblioteca do Framework já instalada nem altera
arquivos do projeto. A aplicação final no projeto continua sendo uma confirmação
separada, cujo padrão é não.

1. **Sistema operacional:** escolha o sistema deste terminal. O padrão é o
   sistema detectado; uma escolha diferente é recusada.
2. **Idioma:** escolha `English` ou `Português (Brasil)`. Pressionar Enter
   seleciona English.
3. **Biblioteca do Framework:** no fluxo de download, informe uma nova pasta
   para guardar os arquivos reutilizáveis do Framework.
4. **Projeto:** informe a pasta do projeto cliente, nova ou existente.
5. **Integração:** escolha `codex`, `claude`, `gemini` ou `opencode`. A escolha
   é obrigatória; pressionar Enter não seleciona um padrão.
6. **Revisão:** confira a saída da simulação. Confirme somente quando as
   inclusões corresponderem ao que você espera. A resposta padrão é não.

Use aspas ao informar caminhos em comandos de shell. Nas perguntas de caminho
do assistente, digite o caminho diretamente; espaços são aceitos. Se o programa
indicar que o diretório é inválido, informe um caminho absoluto ou relativo ao
diretório em que o inicializador foi executado.

## Configuração manual e automação

Para conhecer as opções manuais do bootstrap, a preservação de arquivos e a
verificação do projeto, consulte [START_PROJECTS](START_PROJECTS.md).
Os scripts nativos de bootstrap continuam não interativos e usam simulação por
padrão:

```sh
sh scripts/bootstrap.sh --help
```

```powershell
Get-Help .\scripts\bootstrap.ps1
```

## Links do mantenedor

- [Leandro Fernandes — GitHub](https://github.com/LeandroFernandess)
- [Leandro Fernandes — LinkedIn](https://www.linkedin.com/in/leandro-fernandes-951ab3189)
- [E-mail de contato](mailto:leandrofernandes1600@gmail.com)
