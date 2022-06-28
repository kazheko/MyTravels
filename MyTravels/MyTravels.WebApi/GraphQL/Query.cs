using MyTravels.Core.Domain;
using MyTravels.Persistence;

namespace MyTravels.WebApi.GraphQL
{
    public class Query
    {
        [UseDbContext(typeof(ApplicationContext))]
        [UseProjection]
        [UseFiltering]
        [UseSorting]
        public IQueryable<User> GetUsers([ScopedService] ApplicationContext context)
        {
            return context.Users;
        }

        [UseDbContext(typeof(ApplicationContext))]
        [UseProjection]
        [UseFiltering]
        [UseSorting]
        public IQueryable<Destination> GetDestinations([ScopedService] ApplicationContext context)
        {
            return context.Destinations;
        }
    }
}
