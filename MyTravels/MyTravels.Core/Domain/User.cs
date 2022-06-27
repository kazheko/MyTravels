namespace MyTravels.Core.Domain
{
    public class User
    {
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

    }
}
