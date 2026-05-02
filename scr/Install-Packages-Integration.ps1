<#
.SYNOPSIS
    Installs all KoreForge NuGet packages into the integration test project.

.DESCRIPTION
    This script adds all KoreForge NuGet packages from local artifact folders
    to the integration test project for testing package compatibility.

.PARAMETER Version
    The version of the packages to install. Default is '0.0.7-alpha'.

.PARAMETER Force
    If specified, forces reinstall even if packages are already installed.

.EXAMPLE
    .\Install-Packages-Integration.ps1
    .\Install-Packages-Integration.ps1 -Version 0.0.7-alpha
    .\Install-Packages-Integration.ps1 -Version 0.0.7-alpha -Force
#>

[CmdletBinding()]
param(
    [string]$Version = '0.0.7-alpha',
    
    [switch]$Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$projectDir = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$projectFile = Join-Path $projectDir 'KoreForge.Nuget.Integration.Tests.csproj'

Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║          INSTALL PACKAGES - KOREFORGE NUGET INTEGRATION TESTS      ║" -ForegroundColor Cyan
Write-Host "║              Version: $($Version.PadRight(40))║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path $projectFile)) {
    throw "Project file not found: $projectFile"
}

# Define all packages to install
$packages = @(
    @{ Name = 'KoreForge.AppLifecycle'; Source = 'KoreForge.AppLifecycle' },
    @{ Name = 'KoreForge.Kafka'; Source = 'KoreForge.Kafka' },
    @{ Name = 'KoreForge.Logging'; Source = 'KoreForge.Logging' },
    @{ Name = 'KoreForge.Logging.Serilog'; Source = 'KoreForge.Logging.Serilog' },
    @{ Name = 'KoreForge.Metrics'; Source = 'KoreForge.Metrics' },
    @{ Name = 'KoreForge.Metrics.AspNet'; Source = 'KoreForge.Metrics.AspNet' },
    @{ Name = 'KoreForge.Time'; Source = 'KoreForge.Time' },
    @{ Name = 'KoreForge.Web.Authorization'; Source = 'KoreForge.Web.Authorization' },
    @{ Name = 'KoreForge.Web.RestApi.Abstractions'; Source = 'KoreForge.Web' },
    @{ Name = 'KoreForge.Web.RestApi.Observability'; Source = 'KoreForge.Web' },
    @{ Name = 'KoreForge.Web.RestApi.Persistence'; Source = 'KoreForge.Web' }
)

Push-Location $projectDir
try {
    $results = @()
    
    foreach ($pkg in $packages) {
        Write-Host "[Install] Adding $($pkg.Name)..." -ForegroundColor Yellow
        
        $result = [PSCustomObject]@{
            Package = $pkg.Name
            Status  = 'Unknown'
            Error   = $null
        }
        
        try {
            if ($Force) {
                # Remove existing reference first
                $csprojContent = Get-Content $projectFile -Raw
                if ($csprojContent -match "<PackageReference Include=`"$($pkg.Name)`"") {
                    dotnet remove package $pkg.Name 2>&1 | Out-Null
                }
            }
            
            $output = dotnet add package $pkg.Name --version $Version 2>&1
            
            if ($LASTEXITCODE -eq 0) {
                $result.Status = 'Success'
                Write-Host "  ✓ $($pkg.Name) $Version installed" -ForegroundColor Green
            }
            else {
                # Check if it's already installed
                if ($output -match 'already exists') {
                    $result.Status = 'Skipped'
                    $result.Error = 'Already installed'
                    Write-Host "  ○ $($pkg.Name) already installed" -ForegroundColor DarkGray
                }
                else {
                    throw "dotnet add failed: $output"
                }
            }
        }
        catch {
            $result.Status = 'Failed'
            $result.Error = $_.Exception.Message
            Write-Host "  ✗ $($pkg.Name) FAILED: $($_.Exception.Message)" -ForegroundColor Red
        }
        
        $results += $result
    }
    
    # Summary
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║                    INSTALL SUMMARY                             ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    
    $successCount = @($results | Where-Object { $_.Status -eq 'Success' }).Count
    $failedCount = @($results | Where-Object { $_.Status -eq 'Failed' }).Count
    $skippedCount = @($results | Where-Object { $_.Status -eq 'Skipped' }).Count
    
    Write-Host "  Total: $($results.Count) | Success: $successCount | Failed: $failedCount | Skipped: $skippedCount" -ForegroundColor White
    Write-Host ""
    
    if ($failedCount -gt 0) {
        exit 1
    }
}
finally {
    Pop-Location
}
