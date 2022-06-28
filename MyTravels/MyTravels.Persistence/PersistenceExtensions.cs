using Microsoft.EntityFrameworkCore;

namespace MyTravels.Persistence
{
    public static class PersistenceExtensions
    {
        public static void UseNpgsqlProvider(this DbContextOptionsBuilder builder, string connectionString)
        {
            builder.UseNpgsql(connectionString);
        }
    }
}
