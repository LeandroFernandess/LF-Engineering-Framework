param(
  [string]$FrameworkPath = ""
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($FrameworkPath)) {
  $scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path
  $FrameworkPath = Split-Path -Parent $scriptDirectory
}

$FrameworkPath = [System.IO.Path]::GetFullPath($FrameworkPath)
$testRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("lf-bootstrap-test-" + [System.Guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Force -Path $testRoot | Out-Null

function Assert-True([bool]$Condition, [string]$Message) {
  if (-not $Condition) {
    throw "Bootstrap test failed: $Message"
  }
}

function Get-UnixFileModeForTest([string]$Path) {
  $modeType = [System.Type]::GetType("System.IO.UnixFileMode")
  Assert-True ($null -ne $modeType) "Unix file modes are not available on this host"
  $method = [System.IO.File].GetMethod("GetUnixFileMode", [System.Type[]]@([string]))
  Assert-True ($null -ne $method) "Unix file mode inspection is not available on this host"
  return $method.Invoke($null, @($Path))
}

function Assert-OwnerOnlyStatePath([string]$Path, [bool]$IsDirectory) {
  if ($env:OS -eq "Windows_NT") {
    $acl = Get-Acl -LiteralPath $Path
    Assert-True $acl.AreAccessRulesProtected "$Path still inherits access rules"
    $ownerSid = [System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value
    $allowRules = @($acl.Access | Where-Object {
      $_.AccessControlType -eq [System.Security.AccessControl.AccessControlType]::Allow
    })
    Assert-True ($allowRules.Count -eq 1) "$Path has access grants beyond its owner"
    $allowedSid = $allowRules[0].IdentityReference.Translate(
      [System.Security.Principal.SecurityIdentifier]
    ).Value
    Assert-True ($allowedSid -eq $ownerSid) "$Path is not restricted to the current user"
    $fullControl = [System.Security.AccessControl.FileSystemRights]::FullControl
    Assert-True (($allowRules[0].FileSystemRights -band $fullControl) -eq $fullControl) "$Path does not grant full control to its owner"
  } else {
    $actualMode = Get-UnixFileModeForTest $Path
    if ($IsDirectory) {
      $expectedMode = [System.Enum]::Parse(
        [System.Type]::GetType("System.IO.UnixFileMode"),
        "UserRead, UserWrite, UserExecute"
      )
    } else {
      $expectedMode = [System.Enum]::Parse(
        [System.Type]::GetType("System.IO.UnixFileMode"),
        "UserRead, UserWrite"
      )
    }
    Assert-True ($actualMode -eq $expectedMode) "$Path has mode $actualMode instead of owner-only mode $expectedMode"
  }
}

function Get-StatePermissionToken([string]$Path) {
  if ($env:OS -eq "Windows_NT") {
    return (Get-Acl -LiteralPath $Path).Sddl
  }
  return (Get-UnixFileModeForTest $Path).ToString()
}

function Set-BroadStatePermissionsForTest([string]$Path, [bool]$IsDirectory) {
  if ($env:OS -eq "Windows_NT") {
    $acl = Get-Acl -LiteralPath $Path
    $acl.SetAccessRuleProtection($true, $false)
    foreach ($existingRule in @($acl.Access)) {
      $null = $acl.RemoveAccessRuleAll($existingRule)
    }
    $ownerSid = [System.Security.Principal.WindowsIdentity]::GetCurrent().User
    $everyoneSid = [System.Security.Principal.SecurityIdentifier]::new("S-1-1-0")

    $ownerRule = [System.Security.AccessControl.FileSystemAccessRule]::new(
      $ownerSid,
      [System.Security.AccessControl.FileSystemRights]::FullControl,
      [System.Security.AccessControl.AccessControlType]::Allow
    )
    if ($IsDirectory) {
      $inheritanceFlags = [System.Security.AccessControl.InheritanceFlags]::ContainerInherit -bor
        [System.Security.AccessControl.InheritanceFlags]::ObjectInherit
      $everyoneRule = [System.Security.AccessControl.FileSystemAccessRule]::new(
        $everyoneSid,
        [System.Security.AccessControl.FileSystemRights]::ReadAndExecute,
        $inheritanceFlags,
        [System.Security.AccessControl.PropagationFlags]::None,
        [System.Security.AccessControl.AccessControlType]::Allow
      )
    } else {
      $everyoneRule = [System.Security.AccessControl.FileSystemAccessRule]::new(
        $everyoneSid,
        [System.Security.AccessControl.FileSystemRights]::Read,
        [System.Security.AccessControl.AccessControlType]::Allow
      )
    }
    $acl.AddAccessRule($ownerRule)
    $acl.AddAccessRule($everyoneRule)
    Set-Acl -LiteralPath $Path -AclObject $acl
  } else {
    $modeType = [System.Type]::GetType("System.IO.UnixFileMode")
    if ($IsDirectory) {
      $modeName = "UserRead, UserWrite, UserExecute, GroupRead, GroupExecute, OtherRead, OtherExecute"
    } else {
      $modeName = "UserRead, UserWrite, GroupRead, OtherRead"
    }
    $mode = [System.Enum]::Parse($modeType, $modeName)
    $method = [System.IO.File].GetMethod(
      "SetUnixFileMode",
      [System.Type[]]@([string], $modeType)
    )
    $null = $method.Invoke($null, @($Path, $mode))
  }
}

function New-TestDirectoryLink([string]$Path, [string]$Target) {
  try {
    New-Item -ItemType SymbolicLink -Force -Path $Path -Target $Target | Out-Null
    return $true
  } catch {
    if ($env:OS -eq "Windows_NT") {
      try {
        New-Item -ItemType Junction -Force -Path $Path -Target $Target | Out-Null
        return $true
      } catch {
        return $false
      }
    }
    return $false
  }
}

try {
  $newProject = Join-Path $testRoot "new project"
  $bootstrap = Join-Path $FrameworkPath "scripts\bootstrap.ps1"
  & $bootstrap -FrameworkPath $FrameworkPath -TargetPath $newProject -Language pt-BR -Adapter claude -DryRun | Out-File (Join-Path $testRoot "new-dry-run.txt")
  Assert-True (-not (Test-Path -LiteralPath $newProject -PathType Any)) "dry-run created the target"
  Assert-True ((Select-String -LiteralPath (Join-Path $testRoot "new-dry-run.txt") -SimpleMatch "ADD AGENTS.md" -Quiet)) "dry-run did not report AGENTS.md"
  Assert-True ((Select-String -LiteralPath (Join-Path $testRoot "new-dry-run.txt") -SimpleMatch "ADD START_PROJECTS.md" -Quiet)) "dry-run did not report the local start guide"
  Assert-True ((Select-String -LiteralPath (Join-Path $testRoot "new-dry-run.txt") -SimpleMatch "ADD FIRST_PROMPT_TEMPLATE.md" -Quiet)) "dry-run did not report the local prompt template"
  $newDryRun = (Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $testRoot "new-dry-run.txt")).Replace('\', '/')
  Assert-True ($newDryRun.Contains("ADD .claude/skills/lf-project-onboarding/SKILL.md")) "dry-run did not report Claude skills"

  & $bootstrap -FrameworkPath $FrameworkPath -TargetPath $newProject -Language pt-BR -Adapter claude -Apply | Out-File (Join-Path $testRoot "new-apply.txt")
   Assert-True (Test-Path -LiteralPath (Join-Path $newProject ".ai\contracts.md") -PathType Leaf) "contracts were not copied"
  foreach ($required in @(
    "AGENTS.md", "LF_ENGINEERING.md", "README.md",
    ".ai/workflow.md", ".ai/handoff.md", ".ai/decisions.md", ".ai/tasks.md", ".ai/artifacts.md",
    ".ai/state/current-phase.md", ".ai/state/current-agent.md", ".ai/state/project-summary.md",
    ".ai/state/next-actions.md", ".ai/state/risks.md",
    "docs/PRD.md", "docs/ARCHITECTURE.md", "docs/SPRINTS.md", "docs/ADR.md"
  )) {
    Assert-True (Test-Path -LiteralPath (Join-Path $newProject $required) -PathType Leaf) "required project file $required was not installed"
  }
   Assert-True ((Select-String -LiteralPath (Join-Path $newProject ".gitignore") -SimpleMatch "/.ai/state/" -Quiet)) "new projects do not ignore local state by default"
   Assert-OwnerOnlyStatePath (Join-Path $newProject ".ai\state") $true
  Assert-OwnerOnlyStatePath (Join-Path $newProject ".ai\state\current-phase.md") $false
  Assert-True (Test-Path -LiteralPath (Join-Path $newProject "CLAUDE.md") -PathType Leaf) "Claude adapter was not copied"
  Assert-True ((Select-String -LiteralPath (Join-Path $newProject "AGENTS.md") -SimpleMatch "Instruções dos agentes" -Quiet)) "PT-BR template was not selected"
  Assert-True ((Select-String -LiteralPath (Join-Path $newProject "LF_ENGINEERING.md") -SimpleMatch "https://github.com/LeandroFernandess/LF-Engineering-Framework" -Quiet)) "official Framework source was not documented"
  foreach ($document in @(Get-ChildItem -LiteralPath $newProject -Filter "*.md" -Recurse -File)) {
    $documentContent = Get-Content -Raw -Encoding UTF8 -LiteralPath $document.FullName
    Assert-True (-not $documentContent.Contains($FrameworkPath)) "machine-specific Framework path leaked into $($document.Name)"
    Assert-True (-not $documentContent.Contains("file://")) "local file URI leaked into $($document.Name)"
  }
  Assert-True (-not (Test-Path -LiteralPath (Join-Path $newProject "opencode.jsonc") -PathType Any)) "Claude selection received OpenCode config"
  Assert-True (Test-Path -LiteralPath (Join-Path $newProject "START_PROJECTS.md") -PathType Leaf) "localized start guide was not installed"
  Assert-True (Test-Path -LiteralPath (Join-Path $newProject "FIRST_PROMPT_TEMPLATE.md") -PathType Leaf) "localized first prompt was not installed"
  Assert-True (-not (Test-Path -LiteralPath (Join-Path $newProject "GET_STARTED.md") -PathType Any)) "GET_STARTED.md was copied into the project"
  Assert-True (-not (Test-Path -LiteralPath (Join-Path $newProject "PROJECT_BRIEF.md") -PathType Any)) "conditional PROJECT_BRIEF.md was copied before the workflow required it"
  foreach ($conditional in @("docs/DESIGN.md", "docs/PERFORMANCE_VALIDATION_REPORT.md", "docs/TECH_DEBT_AUDIT.md")) {
    Assert-True (-not (Test-Path -LiteralPath (Join-Path $newProject $conditional) -PathType Any)) "conditional artifact $conditional was copied before the workflow required it"
  }
  foreach ($directory in @("agents", "knowledge", "workflows", "protocols", "schemas")) {
    Assert-True (-not (Test-Path -LiteralPath (Join-Path $newProject $directory) -PathType Any)) "full Framework directory $directory was copied"
  }
  foreach ($skill in @("lf-project-onboarding", "lf-project-planning", "lf-approved-implementation", "lf-delivery-review", "lf-design", "lf-security-review")) {
    Assert-True (Test-Path -LiteralPath (Join-Path $newProject ".claude/skills/$skill/SKILL.md") -PathType Leaf) "Claude skill $skill was not installed"
  }
  Assert-True ((Select-String -LiteralPath (Join-Path $newProject ".claude/skills/lf-project-onboarding/SKILL.md") -SimpleMatch "Integração inicial de projeto LF" -Quiet)) "PT-BR skill source was not selected"
  $projectGuide = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $newProject "START_PROJECTS.md")
  Assert-True ($projectGuide.Contains("https://github.com/LeandroFernandess/LF-Engineering-Framework/blob/main/locales/pt-BR/public-docs/GET_STARTED.md")) "guide does not link to the official Framework source"
  Assert-True ($projectGuide.Contains("FIRST_PROMPT_TEMPLATE.md)")) "guide does not link to the local prompt"
  $repeatPreview = @(& $bootstrap -FrameworkPath $FrameworkPath -TargetPath $newProject -Language pt-BR -Adapter claude -DryRun)
  $repeatPreviewPaths = @($repeatPreview | ForEach-Object { ([string]$_).Replace('\', '/') })
  Assert-True (-not ($repeatPreviewPaths | Where-Object { $_ -match '^ADD (START_PROJECTS.md|FIRST_PROMPT_TEMPLATE.md|\.claude/skills/)' })) "second bootstrap preview proposed guide or skill additions"

  $missingAdapterProject = Join-Path $testRoot "missing adapter project"
  $missingAdapterFailed = $false
  try { & $bootstrap -FrameworkPath $FrameworkPath -TargetPath $missingAdapterProject -Language pt-BR -DryRun | Out-Null }
  catch { $missingAdapterFailed = $true }
  Assert-True $missingAdapterFailed "bootstrap accepted a missing adapter"
  Assert-True (-not (Test-Path -LiteralPath $missingAdapterProject -PathType Any)) "missing-adapter validation created the target"

  $genericAdapterProject = Join-Path $testRoot "generic adapter project"
  $genericAdapterFailed = $false
  try { & $bootstrap -FrameworkPath $FrameworkPath -TargetPath $genericAdapterProject -Language pt-BR -Adapter generic -DryRun | Out-Null }
  catch { $genericAdapterFailed = $true }
  Assert-True $genericAdapterFailed "bootstrap accepted the removed generic adapter"
  Assert-True (-not (Test-Path -LiteralPath $genericAdapterProject -PathType Any)) "generic-adapter validation created the target"

  $existingProject = Join-Path $testRoot "existing project"
  $nestedStateDirectory = Join-Path $existingProject ".ai\state\archive\subdir"
  $existingSkillDirectory = Join-Path $existingProject ".claude/skills/lf-project-onboarding"
  New-Item -ItemType Directory -Force -Path (Join-Path $existingProject "docs"), $nestedStateDirectory, $existingSkillDirectory | Out-Null
  Set-Content -LiteralPath (Join-Path $existingProject "README.md") -Value "project-owned README"
  Set-Content -LiteralPath (Join-Path $existingProject "START_PROJECTS.md") -Value "project-owned guide"
  Set-Content -LiteralPath (Join-Path $existingProject "FIRST_PROMPT_TEMPLATE.md") -Value "project-owned prompt"
  Set-Content -LiteralPath (Join-Path $existingSkillDirectory "SKILL.md") -Value "project-owned skill"
  Set-Content -LiteralPath (Join-Path $existingProject "AGENTS.md") -Value "project-owned AGENTS"
  Set-Content -LiteralPath (Join-Path $existingProject ".gitignore") -Value "project-owned ignore"
  Set-Content -LiteralPath (Join-Path $existingProject "CLAUDE.md") -Value "project-owned CLAUDE"
  Set-Content -LiteralPath (Join-Path $existingProject "opencode.jsonc") -Value "project-owned config"
  Set-Content -LiteralPath (Join-Path $existingProject ".ai\framework-installation.md") -Value "project-owned marker"
  Set-Content -LiteralPath (Join-Path $existingProject ".ai\state\current-phase.md") -Value "project-owned phase"
  $nestedStateFile = Join-Path $nestedStateDirectory "old.md"
  Set-Content -LiteralPath $nestedStateFile -Value "project-owned nested state"
  Set-Content -LiteralPath (Join-Path $existingProject "docs\PRD.md") -Value "project-owned PRD"
  $stateDirectory = Join-Path $existingProject ".ai\state"
  $stateFile = Join-Path $stateDirectory "current-phase.md"
  $stateArchiveDirectory = Join-Path $stateDirectory "archive"
  Set-BroadStatePermissionsForTest $stateDirectory $true
  Set-BroadStatePermissionsForTest $stateFile $false
  Set-BroadStatePermissionsForTest $stateArchiveDirectory $true
  Set-BroadStatePermissionsForTest $nestedStateDirectory $true
  Set-BroadStatePermissionsForTest $nestedStateFile $false
  $stateDirectoryPermissionsBefore = Get-StatePermissionToken $stateDirectory
  $stateFilePermissionsBefore = Get-StatePermissionToken $stateFile
  $stateArchiveDirectoryPermissionsBefore = Get-StatePermissionToken $stateArchiveDirectory
  $nestedStateDirectoryPermissionsBefore = Get-StatePermissionToken $nestedStateDirectory
  $nestedStateFilePermissionsBefore = Get-StatePermissionToken $nestedStateFile

  & $bootstrap -FrameworkPath $FrameworkPath -TargetPath $existingProject -Language en-US -Adapter claude -DryRun | Out-File (Join-Path $testRoot "existing-dry-run.txt")
  Assert-True ((Select-String -LiteralPath (Join-Path $testRoot "existing-dry-run.txt") -SimpleMatch "PRESERVE START_PROJECTS.md" -Quiet)) "existing guide was not preserved"
  Assert-True ((Select-String -LiteralPath (Join-Path $testRoot "existing-dry-run.txt") -SimpleMatch "PRESERVE FIRST_PROMPT_TEMPLATE.md" -Quiet)) "existing prompt was not preserved"
  Assert-True ((Select-String -LiteralPath (Join-Path $testRoot "existing-dry-run.txt") -Pattern 'PRESERVE \.claude[\\/]skills[\\/]lf-project-onboarding[\\/]SKILL\.md' -Quiet)) "existing skill was not preserved"
  Assert-True ((Select-String -LiteralPath (Join-Path $testRoot "existing-dry-run.txt") -Pattern 'PRESERVE \.ai[\\/]state[\\/]current-phase\.md' -Quiet)) "hidden state was not preserved"
  Assert-True ((Select-String -LiteralPath (Join-Path $testRoot "existing-dry-run.txt") -SimpleMatch "RESTRICT .ai/state to owner-only permissions" -Quiet)) "dry-run did not report local-state permission hardening"
  Assert-True ((Get-StatePermissionToken $stateDirectory) -eq $stateDirectoryPermissionsBefore) "dry-run changed state-directory permissions"
  Assert-True ((Get-StatePermissionToken $stateFile) -eq $stateFilePermissionsBefore) "dry-run changed state-file permissions"
  Assert-True ((Get-StatePermissionToken $stateArchiveDirectory) -eq $stateArchiveDirectoryPermissionsBefore) "dry-run changed nested state-directory permissions"
  Assert-True ((Get-StatePermissionToken $nestedStateDirectory) -eq $nestedStateDirectoryPermissionsBefore) "dry-run changed nested state-directory permissions"
  Assert-True ((Get-StatePermissionToken $nestedStateFile) -eq $nestedStateFilePermissionsBefore) "dry-run changed nested state-file permissions"
  Assert-True (-not (Test-Path -LiteralPath (Join-Path $existingProject ".ai\contracts.md") -PathType Any)) "dry-run copied files"

  & $bootstrap -FrameworkPath $FrameworkPath -TargetPath $existingProject -Language en-US -Adapter claude -Apply | Out-File (Join-Path $testRoot "existing-apply.txt")
  Assert-True ((Get-Content -Raw -LiteralPath (Join-Path $existingProject "README.md")).Trim() -eq "project-owned README") "README was overwritten"
  Assert-True ((Get-Content -Raw -LiteralPath (Join-Path $existingProject "START_PROJECTS.md")).Trim() -eq "project-owned guide") "existing guide was overwritten"
  Assert-True ((Get-Content -Raw -LiteralPath (Join-Path $existingProject "FIRST_PROMPT_TEMPLATE.md")).Trim() -eq "project-owned prompt") "existing prompt was overwritten"
  Assert-True ((Get-Content -Raw -LiteralPath (Join-Path $existingSkillDirectory "SKILL.md")).Trim() -eq "project-owned skill") "existing skill was overwritten"
  Assert-True ((Get-Content -Raw -LiteralPath (Join-Path $existingProject "AGENTS.md")).Trim() -eq "project-owned AGENTS") "AGENTS.md was overwritten"
  Assert-True ((Get-Content -Raw -LiteralPath (Join-Path $existingProject ".gitignore")).Trim() -eq "project-owned ignore") ".gitignore was overwritten"
  Assert-True ((Get-Content -Raw -LiteralPath (Join-Path $existingProject "CLAUDE.md")).Trim() -eq "project-owned CLAUDE") "CLAUDE.md was overwritten"
  Assert-True ((Get-Content -Raw -LiteralPath (Join-Path $existingProject "opencode.jsonc")).Trim() -eq "project-owned config") "existing OpenCode config was overwritten"
  Assert-True ((Get-Content -Raw -LiteralPath (Join-Path $existingProject ".ai\framework-installation.md")).Trim() -eq "project-owned marker") "installation marker was overwritten"
  Assert-True ((Get-Content -Raw -LiteralPath (Join-Path $existingProject ".ai\state\current-phase.md")).Trim() -eq "project-owned phase") "hidden state was overwritten"
  Assert-True ((Get-Content -Raw -LiteralPath $nestedStateFile).Trim() -eq "project-owned nested state") "nested local state was overwritten"
  Assert-True ((Get-Content -Raw -LiteralPath (Join-Path $existingProject "docs\PRD.md")).Trim() -eq "project-owned PRD") "project documentation was overwritten"
  Assert-OwnerOnlyStatePath $stateDirectory $true
  Assert-OwnerOnlyStatePath $stateFile $false
  Assert-OwnerOnlyStatePath $stateArchiveDirectory $true
  Assert-OwnerOnlyStatePath $nestedStateDirectory $true
  Assert-OwnerOnlyStatePath $nestedStateFile $false
  Assert-True (Test-Path -LiteralPath (Join-Path $existingProject ".ai\contracts.md") -PathType Leaf) "missing files were not copied"

  $opencodeProject = Join-Path $testRoot "opencode project"
  & $bootstrap -FrameworkPath $FrameworkPath -TargetPath $opencodeProject -Language en-US -Adapter opencode -Apply | Out-File (Join-Path $testRoot "opencode-apply.txt")
  $configPath = Join-Path $opencodeProject "opencode.jsonc"
  Assert-True (Test-Path -LiteralPath $configPath -PathType Leaf) "OpenCode config was not generated"
  $configContent = Get-Content -Raw -LiteralPath $configPath
  Assert-True ($configContent -notmatch "__LF_ENGINEERING_SYSTEM_REF__") "OpenCode reference placeholder was not replaced"
  Assert-True ($configContent.Contains('"repository": "LeandroFernandess/LF-Engineering-Framework"')) "OpenCode repository reference was not generated"
  Assert-True ($configContent.Contains('"branch": "main"')) "OpenCode reference was not pinned to the selected Framework source"
  $config = $configContent | ConvertFrom-Json -ErrorAction Stop
  $frameworkPermissionResource = "*/repos/github.com/LeandroFernandess/LF-Engineering-Framework/*"
  foreach ($expected in @(
    @{ action = "external_directory"; effect = "allow" },
    @{ action = "read"; effect = "allow" },
    @{ action = "edit"; effect = "deny" }
  )) {
    Assert-True (@($config.permissions | Where-Object {
      $_.action -eq $expected.action -and
      $_.resource -eq $frameworkPermissionResource -and
      $_.effect -eq $expected.effect
    }).Count -gt 0) "OpenCode Framework permission $($expected.action) was not configured safely"
  }
  foreach ($skill in @("lf-project-onboarding", "lf-project-planning", "lf-approved-implementation", "lf-delivery-review", "lf-design", "lf-security-review")) {
    Assert-True (Test-Path -LiteralPath (Join-Path $opencodeProject ".agents/skills/$skill/SKILL.md") -PathType Leaf) "OpenCode skill $skill was not installed"
  }

  foreach ($adapter in @("codex", "gemini")) {
    $adapterProject = Join-Path $testRoot ("adapter-" + $adapter)
    & $bootstrap -FrameworkPath $FrameworkPath -TargetPath $adapterProject -Language en-US -Adapter $adapter -Apply | Out-Null
    Assert-True (Test-Path -LiteralPath (Join-Path $adapterProject "AGENTS.md") -PathType Leaf) "$adapter did not receive AGENTS.md"
    if ($adapter -eq "codex") {
      Assert-True (-not (Test-Path -LiteralPath (Join-Path $adapterProject "CLAUDE.md") -PathType Any)) "codex received Claude adapter"
      Assert-True (-not (Test-Path -LiteralPath (Join-Path $adapterProject "GEMINI.md") -PathType Any)) "codex received Gemini adapter"
    } else {
      Assert-True (Test-Path -LiteralPath (Join-Path $adapterProject "GEMINI.md") -PathType Leaf) "gemini adapter was not copied"
      Assert-True (-not (Test-Path -LiteralPath (Join-Path $adapterProject "CLAUDE.md") -PathType Any)) "gemini received Claude adapter"
    }
    foreach ($skill in @("lf-project-onboarding", "lf-project-planning", "lf-approved-implementation", "lf-delivery-review", "lf-design", "lf-security-review")) {
      Assert-True (Test-Path -LiteralPath (Join-Path $adapterProject ".agents/skills/$skill/SKILL.md") -PathType Leaf) "$adapter skill $skill was not installed"
    }
    Assert-True (-not (Test-Path -LiteralPath (Join-Path $adapterProject ".claude/skills") -PathType Any)) "$adapter received Claude's skill directory"
  }

  $invalidLanguageBlocked = $false
  try {
    & $bootstrap -FrameworkPath $FrameworkPath -TargetPath (Join-Path $testRoot "invalid-language") -Language xx-XX -DryRun *> $null
  } catch {
    $invalidLanguageBlocked = $true
  }
  Assert-True $invalidLanguageBlocked "invalid language was accepted"

  $invalidAdapterBlocked = $false
  try {
    & $bootstrap -FrameworkPath $FrameworkPath -TargetPath (Join-Path $testRoot "invalid-adapter") -Adapter unknown -DryRun *> $null
  } catch {
    $invalidAdapterBlocked = $true
  }
  Assert-True $invalidAdapterBlocked "invalid adapter was accepted"

  $insideFramework = Join-Path $FrameworkPath "inside"
  $boundaryBlocked = $false
  try {
    & $bootstrap -FrameworkPath $FrameworkPath -TargetPath $insideFramework -DryRun *> $null
  } catch {
    $boundaryBlocked = $true
  }
  Assert-True $boundaryBlocked "Framework boundary protection failed"

  $frameworkLink = Join-Path $testRoot "framework-link"
  $linkCreated = New-TestDirectoryLink $frameworkLink $FrameworkPath
  if ($linkCreated) {
    $linkedTarget = Join-Path $frameworkLink "inside"
    $linkedTargetBlocked = $false
    try {
      & $bootstrap -FrameworkPath $FrameworkPath -TargetPath $linkedTarget -DryRun *> $null
    } catch {
      $linkedTargetBlocked = $true
    }
    Assert-True $linkedTargetBlocked "Framework boundary allowed a target through a directory link"

    $frameworkAliasTarget = Join-Path $FrameworkPath "framework-alias-inside"
    $frameworkAlias = Join-Path $testRoot "framework-alias"
    $aliasCreated = New-TestDirectoryLink $frameworkAlias $FrameworkPath
    if ($aliasCreated) {
      $aliasBoundaryBlocked = $false
      try {
        & $bootstrap -FrameworkPath $frameworkAlias -TargetPath $frameworkAliasTarget -DryRun *> $null
      } catch {
        $aliasBoundaryBlocked = $true
      }
      Assert-True $aliasBoundaryBlocked "Framework boundary allowed a target when FrameworkPath was a link"
    }
  } elseif ($env:OS -eq "Windows_NT") {
    throw "Bootstrap test failed: native Windows could not create a symlink or junction for boundary validation"
  } else {
    Write-Warning "Symlink boundary test skipped because the host could not create a directory link."
  }

  $symlinkProject = Join-Path $testRoot "symlink-project"
  $outsideProject = Join-Path $testRoot "outside-project"
  New-Item -ItemType Directory -Force -Path $symlinkProject, $outsideProject | Out-Null
  $targetDocsLink = Join-Path $symlinkProject "docs"
  $targetDocsLinkCreated = New-TestDirectoryLink $targetDocsLink $outsideProject
  if ($targetDocsLinkCreated) {
    $nestedLinkBlocked = $false
    try {
      & $bootstrap -FrameworkPath $FrameworkPath -TargetPath $symlinkProject -Apply *> $null
    } catch {
      $nestedLinkBlocked = $true
    }
    Assert-True $nestedLinkBlocked "Bootstrap followed a linked directory inside the target project"

    $escapedFiles = @(Get-ChildItem -LiteralPath $outsideProject -Force -Recurse -File)
    Assert-True ($escapedFiles.Count -eq 0) "Bootstrap wrote template files outside the target project"
  } elseif ($env:OS -eq "Windows_NT") {
    throw "Bootstrap test failed: native Windows could not create a nested directory link"
  } else {
    Write-Warning "Nested target-link test skipped because the host could not create a directory link."
  }

  Write-Output "Bootstrap tests passed."
} finally {
  if (Test-Path -LiteralPath $testRoot -PathType Any) {
    Remove-Item -LiteralPath $testRoot -Recurse -Force
  }
}
