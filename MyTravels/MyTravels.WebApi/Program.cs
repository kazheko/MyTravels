using MyTravels.Persistence;
using MyTravels.WebApi.Configurations;

var builder = WebApplication.CreateBuilder(args);

builder.Logging.ClearProviders();
builder.Logging.AddSerilogLogging();

builder.Services.AddPooledDbContextFactory<ApplicationContext>(x =>
    x.UseNpgsqlProvider(builder.Configuration.GetDefaultConnection()));

builder.Services.AddGraphQL();

var app = builder.Build();

app.MapGraphQL();

app.Run();
