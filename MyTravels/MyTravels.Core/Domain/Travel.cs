namespace MyTravels.Core.Domain
{
    public class Travel
    {
        private Travel() { }

        public Travel(int userId, string name)
        {
            UserId = userId;
            Name = name;
            CreatedAt = DateTime.Now.ToUniversalTime();
            Destinations = new List<Destination>();
        }

        public int Id { get; private set; }
        public int UserId { get; private set; }
        public string Name { get; private set; }
        public string? Description { get; private set; }
        public DateTime CreatedAt { get; private set; }
        public DateTime? CompletedAt { get; private set; }
        public ICollection<Destination> Destinations { get; private set; }

        public Destination AddDestination(string name, decimal lat, decimal lang)
        {
            var destination = new Destination(Id, name, lat, lang);
            Destinations.Add(destination);
            return destination;
        }
    }
}
