namespace MyTravels.Core.Domain
{
    public class Note
    {
        public Note(int destinationId, string description)
        {
            DestinationId = destinationId;
            Description = description;
        }

        public int Id { get; set; }
        public int DestinationId { get; private set; }
        public string Description { get; private set; }
    }
}
