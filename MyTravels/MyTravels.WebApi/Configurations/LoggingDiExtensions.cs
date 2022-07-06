using Serilog;
using Path = System.IO.Path;

namespace MyTravels.WebApi.Configurations
{
    public static class LoggingDiExtensions
    {
        public static ILoggingBuilder AddSerilogLogging(this ILoggingBuilder builder)
        {
            var baseDirectory = AppDomain.CurrentDomain.BaseDirectory;
            var logsPathTemplate = "logs/.log";         
            var logsPath = Path.Combine(baseDirectory, logsPathTemplate);

            var logger = new LoggerConfiguration()
                .Enrich.FromLogContext()
                .WriteTo.File(logsPath, rollingInterval: RollingInterval.Day)
                .CreateLogger();

            builder = builder.AddSerilog(logger);

            return builder;
        }
    }
}
