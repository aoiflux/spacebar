<#
.SYNOPSIS
    Build Spacebar end-to-end for Windows (exe), Linux, and Android.
.DESCRIPTION
    Runs full pre-build pipeline first (Flutter deps, FRB codegen, Rust test/build),
    then runs flutter build for each target platform and collects outputs
    into fixed folders under dist/.
.PARAMETER Targets
    Comma-separated list of targets to build: windows, linux, android.
    Defaults to all three.
.PARAMETER OutDir
    Root output directory. Defaults to .\dist.
.PARAMETER SkipPrebuild
    Skips pre-build pipeline (flutter pub get, FRB generate, Rust test/build).
.EXAMPLE
    .\build.ps1
    .\build.ps1 -Targets windows,android
    .\build.ps1 -OutDir C:\releases
    .\build.ps1 -SkipPrebuild
#>

param(
    [string[]] $Targets = @("windows", "linux", "android"),
    [string]   $OutDir = ".\dist",
    [switch]   $SkipPrebuild
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

function Test-Command([string]$name) {
    return $null -ne (Get-Command $name -ErrorAction SilentlyContinue)
}

function Run([string[]]$cmd) {
    & $cmd[0] $cmd[1..($cmd.Length - 1)]
    if ($LASTEXITCODE -ne 0) {
        throw "Command failed with exit code ${LASTEXITCODE}: $($cmd -join ' ')"
    }
}

# ── setup ────────────────────────────────────────────────────────────────────

$ProjectRoot = Split-Path -Parent $PSCommandPath
Push-Location $ProjectRoot

try {
    if (-not (Test-Command "flutter")) {
        throw "flutter is not available in PATH."
    }

    if (-not (Test-Command "cargo")) {
        throw "cargo is not available in PATH."
    }

    $normalizedTargets = @($Targets | ForEach-Object { $_.ToLowerInvariant() })
    $validTargets = @("windows", "linux", "android")
    $invalidTargets = @($normalizedTargets | Where-Object { $_ -notin $validTargets })
    if ($invalidTargets.Count -gt 0) {
        throw "Invalid target(s): $($invalidTargets -join ', '). Valid values: windows, linux, android."
    }

    $releaseRoot = if ([System.IO.Path]::IsPathRooted($OutDir)) { $OutDir } else { Join-Path $ProjectRoot $OutDir }
    New-Item -ItemType Directory -Force -Path $releaseRoot | Out-Null
    Write-Step "Output directory: $releaseRoot"

    $results = @()

    # ── pre-build pipeline ───────────────────────────────────────────────────────

    if (-not $SkipPrebuild) {
        Write-Step "Pre-build: Flutter dependencies"
        Run flutter, pub, get
        Write-Ok "flutter pub get completed"

        Write-Step "Pre-build: Flutter Rust Bridge code generation"
        if (-not (Test-Command "flutter_rust_bridge_codegen")) {
            throw "flutter_rust_bridge_codegen is not installed. Run: cargo install flutter_rust_bridge_codegen"
        }
        Run flutter_rust_bridge_codegen, generate
        Write-Ok "FRB bindings generated"

        Write-Step "Pre-build: Rust test and release build"
        Push-Location (Join-Path $ProjectRoot "rust")
        try {
            Run cargo, test
            Run cargo, build, --release
        }
        finally {
            Pop-Location
        }
        Write-Ok "Rust test/build completed"
    }
    else {
        Write-Step "Skipping pre-build pipeline (SkipPrebuild=true)"
    }

    # ── windows ──────────────────────────────────────────────────────────────────

    if ($normalizedTargets -contains "windows") {
        Write-Step "Building Windows (exe)..."
        try {
            Run flutter, build, windows, --release
            $src = Join-Path $ProjectRoot "build\windows\x64\runner\Release"
            $dst = Join-Path $releaseRoot "windows"
            if (Test-Path $dst) {
                Remove-Item -Recurse -Force -Path $dst
            }
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

    if ($normalizedTargets -contains "linux") {
        Write-Step "Building Linux..."
        try {
            Run flutter, build, linux, --release
            $src = Join-Path $ProjectRoot "build\linux\x64\release\bundle"
            $dst = Join-Path $releaseRoot "linux"
            if (Test-Path $dst) {
                Remove-Item -Recurse -Force -Path $dst
            }
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

    if ($normalizedTargets -contains "android") {
        Write-Step "Building Android (APK)..."
        try {
            Run flutter, build, apk, --release
            $src = Join-Path $ProjectRoot "build\app\outputs\flutter-apk\app-release.apk"
            $dst = Join-Path $releaseRoot "andrioid"
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
    Write-Host "  Output root: $releaseRoot" -ForegroundColor White
    Write-Host "────────────────────────────────────────`n" -ForegroundColor DarkGray

    $failed = ($results | Where-Object { $_.Status -eq "FAILED" }).Count
    if ($failed -gt 0) {
        exit 1
    }
}
finally {
    Pop-Location
}
