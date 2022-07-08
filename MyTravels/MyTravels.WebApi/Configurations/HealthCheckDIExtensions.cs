using Microsoft.Extensions.Diagnostics.HealthChecks;

namespace MyTravels.WebApi.Configurations
{
    public static class HealthCheckDIExtensions
    {
        public static IServiceCollection AddLiveHealthChecks(this IServiceCollection service, params string[] tags)
        {
            service.AddHealthChecks()
                .AddCheck("LiveHealthCheck", () => HealthCheckResult.Healthy(), tags);

            return service;
        }
    }
}
