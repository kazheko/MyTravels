namespace MyTravels.Core.Domain
{
    public class User
    {
        private User() { }

        public User(string name)
        {
            Name = name;
            CreatedAt = DateTime.Now.ToUniversalTime();
            Travels = new List<Travel>();
        }

        public int Id { get; private set; }
        public string Name { get; private set; }
        public DateTime CreatedAt { get; private set; }
        public ICollection<Travel> Travels { get; private set; }

        public Travel PlaneTravel(string name)
        {
            var travel = new Travel(Id, name);
            Travels.Add(travel);
            return travel;
        }

    }
}
