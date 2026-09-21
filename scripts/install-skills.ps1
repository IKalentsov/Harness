# install-skills.ps1
# Copies skill sets from this reference repository into a project's .dsh/skills.
# DSH reads exactly one level (<root>/<name>/SKILL.md), so the target layout is flat.
#
#   pwsh -NoProfile -File .\scripts\install-skills.ps1 -Project ..\my-project -Set shared,backend
#   pwsh -NoProfile -File .\scripts\install-skills.ps1 -Project ..\my-project -Set shared,frontend -Clean
#
# -Project takes any path, relative to the directory the script is run from.
#
# Messages are ASCII on purpose: Windows PowerShell 5.1 reads BOM-less .ps1 as ANSI.

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Project,

    # 'shared', 'backend', 'frontend' or a comma-separated list of them.
    [string[]]$Set = @('shared'),

    # Optional allow-list: copy only these skills (by folder name).
    [string[]]$Only = @(),

    [switch]$Clean,

    [switch]$WhatIfOnly
)

$ErrorActionPreference = 'Stop'
$base = Split-Path -Parent $PSScriptRoot

# PowerShell 5.1 passes "-Set shared,backend" as a single string when the script is
# invoked with -File, so split each element on commas before validating.
$Set = @($Set | ForEach-Object { $_ -split ',' } | Where-Object { $_ } | ForEach-Object { $_.Trim() } | Select-Object -Unique)
$Only = @($Only | ForEach-Object { $_ -split ',' } | Where-Object { $_ } | ForEach-Object { $_.Trim() } | Select-Object -Unique)

$known = @('shared', 'backend', 'frontend')
$unknown = @($Set | Where-Object { $known -notcontains $_ })
if ($unknown.Count -gt 0) {
    throw ("unknown set(s): {0}. known: {1}" -f ($unknown -join ', '), ($known -join ', '))
}
if ($Set.Count -eq 0) { throw 'no sets selected' }

if (-not (Test-Path -LiteralPath $Project)) {
    throw "project path not found: $Project"
}

$target = Join-Path (Resolve-Path -LiteralPath $Project) '.dsh\skills'

if ($Clean -and (Test-Path -LiteralPath $target)) {
    Write-Host "clean: removing $target"
    if (-not $WhatIfOnly) { Remove-Item -LiteralPath $target -Recurse -Force }
}

if (-not (Test-Path -LiteralPath $target)) {
    if (-not $WhatIfOnly) { New-Item -ItemType Directory -Force -Path $target | Out-Null }
}

$sources = foreach ($name in $Set) {
    $dir = Join-Path $base "$name\skills"
    if (-not (Test-Path -LiteralPath $dir)) {
        Write-Warning "set '$name' has no skills directory: $dir"
        continue
    }
    $dir
}

$overall = @{}
foreach ($dir in $sources) {
    $setName = Split-Path -Parent $dir | Split-Path -Leaf
    Get-ChildItem -LiteralPath $dir -Directory | Where-Object {
        $Only.Count -eq 0 -or $Only -contains $_.Name
    } | ForEach-Object {
        $skill = $_.Name
        $dest = Join-Path $target $skill
        if ($overall.ContainsKey($skill)) {
            Write-Host ("duplicate '{0}': already provided by '{1}', overwritten by '{2}'" -f $skill, $overall[$skill], $setName)
        }
        $overall[$skill] = $setName
        if ($WhatIfOnly) {
            Write-Host ("would copy [{0}] {1}" -f $setName, $skill)
        }
        else {
            # A pre-existing target directory makes Copy-Item nest the source inside it
            # (skill/skill/SKILL.md), so the target is recreated from scratch every time.
            if (Test-Path -LiteralPath $dest) { Remove-Item -LiteralPath $dest -Recurse -Force }
            Copy-Item -LiteralPath $_.FullName -Destination $dest -Recurse -Force
        }
    }
}

$count = ($overall.Keys | Measure-Object).Count
Write-Host ("skills installed: {0} -> {1}" -f $count, $target)
$overall.GetEnumerator() | Sort-Object Name | ForEach-Object {
    Write-Host ("  {0,-40} [{1}]" -f $_.Key, $_.Value)
}
