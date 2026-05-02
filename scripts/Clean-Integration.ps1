<#
.SYNOPSIS
    Cleans the NuGet Integration Tests project and clears the package cache.

.DESCRIPTION
    This script removes build artifacts, test results, and clears the NuGet package
    cache for all KoreForge packages to ensure a fresh integration test.

.PARAMETER ClearGlobalCache
    If specified, clears the packages from the global NuGet cache (~/.nuget/packages).
    By default, only local build artifacts are cleaned.

.EXAMPLE
    .\Clean-Integration.ps1
    .\Clean-Integration.ps1 -ClearGlobalCache
#>

[CmdletBinding()]
param(
    [switch]$ClearGlobalCache
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$projectDir = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$projectFile = Join-Path $projectDir 'KoreForge.Nuget.Integration.Tests.csproj'

Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║          CLEAN KOREFORGE NUGET INTEGRATION TESTS                 ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path $projectFile)) {
    throw "Project file not found: $projectFile"
}

# Clean local build artifacts
Write-Host "[Clean] Removing bin and obj folders..." -ForegroundColor Yellow
$foldersToClean = @('bin', 'obj', 'docs')
foreach ($folder in $foldersToClean) {
    $folderPath = Join-Path $projectDir $folder
    if (Test-Path $folderPath) {
        Remove-Item -Path $folderPath -Recurse -Force
        Write-Host "  ✓ Removed: $folder" -ForegroundColor Green
    }
}

# Clean local NuGet packages folder
$packagesFolder = Join-Path $projectDir 'packages'
if (Test-Path $packagesFolder) {
    Remove-Item -Path $packagesFolder -Recurse -Force
    Write-Host "  ✓ Removed: packages" -ForegroundColor Green
}

if ($ClearGlobalCache) {
    Write-Host ""
    Write-Host "[Clean] Clearing KoreForge packages from global NuGet cache..." -ForegroundColor Yellow
    
    $nugetCache = Join-Path $env:USERPROFILE '.nuget\packages'
    $packagesToRemove = @(
        'koreforge.applifecycle',
        'KoreForge.kafka',
        'koreforge.logging',
        'koreforge.logging.serilog',
        'koreforge.metrics',
        'koreforge.metrics.aspnet',
        'koreforge.time',
        'koreforge.web.authorization',
        'koreforge.web.restapi.abstractions',
        'koreforge.web.restapi.observability',
        'koreforge.web.restapi.persistence'
    )
    
    foreach ($package in $packagesToRemove) {
        $packagePath = Join-Path $nugetCache $package
        if (Test-Path $packagePath) {
            Remove-Item -Path $packagePath -Recurse -Force
            Write-Host "  ✓ Removed from cache: $package" -ForegroundColor Green
        }
        else {
            Write-Host "  ○ Not in cache: $package" -ForegroundColor DarkGray
        }
    }
}

Write-Host ""
Write-Host "[Clean] Integration test project cleaned successfully!" -ForegroundColor Green
Write-Host ""
