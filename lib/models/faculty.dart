import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_helper/models/faculty_event.dart';

class Faculty {
  final String id;
  final String name;
  final List<FacultyEvent> events;

  Faculty({
    required this.id,
    required this.name,
    required this.events,
  });

  factory Faculty.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    List<FacultyEvent> events = [];

    if (data['events'] != null) {
      events = (data['events'] as List).map((eventData) {
        return FacultyEvent(
          id: eventData['id'] ?? '',
          eventName: eventData['eventName'] ?? '',
          description: eventData['description'] ?? '',
          date: (eventData['date'] as Timestamp).toDate(),
        );
      }).toList();
    }

    return Faculty(
      id: doc.id,
      name: data['name'] ?? '',
      events: events,
    );
  }
}
