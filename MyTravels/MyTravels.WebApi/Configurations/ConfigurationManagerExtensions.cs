namespace MyTravels.WebApi.Configurations
{
    public static class ConfigurationManagerExtensions
    {
        private const string ConnectionName = "DefaultConnection";

        public static string GetDefaultConnection(this ConfigurationManager configuration)
        {
            return configuration.GetConnectionString(ConnectionName);
        }
    }
}
