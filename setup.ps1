param([switch]$NoAnimation, [switch]$NoColor, [switch]$Help)
$ErrorActionPreference = 'Stop'
$script:RepositoryUrl = 'https://github.com/LeandroFernandess/LF-Engineering-Framework'
$script:ReleaseDownloadUrl = "$script:RepositoryUrl/releases/latest/download"
$script:Author = 'Leandro Fernandes'
$script:AuthorEmail = 'leandrofernandes1600@gmail.com'
$script:GitHubUrl = 'https://github.com/LeandroFernandess'
$script:LinkedInUrl = 'https://www.linkedin.com/in/leandro-fernandes-951ab3189'
$script:Language = 'en-US'
$script:TempRoot = $null
$script:InstallStage = $null

if ($Help) {
  Write-Output '.\setup.ps1 [-NoAnimation] [-NoColor]'
  Write-Output "Author: $script:Author <$script:AuthorEmail>"
  Write-Output "GitHub: $script:GitHubUrl"
  Write-Output "LinkedIn: $script:LinkedInUrl"
  Write-Output 'Automation: Get-Help .\scripts\bootstrap.ps1'
  return
}
if ([Console]::IsInputRedirected -or [Console]::IsOutputRedirected -or $env:CI) {
  throw 'Interactive terminal required. Automation: scripts/bootstrap.ps1'
}

$script:HostPlatform = 'unsupported'
if ($env:OS -eq 'Windows_NT' -or [Environment]::OSVersion.Platform -eq [PlatformID]::Win32NT) {
  $script:HostPlatform = 'windows'
} elseif (Test-Path -LiteralPath '/System/Library/CoreServices/SystemVersion.plist') {
  $script:HostPlatform = 'macos'
} else {
  $uname = Get-Command uname -ErrorAction SilentlyContinue
  if ($null -ne $uname) {
    $unameValue = (& $uname.Source -s 2>$null | Out-String).Trim()
    if ($unameValue -eq 'Linux') { $script:HostPlatform = 'linux' }
    elseif ($unameValue -eq 'Darwin') { $script:HostPlatform = 'macos' }
  }
}
if ($script:HostPlatform -eq 'unsupported') { throw 'This installer supports macOS, Linux and Windows terminals.' }

$script:Animated = -not $NoAnimation -and $env:TERM -ne 'dumb'
$script:Colored = -not $NoColor -and [string]::IsNullOrEmpty($env:NO_COLOR) -and $env:TERM -ne 'dumb'
try { $script:TerminalWidth = [Console]::WindowWidth } catch { $script:TerminalWidth = 0 }
if ($script:TerminalWidth -lt 1) {
  $script:TerminalWidth = 80
  if ($env:COLUMNS -match '^\d+$' -and [int]$env:COLUMNS -gt 0) { $script:TerminalWidth = [int]$env:COLUMNS }
}
$isWindowsHost = $script:HostPlatform -eq 'windows'
$supportsVirtualTerminal = -not $isWindowsHost -or $env:WT_SESSION -or $env:TERM_PROGRAM -or $env:ConEmuANSI -eq 'ON' -or $env:TERM -match 'xterm|vt100|cygwin|msys'
$script:AnimateUi = $script:Animated -and $supportsVirtualTerminal -and $script:TerminalWidth -ge 78
$script:WorkFrameDrawn = $false

function Write-EnglishPrompt([string]$Text) {
  Write-HighlightedPromptText $Text
  Write-Host -NoNewline '> '
  $value = [Console]::ReadLine()
  if ($null -eq $value) { throw 'Cancelled (EOF).' }
  return $value
}
function Say([string]$English, [string]$Portuguese) {
  if ($script:Language -eq 'pt-BR') { Write-HighlightedPromptText $Portuguese }
  else { Write-HighlightedPromptText $English }
}
function Write-HighlightedPromptText([string]$Text) {
  $pattern = '(?i)b(?:\)\s*(?:Back|Voltar)|:\s*(?:Back|Voltar))'
  $matches = [regex]::Matches($Text, $pattern)
  $position = 0
  foreach ($match in $matches) {
    if ($match.Index -gt $position) {
      [Console]::Write($Text.Substring($position, $match.Index - $position))
    }
    if ($script:Colored) {
      Write-Host -NoNewline $match.Value -ForegroundColor Yellow
    } else {
      [Console]::Write(">>> $($match.Value) <<<")
    }
    $position = $match.Index + $match.Length
  }
  if ($position -lt $Text.Length) { [Console]::Write($Text.Substring($position)) }
  [Console]::WriteLine('')
}
function Heading([string]$English, [string]$Portuguese) {
  $label = if ($script:Language -eq 'pt-BR') { $Portuguese } else { $English }
  if ($script:Colored) { Write-Host $label -ForegroundColor Cyan } else { Write-Host $label }
}
function Write-SectionDivider {
  $ruleWidth = [Math]::Max(1, [Math]::Min(72, $script:TerminalWidth - 4))
  Write-Host ('-' * $ruleWidth)
}
function Answer([string]$English, [string]$Portuguese) {
  Say $English $Portuguese
  Write-Host -NoNewline '> '
  $value = [Console]::ReadLine()
  if ($null -eq $value) { throw 'Cancelled (EOF).' }
  return $value
}

