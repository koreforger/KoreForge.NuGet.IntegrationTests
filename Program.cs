// =============================================================================
// KoreForge NuGet Package Integration Tests
// This file verifies that all KoreForge NuGet packages can be referenced together
// =============================================================================

// AppLifecycle
using KoreForge.AppLifecycle;
using KoreForge.AppLifecycle.Hosting;
using KoreForge.AppLifecycle.Options;
using KoreForge.AppLifecycle.Flows;

// Kafka
using KoreForge.Kafka.Configuration.Extensions;
using KoreForge.Kafka.Configuration.Options;
using KoreForge.Kafka.Consumer.Hosting;
using KoreForge.Kafka.Producer.Abstractions;
using KoreForge.Kafka.AdminClient.Abstractions;
using KoreForge.Kafka.Core.Alerts;

// Logging
using KoreForge.Logging;
using KoreForge.Logging.Serilog;

// Metrics
using KoreForge.Metrics;
using KoreForge.Metrics.AspNet;

// Time
using KoreForge.Time;

// Web.Authorization
using KoreForge.Web.Authorization.Core;
using KoreForge.Web.Authorization.Core.Mvc;
using KoreForge.Web.Authorization.Dynamic;

// RestApi (Common packages)
using KoreForge.RestApi.Common.Abstractions.Options;
using KoreForge.RestApi.Common.Abstractions.DependencyInjection;
using KoreForge.RestApi.Common.Observability.Tracing;
using KoreForge.RestApi.Common.Observability.DependencyInjection;
using KoreForge.RestApi.Common.Persistence;
using KoreForge.RestApi.Common.Persistence.DependencyInjection;
using KoreForge.RestApi.Common.Persistence.Repositories;

Console.WriteLine("╔════════════════════════════════════════════════════════════════╗");
Console.WriteLine("║       KoreForge NuGet Package Integration Test                 ║");
Console.WriteLine("╚════════════════════════════════════════════════════════════════╝");
Console.WriteLine();
Console.WriteLine("All packages loaded successfully!");
Console.WriteLine();
Console.WriteLine("Installed Packages:");
Console.WriteLine("  • KoreForge.AppLifecycle");
Console.WriteLine("  • KoreForge.Kafka");
Console.WriteLine("  • KoreForge.Logging");
Console.WriteLine("  • KoreForge.Logging.Serilog");
Console.WriteLine("  • KoreForge.Metrics");
Console.WriteLine("  • KoreForge.Metrics.AspNet");
Console.WriteLine("  • KoreForge.Time");
Console.WriteLine("  • KoreForge.Web.Authorization");
Console.WriteLine("  • KoreForge.Web.RestApi.Abstractions");
Console.WriteLine("  • KoreForge.Web.RestApi.Observability");
Console.WriteLine("  • KoreForge.Web.RestApi.Persistence");
Console.WriteLine();
Console.WriteLine("Integration test completed successfully!");
