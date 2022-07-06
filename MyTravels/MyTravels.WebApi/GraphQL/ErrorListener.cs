using HotChocolate.Execution;
using HotChocolate.Execution.Instrumentation;
using HotChocolate.Resolvers;

namespace MyTravels.WebApi.GraphQL
{
    public class ErrorListener : ExecutionDiagnosticEventListener
    {
        private readonly ILogger<ErrorListener> _logger;

        public ErrorListener(ILogger<ErrorListener> logger)
        {
            _logger = logger;
        }

        public override void RequestError(IRequestContext context, Exception exception)
        {
            _logger.LogError("A request error occured: {@error}", exception);

            base.RequestError(context, exception);
        }

        public override void ResolverError(IMiddlewareContext context, IError error)
        {
            _logger.LogError("A request error occured: {@error}", error.Exception);

            base.ResolverError(context, error);
        }
    }
}