$script:FrameworkRoot = $PSScriptRoot
$localBundle = (Test-Path -LiteralPath (Join-Path $script:FrameworkRoot 'PROJECT_TEMPLATE') -PathType Container) -and
  (Test-Path -LiteralPath (Join-Path $script:FrameworkRoot 'scripts/bootstrap.ps1') -PathType Leaf) -and
  (Test-Path -LiteralPath (Join-Path $script:FrameworkRoot 'adapters') -PathType Container)
$script:PackagePlatform = $null
$script:PackageLanguage = $null
$packageManifestPath = Join-Path $script:FrameworkRoot 'framework-manifest.json'
if ($localBundle -and (Test-Path -LiteralPath $packageManifestPath -PathType Leaf)) {
  try { $packageManifest = Get-Content -Raw -LiteralPath $packageManifestPath | ConvertFrom-Json }
  catch { throw 'The Framework package manifest is invalid.' }
  if ($packageManifest.target_platform -notin @('windows','macos','linux') -or $packageManifest.language -notin @('en-US','pt-BR')) {
    throw 'The Framework package manifest is invalid.'
  }
  $script:PackagePlatform = [string]$packageManifest.target_platform
  $script:PackageLanguage = [string]$packageManifest.language
}

function Selection([string]$Label, [string]$Value) {
  if ($script:Colored) { Write-Host "✓ ${Label}: $Value" -ForegroundColor Green }
  else { [Console]::WriteLine("✓ ${Label}: $Value") }
}
function Select-Platform {
  Write-SectionDivider
  while ($true) {
    $prompt = "Select operating system:`n  1) macOS`n  2) Linux`n  3) Windows`n  b) Back (no previous step)`nPress Enter for the detected host: $script:HostPlatform"
    $choice = Write-EnglishPrompt $prompt
    if ($choice -ieq 'b') { Write-Host 'There is no previous step.'; continue }
    if ([string]::IsNullOrWhiteSpace($choice)) { $script:SelectedPlatform = $script:HostPlatform }
    elseif ($choice -eq '1') { $script:SelectedPlatform = 'macos' }
    elseif ($choice -eq '2') { $script:SelectedPlatform = 'linux' }
    elseif ($choice -eq '3') { $script:SelectedPlatform = 'windows' }
    else { Write-Host 'Choose 1, 2 or 3, or press b.'; continue }
    if ($script:SelectedPlatform -ne $script:HostPlatform) {
      Write-Host "This terminal is running on $script:HostPlatform. Run the matching native installer for the selected operating system."
      continue
    }
    if ($null -ne $script:PackagePlatform -and $script:SelectedPlatform -ne $script:PackagePlatform) {
      Write-Host "This Framework library package is for $script:PackagePlatform."
      continue
    }
    Selection 'System' $script:SelectedPlatform
    return
  }
}
function Select-Language {
  Write-SectionDivider
  while ($true) {
    if ($null -eq $script:PackageLanguage) {
      $prompt = "Select language:`n  1) English (default)`n  2) Português (Brasil)`n  b) Back"
    } else {
      $prompt = "Select language:`n  1) English`n  2) Português (Brasil)`n  b) Back`nPackage language: $script:PackageLanguage"
    }
    $choice = Write-EnglishPrompt $prompt
    if ($choice -ieq 'b') { Select-Platform; continue }
    if ([string]::IsNullOrWhiteSpace($choice) -or $choice -eq '1') { $script:Language = 'en-US' }
    elseif ($choice -eq '2') { $script:Language = 'pt-BR' }
    else { Write-Host 'Choose 1 or 2, or press b.'; continue }
    if ($null -ne $script:PackageLanguage -and $script:Language -ne $script:PackageLanguage) {
      Write-Host "This Framework library contains the $script:PackageLanguage language package. Choose that language to continue."
      continue
    }
    if ($script:Language -eq 'pt-BR') { Selection 'Idioma' 'Português (Brasil)' }
    else { Selection 'Language' 'English' }
    return
  }
}

