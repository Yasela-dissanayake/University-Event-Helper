import 'package:cloud_firestore/cloud_firestore.dart';

class FacultyEvent {
  final String id;
  final String eventName;
  final String description;
  final DateTime date;

  FacultyEvent({
    required this.id,
    required this.eventName,
    required this.description,
    required this.date,
  });

  factory FacultyEvent.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return FacultyEvent(
      id: doc.id,
      eventName: data['eventName'] ?? '',
      description: data['description'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
    );
  }
}
