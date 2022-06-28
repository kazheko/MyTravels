namespace MyTravels.Core.Domain
{
    public class Destination
    {
        private Destination() { }

        public Destination(int travelId, string name, decimal lat, decimal lang)
        {
            TravelId = travelId;
            Name = name;
            Lat = lat;
            Lang = lang;
            CreatedAt = DateTime.Now.ToUniversalTime();
            Notes = new List<Note>();
        }

        public int Id { get; private set; }
        public int TravelId { get; private set; }
        public string Name { get; private set; }
        public decimal Lat { get; private set; }
        public decimal Lang { get; private set; }
        public DateTime CreatedAt { get; private set; }
        public ICollection<Note> Notes { get; private set; }

        public void AddNote(string text)
        {
            var note = new Note(Id, text);
            Notes.Add(note);
        }
    }
}
