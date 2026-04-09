<#
.SYNOPSIS
    Build Spacebar for Windows (exe), Linux, and Android.
.DESCRIPTION
    Runs flutter build for each target platform and collects all
    outputs into a timestamped folder under dist/.
.PARAMETER Targets
    Comma-separated list of targets to build: windows, linux, android.
    Defaults to all three.
.PARAMETER OutDir
    Root output directory. Defaults to .\dist.
.EXAMPLE
    .\build.ps1
    .\build.ps1 -Targets windows,android
    .\build.ps1 -OutDir C:\releases
#>

param(
    [string[]] $Targets = @("windows", "linux", "android"),
    [string]   $OutDir = ".\dist"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ── helpers ──────────────────────────────────────────────────────────────────

function Write-Step([string]$msg) {
    Write-Host "`n==> $msg" -ForegroundColor Cyan
}

function Write-Ok([string]$msg) {
    Write-Host "    $msg" -ForegroundColor Green
}

function Write-Err([string]$msg) {
    Write-Host "    ERROR: $msg" -ForegroundColor Red
}

function Run([string[]]$cmd) {
    & $cmd[0] $cmd[1..($cmd.Length - 1)]
    if ($LASTEXITCODE -ne 0) {
        throw "Command failed with exit code ${LASTEXITCODE}: $($cmd -join ' ')"
    }
}

# ── setup ────────────────────────────────────────────────────────────────────

$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$release = Join-Path $OutDir $stamp
New-Item -ItemType Directory -Force -Path $release | Out-Null
Write-Step "Output directory: $release"

$results = @()

# ── windows ──────────────────────────────────────────────────────────────────

if ($Targets -contains "windows") {
    Write-Step "Building Windows (exe)..."
    try {
        Run flutter, build, windows, --release
        $src = "build\windows\x64\runner\Release"
        $dst = Join-Path $release "windows"
        Copy-Item -Recurse -Force -Path $src -Destination $dst
        Write-Ok "Copied → $dst"
        $results += [pscustomobject]@{ Target = "windows"; Status = "OK"; Path = $dst }
    }
    catch {
        Write-Err $_
        $results += [pscustomobject]@{ Target = "windows"; Status = "FAILED"; Path = "" }
    }
}

# ── linux ─────────────────────────────────────────────────────────────────────

if ($Targets -contains "linux") {
    Write-Step "Building Linux..."
    try {
        Run flutter, build, linux, --release
        $src = "build\linux\x64\release\bundle"
        $dst = Join-Path $release "linux"
        Copy-Item -Recurse -Force -Path $src -Destination $dst
        Write-Ok "Copied → $dst"
        $results += [pscustomobject]@{ Target = "linux"; Status = "OK"; Path = $dst }
    }
    catch {
        Write-Err $_
        $results += [pscustomobject]@{ Target = "linux"; Status = "FAILED"; Path = "" }
    }
}

# ── android ───────────────────────────────────────────────────────────────────

if ($Targets -contains "android") {
    Write-Step "Building Android (APK)..."
    try {
        Run flutter, build, apk, --release
        $src = "build\app\outputs\flutter-apk\app-release.apk"
        $dst = Join-Path $release "android"
        New-Item -ItemType Directory -Force -Path $dst | Out-Null
        Copy-Item -Force -Path $src -Destination (Join-Path $dst "spacebar.apk")
        Write-Ok "Copied → $dst\spacebar.apk"
        $results += [pscustomobject]@{ Target = "android"; Status = "OK"; Path = "$dst\spacebar.apk" }
    }
    catch {
        Write-Err $_
        $results += [pscustomobject]@{ Target = "android"; Status = "FAILED"; Path = "" }
    }
}

# ── summary ───────────────────────────────────────────────────────────────────

Write-Host "`n────────────────────────────────────────" -ForegroundColor DarkGray
Write-Host "  Build summary" -ForegroundColor White
Write-Host "────────────────────────────────────────" -ForegroundColor DarkGray
$results | Format-Table -AutoSize
Write-Host "  Release folder: $release" -ForegroundColor White
Write-Host "────────────────────────────────────────`n" -ForegroundColor DarkGray

$failed = ($results | Where-Object { $_.Status -eq "FAILED" }).Count
if ($failed -gt 0) {
    exit 1
}
