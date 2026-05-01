# NuGet Integration Tests

This project validates that all KoreForge NuGet packages can be installed and used together in a single application.

## Purpose

- Verify all NuGet packages install correctly
- Ensure no dependency conflicts between packages
- Validate all namespaces are accessible
- Confirm packages build together successfully

## Prerequisites

1. All KoreForge solution packages must be built and packed first:
   ```powershell
   # From the root scripts folder
   cd c:\My\KoreForge\scripts
   .\Pack-All.ps1
   ```

## Scripts

### Clean-Integration.ps1
Removes build artifacts and optionally clears the NuGet cache.

```powershell
# Clean local build artifacts only
.\scr\Clean-Integration.ps1

# Also clear packages from global NuGet cache
.\scr\Clean-Integration.ps1 -ClearGlobalCache
```

### Install-Packages-Integration.ps1
Installs all KoreForge NuGet packages into the project.

```powershell
# Install with default version (0.0.10)
.\scr\Install-Packages-Integration.ps1

# Install specific version
.\scr\Install-Packages-Integration.ps1 -Version 0.0.11

# Force reinstall
.\scr\Install-Packages-Integration.ps1 -Force
```

### Build-Integration.ps1
Builds the project to verify all packages work together.

```powershell
# Build only
.\scr\Build-Integration.ps1

# Clean and build
.\scr\Build-Integration.ps1 -Clean

# Build and run
.\scr\Build-Integration.ps1 -Run

# Release build
.\scr\Build-Integration.ps1 -Configuration Release
```

## Full Integration Test Workflow

```powershell
# 1. Clean everything
.\scr\Clean-Integration.ps1 -ClearGlobalCache

# 2. Pack all solutions (from root scripts folder)
cd c:\My\KoreForge\scripts
.\Pack-All.ps1

# 3. Install packages (from integration tests folder)
cd c:\My\KoreForge\Nuget.Integration.Tests
.\scr\Install-Packages-Integration.ps1

# 4. Build and run
.\scr\Build-Integration.ps1 -Run
```

## Installed Packages

| Package | Source Solution |
|---------|-----------------|
| KoreForge.AppLifecycle | KoreForge.AppLifeCycle |
| KoreForge.Kafka | KoreForge.Kafka |
| KoreForge.Logging | KoreForge.Logging |
| KoreForge.Logging.Serilog | KoreForge.Logging |
| KoreForge.Metrics | KoreForge.Metrics |
| KoreForge.MultiApp.Settings | KoreForge.MultiApp.Settings |
| KoreForge.Processing.Pipelines | KoreForge.Processing.Pipelines |
| KoreForge.Time | KoreForge.Time |
| KoreForge.Web.Authorization | KoreForge.Web.Authorization |
| Common.Abstractions | KoreForge.RestApi |
| Common.Observability | KoreForge.RestApi |
| Common.Persistence | KoreForge.RestApi |

## Local NuGet Sources

The `NuGet.config` file is configured to look for packages in the local artifact folders of each solution. This allows testing locally built packages before publishing to a NuGet feed.

