using Microsoft.AspNetCore.Mvc;
using MyTravels.Persistence;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddDbContext<ApplicationContext>(x =>
    x.UseNpgsqlProvider(builder.Configuration.GetConnectionString("GeneralConection")));

var app = builder.Build();

app.MapGet("/", ([FromServices]ApplicationContext ctx) => {
    var result = ctx.Destinations.ToList();
    return "Hello World!"; 
});

app.Run();
