# How to Extend the KoreForge Settings Solution

This guide is for contributors enhancing the libraries or CLI in this repository.

## Repository layout (quick map)

| Project | Purpose |
| --- | --- |
| `KoreForge.Settings.Abstractions` | Contracts, models, and exceptions shared by all components |
| `KoreForge.Settings.Core` | Core services (business logic, health reporting) |
| `KoreForge.Settings.Data` | EF Core data access and SQL Server integration |
| `KoreForge.Settings.Encryption` | Default `IEncryptionProvider` implementation |
| `KoreForge.Settings.Metrics` | Metrics abstractions and in-memory recorder |
| `KoreForge.Settings.Provider` | Configuration provider, dependency injection wiring, background reload service |
| `KoreForge.Settings.Cli` | Tooling for managing settings data |
| `KoreForge.Settings.Tests` | Unit/integration tests covering the layers above |
| Samples (`ConsoleSample`, `Sample`) | Smoke-test apps; never published |

## Local developer workflow

1. Clone the repo and ensure you are on the correct feature branch.
2. Install the .NET 9 SDK.
3. Use the scripts in `/scripts`:
   - `scr/build-rebuild.ps1` – restore + build the full solution.
   - `scr/build-test.ps1` – run the unit tests (coverage on by default).
   - `scr/build-test-codecoverage.ps1 -OpenReport` – regenerate the HTML report in `TestResults/Coverage` and open it.
4. For package builds, run `scr/build-pack.ps1` and inspect `artifacts/packages`.
5. Remember that everything under `buildTransitive/` (currently `KoreForge.Settings.CopyDocs.targets`) ships with each NuGet package and executes inside *consuming* projects. Keep those files stable—they copy the `/docs` folder into downstream solutions so implementers always have the latest guidance.

## Adding new functionality

1. **Start in the right layer.**
   - Shared contracts go in `KoreForge.Settings.Abstractions`.
   - Data changes live in `KoreForge.Settings.Data` (include EF migrations + SQL script updates if necessary).
   - Provider-level behaviors belong in `KoreForge.Settings.Provider` or `KoreForge.Settings.Core`.
2. **Keep projects packable.** MinVer drives all versions; do not add `<Version>` nodes to any `.csproj`.
3. **Add tests before wiring samples.** Place new unit tests under `KoreForge.Settings.Tests` in the matching folder (Services/Provider/etc.).
4. **Update documentation.** If your change alters public behavior, update the relevant how-to doc and the sample `appsettings.json` where appropriate.
5. **Follow coding standards.** Nullable + implicit usings are enabled; treat warnings as errors. Use succinct comments only when logic is non-obvious.
6. **Regenerate coverage.** Ensure the HTML report reflects your change before submitting a PR.

## Design guidelines

- **Public API surface** lives in the abstractions project. Breaking changes require a MAJOR version bump; consult `docs/versioning-guide.md`.
- **DI-friendly services** – keep constructors minimal and favor interfaces for dependencies.
- **Options-driven behavior** – prefer extending `KoreForgeSettingsOptions` to adding new global statics.
- **Background services** – hook into `SettingsReloadBackgroundService` rather than starting additional hosted services whenever possible.
- **CLI parity** – any feature you add to the provider should have equivalent support in the CLI when it affects administrators.

## Review checklist

- [ ] Unit tests cover the new code paths and pass via `scr/build-test.ps1`.
- [ ] Coverage HTML in `TestResults/Coverage` shows meaningful lines touched.
- [ ] Scripts and docs require no manual edits to work on a clean machine.
- [ ] No generated artifacts (`TestResults`, `artifacts`, `bin`, `obj`) are committed.

