param([switch]$NoAnimation, [switch]$NoColor, [switch]$Help)
$ErrorActionPreference = 'Stop'
$script:authorEmail = 'leandorfernandes1600@gmail.com'
if ($Help) {
  Write-Output '.\setup.ps1 [-NoAnimation] [-NoColor]'
  Write-Output "Author / Autor: Leandro Fernandes <$script:authorEmail>"
  Write-Output 'Automation / Automação: Get-Help .\scripts\bootstrap.ps1'
  return
}
if ([Console]::IsInputRedirected -or [Console]::IsOutputRedirected -or $env:CI) {
  throw 'Interactive terminal required / É necessário um terminal interativo. Automation / Automação: scripts/bootstrap.ps1'
}
$language = 'en-US'
$animated = -not $NoAnimation -and $env:TERM -ne 'dumb'
$colored = -not $NoColor -and $null -eq $env:NO_COLOR -and $env:TERM -ne 'dumb'
try { $script:terminalWidth = [Console]::WindowWidth } catch { $script:terminalWidth = 0 }
if ($script:terminalWidth -lt 1) {
  $script:terminalWidth = 80
  if ($env:COLUMNS -match '^\d+$' -and [int]$env:COLUMNS -gt 0) { $script:terminalWidth = [int]$env:COLUMNS }
}
$isWindowsHost = [Environment]::OSVersion.Platform -eq [PlatformID]::Win32NT
$supportsVirtualTerminal = -not $isWindowsHost -or $env:WT_SESSION -or $env:TERM_PROGRAM -or $env:ConEmuANSI -eq 'ON' -or $env:TERM -match 'xterm|vt100|cygwin|msys'
$script:animateUi = $animated -and $supportsVirtualTerminal -and $script:terminalWidth -ge 44
$script:workFrameDrawn = $false
function Say([string]$English, [string]$Portuguese) {
  if ($language -eq 'pt-BR') { Write-Host $Portuguese } else { Write-Host $English }
}
function Heading([string]$English, [string]$Portuguese) {
  $label = if ($language -eq 'pt-BR') { $Portuguese } else { $English }
  if ($colored) { Write-Host $label -ForegroundColor Cyan } else { Write-Host $label }
}
function Answer([string]$English, [string]$Portuguese) {
  Say $English $Portuguese
  $value = [Console]::ReadLine()
  if ($null -eq $value) { throw 'Cancelled / Cancelado (EOF).' }
  return $value
}
function Write-BrandFrame([int]$Frame, [switch]$Redraw) {
  $emailLine = '|  ' + $script:authorEmail + '      |'
  $rows = switch ($Frame) {
    0 { @('+*-------------------------------------+', '|   LF  /  LF ENGINEERING FRAMEWORK    |', '|       Leandro Fernandes              |', $emailLine, '+--------------------------------------+') }
    1 { @('+--------------------------------------+', '|*  LF  /  LF ENGINEERING FRAMEWORK    |', '|       Leandro Fernandes              |', $emailLine, '+--------------------------------------+') }
    2 { @('+--------------------------------------+', '|   LF  /  LF ENGINEERING FRAMEWORK    |', '|*      Leandro Fernandes              |', $emailLine, '+--------------------------------------+') }
    3 { @('+--------------------------------------+', '|   LF  /  LF ENGINEERING FRAMEWORK    |', '|       Leandro Fernandes              |', ('|* ' + $script:authorEmail + '      |'), '+--------------------------------------+') }
    4 { @('+--------------------------------------+', '|   LF  /  LF ENGINEERING FRAMEWORK    |', '|       Leandro Fernandes              |', $emailLine, '+-------------------------------------*+') }
    default { @('+--------------------------------------+', '|   LF  /  LF ENGINEERING FRAMEWORK    |', '|       Leandro Fernandes              |', $emailLine, '+--------------------------------------+') }
  }
  if ($script:terminalWidth -lt 40) {
    [Console]::WriteLine('LF Engineering Framework')
    [Console]::WriteLine('Leandro Fernandes')
    [Console]::WriteLine($script:authorEmail)
    return
  }
  if ($Redraw) { [Console]::Write(([char]27).ToString() + '[5A') }
  foreach ($row in $rows) {
    if ($Redraw) { [Console]::Write(([char]27).ToString() + '[K') }
    [Console]::WriteLine($row)
  }
}
function Show-Intro {
  if ($script:animateUi) {
    Write-BrandFrame 0
    foreach ($frame in 1..4) {
      Start-Sleep -Milliseconds 120
      Write-BrandFrame $frame -Redraw
    }
    Start-Sleep -Milliseconds 120
  } else {
    Write-BrandFrame -1
  }
}
function Clear-WorkFrame {
  if ($script:workFrameDrawn) {
    [Console]::Write(([char]27).ToString() + '[5A')
    1..5 | ForEach-Object { [Console]::Write(([char]27).ToString() + '[K'); [Console]::WriteLine('') }
    $script:workFrameDrawn = $false
  }
}
$translations = Import-Csv -LiteralPath (Join-Path $PSScriptRoot 'scripts/i18n/setup.tsv') -Delimiter "`t" -Header English,Portuguese -Encoding UTF8
function Show-Line([string]$Line) {
  if ($language -eq 'pt-BR') {
    foreach ($entry in $translations) {
      if ($Line.StartsWith($entry.English, [StringComparison]::Ordinal)) {
        $Line = $entry.Portuguese + $Line.Substring($entry.English.Length)
        break
      }
    }
  }
  Write-Host $Line
}
function Run-Bootstrap([bool]$ApplyChanges) {
  # A local runspace keeps the UI responsive without another installed runtime.
  $runner = [PowerShell]::Create()
  $script = @'
param($Bootstrap, $Root, $Target, $Language, $Adapter, $ApplyChanges)
$ErrorActionPreference = 'Stop'
& $Bootstrap -FrameworkPath $Root -TargetPath $Target -Language $Language -Adapter $Adapter -Apply:$ApplyChanges -DryRun:(-not $ApplyChanges)
'@
  $null = $runner.AddScript($script).AddArgument((Join-Path $PSScriptRoot 'scripts/bootstrap.ps1')).AddArgument($PSScriptRoot).AddArgument($target).AddArgument($language).AddArgument($adapter).AddArgument($ApplyChanges)
  try {
    $pending = $runner.BeginInvoke()
    if ($script:animateUi) {
      Write-BrandFrame 0
      $script:workFrameDrawn = $true
    }
    $index = 1
    while (-not $pending.IsCompleted) {
      Start-Sleep -Milliseconds 150
      if ($script:animateUi -and -not $pending.IsCompleted) {
        Write-BrandFrame ($index % 5) -Redraw
        $index++
      }
    }
    Clear-WorkFrame
    $output = $runner.EndInvoke($pending)
    foreach ($line in $output) { Show-Line ([string]$line) }
    if ($runner.HadErrors) { throw [string]$runner.Streams.Error[0] }
  } catch {
    Show-Line $_.Exception.GetBaseException().Message
    Say 'Setup failed. Correct the cause and run again. Existing files are preserved; interrupted application can leave newly added files.' 'A instalação falhou. Corrija a causa e execute novamente. Arquivos existentes são preservados; uma aplicação interrompida pode deixar arquivos novos.'
    throw
  } finally {
    $runner.Stop()
    $runner.Dispose()
    Clear-WorkFrame
  }
}
try {
Show-Intro
do { $choice = Answer 'Language / Idioma: 1) Português (Brasil)  2) English' 'Language / Idioma: 1) Português (Brasil)  2) English' } while ($choice -notin @('1','2'))
$language = if ($choice -eq '1') { 'pt-BR' } else { 'en-US' }
Heading '1/3 · Project' '1/3 · Projeto'
do { $target = Answer 'Project directory (absolute or relative to your current directory):' 'Diretório do projeto (absoluto ou relativo ao diretório atual):' } while ([string]::IsNullOrWhiteSpace($target))
if ($target -eq '~') { $target = $HOME }
elseif ($target.StartsWith('~/') -or $target.StartsWith('~\')) { $target = Join-Path $HOME $target.Substring(2) }
$target = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($target)
Heading '2/3 · Integration' '2/3 · Integração'
do { $choice = Answer '1) Generic (default)  2) Codex  3) Claude  4) Gemini  5) OpenCode' '1) Genérica (padrão)  2) Codex  3) Claude  4) Gemini  5) OpenCode' } while ($choice -notin @('','1','2','3','4','5'))
$adapter = switch ($choice) { '2' { 'codex' } '3' { 'claude' } '4' { 'gemini' } '5' { 'opencode' } default { 'generic' } }
Heading '3/3 · Review' '3/3 · Revisão'
Run-Bootstrap $false
$record = Join-Path $target '.ai/framework-installation.md'
if (Test-Path -LiteralPath $record -PathType Leaf) {
  $lines = Get-Content -Encoding UTF8 -LiteralPath $record
  if ($lines -notcontains "- Language: $language" -or $lines -notcontains "- Adapter: $adapter") {
    Say 'Warning: the installation record differs. This adds missing files; it does not migrate language or integration. The old record is preserved.' 'Atenção: o registro de instalação difere. Esta operação adiciona arquivos ausentes; não migra idioma ou integração. O registro anterior será preservado.'
  }
}
Say 'Preserved instructions/configuration may need manual reconciliation. Existing state permissions will be restricted to the current user.' 'Instruções/configurações preservadas podem precisar de revisão manual. As permissões do estado existente serão restritas ao usuário atual.'
$choice = Answer 'Apply these changes? [y/N]' 'Aplicar estas alterações? [s/N]'
if (($language -eq 'pt-BR' -and $choice -ieq 's') -or ($language -eq 'en-US' -and $choice -ieq 'y')) {
  Run-Bootstrap $true
  Say 'Next: open the project, read LF_ENGINEERING.md and AGENTS.md, review preserved configuration, then use FIRST_PROMPT_TEMPLATE.md from the Framework.' 'Próximo passo: abra o projeto, leia LF_ENGINEERING.md e AGENTS.md, revise as configurações preservadas e use locales/pt-BR/public-docs/FIRST_PROMPT_TEMPLATE.md do Framework.'
} else { Say 'Cancelled. No project files changed.' 'Cancelado. Nenhum arquivo do projeto foi alterado.' }

} catch {
  Say 'Setup stopped. No existing files were overwritten; review the diagnostic above before retrying.' 'Instalação encerrada. Nenhum arquivo existente foi sobrescrito; revise o diagnóstico acima antes de tentar novamente.'
  exit 1
}
