import 'faculty_event.dart';

class Faculty {
  final String name;
  final double? latitude;
  final double? longitude;
  final List<FacultyEvent> events;

  Faculty({
    required this.name,
    this.latitude,
    this.longitude,
    required this.events,
  });
}
