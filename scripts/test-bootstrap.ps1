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

  & $bootstrap -FrameworkPath $FrameworkPath -TargetPath $newProject -Language pt-BR -Adapter claude -Apply | Out-File (Join-Path $testRoot "new-apply.txt")
   Assert-True (Test-Path -LiteralPath (Join-Path $newProject ".ai\contracts.md") -PathType Leaf) "contracts were not copied"
   Assert-True ((Select-String -LiteralPath (Join-Path $newProject ".gitignore") -SimpleMatch "/.ai/state/" -Quiet)) "new projects do not ignore local state by default"
   Assert-OwnerOnlyStatePath (Join-Path $newProject ".ai\state") $true
  Assert-OwnerOnlyStatePath (Join-Path $newProject ".ai\state\current-phase.md") $false
  Assert-True (Test-Path -LiteralPath (Join-Path $newProject "CLAUDE.md") -PathType Leaf) "Claude adapter was not copied"
  Assert-True ((Select-String -LiteralPath (Join-Path $newProject "AGENTS.md") -SimpleMatch "Instruções dos agentes" -Quiet)) "PT-BR template was not selected"
  Assert-True ((Select-String -LiteralPath (Join-Path $newProject "LF_ENGINEERING.md") -SimpleMatch $FrameworkPath -Quiet)) "Framework path was not rendered"
  Assert-True (-not (Test-Path -LiteralPath (Join-Path $newProject "opencode.jsonc") -PathType Any)) "generic project received OpenCode config"

  $defaultProject = Join-Path $testRoot "default adapter project"
  & $bootstrap -FrameworkPath $FrameworkPath -TargetPath $defaultProject -Language pt-BR -DryRun | Out-File (Join-Path $testRoot "default-dry-run.txt")
  Assert-True (-not (Test-Path -LiteralPath $defaultProject -PathType Any)) "default-adapter dry-run created the target"
  & $bootstrap -FrameworkPath $FrameworkPath -TargetPath $defaultProject -Language pt-BR -Apply | Out-File (Join-Path $testRoot "default-apply.txt")
  Assert-True (Test-Path -LiteralPath (Join-Path $defaultProject ".ai\contracts.md") -PathType Leaf) "default adapter did not copy contracts"
  Assert-True ((Get-Content -Raw -LiteralPath (Join-Path $defaultProject ".ai\framework-installation.md")) -match '(?m)^- Adapter: generic\r?$') "generic is not the default adapter"
  Assert-True (-not (Test-Path -LiteralPath (Join-Path $defaultProject "CLAUDE.md") -PathType Any)) "default adapter unexpectedly installed Claude entrypoint"
  Assert-True (-not (Test-Path -LiteralPath (Join-Path $defaultProject "GEMINI.md") -PathType Any)) "default adapter unexpectedly installed Gemini entrypoint"
  Assert-True (-not (Test-Path -LiteralPath (Join-Path $defaultProject "opencode.jsonc") -PathType Any)) "default adapter unexpectedly installed OpenCode config"

  $existingProject = Join-Path $testRoot "existing project"
  $nestedStateDirectory = Join-Path $existingProject ".ai\state\archive\subdir"
  New-Item -ItemType Directory -Force -Path (Join-Path $existingProject "docs"), $nestedStateDirectory | Out-Null
  Set-Content -LiteralPath (Join-Path $existingProject "README.md") -Value "project-owned README"
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
  Assert-True ((Get-Content -Raw -LiteralPath $configPath) -notmatch "__LF_ENGINEERING_SYSTEM_PATH__") "OpenCode placeholder was not replaced"
  $null = Get-Content -Raw -LiteralPath $configPath | ConvertFrom-Json -ErrorAction Stop

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
