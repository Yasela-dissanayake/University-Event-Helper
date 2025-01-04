class Faculty {
  final String name;
  final double latitude;
  final double longitude;
  final List<FacultyEvent> events;
  final String url;
  final Map<String, String> selectors; // Add this line

  Faculty({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.events,
    required this.url,
    required this.selectors, // Add this line
  });
}

class FacultyEvent {
  final String title;
  final String description;
  final DateTime dateTime;

  FacultyEvent({
    required this.title,
    required this.description,
    required this.dateTime,
  });
}
