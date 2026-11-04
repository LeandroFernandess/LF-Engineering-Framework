param(
  [string]$FrameworkPath = ""
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($FrameworkPath)) {
  $scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path
  $FrameworkPath = Split-Path -Parent $scriptDirectory
}

$FrameworkPath = [System.IO.Path]::GetFullPath($FrameworkPath)

function Fail([string]$Message) {
  throw "Validation failed: $Message"
}

function Require-File([string]$RelativePath) {
  if (-not (Test-Path -LiteralPath (Join-Path $FrameworkPath $RelativePath) -PathType Leaf)) {
    Fail "missing file: $RelativePath"
  }
}

function Require-Directory([string]$RelativePath) {
  if (-not (Test-Path -LiteralPath (Join-Path $FrameworkPath $RelativePath) -PathType Container)) {
    Fail "missing directory: $RelativePath"
  }
}

function Get-MarkdownStructureSignature([string]$Path) {
  $headings = @(
    Get-Content -LiteralPath $Path |
      Where-Object { $_ -match '^#{1,6}\s' } |
      ForEach-Object { ([regex]::Match($_, '^#+')).Value.Length }
  ) -join ","
  $tables = @(Select-String -LiteralPath $Path -Pattern '^\|[\s:|0-9-]+\|[\s]*$').Count
  $fences = @(Select-String -LiteralPath $Path -Pattern '^```').Count
  $content = Get-Content -Raw -LiteralPath $Path
  $comments = "{0} {1}" -f ([regex]::Matches($content, '<!--').Count), ([regex]::Matches($content, '-->').Count)
  return "$headings|$tables|$fences|$comments"
}

@(
  "agents", "knowledge", "workflows", "protocols", "schemas",
  "PROJECT_TEMPLATE", "adapters", "locales", "scripts", "docs", ".github", ".opencode"
) | ForEach-Object { Require-Directory $_ }

@(
  "README.md",
  "README.pt-BR.md",
  "CONTRIBUTING.md",
  "SECURITY.md",
  "TESTING.md",
  "START_PROJECTS.en-US.md",
  "AGENTS.md",
  "LICENSE",
  "CHANGELOG.md",
  "ROADMAP.md",
  "OVERVIEW.md",
  ".gitattributes",
  "docs\ADR.md",
  "docs\reference\LF_DESIGN_PERFORMANCE_GUIDE.md",
  "docs\security-audit\gerar_relatorio.py",
  "docs\security-audit\test_gerar_relatorio.py",
  "docs\security-audit\README.md",
  "docs\security-audit\relatorio-auditoria-seguranca.pdf",
  ".github\workflows\validate.yml",
  ".github\workflows\release.yml",
  ".github\ISSUE_TEMPLATE\bug_report.md",
  ".github\ISSUE_TEMPLATE\feature_request.md",
  ".github\PULL_REQUEST_TEMPLATE.md",
  ".opencode\README.md",
  ".opencode\opencode.jsonc",
  "adapters\README.md",
  "locales\README.md",
  "locales\en-US\README.md",
  "locales\pt-BR\README.md",
  "locales\pt-BR\TRANSLATION_STATUS.md",
  "locales\pt-BR\public-docs\CONTRIBUTING.md",
  "locales\pt-BR\public-docs\SECURITY.md",
  "locales\pt-BR\public-docs\SECURITY_AUDIT.md",
  "locales\pt-BR\public-docs\TESTING.md",
  "locales\pt-BR\public-docs\START_PROJECTS.md",
  "locales\pt-BR\public-docs\CHANGELOG.md",
  "locales\pt-BR\public-docs\ROADMAP.md",
  "locales\pt-BR\public-docs\OVERVIEW.md",
  "locales\pt-BR\docs\ADR.md",
  "PROJECT_TEMPLATE\AGENTS.md",
  "PROJECT_TEMPLATE\LF_ENGINEERING.md",
  "PROJECT_TEMPLATE\README.md",
  "adapters\opencode\opencode.jsonc",
  "scripts\bootstrap.sh",
  "scripts\bootstrap.ps1",
  "scripts\check-locales.sh",
  "scripts\package-release.sh",
  "scripts\validate-framework.sh",
  "scripts\validate-framework.ps1",
  "scripts\test-bootstrap.sh",
  "scripts\test-bootstrap.ps1"
) | ForEach-Object { Require-File $_ }

if (Test-Path -LiteralPath (Join-Path $FrameworkPath "PROJECT_TEMPLATE\opencode.jsonc") -PathType Any) {
  Fail "OpenCode configuration must be optional"
}

