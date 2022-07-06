using MyTravels.WebApi.GraphQL;

namespace MyTravels.WebApi.Configurations
{
    public static class GraphQlDiExtensions
    {
        public static IServiceCollection AddGraphQL(this IServiceCollection services)
        {
            services.AddGraphQLServer()
                .AddDiagnosticEventListener<ErrorListener>()
                .AddQueryType<Query>()
                .AddProjections()
                .AddFiltering()
                .AddSorting();

            return services;
        }
    }
}
