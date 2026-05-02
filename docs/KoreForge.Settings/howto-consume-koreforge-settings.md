# How to Consume KoreForge Settings Packages

This guide is for developers integrating the KoreForge Settings libraries or CLI into their own applications.

## Choose the NuGet packages

| Scenario | Recommended packages |
| --- | --- |
| Configuration provider for apps | `KoreForge.MultiApp.Settings` (NuGet package bundling the abstractions/core/data/encryption/metrics/provider assemblies)
| Access shared abstractions only | `KoreForge.Settings.Abstractions`
| Command-line management | `KoreForge.Settings.Cli` (global or local tool)

> One `KoreForge.MultiApp.Settings` reference copies every runtime assembly (Abstractions, Core, Data, Encryption, Metrics, Provider) into your app output so you never chase multiple package versions.

```bash
# Example: add the provider package to a web app
 dotnet add package KoreForge.MultiApp.Settings

# Example: install the CLI as a local tool
 dotnet tool install --local KoreForge.Settings.Cli
```

## Configure your application

1. **Connection string** – supply it explicitly, via `appsettings.json`, or using the `KOREFORGE_SETTINGS_CONNECTIONSTRING` environment variable.
2. **Add the configuration source** during host builder setup.
3. **Register services** so consumers can request `ISettingsService`, `IHistoryService`, etc.

```csharp
var builder = WebApplication.CreateBuilder(args);

builder.Configuration.AddKoreForgeSettings(opts =>
{
    opts.ConnectionString = builder.Configuration.GetConnectionString("KoreForgeSettings");
    opts.EnableDecryption = false;
    opts.EnableMetrics = true;
});

builder.Services.AddKoreForgeSettingsServices(builder.Configuration);
```

> The provider automatically resolves the connection string using `KoreForge:Settings:ConnectionString`, `ConnectionStrings:KoreForgeSettings`, or the `KOREFORGE_SETTINGS_CONNECTIONSTRING` environment variable, so you only need to set it if the defaults do not apply.

## Using the CLI

After installing `KoreForge.Settings.Cli`, point it at the same connection string:

```bash
# List current settings
koreforge-settings list --connection "Server=.;Database=KoreForgeSettings;Trusted_Connection=True"

# Update a value
koreforge-settings set --app Sample --key FeatureFlag --value true
```

## Best practices

- **Centralize options** – keep the `KoreForgeSettingsOptions` initialization in one place (usually `Program.cs`) so connection strings and feature flags stay consistent between the host and CLI.
- **Enable metrics intentionally** – leave `EnableMetrics` off unless you have a collector reading the in-memory recorder or plan to swap in a custom `IMetricsRecorder`.
- **Encrypt sensitive values** – register a custom `IEncryptionProvider` and set `EnableDecryption=true` before storing secrets. Default `NoOpEncryptionProvider` leaves content in plain text.
- **Watch row versions** – the provider enforces optimistic concurrency; handle `ConcurrencyConflictException` in your calling code if you manipulate settings directly.
- **Keep packages aligned** – reference the same version of every `KoreForge.Settings.*` package in your solution to avoid binding issues. All packages ship together, so upgrade them as a set.

## Common pitfalls

| Pitfall | How to avoid it |
| --- | --- |
| Missing connection string | Either set `opts.ConnectionString`, add `ConnectionStrings:KoreForgeSettings`, or export `KOREFORGE_SETTINGS_CONNECTIONSTRING`. The service registration throws if nothing resolves.
| `EnableDecryption=true` without a provider | Register an `IEncryptionProvider` implementation before calling `AddKoreForgeSettingsServices` or leave encryption disabled.
| Running migrations manually | The data layer handles EF Core migrations internally. Use the CLI or application bootstrapper; do not apply schema changes outside coordinated releases.
| Multiple configuration builders | Always call `AddKoreForgeSettings` on the same `ConfigurationManager` instance you pass into `AddKoreForgeSettingsServices`. Copying configuration objects loses the options tuple stored in `builder.Properties`.
| Divergent package versions | Do not mix versions from different tags. Use `dotnet list package --outdated` to confirm everything shares the same SemVer.

## Next steps

- Review `docs/versioning-guide.md` for release/tagging instructions.
- See `docs/build-publish.md` for the scripts that build, test, and pack this solution.
