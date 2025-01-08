import 'package:cloud_firestore/cloud_firestore.dart';

class FacultyEvent {
  // final String id;
  final String date;
  final String faculty;
  final String scraped_at;
  final String source_url;
  // final DateTime timestamp;
  final String title;

  FacultyEvent({
    required this.date,
    required this.faculty,
    required this.scraped_at,
    required this.source_url,
    // required this.timestamp,
    required this.title,
  });

  factory FacultyEvent.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    print("here is the data: ${data}");
    return FacultyEvent(
      // id: doc.id,
      title: data['title'] ?? '',
      faculty: data['faculty'] ?? '',
      date: data['date'] ?? '',
      // timestamp: (data['timestamp'] as Timestamp).toDate(),
      scraped_at: data['scraped_at'] ?? '',
      source_url: data['source_url'] ?? '',
    );
  }
}
