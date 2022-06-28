using Microsoft.EntityFrameworkCore;
using MyTravels.Core.Domain;

namespace MyTravels.Persistence
{
    public static class PersistenceExtensions
    {
        public static void UseNpgsqlProvider(this DbContextOptionsBuilder builder, string connectionString)
        {
            builder.UseNpgsql(connectionString);
        }

        internal static void SeedData(this ModelBuilder modelBuilder)
        {
            var now = DateTime.Now.ToUniversalTime();

            modelBuilder.Entity<User>().HasData
            (
                new { Id = 1, Name = "John Doe", CreatedAt = now },
                new { Id = 2, Name = "Jane Doe", CreatedAt = now }
            );

            modelBuilder.Entity<Travel>().HasData
            (
                new { Id = 1, UserId = 1, Name = "Italy", CreatedAt = now },
                new { Id = 2, UserId = 2, Name = "Poland", CreatedAt = now }
            );

            modelBuilder.Entity<Destination>().HasData
            (
                new { Id = 1, TravelId = 1, Name = "Milan", Lat = 45.466944m, Lang = 9.19m, CreatedAt = now },
                new { Id = 2, TravelId = 1, Name = "Verona", Lat = 45.438611m, Lang = 10.992778m, CreatedAt = now },
                new { Id = 3, TravelId = 1, Name = "Venice", Lat = 45.4375m, Lang = 12.335833m, CreatedAt = now },
                new { Id = 4, TravelId = 2, Name = "Wrocław", Lat = 51.11m, Lang = 17.0325m, CreatedAt = now },
                new { Id = 5, TravelId = 2, Name = "Olsztyn", Lat = 53.777778m, Lang = 20.479167m, CreatedAt = now }
            );

            modelBuilder.Entity<Note>().HasData
            (
                new { Id = 1, DestinationId = 1, Description = "Visit the Milan Cathedral" },
                new { Id = 2, DestinationId = 2, Description = "Visit the Verona Arena" },
                new { Id = 3, DestinationId = 3, Description = "Visit St Mark's Square" },
                new { Id = 4, DestinationId = 4, Description = "Visit Old Town" },
                new { Id = 5, DestinationId = 5, Description = "Visit Old Town" }
            );
        }
    }
}
