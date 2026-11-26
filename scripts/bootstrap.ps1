param(
  [string]$FrameworkPath = "",
  [string]$TargetPath = (Get-Location).Path,
  [ValidateSet("en-US", "pt-BR")]
  [string]$Language = "en-US",
  [string]$Adapter,
  [switch]$Apply,
  [switch]$DryRun
)

$ErrorActionPreference = "Stop"

function Resolve-BoundaryPath([string]$Path) {
  $fullPath = [System.IO.Path]::GetFullPath($Path)
  $probe = $fullPath
  $suffix = New-Object System.Collections.Generic.List[string]

  while ($true) {
    if (Test-Path -LiteralPath $probe -PathType Any) {
      $item = Get-Item -LiteralPath $probe -Force -ErrorAction Stop
      $resolvedLink = $null

      $isFileSystemRoot = [string]::Equals(
        $probe,
        [System.IO.Path]::GetPathRoot($probe),
        [System.StringComparison]::OrdinalIgnoreCase
      )

      if (-not $isFileSystemRoot -and
          $item.PSObject.Methods.Name -contains "ResolveLinkTarget") {
        $targetInfo = $item.ResolveLinkTarget($true)
        if ($null -ne $targetInfo) {
          $resolvedLink = $targetInfo.FullName
        }
      }

      if ([string]::IsNullOrWhiteSpace($resolvedLink) -and
          $item.PSObject.Properties.Name -contains "Target") {
        $rawTarget = @($item.Target)
        if ($rawTarget.Count -gt 0 -and
            -not [string]::IsNullOrWhiteSpace([string]$rawTarget[0])) {
          $resolvedLink = [string]$rawTarget[0]
          if (-not [System.IO.Path]::IsPathRooted($resolvedLink)) {
            $resolvedLink = Join-Path (Split-Path -Parent $probe) $resolvedLink
          }
        }
      }

      if (-not [string]::IsNullOrWhiteSpace($resolvedLink)) {
        $canonicalPath = Resolve-BoundaryPath $resolvedLink
        foreach ($part in $suffix) {
          $canonicalPath = Join-Path $canonicalPath $part
        }
        return [System.IO.Path]::GetFullPath($canonicalPath)
      }
    }

    $parent = Split-Path -Parent $probe
    if ([string]::IsNullOrWhiteSpace($parent) -or $parent -eq $probe) {
      break
    }

    $leaf = Split-Path -Leaf $probe
    if (-not [string]::IsNullOrWhiteSpace($leaf)) {
      $suffix.Insert(0, $leaf)
    }
    $probe = $parent
  }

  return $fullPath
}

if ($DryRun) {
  $Apply = $false
}

if ([string]::IsNullOrWhiteSpace($Adapter)) {
  throw "Adapter is required. Choose codex, claude, gemini or opencode."
}
if ($Adapter -notin @("codex", "claude", "gemini", "opencode")) {
  throw "Adapter is not supported: $Adapter"
}

if ([string]::IsNullOrWhiteSpace($FrameworkPath)) {
  $scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path
  $FrameworkPath = Split-Path -Parent $scriptDirectory
}

$FrameworkPath = Resolve-BoundaryPath $FrameworkPath
$TargetPath = Resolve-BoundaryPath $TargetPath
$script:FrameworkRepository = "https://github.com/LeandroFernandess/LF-Engineering-Framework"
$script:FrameworkRef = "main"
$frameworkManifestPath = Join-Path $FrameworkPath "framework-manifest.json"
if (Test-Path -LiteralPath $frameworkManifestPath -PathType Leaf) {
  try { $frameworkManifest = Get-Content -Raw -LiteralPath $frameworkManifestPath | ConvertFrom-Json }
  catch { throw "Framework package manifest is invalid." }
  $manifestVersion = [string]$frameworkManifest.framework_version
  if ($manifestVersion -notmatch '^v?(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$') {
    throw "Framework package manifest version is invalid."
  }
  $script:FrameworkRef = $manifestVersion
}
$templatePath = Join-Path $FrameworkPath "PROJECT_TEMPLATE"
$localeTemplatePath = Join-Path $FrameworkPath "locales\$Language\PROJECT_TEMPLATE"

