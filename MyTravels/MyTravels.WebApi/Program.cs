using Microsoft.AspNetCore.Diagnostics.HealthChecks;
using MyTravels.Persistence;
using MyTravels.WebApi.Configurations;

const string healthCheckTagLive = "live";

var builder = WebApplication.CreateBuilder(args);

builder.Logging.ClearProviders();
builder.Logging.AddSerilogLogging();

builder.Services.AddLiveHealthChecks(healthCheckTagLive);

builder.Services.AddPooledDbContextFactory<ApplicationContext>(x =>
    x.UseNpgsqlProvider(builder.Configuration.GetDefaultConnection()));

builder.Services.AddGraphQL();

var app = builder.Build();

app.MapGraphQL();

app.MapHealthChecks("/health/live", new HealthCheckOptions { Predicate = x => x.Tags.Contains(healthCheckTagLive) });

app.Run();
