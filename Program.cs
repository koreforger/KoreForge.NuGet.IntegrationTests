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
using KF.Kafka.Configuration.Extensions;
using KF.Kafka.Configuration.Options;
using KF.Kafka.Consumer.Hosting;
using KF.Kafka.Producer.Abstractions;
using KF.Kafka.AdminClient.Abstractions;
using KF.Kafka.Core.Alerts;

// Logging
using KF.Logging;
using KF.Logging.Serilog;

// Metrics
using KF.Metrics;
using KF.Metrics.AspNet;

// Time
using KF.Time;

// Web.Authorization
using KF.Web.Authorization.Core;
using KF.Web.Authorization.Core.Mvc;
using KF.Web.Authorization.Dynamic;

// RestApi (Common packages)
using KF.RestApi.Common.Abstractions.Options;
using KF.RestApi.Common.Abstractions.DependencyInjection;
using KF.RestApi.Common.Observability.Tracing;
using KF.RestApi.Common.Observability.DependencyInjection;
using KF.RestApi.Common.Persistence;
using KF.RestApi.Common.Persistence.DependencyInjection;
using KF.RestApi.Common.Persistence.Repositories;

Console.WriteLine("╔════════════════════════════════════════════════════════════════╗");
Console.WriteLine("║       KoreForge NuGet Package Integration Test                 ║");
Console.WriteLine("╚════════════════════════════════════════════════════════════════╝");
Console.WriteLine();
Console.WriteLine("All packages loaded successfully!");
Console.WriteLine();
Console.WriteLine("Installed Packages:");
Console.WriteLine("  • KoreForge.AppLifecycle");
Console.WriteLine("  • KF.Kafka");
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
