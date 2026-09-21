# verify-library.ps1
# Checks every skill in the reference library: shared/skills, backend/skills, frontend/skills.
#
#   .\scripts\verify-library.ps1
#   .\scripts\verify-library.ps1 -Set frontend
#
# What it checks (the DSH parser silently skips a skill that fails these):
#   - <name>/SKILL.md exists;
#   - frontmatter starts with ---, has name and description;
#   - frontmatter name equals the folder name;
#   - description / whenToUse do not contain an unquoted colon (breaks YAML);
#   - every relative Markdown link inside SKILL.md points at an existing file.
#
# Exit code: 0 = clean, 1 = problems found.
# Messages are ASCII on purpose: Windows PowerShell 5.1 reads BOM-less .ps1 as ANSI.

[CmdletBinding()]
param(
    [ValidateSet('shared', 'backend', 'frontend')]
    [string[]]$Set = @('shared', 'backend', 'frontend')
)

$ErrorActionPreference = 'Stop'
$base = Split-Path -Parent $PSScriptRoot
$problems = @()
$checked = 0

# Deliberate placeholder links that appear in skill text as examples, not as resources.
$intentionalBrokenLinks = @{
    'shared/wayfinder' = @('link')
}

foreach ($name in $Set) {
    $root = Join-Path $base "$name\skills"
    if (-not (Test-Path -LiteralPath $root)) { continue }

    foreach ($dir in (Get-ChildItem -LiteralPath $root -Directory | Sort-Object Name)) {
        $checked++
        $skillFile = Join-Path $dir.FullName 'SKILL.md'
        $label = "$name/$($dir.Name)"

        if (-not (Test-Path -LiteralPath $skillFile)) {
            $problems += "$label : no SKILL.md"
            continue
        }

        $lines = Get-Content -LiteralPath $skillFile
        if ($lines.Count -lt 3 -or $lines[0].TrimEnd("`r") -ne '---') {
            $problems += "$label : frontmatter does not start with ---"
            continue
        }

        $front = @()
        for ($i = 1; $i -lt $lines.Count; $i++) {
            if ($lines[$i].TrimEnd("`r") -eq '---') { break }
            $front += $lines[$i]
        }

        $nameLine = $front | Where-Object { $_ -match '^name:\s*\S' } | Select-Object -First 1
        # description may be a plain multi-line value: the text starts on the next line.
        $descLine = $front | Where-Object { $_ -match '^description:\s*' } | Select-Object -First 1

        if (-not $nameLine) { $problems += "$label : frontmatter has no name" }
        if (-not $descLine) { $problems += "$label : frontmatter has no description" }

        # A vendored skill keeps the upstream name, which may differ from the folder name
        # (DSH takes the skill name from frontmatter, not from the directory).
        $vendored = Test-Path -LiteralPath (Join-Path $dir.FullName 'SOURCE.md')
        if ($nameLine -and -not $vendored) {
            if ($nameLine -notmatch "^name:\s*$([regex]::Escape($dir.Name))\s*$") {
                $problems += "$label : frontmatter name does not match the folder"
            }
        }

        # An unquoted colon inside a value breaks YAML parsing: the provider skips the file mutely.
        foreach ($line in $front) {
            if ($line -notmatch '^(description|whenToUse|name):\s*(.+)$') { continue }
            $key = $Matches[1]
            $value = $Matches[2].Trim()
            if ($value.Length -eq 0) { continue }
            if ($value.StartsWith('"') -or $value.StartsWith("'")) { continue }
            if ($value.StartsWith('>') -or $value.StartsWith('|')) { continue }
            if ($value -match ':\s') {
                $problems += "$label : $key has an unquoted colon (quote the value)"
            }
        }

        # Relative markdown links must resolve.
        $text = Get-Content -LiteralPath $skillFile -Raw
        foreach ($m in [regex]::Matches($text, '\]\((?!https?:|#|mailto:)([^)]+)\)')) {
            $rel = $m.Groups[1].Value.Split('#')[0].Trim()
            if ($rel.Length -eq 0) { continue }
            $allowed = $intentionalBrokenLinks[$label]
            if ($allowed -and ($allowed -contains $rel)) { continue }
            $target = Join-Path $dir.FullName $rel
            if (-not (Test-Path -LiteralPath $target)) {
                $problems += "$label : broken relative link -> $rel"
            }
        }

        $tag = if ($vendored) { 'vendored' } else { 'own' }
        Write-Host ("OK  {0,-52} files: {1,-4} [{2}]" -f $label, (Get-ChildItem -LiteralPath $dir.FullName -Recurse -File).Count, $tag)
    }
}

""
"Skills checked: $checked."
if ($problems.Count -gt 0) {
    ""
    "PROBLEMS:"
    $problems | ForEach-Object { " - $_" }
    exit 1
}
"No problems."
exit 0
