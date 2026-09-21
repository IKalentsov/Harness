# Verifies the vendored skill set in this project against SOURCES.json.
#   pwsh -NoProfile -File .dsh/skills/verify-set.ps1
#   pwsh -NoProfile -File .dsh/skills/verify-set.ps1 -CheckUpstream
#
# Run it through pwsh 7, or through the verify-set.cmd wrapper, which prefers pwsh and falls back
# to Windows PowerShell 5.1 with -ExecutionPolicy Bypass. A bare .\verify-set.ps1 is refused in a
# shell whose execution policy is Restricted, which is what the DSH tool's own shell is.
#
# The manifest holds upstream files only. SOURCE.md next to a skill is our provenance record
# and is skipped by the hash comparison, so it neither has to be in the manifest nor counts
# as an extra file.
#
# Exit code: 0 = in sync, 1 = drift found.

[CmdletBinding()]
param(
    [switch]$CheckUpstream
)

$ErrorActionPreference = 'Stop'

$manifestPath = Join-Path $PSScriptRoot 'SOURCES.json'
if (-not (Test-Path $manifestPath)) { throw "Manifest not found: $manifestPath" }
$manifest = Get-Content -Raw $manifestPath | ConvertFrom-Json

$problems = @()

foreach ($skill in $manifest.skills) {
    $skillPath = Join-Path $PSScriptRoot $skill.name
    $skillFile = Join-Path $skillPath 'SKILL.md'
    if (-not (Test-Path $skillFile)) {
        $problems += "missing $($skill.name)/SKILL.md"
        continue
    }

    # Frontmatter must satisfy the DSH skill parser: opening ---, name, description.
    $lines = Get-Content $skillFile
    if ($lines[0].TrimEnd("`r") -ne '---') { $problems += "$($skill.name): no frontmatter" }
    $frontmatter = @()
    for ($i = 1; $i -lt $lines.Count; $i++) {
        if ($lines[$i].TrimEnd("`r") -eq '---') { break }
        $frontmatter += $lines[$i]
    }
    $nameLine = $frontmatter | Where-Object { $_ -match '^name:' } | Select-Object -First 1
    $descLine = $frontmatter | Where-Object { $_ -match '^description:' } | Select-Object -First 1
    if (-not $nameLine) { $problems += "$($skill.name): frontmatter has no name" }
    elseif ($nameLine -notmatch "^name:\s*$([regex]::Escape($skill.name))\s*$") {
        $problems += "$($skill.name): frontmatter name does not match the folder"
    }
    if (-not $descLine) { $problems += "$($skill.name): frontmatter has no description" }

    # File hashes recorded in the manifest. SOURCE.md is our own provenance record, not an
    # upstream file: it is never listed in the manifest and must not count as an extra file.
    $actual = @{}
    foreach ($file in (Get-ChildItem -Recurse -File $skillPath)) {
        $rel = $file.FullName.Substring($skillPath.Length + 1).Replace('\', '/')
        if ($rel -eq 'SOURCE.md') { continue }
        $actual[$rel] = (Get-FileHash -Algorithm SHA256 $file.FullName).Hash.ToLower()
    }
    foreach ($rel in $skill.sha256.PSObject.Properties.Name) {
        if (-not $actual.ContainsKey($rel)) { $problems += "$($skill.name): removed $rel" }
        elseif ($actual[$rel] -ne $skill.sha256.$rel) { $problems += "$($skill.name): changed $rel" }
    }
    foreach ($rel in $actual.Keys) {
        if (-not $skill.sha256.PSObject.Properties.Name.Contains($rel)) { $problems += "$($skill.name): extra $rel" }
    }

    "OK  {0,-32} files: {1}" -f $skill.name, $actual.Count
}

# Anything in the set root that is not a skill (manifest, this script, the cmd wrapper).
$rootFiles = Get-ChildItem -File $PSScriptRoot | Where-Object { $_.Extension -notin '.ps1', '.cmd' -and $_.Name -ne 'SOURCES.json' }
foreach ($file in $rootFiles) { $problems += "unexpected file in set root: $($file.Name)" }

if ($CheckUpstream) {
    $api = 'https://api.github.com/repos/{0}/commits/{1}' -f $manifest.repository, $manifest.ref
    try {
        $head = (Invoke-RestMethod -Uri $api -Headers @{ 'User-Agent' = 'dsh-verify-set' }).sha
        if ($head -ne $manifest.commit) {
            ""
            "Upstream moved: $($manifest.commit.Substring(0,12)) -> $($head.Substring(0,12))"
            "Diff: https://github.com/$($manifest.repository)/compare/$($manifest.commit)...$head"
        }
        else { "Upstream unchanged (commit $($manifest.commit.Substring(0,12)))." }
    }
    catch { "Could not reach upstream: $($_.Exception.Message)" }
}

""
"Skills in the manifest: $($manifest.skills.Count). Not installed: $($manifest.notInstalled.Count)."
if ($problems.Count -gt 0) {
    ""
    "DRIFT:"
    $problems | ForEach-Object { " - $_" }
    exit 1
}
"No drift."
exit 0