function Get-BrandRow([string]$Text) { return '│ ' + $Text.PadRight(70) + ' │' }
function Get-BrandCenterRow([string]$Text) {
  $leftPadding = [Math]::Max(0, [int][Math]::Floor((70 - $Text.Length) / 2))
  $rightPadding = [Math]::Max(0, 70 - $leftPadding - $Text.Length)
  return '│ ' + (' ' * $leftPadding) + $Text + (' ' * $rightPadding) + ' │'
}
function Show-Intro {
  if ($script:TerminalWidth -lt 78) {
    if ($script:TerminalWidth -lt 32) { [Console]::WriteLine('LF FRAMEWORK') }
    else { [Console]::WriteLine('LF ENGINEERING FRAMEWORK') }
    [Console]::WriteLine('')
    [Console]::WriteLine($script:AuthorEmail)
    [Console]::WriteLine('github.com/LeandroFernandess')
    [Console]::WriteLine('linkedin.com/in/')
    [Console]::WriteLine('  leandro-fernandes-951ab3189')
    return
  }
  $rows = @(
    ('┌' + ('─' * 72) + '┐'),
    (Get-BrandCenterRow 'LF ENGINEERING FRAMEWORK'),
    (Get-BrandRow "Contact: $script:AuthorEmail"),
    (Get-BrandRow "GitHub: $script:GitHubUrl"),
    (Get-BrandRow "LinkedIn: $script:LinkedInUrl"),
    ('└' + ('─' * 72) + '┘')
  )
  foreach ($row in $rows) {
    if ($script:Colored -and $row -match 'FRAMEWORK') { Write-Host $row -ForegroundColor White }
    elseif ($script:Colored -and ($row -match 'Contact:|GitHub:|LinkedIn:')) { Write-Host $row -ForegroundColor Cyan }
    elseif ($script:Colored -and $row -match '^[┌└]') { Write-Host $row -ForegroundColor DarkCyan }
    else { [Console]::WriteLine($row) }
  }
}
function Write-WorkIndicator([int]$Frame) {
  $symbol = if ($Frame -eq 1) { '•' } else { '·' }
  $label = if ($script:Language -eq 'pt-BR') { 'Trabalhando...' } else { 'Working...' }
  if ($script:AnimateUi) { [Console]::Write("`r" + ([char]27).ToString() + '[K') }
  if ($script:Colored) { Write-Host -NoNewline "$symbol $label" -ForegroundColor Cyan }
  else { [Console]::Write("$symbol $label") }
  if (-not $script:AnimateUi) { [Console]::WriteLine('') }
}
function Clear-WorkIndicator {
  if ($script:WorkFrameDrawn) {
    [Console]::Write("`r" + ([char]27).ToString() + '[K' + "`n")
    $script:WorkFrameDrawn = $false
  }
}
function Resolve-ProspectivePath([string]$Path) {
  if ($Path -eq '~') { $Path = $HOME }
  elseif ($Path.StartsWith('~/') -or $Path.StartsWith('~\')) { $Path = Join-Path $HOME $Path.Substring(2) }
  $full = [System.IO.Path]::GetFullPath($Path)
  $probe = $full
  $suffix = New-Object System.Collections.Generic.List[string]
  while (-not (Test-Path -LiteralPath $probe)) {
    $parent = Split-Path -Parent $probe
    if ([string]::IsNullOrWhiteSpace($parent) -or $parent -eq $probe) { break }
    $leaf = Split-Path -Leaf $probe
    if (-not [string]::IsNullOrWhiteSpace($leaf)) { $suffix.Insert(0, $leaf) }
    $probe = $parent
  }
  if (Test-Path -LiteralPath $probe) { $base = (Resolve-Path -LiteralPath $probe).Path } else { $base = $probe }
  foreach ($part in $suffix) { $base = Join-Path $base $part }
  return [System.IO.Path]::GetFullPath($base)
}
function Test-EntryExists([string]$Path) {
  if (Test-Path -LiteralPath $Path) { return $true }
  return $null -ne (Get-Item -LiteralPath $Path -Force -ErrorAction SilentlyContinue)
}
function Test-PathOverlap([string]$First, [string]$Second) {
  $firstFullPath = [System.IO.Path]::GetFullPath($First)
  $secondFullPath = [System.IO.Path]::GetFullPath($Second)
  if ([string]::Equals($firstFullPath, [System.IO.Path]::GetPathRoot($firstFullPath), [StringComparison]::OrdinalIgnoreCase) -or
      [string]::Equals($secondFullPath, [System.IO.Path]::GetPathRoot($secondFullPath), [StringComparison]::OrdinalIgnoreCase)) { return $true }
  $firstPath = [System.IO.Path]::GetFullPath($First).TrimEnd([char[]]@('\','/'))
  $secondPath = [System.IO.Path]::GetFullPath($Second).TrimEnd([char[]]@('\','/'))
  if ([string]::Equals($firstPath, $secondPath, [StringComparison]::OrdinalIgnoreCase)) { return $true }
  $separator = [System.IO.Path]::DirectorySeparatorChar
  return $firstPath.StartsWith($secondPath + $separator, [StringComparison]::OrdinalIgnoreCase) -or
    $secondPath.StartsWith($firstPath + $separator, [StringComparison]::OrdinalIgnoreCase)
}

try {
  Select-Platform
  Select-Language
  Show-Intro
  Write-Host ''
  if (-not $localBundle -and $script:SelectedPlatform -ne 'windows') {
    Say 'For a standalone macOS/Linux install, download and run setup.sh with sh.' 'Para uma instalação independente no macOS/Linux, baixe e execute setup.sh com sh.'
    exit 1
  }

  $script:PackageInstalledPath = $null
  $script:PackageInstalledPlatform = $null
  $script:PackageInstalledLanguage = $null
  if ($localBundle) {
    $script:ProjectHeading = '1/3 · Project'; $script:ProjectHeadingPt = '1/3 · Projeto'
    $script:IntegrationHeading = '2/3 · Integration'; $script:IntegrationHeadingPt = '2/3 · Integração'
    $script:ReviewHeading = '3/3 · Review'; $script:ReviewHeadingPt = '3/3 · Revisão'
  } else {
    $script:ProjectHeading = '2/4 · Project'; $script:ProjectHeadingPt = '2/4 · Projeto'
    $script:IntegrationHeading = '3/4 · Integration'; $script:IntegrationHeadingPt = '3/4 · Integração'
    $script:ReviewHeading = '4/4 · Review'; $script:ReviewHeadingPt = '4/4 · Revisão'
  }

  function Prompt-FrameworkRoot {
    Write-SectionDivider
    Heading '1/4 · Framework library' '1/4 · Biblioteca do Framework'
    while ($true) {
      $choice = Answer 'Framework installation directory (must not already exist; b: back):' 'Diretório de instalação do Framework (ainda não pode existir; b: voltar):'
      if ($choice -ieq 'b') { Select-Language; continue }
      if ([string]::IsNullOrWhiteSpace($choice)) { Say 'Enter a directory.' 'Informe um diretório.'; continue }
      $candidate = Resolve-ProspectivePath $choice
      if (Test-EntryExists $candidate) {
        if ($candidate -eq $script:PackageInstalledPath -and $script:SelectedPlatform -eq $script:PackageInstalledPlatform -and $script:Language -eq $script:PackageInstalledLanguage) {
          $script:FrameworkRoot = $candidate
          Selection 'Framework library' $candidate
          return
        }
        Say 'That directory already exists; choose a new location.' 'Esse diretório já existe; escolha outro local.'
        continue
      }
      $script:FrameworkRoot = $candidate
      Selection 'Framework library' $candidate
      return
    }
  }

  function Prompt-Project {
    Write-SectionDivider
    Heading $script:ProjectHeading $script:ProjectHeadingPt
    while ($true) {
      $choice = Answer 'Project directory (e.g. C:/Users/name/Projects/app or ./my-project; b: back):' 'Diretório do projeto (ex.: C:/Users/nome/Projetos/app ou ./meu-projeto; b: voltar):'
      if ($choice -ieq 'b') {
        if (-not $localBundle) { Prompt-FrameworkRoot } else { Select-Language }
        continue
      }
      if ([string]::IsNullOrWhiteSpace($choice)) { Say 'Enter a directory.' 'Informe um diretório.'; continue }
      $candidate = Resolve-ProspectivePath $choice
      if (Test-PathOverlap $candidate $script:FrameworkRoot) {
        Say 'The Framework library and project directories must not overlap.' 'A biblioteca do Framework e o projeto não podem se sobrepor.'
        continue
      }
      $script:Target = $candidate
      Selection 'Project' $candidate
      return
    }
  }

  function Prompt-Integration {
    Write-SectionDivider
    Heading $script:IntegrationHeading $script:IntegrationHeadingPt
    while ($true) {
      $promptEn = @('Choose an integration:', '  1) Codex', '  2) Claude', '  3) Gemini', '  4) OpenCode', '  b) Back') -join [Environment]::NewLine
      $promptPt = @('Escolha uma integração:', '  1) Codex', '  2) Claude', '  3) Gemini', '  4) OpenCode', '  b) Voltar') -join [Environment]::NewLine
      $choice = Answer $promptEn $promptPt
      if ($choice -ieq 'b') { Prompt-Project; continue }
      if ($choice -notin @('1', '2', '3', '4')) {
        if ($script:Language -eq 'pt-BR') {
          Write-Host 'Escolha de 1 a 4 ou pressione b. É obrigatório selecionar uma opção.'
        } else {
          Write-Host 'Choose 1–4, or press b. A selection is required.'
        }
        continue
      }
      switch ($choice) {
        '1' { $script:Adapter = 'codex'; $labelEn = 'Codex'; $labelPt = 'Codex'; break }
        '2' { $script:Adapter = 'claude'; $labelEn = 'Claude'; $labelPt = 'Claude'; break }
        '3' { $script:Adapter = 'gemini'; $labelEn = 'Gemini'; $labelPt = 'Gemini'; break }
        '4' { $script:Adapter = 'opencode'; $labelEn = 'OpenCode'; $labelPt = 'OpenCode'; break }
      }
      if ($script:Language -eq 'pt-BR') { Selection 'Integração' $labelPt }
      else { Selection 'Integration' $labelEn }
      return
    }
  }

  function Install-Package {
    if ($localBundle) { return $true }
    if ($script:FrameworkRoot -eq $script:PackageInstalledPath -and
        $script:SelectedPlatform -eq $script:PackageInstalledPlatform -and
        $script:Language -eq $script:PackageInstalledLanguage) {
      return $true
    }
    Say 'Latest release package details:' 'Detalhes do pacote da versão mais recente:'
    if ($null -eq $script:TempRoot) {
      $script:TempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ('lf-framework-' + [guid]::NewGuid().ToString('N'))
      New-Item -ItemType Directory -Path $script:TempRoot | Out-Null
    }
    $checksumPath = Join-Path $script:TempRoot 'SHA256SUMS'
    while ($true) {
      try { Invoke-WebRequest -Uri "$script:ReleaseDownloadUrl/SHA256SUMS" -OutFile $checksumPath -UseBasicParsing | Out-Null }
      catch { throw 'Could not read the latest release checksums. The release may not contain platform packages yet.' }

      $extension = if ($script:SelectedPlatform -eq 'windows') { 'zip' } else { 'tar.gz' }
      $assetPattern = '^lf-engineering-framework-v(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)-' + [regex]::Escape($script:SelectedPlatform) + '-' + [regex]::Escape($script:Language) + '\.' + [regex]::Escape($extension) + '$'
      $assetRecords = @()
      foreach ($line in Get-Content -LiteralPath $checksumPath) {
        $parts = $line.Trim() -split '\s+'
        if ($parts.Count -ge 2) {
          $name = $parts[1].TrimStart('*')
          if ($name -match $assetPattern) {
            $versionGroups = $Matches
            if ($parts[0] -match '^[a-fA-F0-9]{64}$') {
              $assetRecords += [pscustomobject]@{ Hash = $parts[0].ToLowerInvariant(); Name = $name; Version = ('v' + $versionGroups[1] + '.' + $versionGroups[2] + '.' + $versionGroups[3]) }
            }
          }
        }
      }
      if ($assetRecords.Count -ne 1) { throw 'The latest release does not contain exactly one package for this platform and language. No package was installed.' }
      $releasePackage = $assetRecords[0]
      Say "Package: $($releasePackage.Name)" "Pacote: $($releasePackage.Name)"
      Say "Framework version: $($releasePackage.Version)" "Versão do Framework: $($releasePackage.Version)"
      Say "Install location: $script:FrameworkRoot" "Local de instalação: $script:FrameworkRoot"
      $confirmation = Answer 'Download and install this package? [y/N] (b: back)' 'Baixar e instalar este pacote? [s/N] (b: voltar)'
      if ($confirmation -ieq 'b') { Prompt-Integration; continue }
      $downloadApproved = ($script:Language -eq 'en-US' -and $confirmation -in @('y','Y')) -or
        ($script:Language -eq 'pt-BR' -and $confirmation -in @('s','S'))
      if (-not $downloadApproved) {
        Say 'Cancelled. No package was downloaded.' 'Cancelado. Nenhum pacote foi baixado.'
        return $false
      }
      break
    }

    if ($script:Language -eq 'pt-BR') { Selection 'Download' 'aprovado' } else { Selection 'Download' 'approved' }
    $frameworkParent = Split-Path -Parent $script:FrameworkRoot
    New-Item -ItemType Directory -Force -Path $frameworkParent | Out-Null
    if (Test-EntryExists $script:FrameworkRoot) { throw 'The Framework destination now exists; refusing to overwrite it.' }
    $script:InstallStage = Join-Path $frameworkParent ('.lf-framework-install-' + [guid]::NewGuid().ToString('N'))
    New-Item -ItemType Directory -Path $script:InstallStage | Out-Null
    $archivePath = Join-Path $script:TempRoot $releasePackage.Name
    Invoke-WebRequest -Uri "$script:ReleaseDownloadUrl/$($releasePackage.Name)" -OutFile $archivePath -UseBasicParsing | Out-Null
    $actualHash = (Get-FileHash -LiteralPath $archivePath -Algorithm SHA256).Hash.ToLowerInvariant()
    if ($actualHash -ne $releasePackage.Hash) { throw 'Package checksum mismatch. The archive was rejected.' }
    $extractRoot = $script:InstallStage

    if ($script:SelectedPlatform -eq 'windows') {
      Add-Type -AssemblyName System.IO.Compression
      $zip = [System.IO.Compression.ZipFile]::OpenRead($archivePath)
      try {
        foreach ($entry in $zip.Entries) {
          $name = $entry.FullName
          if (-not $name.StartsWith('lf-engineering-framework/', [StringComparison]::Ordinal) -or $name.Contains('\') -or $name.StartsWith('/') -or $name -match '(^|/)\.\.?(/|$)') { throw 'The package contains an unsafe archive path.' }
          $unixType = ($entry.ExternalAttributes -shr 16) -band 0xF000
          if ($unixType -notin @(0,0x8000,0x4000)) { throw 'The package contains an unsupported filesystem entry.' }
        }
      } finally { $zip.Dispose() }
      Expand-Archive -LiteralPath $archivePath -DestinationPath $extractRoot
    } else {
      $tar = Get-Command tar -ErrorAction SilentlyContinue
      if ($null -eq $tar) { throw 'The tar command is required to extract this platform package.' }
      $members = @(& $tar.Source -tzf $archivePath)
      if ($LASTEXITCODE -ne 0 -or $members.Count -eq 0) { throw 'The package archive is invalid.' }
      foreach ($member in $members) {
        if (-not $member.StartsWith('lf-engineering-framework/', [StringComparison]::Ordinal) -or $member -match '(^|/)\.\.?(/|$)' -or $member.Contains('\')) { throw 'The package contains an unsafe archive path.' }
      }
      $details = @(& $tar.Source -tvzf $archivePath)
      if ($LASTEXITCODE -ne 0 -or @($details | Where-Object { -not $_.StartsWith('-') }).Count -gt 0) { throw 'The package contains an unsupported filesystem entry.' }
      & $tar.Source -xzf $archivePath -C $extractRoot
      if ($LASTEXITCODE -ne 0) { throw 'The package could not be extracted.' }
    }

    $stagedRoot = Join-Path $extractRoot 'lf-engineering-framework'
    $manifestPath = Join-Path $stagedRoot 'framework-manifest.json'
    if (-not (Test-Path -LiteralPath $manifestPath -PathType Leaf)) { throw 'The package manifest is missing.' }
    $manifest = Get-Content -Raw -LiteralPath $manifestPath | ConvertFrom-Json
    if ($manifest.framework_version -ne $releasePackage.Version -or
        $manifest.target_platform -ne $script:SelectedPlatform -or $manifest.language -ne $script:Language -or
        -not (Test-Path -LiteralPath (Join-Path $stagedRoot 'PROJECT_TEMPLATE') -PathType Container) -or
        -not (Test-Path -LiteralPath (Join-Path $stagedRoot 'scripts/bootstrap.ps1') -PathType Leaf)) {
      throw 'The package manifest or required Framework files do not match the selection.'
    }
    if (Test-EntryExists $script:FrameworkRoot) { throw 'The Framework destination now exists; refusing to overwrite it.' }
    Move-Item -LiteralPath $stagedRoot -Destination $script:FrameworkRoot
    Remove-Item -LiteralPath $script:InstallStage -Force
    $script:InstallStage = $null
    $script:PackageInstalledPath = $script:FrameworkRoot
    $script:PackageInstalledPlatform = $script:SelectedPlatform
    $script:PackageInstalledLanguage = $script:Language
    Say 'Verified Framework package installed.' 'Pacote verificado do Framework instalado.'
    return $true
  }

  $script:Translations = $null
  $script:TranslationRoot = $null
  function Show-Line([string]$Line) {
    if ($script:TranslationRoot -ne $script:FrameworkRoot) {
      $script:Translations = Import-Csv -LiteralPath (Join-Path $script:FrameworkRoot 'scripts/i18n/setup.tsv') -Delimiter ([char]9) -Header English,Portuguese -Encoding UTF8
      $script:TranslationRoot = $script:FrameworkRoot
    }
    if ($script:Language -eq 'pt-BR') {
      foreach ($entry in $script:Translations) {
        $key = $entry.English.TrimEnd()
        if ($Line.StartsWith($key, [StringComparison]::Ordinal)) {
          $rest = $Line.Substring($key.Length).TrimStart()
          $label = $entry.Portuguese.TrimEnd()
          if ($rest.Length -gt 0 -and ($entry.English.EndsWith(' ') -or $key.EndsWith(':'))) { $Line = "$label $rest" }
          else { $Line = "$label$rest" }
          break
        }
      }
    }
    Write-Host $Line
  }
  function Show-Preview([object[]]$Lines) {
    $additions = @($Lines | Where-Object { ([string]$_) -match '^ADD ' }).Count
    $preserved = @($Lines | Where-Object { ([string]$_) -match '^PRESERVE ' }).Count
    Write-SectionDivider
    Say "Summary: $additions files to add; $preserved existing files to preserve." "Resumo: $additions arquivos para adicionar; $preserved arquivos existentes para preservar."
    $tableShown = $false
    $metadataDividerShown = $false
    $permissionsShown = $false
    $ruleWidth = [Math]::Max(1, [Math]::Min(72, $script:TerminalWidth - 4))
    foreach ($item in $Lines) {
      $line = [string]$item
      if (-not $metadataDividerShown) {
        Write-Host ('-' * $ruleWidth)
        $metadataDividerShown = $true
      }
      if ($line -match '^(ADD|PRESERVE) (.*)$') {
        $status = $Matches[1]
        $path = $Matches[2]
        $label = [System.IO.Path]::GetFileName(($path -replace '\\','/'))
        if ($script:Language -eq 'pt-BR') { $status = if ($status -eq 'ADD') { 'ADICIONAR' } else { 'PRESERVAR' } }
        $maxLabel = if ($script:TerminalWidth -lt 78) { [Math]::Max(4, $script:TerminalWidth - $status.Length - 3) } else { 30 }
        if ($label.Length -gt $maxLabel) { $label = $label.Substring(0, $maxLabel - 3) + '...' }
        if (-not $tableShown) {
          Write-Host ('-' * $ruleWidth)
          if ($permissionsShown) { Say 'Installation record' 'Registro da instalação' }
          else { Say 'Planned file changes' 'Alterações previstas' }
          Write-Host ''
          if ($script:TerminalWidth -lt 78) {
            if ($script:Language -eq 'pt-BR') { Write-Host 'ESTADO / RÓTULO' } else { Write-Host 'STATE / LABEL' }
          } elseif ($script:Language -eq 'pt-BR') { Write-Host ('{0,-12} {1,-30} {2}' -f 'ESTADO', 'RÓTULO', 'CAMINHO') }
          else { Write-Host ('{0,-12} {1,-30} {2}' -f 'STATE', 'LABEL', 'PATH') }
          $tableShown = $true
        }
        if ($script:TerminalWidth -lt 78) {
          Write-Host "[$status] $label"
          if ($script:Language -eq 'pt-BR') { Write-Host "  Caminho: $path" } else { Write-Host "  Path: $path" }
        } else { Write-Host ('{0,-12} {1,-30} {2}' -f $status, $label, $path) }
      } else {
        if (-not $permissionsShown -and ($line -match '^RESTRICT ' -or $line -match '^Secured \.ai/state permissions')) {
          Write-Host ('-' * $ruleWidth)
          Say 'Permissions and installation state' 'Permissões e estado da instalação'
          $permissionsShown = $true
          $tableShown = $false
        }
        Show-Line $line
      }
    }
  }
  function Run-Bootstrap([bool]$ApplyChanges) {
    $runner = [PowerShell]::Create()
    $scriptBlock = @'
param($BootstrapPath, $RootPath, $TargetPath, $LanguageName, $AdapterName, $ApplyChanges)
$ErrorActionPreference = 'Stop'
& $BootstrapPath -FrameworkPath $RootPath -TargetPath $TargetPath -Language $LanguageName -Adapter $AdapterName -Apply:$ApplyChanges -DryRun:(-not $ApplyChanges)
'@
    $bootstrapPath = Join-Path $script:FrameworkRoot 'scripts/bootstrap.ps1'
    $null = $runner.AddScript($scriptBlock).AddArgument($bootstrapPath).AddArgument($script:FrameworkRoot).AddArgument($script:Target).AddArgument($script:Language).AddArgument($script:Adapter).AddArgument($ApplyChanges)
    try {
      $pending = $runner.BeginInvoke()
      if ($script:AnimateUi) { Write-WorkIndicator 0; $script:WorkFrameDrawn = $true }
      $frame = 1
      while (-not $pending.IsCompleted) {
        Start-Sleep -Milliseconds 180
        if ($script:AnimateUi -and -not $pending.IsCompleted) { Write-WorkIndicator $frame; $frame = 1 - $frame }
      }
      Clear-WorkIndicator
      $output = $runner.EndInvoke($pending)
      Show-Preview @($output)
      if ($runner.HadErrors) { throw [string]$runner.Streams.Error[0] }
    } catch {
      Show-Line $_.Exception.GetBaseException().Message
      Say 'Setup failed. Correct the cause and run again. Existing files are preserved; interrupted application can leave newly added files.' 'A instalação falhou. Corrija a causa e execute novamente. Arquivos existentes são preservados; uma aplicação interrompida pode deixar arquivos novos.'
      throw
    } finally {
      $runner.Stop()
      $runner.Dispose()
      Clear-WorkIndicator
    }
  }

  function Review-AndApply {
    while ($true) {
      Write-SectionDivider
      Heading $script:ReviewHeading $script:ReviewHeadingPt
      Run-Bootstrap $false
      $record = Join-Path $script:Target '.ai/framework-installation.md'
      if (Test-Path -LiteralPath $record -PathType Leaf) {
        $recordLines = Get-Content -Encoding UTF8 -LiteralPath $record
        if ($recordLines -notcontains "- Language: $script:Language" -or $recordLines -notcontains "- Adapter: $script:Adapter") {
          Say 'Warning: the installation record differs. This adds missing files; it does not migrate language or integration. The old record is preserved.' 'Atenção: o registro de instalação difere. Esta operação adiciona arquivos ausentes; não migra idioma ou integração. O registro anterior será preservado.'
        }
      }
      Say 'Preserved project instructions and configuration may need manual reconciliation.' 'Instruções e configurações preservadas do projeto podem precisar de revisão manual.'
      $confirmation = Answer 'Apply these changes? [y/N] (b: back)' 'Aplicar estas alterações? [s/N] (b: voltar)'
      if ($confirmation -ieq 'b') {
        Prompt-Integration
        if (-not (Install-Package)) { Say 'Cancelled. No project files changed.' 'Cancelado. Nenhum arquivo do projeto foi alterado.'; return }
        continue
      }
      $approved = ($script:Language -eq 'pt-BR' -and $confirmation -in @('s','S')) -or
        ($script:Language -eq 'en-US' -and $confirmation -in @('y','Y'))
      if (-not $approved) { Say 'Cancelled. No project files changed.' 'Cancelado. Nenhum arquivo do projeto foi alterado.'; return }
      if ($script:Language -eq 'pt-BR') { Selection 'Aplicação' 'aprovada' } else { Selection 'Apply' 'approved' }
      Run-Bootstrap $true
      Say 'Next: open the project, read LF_ENGINEERING.md and AGENTS.md, review preserved configuration, then use the local START_PROJECTS.md and FIRST_PROMPT_TEMPLATE.md guides.' 'Próximo passo: abra o projeto, leia LF_ENGINEERING.md e AGENTS.md, revise as configurações preservadas e use os guias locais START_PROJECTS.md e FIRST_PROMPT_TEMPLATE.md.'
      return
    }
  }

  if (-not $localBundle) { Prompt-FrameworkRoot }
  Prompt-Project
  Prompt-Integration
  if (-not (Install-Package)) { exit 0 }
  Review-AndApply
} catch {
  Clear-WorkIndicator
  Write-Host $_.Exception.GetBaseException().Message -ForegroundColor Red
  Say 'Setup stopped. No existing files were overwritten; review the diagnostic before retrying.' 'Instalação encerrada. Nenhum arquivo existente foi sobrescrito; revise o diagnóstico antes de tentar novamente.'
  exit 1
} finally {
  if ($null -ne $script:TempRoot -and (Test-Path -LiteralPath $script:TempRoot)) { Remove-Item -LiteralPath $script:TempRoot -Recurse -Force }
  if ($null -ne $script:InstallStage -and (Test-Path -LiteralPath $script:InstallStage)) { Remove-Item -LiteralPath $script:InstallStage -Recurse -Force }
}
