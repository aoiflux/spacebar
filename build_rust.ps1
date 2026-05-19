#!/usr/bin/env pwsh
# PowerShell script to build Rust library for Windows

# Change to rust directory
$rustDir = Split-Path -Parent $MyInvocation.MyCommand.Path | Join-Path -ChildPath "rust"

Push-Location $rustDir

try {
    Write-Host "Building Rust library..."
    cargo build --release

    if ($LASTEXITCODE -ne 0) {
        Write-Error "Rust build failed"
        exit 1
    }

    Write-Host "Rust library built successfully"
}
finally {
    Pop-Location
}
