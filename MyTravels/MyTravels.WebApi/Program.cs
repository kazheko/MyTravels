using MyTravels.Persistence;
using MyTravels.WebApi.GraphQL;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddPooledDbContextFactory<ApplicationContext>(x =>
    x.UseNpgsqlProvider(builder.Configuration.GetConnectionString("GeneralConection")));

builder.Services.AddGraphQLServer()
    .AddQueryType<Query>()
    .AddProjections()
    .AddFiltering()
    .AddSorting();

var app = builder.Build();

app.MapGraphQL();

app.Run();
