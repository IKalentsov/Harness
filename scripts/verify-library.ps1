# verify-library.ps1
# Checks every skill in the reference library: shared/skills, backend/skills, frontend/skills.
# With -SkillsRoot it checks a deployed project's <root>/.dsh/skills by the same rules, which is
# what DEPLOY.md step 8 asks for.
#
#   pwsh -NoProfile -File .\scripts\verify-library.ps1
#   pwsh -NoProfile -File .\scripts\verify-library.ps1 -Set frontend
#   pwsh -NoProfile -File .\scripts\verify-library.ps1 -SkillsRoot ..\my-project\.dsh\skills
#
# What it checks (DSH drops a skill that fails these, without saying so):
#   - <name>/SKILL.md exists, and the declared name is kebab-case, which the loader requires;
#   - SKILL.md does not start with a UTF-8 BOM, which would hide the frontmatter from the loader;
#   - frontmatter starts with ---, has name and description;
#   - frontmatter name equals the folder name unless the skill carries a SOURCE.md;
#   - description / whenToUse do not contain an unquoted colon (breaks YAML);
#   - every relative Markdown link inside SKILL.md points at an existing file;
#   - no nested SKILL.md, no AGENTS.md or CLAUDE.md inside a bundle, no flat <name>.md at the root;
#   - in base mode, every skill in the tracked .dsh/skills still equals the section it came from.
#
# Exit code: 0 = clean, 1 = problems found.
# Run it through pwsh: the DSH tool's own shell is 5.1 with an execution policy of Restricted,
# and a bare .\script.ps1 is refused there before it starts.
# Messages are ASCII on purpose: the 5.1 fallback in verify-set.cmd cannot read BOM-less UTF-8.

[CmdletBinding()]
param(
    [ValidateSet('shared', 'backend', 'frontend')]
    [string[]]$Set = @('shared', 'backend', 'frontend'),

    # A deployed project's skills root, usually <project>\.dsh\skills. Checked instead of the
    # sections, by the same rules, with the .dsh drift comparison left out.
    [string]$SkillsRoot
)

$ErrorActionPreference = 'Stop'
$base = Split-Path -Parent $PSScriptRoot
$problems = @()
$checked = 0
$targetMode = [bool]$SkillsRoot

# Deliberate placeholder links that appear in skill text as examples, not as resources.
$intentionalBrokenLinks = @{
    'wayfinder' = @('link')
}

if ($targetMode) {
    if (-not (Test-Path -LiteralPath $SkillsRoot)) { throw "no skills root: $SkillsRoot" }
    $roots = @([pscustomobject]@{ Label = 'target'; Path = (Resolve-Path -LiteralPath $SkillsRoot).Path })
}
else {
    $roots = @(foreach ($name in $Set) {
        $candidate = Join-Path $base "$name\skills"
        if (Test-Path -LiteralPath $candidate) { [pscustomobject]@{ Label = $name; Path = $candidate } }
    })
}

