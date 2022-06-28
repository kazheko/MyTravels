using Microsoft.EntityFrameworkCore;
using MyTravels.Core.Domain;

namespace MyTravels.Persistence
{
    public class ApplicationContext : DbContext
    {
        public DbSet<User> Users { get; set; }
        public DbSet<Destination> Destinations { get;set;}

        public ApplicationContext(DbContextOptions<ApplicationContext> options)
        : base(options)
        { 
            Database.EnsureCreated();
        }

        //public ApplicationContext()
        //{
        //    Database.EnsureCreated();
        //}

        //protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        //{
        //    optionsBuilder.UseNpgsql("Host=localhost;Port=5433;Database=usersdb;Username=postgres;Password=здесь_указывается_пароль_от_postgres");
        //}
    }
}