$frameworkPrefix = $FrameworkPath.TrimEnd('\', '/') + [System.IO.Path]::DirectorySeparatorChar
if ($TargetPath -eq $FrameworkPath -or $TargetPath.StartsWith($frameworkPrefix, [System.StringComparison]::OrdinalIgnoreCase)) {
  throw "The target project must be outside the Framework directory."
}

if (-not (Test-Path -LiteralPath $templatePath -PathType Container)) {
  throw "PROJECT_TEMPLATE was not found under $FrameworkPath."
}

if ((Test-Path -LiteralPath $TargetPath -PathType Any) -and
    -not (Test-Path -LiteralPath $TargetPath -PathType Container)) {
  throw "The target path must be a directory: $TargetPath"
}

if ($Language -eq 'pt-BR' -and -not (Test-Path -LiteralPath $localeTemplatePath -PathType Container)) {
  throw "Localized template was not found: $localeTemplatePath"
}
if ($Apply) {
  & $PSCommandPath -FrameworkPath $FrameworkPath -TargetPath $TargetPath -Language $Language -Adapter $Adapter -DryRun | Out-Null
  New-Item -ItemType Directory -Force -Path $TargetPath | Out-Null
}

$pathComparison = [System.StringComparison]::Ordinal
if ($env:OS -eq "Windows_NT") {
  $pathComparison = [System.StringComparison]::OrdinalIgnoreCase
}
$targetPrefix = $TargetPath
if (-not $targetPrefix.EndsWith([string][System.IO.Path]::DirectorySeparatorChar) -and
    -not $targetPrefix.EndsWith([string][System.IO.Path]::AltDirectorySeparatorChar)) {
  $targetPrefix += [System.IO.Path]::DirectorySeparatorChar
}

function Assert-SafeTargetParent([string]$Destination) {
  $parentPath = [System.IO.Path]::GetFullPath((Split-Path -Parent $Destination))

  while (-not [string]::Equals($parentPath, $TargetPath, $pathComparison)) {
    if (-not $parentPath.StartsWith($targetPrefix, $pathComparison)) {
      throw "Destination escapes the target project directory: $Destination"
    }

    $entry = Get-Item -LiteralPath $parentPath -Force -ErrorAction SilentlyContinue
    if ($null -ne $entry) {
      if (-not $entry.PSIsContainer) {
        throw "The target path must be a directory: $parentPath"
      }
      $isLinkedDirectory =
        ($entry.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -ne 0
      if ($entry.PSObject.Properties.Name -contains "LinkType" -and
          -not [string]::IsNullOrWhiteSpace([string]$entry.LinkType)) {
        $isLinkedDirectory = $true
      }
      if ($isLinkedDirectory) {
        throw "Refusing to write through a linked target directory: $parentPath"
      }
    }

    $nextParentPath = Split-Path -Parent $parentPath
    if ([string]::IsNullOrWhiteSpace($nextParentPath) -or $nextParentPath -eq $parentPath) {
      throw "Destination is outside the target project directory: $Destination"
    }
    $parentPath = $nextParentPath
  }
}

function Set-UnixFileModeByName([string]$Path, [string]$ModeName) {
  $modeType = [System.Type]::GetType("System.IO.UnixFileMode")
  if ($null -eq $modeType) {
    throw "This runtime cannot set owner-only Unix permissions for local state."
  }

  $parameterTypes = [System.Type[]]@([string], $modeType)
  $method = [System.IO.File].GetMethod("SetUnixFileMode", $parameterTypes)
  if ($null -eq $method) {
    throw "This runtime cannot set owner-only Unix permissions for local state."
  }

  $mode = [System.Enum]::Parse($modeType, $ModeName)
  $null = $method.Invoke($null, @($Path, $mode))
}

function Set-WindowsOwnerOnlyAccess([string]$Path, [bool]$IsDirectory) {
  $ownerSid = [System.Security.Principal.WindowsIdentity]::GetCurrent().User
  $acl = Get-Acl -LiteralPath $Path
  $acl.SetAccessRuleProtection($true, $false)
  foreach ($existingRule in @($acl.Access)) {
    $null = $acl.RemoveAccessRuleAll($existingRule)
  }
  $acl.SetOwner($ownerSid)

  $inheritanceFlags = [System.Security.AccessControl.InheritanceFlags]::None
  if ($IsDirectory) {
    $inheritanceFlags = [System.Security.AccessControl.InheritanceFlags]::ContainerInherit -bor
      [System.Security.AccessControl.InheritanceFlags]::ObjectInherit
  }
  $ownerRule = [System.Security.AccessControl.FileSystemAccessRule]::new(
    $ownerSid,
    [System.Security.AccessControl.FileSystemRights]::FullControl,
    $inheritanceFlags,
    [System.Security.AccessControl.PropagationFlags]::None,
    [System.Security.AccessControl.AccessControlType]::Allow
  )
  $acl.AddAccessRule($ownerRule)
  Set-Acl -LiteralPath $Path -AclObject $acl
}

function Protect-LocalState {
  $stateDirectory = Join-Path $TargetPath ".ai\state"
  $sourceStateDirectory = Join-Path $templatePath ".ai\state"
  $localizedStateDirectory = Join-Path $localeTemplatePath ".ai\state"
  $hasStateTemplate =
    (Test-Path -LiteralPath $sourceStateDirectory -PathType Container) -or
    (Test-Path -LiteralPath $localizedStateDirectory -PathType Container)

  if (-not $hasStateTemplate -and
      -not (Test-Path -LiteralPath $stateDirectory -PathType Container)) {
    return
  }

  Assert-SafeTargetParent (Join-Path $stateDirectory ".owner-only-permissions")
  if (-not $Apply) {
    Write-Output "RESTRICT .ai/state to owner-only permissions (0700 directories, 0600 files)"
    return
  }
  if (-not (Test-Path -LiteralPath $stateDirectory -PathType Container)) {
    throw "Local state directory was not created: $stateDirectory"
  }

  if ($env:OS -eq "Windows_NT") {
    Set-WindowsOwnerOnlyAccess $stateDirectory $true
  } else {
    Set-UnixFileModeByName $stateDirectory "UserRead, UserWrite, UserExecute"
  }

  $pendingDirectories = New-Object 'System.Collections.Generic.Stack[string]'
  $pendingDirectories.Push($stateDirectory)
  while ($pendingDirectories.Count -gt 0) {
    $currentDirectory = $pendingDirectories.Pop()
    foreach ($entry in Get-ChildItem -LiteralPath $currentDirectory -Force) {
      if (($entry.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -ne 0) {
        continue
      }
      if ($entry.PSIsContainer) {
        if ($env:OS -eq "Windows_NT") {
          Set-WindowsOwnerOnlyAccess $entry.FullName $true
        } else {
          Set-UnixFileModeByName $entry.FullName "UserRead, UserWrite, UserExecute"
        }
        $pendingDirectories.Push($entry.FullName)
      } elseif ($env:OS -eq "Windows_NT") {
        Set-WindowsOwnerOnlyAccess $entry.FullName $false
      } else {
        Set-UnixFileModeByName $entry.FullName "UserRead, UserWrite"
      }
    }
  }
  Write-Output "Secured .ai/state permissions for the current user."
}

function Copy-TreeMissingOnly {
  param([string]$SourceRoot)

  if (-not (Test-Path -LiteralPath $SourceRoot -PathType Container)) {
    return
  }

  $entries = Get-ChildItem -LiteralPath $SourceRoot -Force -Recurse |
    Sort-Object { $_.FullName.Length }

  foreach ($entry in $entries) {
    $relativePath = $entry.FullName.Substring($SourceRoot.Length).TrimStart('\', '/')
    $portableRelativePath = $relativePath -replace '\\', '/'
    if ($portableRelativePath -in @('docs/DESIGN.md', 'docs/PERFORMANCE_VALIDATION_REPORT.md', 'docs/TECH_DEBT_AUDIT.md')) {
      continue
    }
    if ($SourceRoot -eq $templatePath -and (Test-Path -LiteralPath (Join-Path $localeTemplatePath $relativePath))) {
      continue
    }
    $destination = Join-Path $TargetPath $relativePath

    if (Test-Path -LiteralPath $destination -PathType Any) {
      Write-Output "PRESERVE $relativePath"
      continue
    }

    Assert-SafeTargetParent $destination
    if (-not $Apply) {
      Write-Output "ADD $relativePath"
    } elseif ($entry.PSIsContainer) {
      New-Item -ItemType Directory -Force -Path $destination | Out-Null
    } else {
      $parent = Split-Path -Parent $destination
      New-Item -ItemType Directory -Force -Path $parent | Out-Null
      Copy-Item -LiteralPath $entry.FullName -Destination $destination
    }
  }
}

function Copy-AdapterFile {
  param([string]$SourcePath, [string]$RelativePath)

  if (-not (Test-Path -LiteralPath $SourcePath -PathType Leaf)) {
    throw "Adapter file was not found: $SourcePath"
  }

  $destination = Join-Path $TargetPath $RelativePath
  if (Test-Path -LiteralPath $destination -PathType Any) {
    Write-Output "PRESERVE $RelativePath"
  } elseif (-not $Apply) {
    Assert-SafeTargetParent $destination
    Write-Output "ADD $RelativePath"
  } else {
    Assert-SafeTargetParent $destination
    $parent = Split-Path -Parent $destination
    New-Item -ItemType Directory -Force -Path $parent | Out-Null
    Copy-Item -LiteralPath $SourcePath -Destination $destination
  }
}

function Get-FrameworkDocumentUrl([string]$RelativePath) {
  return "$script:FrameworkRepository/blob/$script:FrameworkRef/$RelativePath"
}

function Copy-ProjectFile([string]$SourcePath, [string]$RelativePath) {
  if (-not (Test-Path -LiteralPath $SourcePath -PathType Leaf)) {
    throw "Project starter file was not found: $SourcePath"
  }

  $destination = Join-Path $TargetPath $RelativePath
  if (Test-Path -LiteralPath $destination -PathType Any) {
    Write-Output "PRESERVE $RelativePath"
  } elseif (-not $Apply) {
    Assert-SafeTargetParent $destination
    Write-Output "ADD $RelativePath"
  } else {
    Assert-SafeTargetParent $destination
    $parent = Split-Path -Parent $destination
    New-Item -ItemType Directory -Force -Path $parent | Out-Null
    Copy-Item -LiteralPath $SourcePath -Destination $destination
  }
}

function Copy-ProjectGuide([string]$SourcePath, [string]$RelativePath) {
  if (-not (Test-Path -LiteralPath $SourcePath -PathType Leaf)) {
    throw "Project starter guide was not found: $SourcePath"
  }

  $destination = Join-Path $TargetPath $RelativePath
  if (Test-Path -LiteralPath $destination -PathType Any) {
    Write-Output "PRESERVE $RelativePath"
    return
  }
  if (-not $Apply) {
    Assert-SafeTargetParent $destination
    Write-Output "ADD $RelativePath"
    return
  }

  Assert-SafeTargetParent $destination
  $parent = Split-Path -Parent $destination
  New-Item -ItemType Directory -Force -Path $parent | Out-Null
  if ($Language -eq 'pt-BR') {
    $getStartedUrl = Get-FrameworkDocumentUrl 'locales/pt-BR/public-docs/GET_STARTED.md'
    $otherStartGuideUrl = Get-FrameworkDocumentUrl 'START_PROJECTS.en-US.md'
    $otherPromptUrl = Get-FrameworkDocumentUrl 'FIRST_PROMPT_TEMPLATE.md'
  } else {
    $getStartedUrl = Get-FrameworkDocumentUrl 'GET_STARTED.md'
    $otherStartGuideUrl = Get-FrameworkDocumentUrl 'locales/pt-BR/public-docs/START_PROJECTS.md'
    $otherPromptUrl = Get-FrameworkDocumentUrl 'locales/pt-BR/public-docs/FIRST_PROMPT_TEMPLATE.md'
  }
  $content = Get-Content -Raw -Encoding UTF8 -LiteralPath $SourcePath
  $content = $content.Replace('](GET_STARTED.md)', "]($getStartedUrl)")
  $content = $content.Replace('locales/pt-BR/public-docs/START_PROJECTS.md)', "$otherStartGuideUrl)")
  $content = $content.Replace('../../../START_PROJECTS.en-US.md)', "$otherStartGuideUrl)")
  $content = $content.Replace('locales/pt-BR/public-docs/FIRST_PROMPT_TEMPLATE.md)', "$otherPromptUrl)")
  $content = $content.Replace('../../../FIRST_PROMPT_TEMPLATE.md)', "$otherPromptUrl)")
  $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
  [System.IO.File]::WriteAllText($destination, $content, $utf8NoBom)
}

function Install-ProjectGuides {
  if ($Language -eq 'pt-BR') {
    $guideSource = Join-Path $FrameworkPath 'locales/pt-BR/public-docs/START_PROJECTS.md'
    $promptSource = Join-Path $FrameworkPath 'locales/pt-BR/public-docs/FIRST_PROMPT_TEMPLATE.md'
  } else {
    $guideSource = Join-Path $FrameworkPath 'START_PROJECTS.en-US.md'
    $promptSource = Join-Path $FrameworkPath 'FIRST_PROMPT_TEMPLATE.md'
  }
  Copy-ProjectGuide $guideSource 'START_PROJECTS.md'
  Copy-ProjectGuide $promptSource 'FIRST_PROMPT_TEMPLATE.md'
}

function Install-ProjectSkills {
  if ($Language -eq 'pt-BR') {
    $sourceRoot = Join-Path $FrameworkPath 'locales/pt-BR/project-skills'
  } else {
    $sourceRoot = Join-Path $FrameworkPath 'project-skills/en-US'
  }
  if ($Adapter -eq 'claude') { $destinationRoot = '.claude/skills' }
  else { $destinationRoot = '.agents/skills' }
  foreach ($skill in @('lf-project-onboarding', 'lf-project-planning', 'lf-approved-implementation', 'lf-delivery-review', 'lf-design', 'lf-security-review')) {
    Copy-ProjectFile (Join-Path $sourceRoot "$skill/SKILL.md") (Join-Path $destinationRoot "$skill/SKILL.md")
  }
}

Write-Output "LF Engineering System bootstrap"
Write-Output "Language: $Language"
Write-Output "Adapter: $Adapter"
Write-Output "Target: $TargetPath"

# The localized overlay is copied first so it wins over the neutral template.
Copy-TreeMissingOnly $localeTemplatePath
Copy-TreeMissingOnly $templatePath

switch ($Adapter) {
  "claude" {
    $localizedAdapter = Join-Path $FrameworkPath "adapters\claude\$Language\CLAUDE.md"
    $defaultAdapter = Join-Path $FrameworkPath "adapters\claude\CLAUDE.md"
    if (Test-Path -LiteralPath $localizedAdapter -PathType Leaf) {
      Copy-AdapterFile $localizedAdapter "CLAUDE.md"
    } else {
      Copy-AdapterFile $defaultAdapter "CLAUDE.md"
    }
  }
  "gemini" {
    $localizedAdapter = Join-Path $FrameworkPath "adapters\gemini\$Language\GEMINI.md"
    $defaultAdapter = Join-Path $FrameworkPath "adapters\gemini\GEMINI.md"
    if (Test-Path -LiteralPath $localizedAdapter -PathType Leaf) {
      Copy-AdapterFile $localizedAdapter "GEMINI.md"
    } else {
      Copy-AdapterFile $defaultAdapter "GEMINI.md"
    }
  }
  "opencode" {
    $sourcePath = Join-Path $FrameworkPath "adapters\opencode\opencode.jsonc"
    if (-not (Test-Path -LiteralPath $sourcePath -PathType Leaf)) {
      throw "OpenCode adapter configuration was not found: $sourcePath"
    }

    $destination = Join-Path $TargetPath "opencode.jsonc"
    if (-not (Test-Path -LiteralPath $destination)) {
      $content = Get-Content -Raw -Encoding UTF8 -LiteralPath $sourcePath
      if (-not $content.Contains("__LF_ENGINEERING_SYSTEM_REF__")) {
        throw "Framework reference placeholder was not found in the OpenCode adapter."
      }
      $content = $content.Replace("__LF_ENGINEERING_SYSTEM_REF__", $script:FrameworkRef)
      $null = $content | ConvertFrom-Json -ErrorAction Stop
    }
    if (Test-Path -LiteralPath $destination -PathType Any) {
      Write-Output "PRESERVE opencode.jsonc"
    } elseif (-not $Apply) {
      Assert-SafeTargetParent $destination
      Write-Output "ADD opencode.jsonc"
    } else {
      Assert-SafeTargetParent $destination
      $temporaryConfig = Join-Path $TargetPath (".opencode." + [Guid]::NewGuid().ToString('N') + ".tmp")
      try {
        $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
        [System.IO.File]::WriteAllText($temporaryConfig, $content, $utf8NoBom)
        Move-Item -LiteralPath $temporaryConfig -Destination $destination
      } finally {
        if (Test-Path -LiteralPath $temporaryConfig) {
          Remove-Item -LiteralPath $temporaryConfig -Force
        }
      }
      Write-Output "Generated opencode.jsonc."
    }
  }
}

Install-ProjectGuides
Install-ProjectSkills

Protect-LocalState

$installationFile = Join-Path $TargetPath ".ai\framework-installation.md"
if (Test-Path -LiteralPath $installationFile -PathType Any) {
  Write-Output "PRESERVE .ai/framework-installation.md"
} elseif (-not $Apply) {
  Assert-SafeTargetParent $installationFile
  Write-Output "ADD .ai/framework-installation.md"
} else {
  Assert-SafeTargetParent $installationFile
  $parent = Split-Path -Parent $installationFile
  New-Item -ItemType Directory -Force -Path $parent | Out-Null
  $installationTitle = 'LF Engineering System Installation'
  $installationDescription = 'This file records how the project base was initialized. Existing project files were preserved by the bootstrap.'
  if ($Language -eq 'pt-BR') {
    $installationTitle = 'Instalação do LF Engineering System'
    $installationDescription = 'Este arquivo registra como a base do projeto foi inicializada. Os arquivos existentes foram preservados pelo bootstrap.'
  }
  $installationContent = @"
# $installationTitle

- Language: $Language
- Adapter: $Adapter
- Framework source: $script:FrameworkRepository/tree/$script:FrameworkRef
- Framework: external read-only library

$installationDescription
"@
  $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
  [System.IO.File]::WriteAllText($installationFile, $installationContent, $utf8NoBom)
}

if ($Apply) {
  Write-Output "Bootstrap applied without overwriting existing files."
} else {
  Write-Output "Dry run only. Re-run with -Apply to write missing files."
}
