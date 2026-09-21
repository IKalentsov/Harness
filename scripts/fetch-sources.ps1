# fetch-sources.ps1
# Downloads official skill repositories into _vendor/ so their skills can be vendored
# into this reference repository.
#
#   .\scripts\fetch-sources.ps1 -List
#   .\scripts\fetch-sources.ps1 -Source dotnet,postgres
#   .\scripts\fetch-sources.ps1 -Source vercel -UseGit
#
# Transport: curl.exe + codeload tarball by default. git clone is available with -UseGit,
# but inside the DSH sandbox git fails on TLS (schannel: SEC_E_NO_CREDENTIALS) while curl works.
# Messages are ASCII on purpose: Windows PowerShell 5.1 reads BOM-less .ps1 as ANSI.

[CmdletBinding()]
param(
    [string[]]$Source = @(),
    [switch]$List,
    [switch]$Update,
    [switch]$UseGit,
    [string]$Vendor = '_vendor'
)

$ErrorActionPreference = 'Stop'

# name -> owner/repo
$repositories = [ordered]@{
    'dotnet'    = 'dotnet/skills'
    'postgres'  = 'neondatabase/postgres-skills'
    'redis'     = 'redis/agent-skills'
    'mongodb'   = 'mongodb/agent-skills'
    'supabase'  = 'supabase/agent-skills'
    'vercel'    = 'vercel-labs/agent-skills'
    'anthropic' = 'anthropics/skills'
    'copilot'   = 'github/awesome-copilot'
}

$Source = @($Source | ForEach-Object { $_ -split ',' } | Where-Object { $_ } | ForEach-Object { $_.Trim() } | Select-Object -Unique)

if ($List -or $Source.Count -eq 0) {
    Write-Host 'available sources:'
    $repositories.GetEnumerator() | ForEach-Object { Write-Host ("  {0,-10} {1}" -f $_.Key, $_.Value) }
    if ($Source.Count -eq 0) {
        Write-Host ''
        Write-Host 'usage: .\scripts\fetch-sources.ps1 -Source dotnet,postgres'
        return
    }
}

foreach ($name in $Source) {
    if (-not $repositories.Contains($name)) {
        Write-Warning "unknown source '$name'; run with -List to see the catalog"
    }
}

$base = Split-Path -Parent $PSScriptRoot
$vendorPath = Join-Path $base $Vendor
if (-not (Test-Path -LiteralPath $vendorPath)) {
    New-Item -ItemType Directory -Force -Path $vendorPath | Out-Null
}

$curl = (Get-Command curl.exe -ErrorAction SilentlyContinue).Source
$tar = (Get-Command tar.exe -ErrorAction SilentlyContinue).Source

foreach ($name in $Source) {
    if (-not $repositories.Contains($name)) { continue }
    $repo = $repositories[$name]
    $dest = Join-Path $vendorPath $name

    if (Test-Path -LiteralPath $dest) {
        if ($Update) { Remove-Item -LiteralPath $dest -Recurse -Force }
        else {
            Write-Host "skip '$name': already present at $dest (use -Update to refresh)"
            continue
        }
    }

    if ($UseGit) {
        Write-Host "clone '$name' <- $repo"
        git clone --depth 1 "https://github.com/$repo" $dest
        continue
    }

    if (-not $curl) { throw 'curl.exe not found; rerun with -UseGit' }
    if (-not $tar) { throw 'tar.exe not found; rerun with -UseGit' }

    $archive = Join-Path $env:TEMP "$name.tar.gz"
    $staging = Join-Path $env:TEMP "$name-extract"
    if (Test-Path -LiteralPath $staging) { Remove-Item -LiteralPath $staging -Recurse -Force }
    New-Item -ItemType Directory -Force -Path $staging | Out-Null

    Write-Host "download '$name' <- https://codeload.github.com/$repo"
    & $curl -sSL --fail -o $archive "https://codeload.github.com/$repo/tar.gz/refs/heads/main"
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "download failed for '$name' (curl exit $LASTEXITCODE)"
        continue
    }

    # Start-Process keeps tar's stderr out of PowerShell's NativeCommandError path.
    $tarRun = Start-Process -FilePath $tar -ArgumentList @('-xzf', $archive, '-C', $staging) -NoNewWindow -Wait -PassThru
    # Windows cannot create symlinks from the archive (for example CLAUDE.md -> AGENTS.md),
    # so tar reports a non-zero exit even though the tree unpacked. Judge by content.
    $unpacked = @(Get-ChildItem -LiteralPath $staging -Force -ErrorAction SilentlyContinue).Count -gt 0
    if (-not $unpacked) {
        Write-Warning "unpack failed for '$name' (tar exit $($tarRun.ExitCode))"
        continue
    }
    if ($tarRun.ExitCode -ne 0) {
        Write-Host '  note: tar skipped symlinked files (windows cannot create them)'
    }

    $inner = Get-ChildItem -LiteralPath $staging -Directory | Select-Object -First 1
    if ($null -eq $inner) {
        Write-Warning "unexpected archive layout for '$name'"
        continue
    }

    Move-Item -LiteralPath $inner.FullName -Destination $dest
    Remove-Item -LiteralPath $archive -Force
    Remove-Item -LiteralPath $staging -Recurse -Force
    Write-Host "  -> $dest"
}

Write-Host ''
Write-Host 'done. next steps:'
Write-Host '  1. pick the skills that fit the stack (see backend/sources.md, frontend/sources.md)'
Write-Host '  2. copy them into <set>/skills/<name>/ (SKILL.md plus its references, rules, scripts)'
Write-Host '  3. add SOURCE.md next to the skill: repository, path, commit, date, license'
Write-Host '  4. drop any AGENTS.md inside a skill folder: DSH loads it as directory instructions'
Write-Host '  5. _vendor/ is not committed'
