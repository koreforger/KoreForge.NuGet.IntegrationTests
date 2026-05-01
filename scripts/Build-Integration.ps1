<#
.SYNOPSIS
    Builds the NuGet Integration Tests project.

.DESCRIPTION
    This script builds the integration test project to verify that all
    KoreForge NuGet packages can be referenced and compiled together.

.PARAMETER Configuration
    The build configuration. Default is 'Debug'.

.PARAMETER Clean
    If specified, cleans the project before building.

.PARAMETER Run
    If specified, runs the project after building.

.EXAMPLE
    .\Build-Integration.ps1
    .\Build-Integration.ps1 -Configuration Release
    .\Build-Integration.ps1 -Clean -Run
#>

[CmdletBinding()]
param(
    [ValidateSet('Debug', 'Release')]
    [string]$Configuration = 'Debug',
    
    [switch]$Clean,
    
    [switch]$Run
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$projectDir = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$projectFile = Join-Path $projectDir 'KF.Nuget.Integration.Tests.csproj'

Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║          BUILD KOREFORGE NUGET INTEGRATION TESTS                ║" -ForegroundColor Cyan
Write-Host "║              Configuration: $($Configuration.PadRight(35))║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path $projectFile)) {
    throw "Project file not found: $projectFile"
}

Push-Location $projectDir
try {
    # Clean if requested
    if ($Clean) {
        Write-Host "[Build] Cleaning project..." -ForegroundColor Yellow
        $cleanScript = Join-Path $PSScriptRoot 'Clean-Integration.ps1'
        if (Test-Path $cleanScript) {
            & $cleanScript
        }
        else {
            dotnet clean --configuration $Configuration 2>&1 | Out-Null
        }
    }
    
    # Restore packages
    Write-Host "[Build] Restoring packages..." -ForegroundColor Yellow
    dotnet restore 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) {
        throw "Package restore failed"
    }
    Write-Host "  ✓ Packages restored" -ForegroundColor Green
    
    # Build
    Write-Host "[Build] Building project..." -ForegroundColor Yellow
    $buildOutput = dotnet build --configuration $Configuration --no-restore 2>&1
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host ""
        Write-Host "Build Output:" -ForegroundColor Red
        $buildOutput | ForEach-Object { Write-Host $_ }
        throw "Build failed"
    }
    
    Write-Host "  ✓ Build succeeded" -ForegroundColor Green
    
    # Run if requested
    if ($Run) {
        Write-Host ""
        Write-Host "[Build] Running integration test..." -ForegroundColor Yellow
        Write-Host ""
        dotnet run --configuration $Configuration --no-build
        
        if ($LASTEXITCODE -ne 0) {
            throw "Run failed"
        }
    }
    
    Write-Host ""
    Write-Host "[Build] Integration test build completed successfully!" -ForegroundColor Green
    Write-Host ""
}
catch {
    Write-Host ""
    Write-Host "[Build] FAILED: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    exit 1
}
finally {
    Pop-Location
}