foreach ($r in $roots) {
    $flat = @(Get-ChildItem -LiteralPath $r.Path -File -Filter '*.md')
    if ($flat.Count -gt 0) {
        $problems += "$($r.Label) : flat .md at the skills root would be read as a skill: " + (($flat | ForEach-Object { $_.Name }) -join ', ')
    }

    foreach ($dir in (Get-ChildItem -LiteralPath $r.Path -Directory | Sort-Object Name)) {
        $checked++
        $skillFile = Join-Path $dir.FullName 'SKILL.md'
        $label = "$($r.Label)/$($dir.Name)"

        if (-not (Test-Path -LiteralPath $skillFile)) {
            $problems += "$label : no SKILL.md"
            continue
        }

        # A UTF-8 BOM turns the first line into "\ufeff---", and the loader compares that line byte
        # for byte: the whole skill is dropped with a "missing YAML frontmatter" warning. Get-Content
        # strips a BOM, so this has to look at the bytes.
        try {
            $head = [System.IO.File]::ReadAllBytes($skillFile)
            if ($head.Length -ge 3 -and $head[0] -eq 0xEF -and $head[1] -eq 0xBB -and $head[2] -eq 0xBF) {
                $problems += "$label : SKILL.md starts with a UTF-8 BOM, the loader then drops the skill"
            }
        }
        catch { }

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

        # The loader requires a kebab-case name and drops the whole skill on anything else.
        if ($nameLine) {
            $declared = ($nameLine -replace '^name:\s*', '').Trim().Trim('"').Trim("'")
            if ($declared -notmatch '^[a-z0-9]+(-[a-z0-9]+)*$') {
                $problems += "$label : name '$declared' is not kebab-case, the loader drops the skill"
            }
        }

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
            $allowed = $intentionalBrokenLinks[$dir.Name]
            if ($allowed -and ($allowed -contains $rel)) { continue }
            $target = Join-Path $dir.FullName $rel
            if (-not (Test-Path -LiteralPath $target)) {
                $problems += "$label : broken relative link -> $rel"
            }
        }

        # Structure the loader and the context budget care about.
        $nested = @(Get-ChildItem -LiteralPath $dir.FullName -Recurse -File -Filter 'SKILL.md' |
            Where-Object { $_.DirectoryName -ne $dir.FullName })
        if ($nested.Count -gt 0) {
            $problems += "$label : nested SKILL.md, the loader reads one level only"
        }
        $stray = @(Get-ChildItem -LiteralPath $dir.FullName -Recurse -File |
            Where-Object { $_.Name -eq 'AGENTS.md' -or $_.Name -eq 'CLAUDE.md' })
        if ($stray.Count -gt 0) {
            $problems += "$label : contains $($stray[0].Name), DSH loads it as directory instructions"
        }

        $tag = if ($vendored) { 'vendored' } else { 'own' }
        Write-Host ("OK  {0,-52} files: {1,-4} [{2}]" -f $label, (Get-ChildItem -LiteralPath $dir.FullName -Recurse -File).Count, $tag)
    }
}

# .dsh/skills is the base's own build of the library and it is tracked, so a copy that drifted
# from its section would be committed silently. Every entry there must equal its source section.
$dshRoot = Join-Path $base '.dsh\skills'
$dshChecked = 0
if (-not $targetMode -and (Test-Path -LiteralPath $dshRoot)) {
    foreach ($dir in (Get-ChildItem -LiteralPath $dshRoot -Directory | Sort-Object Name)) {
        $dshChecked++
        $source = $null
        foreach ($name in @('shared', 'backend', 'frontend')) {
            $candidate = Join-Path $base "$name\skills\$($dir.Name)"
            if (Test-Path -LiteralPath $candidate) { $source = $candidate; break }
        }
        if (-not $source) {
            $problems += ".dsh/skills/$($dir.Name) : no section provides this skill"
            continue
        }

        $installed = @{}
        foreach ($file in (Get-ChildItem -LiteralPath $dir.FullName -Recurse -File)) {
            $rel = $file.FullName.Substring($dir.FullName.Length + 1).Replace('\', '/')
            $installed[$rel] = (Get-FileHash -Algorithm SHA256 $file.FullName).Hash.ToLower()
        }
        $origin = @{}
        foreach ($file in (Get-ChildItem -LiteralPath $source -Recurse -File)) {
            $rel = $file.FullName.Substring($source.Length + 1).Replace('\', '/')
            $origin[$rel] = (Get-FileHash -Algorithm SHA256 $file.FullName).Hash.ToLower()
        }

        foreach ($rel in $origin.Keys) {
            if (-not $installed.ContainsKey($rel)) { $problems += ".dsh/skills/$($dir.Name) : missing $rel" }
            elseif ($installed[$rel] -ne $origin[$rel]) { $problems += ".dsh/skills/$($dir.Name) : differs from the section at $rel" }
        }
        foreach ($rel in $installed.Keys) {
            if (-not $origin.ContainsKey($rel)) { $problems += ".dsh/skills/$($dir.Name) : not in the section: $rel" }
        }
        Write-Host ("OK  {0,-52} [.dsh copy in step with its section]" -f ".dsh/$($dir.Name)")
    }
}

""
if ($targetMode) { "Skills checked in the target root: $checked." } else { "Skills checked: $checked." }
if ($dshChecked -gt 0) { ".dsh copies checked against their sections: $dshChecked." }
if ($problems.Count -gt 0) {
    ""
    "PROBLEMS:"
    $problems | ForEach-Object { " - $_" }
    exit 1
}
"No problems."
exit 0