$placeholder = "__LF_ENGINEERING_SYSTEM_PATH__"
$placeholderFiles = @(
  Get-ChildItem -LiteralPath (Join-Path $FrameworkPath "PROJECT_TEMPLATE") -Force -Recurse -File |
    Select-String -SimpleMatch $placeholder -List |
    ForEach-Object { $_.Path }
  Get-ChildItem -LiteralPath (Join-Path $FrameworkPath "adapters") -Force -Recurse -File |
    Select-String -SimpleMatch $placeholder -List |
    ForEach-Object { $_.Path }
)
$placeholderFiles = @($placeholderFiles | Sort-Object -Unique | ForEach-Object {
  $_.Substring($FrameworkPath.Length + 1).Replace([System.IO.Path]::DirectorySeparatorChar, "/")
})
$expectedPlaceholders = @(
  "PROJECT_TEMPLATE/LF_ENGINEERING.md",
  "adapters/opencode/opencode.jsonc"
)
if ((Compare-Object $expectedPlaceholders $placeholderFiles).Count -gt 0) {
  Fail "unexpected Framework placeholders"
}

$sourceRoot = Join-Path $FrameworkPath "PROJECT_TEMPLATE"
$ptRoot = Join-Path $FrameworkPath "locales\pt-BR\PROJECT_TEMPLATE"
$sourceFiles = @(Get-ChildItem -LiteralPath $sourceRoot -Force -Recurse -File |
  Where-Object { $_.Name -ne ".gitignore" } |
  ForEach-Object { $_.FullName.Substring($sourceRoot.Length + 1).Replace("\", "/") } |
  Sort-Object)
$ptFiles = @(Get-ChildItem -LiteralPath $ptRoot -Force -Recurse -File |
  ForEach-Object { $_.FullName.Substring($ptRoot.Length + 1).Replace("\", "/") } |
  Sort-Object)
if ((Compare-Object $sourceFiles $ptFiles).Count -gt 0) {
  Fail "PT-BR template file parity failed"
}

foreach ($relativePath in $sourceFiles) {
  $sourcePath = Join-Path $sourceRoot ($relativePath.Replace("/", "\"))
  $ptPath = Join-Path $ptRoot ($relativePath.Replace("/", "\"))
  $sourceHeadingOutline = (@(
    Get-Content -LiteralPath $sourcePath |
      Where-Object { $_ -match '^#{1,6}\s' } |
      ForEach-Object { ([regex]::Match($_, '^#+')).Value.Length }
  )) -join ","
  $ptHeadingOutline = (@(
    Get-Content -LiteralPath $ptPath |
      Where-Object { $_ -match '^#{1,6}\s' } |
      ForEach-Object { ([regex]::Match($_, '^#+')).Value.Length }
  )) -join ","
  if ($sourceHeadingOutline -ne $ptHeadingOutline) {
    Fail "PT-BR heading structure parity failed: $relativePath"
  }

  $sourceTableSeparators = @(Select-String -LiteralPath $sourcePath -Pattern '^\|[\s:|0-9-]+\|[\s]*$').Count
  $ptTableSeparators = @(Select-String -LiteralPath $ptPath -Pattern '^\|[\s:|0-9-]+\|[\s]*$').Count
  if ($sourceTableSeparators -ne $ptTableSeparators) {
    Fail "PT-BR table structure parity failed: $relativePath"
  }

  $sourceCodeFences = @(Select-String -LiteralPath $sourcePath -Pattern '^```').Count
  $ptCodeFences = @(Select-String -LiteralPath $ptPath -Pattern '^```').Count
  if ($sourceCodeFences -ne $ptCodeFences) {
    Fail "PT-BR code block parity failed: $relativePath"
  }

  $sourceContent = Get-Content -Raw -LiteralPath $sourcePath
  $ptContent = Get-Content -Raw -LiteralPath $ptPath
  $sourceComments = "{0} {1}" -f ([regex]::Matches($sourceContent, '<!--').Count), ([regex]::Matches($sourceContent, '-->').Count)
  $ptComments = "{0} {1}" -f ([regex]::Matches($ptContent, '<!--').Count), ([regex]::Matches($ptContent, '-->').Count)
  if ($sourceComments -ne $ptComments) {
    Fail "PT-BR comment parity failed: $relativePath"
  }
}

foreach ($canonicalRootName in @("agents", "workflows", "protocols", "schemas", "knowledge")) {
  $canonicalSourceRoot = Join-Path $FrameworkPath $canonicalRootName
  $canonicalPtRoot = Join-Path $FrameworkPath "locales\pt-BR\$canonicalRootName"
  $canonicalSourceFiles = @(Get-ChildItem -LiteralPath $canonicalSourceRoot -Force -Recurse -File |
    Where-Object {
      $canonicalRootName -ne "knowledge" -or
      $_.Name -notin @(
        "ENGINEERING_ELEPHANT_GOLDFISH.md",
        "ENGINEERING_AGENT_GRAPH_FLOW.md",
        "ENGINEERING_RTK.md",
        "ENGINEERING_GRAPHIFY.md"
      )
    } |
    ForEach-Object { $_.FullName.Substring($canonicalSourceRoot.Length + 1).Replace("\", "/") } |
    Sort-Object)
  $canonicalPtFiles = @(Get-ChildItem -LiteralPath $canonicalPtRoot -Force -Recurse -File |
    Where-Object {
      $canonicalRootName -ne "knowledge" -or
      $_.Name -notin @(
        "ENGINEERING_ELEPHANT_GOLDFISH.md",
        "ENGINEERING_AGENT_GRAPH_FLOW.md",
        "ENGINEERING_RTK.md",
        "ENGINEERING_GRAPHIFY.md"
      )
    } |
    ForEach-Object { $_.FullName.Substring($canonicalPtRoot.Length + 1).Replace("\", "/") } |
    Sort-Object)
  if ((Compare-Object $canonicalSourceFiles $canonicalPtFiles).Count -gt 0) {
    Fail "PT-BR $canonicalRootName file parity failed"
  }

  foreach ($relativePath in $canonicalSourceFiles) {
    $sourcePath = Join-Path $canonicalSourceRoot ($relativePath.Replace("/", "\"))
    $ptPath = Join-Path $canonicalPtRoot ($relativePath.Replace("/", "\"))
    $sourceHeadingOutline = (@(
      Get-Content -LiteralPath $sourcePath |
        Where-Object { $_ -match '^#{1,6}\s' } |
        ForEach-Object { ([regex]::Match($_, '^#+')).Value.Length }
    )) -join ","
    $ptHeadingOutline = (@(
      Get-Content -LiteralPath $ptPath |
        Where-Object { $_ -match '^#{1,6}\s' } |
        ForEach-Object { ([regex]::Match($_, '^#+')).Value.Length }
    )) -join ","
    if ($sourceHeadingOutline -ne $ptHeadingOutline) {
      Fail "PT-BR $canonicalRootName heading structure parity failed: $relativePath"
    }

    $sourceTableSeparators = @(Select-String -LiteralPath $sourcePath -Pattern '^\|[\s:|0-9-]+\|[\s]*$').Count
    $ptTableSeparators = @(Select-String -LiteralPath $ptPath -Pattern '^\|[\s:|0-9-]+\|[\s]*$').Count
    if ($sourceTableSeparators -ne $ptTableSeparators) {
      Fail "PT-BR $canonicalRootName table structure parity failed: $relativePath"
    }

    $sourceCodeFences = @(Select-String -LiteralPath $sourcePath -Pattern '^```').Count
    $ptCodeFences = @(Select-String -LiteralPath $ptPath -Pattern '^```').Count
    if ($sourceCodeFences -ne $ptCodeFences) {
      Fail "PT-BR $canonicalRootName code block parity failed: $relativePath"
    }

    $sourceContent = Get-Content -Raw -LiteralPath $sourcePath
    $ptContent = Get-Content -Raw -LiteralPath $ptPath
    $sourceComments = "{0} {1}" -f ([regex]::Matches($sourceContent, '<!--').Count), ([regex]::Matches($sourceContent, '-->').Count)
    $ptComments = "{0} {1}" -f ([regex]::Matches($ptContent, '<!--').Count), ([regex]::Matches($ptContent, '-->').Count)
    if ($sourceComments -ne $ptComments) {
      Fail "PT-BR $canonicalRootName comment parity failed: $relativePath"
    }
  }
}

$publicDocumentPairs = @(
  @{ Source = "OVERVIEW.md"; Pt = "locales\pt-BR\public-docs\OVERVIEW.md" },
  @{ Source = "ROADMAP.md"; Pt = "locales\pt-BR\public-docs\ROADMAP.md" },
  @{ Source = "CHANGELOG.md"; Pt = "locales\pt-BR\public-docs\CHANGELOG.md" },
  @{ Source = "docs\security-audit\README.md"; Pt = "locales\pt-BR\public-docs\SECURITY_AUDIT.md" },
  @{ Source = "docs\ADR.md"; Pt = "locales\pt-BR\docs\ADR.md" }
)
foreach ($pair in $publicDocumentPairs) {
  $sourceDocumentPath = Join-Path $FrameworkPath $pair.Source
  $ptDocumentPath = Join-Path $FrameworkPath $pair.Pt
  $sourceSignature = Get-MarkdownStructureSignature $sourceDocumentPath
  $ptSignature = Get-MarkdownStructureSignature $ptDocumentPath
  if ($sourceSignature -ne $ptSignature) {
    Fail "PT-BR public document structure parity failed: $($pair.Pt)"
  }
}

foreach ($moduleName in @(
  "ENGINEERING_ELEPHANT_GOLDFISH",
  "ENGINEERING_AGENT_GRAPH_FLOW",
  "ENGINEERING_RTK",
  "ENGINEERING_GRAPHIFY"
)) {
  $sourceModulePath = Join-Path $FrameworkPath "knowledge\$moduleName.md"
  $ptModulePath = Join-Path $FrameworkPath "locales\pt-BR\knowledge\$moduleName.md"
  $sourceModuleContent = Get-Content -Raw -LiteralPath $sourceModulePath
  if ($sourceModuleContent -notmatch '(?m)^Status: Approved Optional\s*$') {
    Fail "Supplemental Knowledge module must remain Approved Optional: knowledge\$moduleName.md"
  }
  if (-not (Test-Path -LiteralPath $ptModulePath -PathType Leaf)) {
    Fail "Missing PT-BR mirror for approved optional Knowledge module: locales\pt-BR\knowledge\$moduleName.md"
  }
  $ptModuleContent = Get-Content -Raw -LiteralPath $ptModulePath
  $sourceVersion = [regex]::Match($sourceModuleContent, '(?m)^Version: ([0-9]+\.[0-9]+\.[0-9]+)\s*$')
  $ptVersion = [regex]::Match($ptModuleContent, '(?m)^Versão: ([0-9]+\.[0-9]+\.[0-9]+)\s*$')
  if (-not $sourceVersion.Success -or -not $ptVersion.Success -or
      $sourceVersion.Groups[1].Value -ne $ptVersion.Groups[1].Value) {
    Fail "Approved optional PT-BR version mismatch: $moduleName"
  }
  if ($ptModuleContent -notmatch '(?m)^Status: Opcional aprovado\s*$') {
    Fail "PT-BR supplemental mirror must retain approved optional status: $moduleName"
  }
  if ((Get-MarkdownStructureSignature $sourceModulePath) -ne
      (Get-MarkdownStructureSignature $ptModulePath)) {
    Fail "Approved optional PT-BR Knowledge structure parity failed: $moduleName"
  }
}

$statusPath = Join-Path $FrameworkPath "locales\pt-BR\TRANSLATION_STATUS.md"
if (-not (Select-String -LiteralPath $statusPath -SimpleMatch "**Versão da fonte:** 1.5.0" -Quiet)) {
  Fail "PT-BR translation source version is missing or stale"
}

$configPath = Join-Path $FrameworkPath "adapters\opencode\opencode.jsonc"
$configContent = Get-Content -Raw -LiteralPath $configPath
$escapedFrameworkPath = $FrameworkPath.Replace('\', '\\')
$configContent = $configContent.Replace($placeholder, $escapedFrameworkPath)
$null = $configContent | ConvertFrom-Json -ErrorAction Stop

$frameworkConfigPath = Join-Path $FrameworkPath ".opencode\opencode.jsonc"
$frameworkConfig = Get-Content -Raw -LiteralPath $frameworkConfigPath | ConvertFrom-Json -ErrorAction Stop
$githubServer = $frameworkConfig.mcp.servers.github
if ($githubServer.type -ne "local" -or $githubServer.disabled -ne $true) {
  Fail "Framework-side GitHub MCP server must be local and disabled by default"
}

$githubCommand = @($githubServer.command)
$requiredGitHubArguments = @(
  "127.0.0.1:8085:8085",
  "GITHUB_OAUTH_CALLBACK_PORT=8085",
  "GITHUB_OAUTH_SCOPES=public_repo",
  "GITHUB_TOOLSETS=repos",
  "GITHUB_READ_ONLY=true"
)
foreach ($argument in $requiredGitHubArguments) {
  if ($githubCommand -notcontains $argument) {
    Fail "Framework-side GitHub MCP configuration is missing required safe setting: $argument"
  }
}

$githubImage = @($githubCommand | Where-Object { $_ -like "ghcr.io/github/github-mcp-server:*" })
if ($githubCommand[0] -ne "docker" -or $githubCommand[1] -ne "run" -or
    $githubImage.Count -ne 1 -or $githubImage[0] -notmatch '^ghcr\.io/github/github-mcp-server:v\d+\.\d+\.\d+$') {
  Fail "Framework-side GitHub MCP configuration must use Docker and a pinned release image"
}

Write-Output "Framework validation passed."
