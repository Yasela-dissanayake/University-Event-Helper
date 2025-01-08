// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:event_helper/models/faculty_event.dart';

// class Faculty {
//   // final String id;
//   final String name;
//   final double latitude;
//   final double longitude;
//   final List<FacultyEvent> events;

//   Faculty({
//     // required this.id,
//     required this.name,
//     required this.latitude,
//     required this.longitude,
//     required this.events,
//   });

//   factory Faculty.fromFirestore(DocumentSnapshot doc) {
//     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//     List<FacultyEvent> events = [];

//     if (data['events'] != null) {
//       events = (data['events'] as List).map((eventData) {
//         return FacultyEvent(
//           title: data['title'] ?? '',
//           faculty: data['faculty'] ?? '',
//           date: data['date'] ?? '',
//           timestamp: (data['timestamp'] as Timestamp).toDate(),
//           scraped_at: data['scraped_at'] ?? '',
//           source_url: data['source_url'] ?? '',
//         );
//       }).toList();
//     }

//     return Faculty(
//       // id: doc.id,
//       name: data['name'] ?? '',
//       latitude: data['latitude']?.toDouble() ?? 0.0,
//       longitude: data['longitude']?.toDouble() ?? 0.0,
//       events: events,
//     );
//   }

//   @override
//   String toString() {
//     return 'Faculty{ name: $name, latitude: $latitude, longitude: $longitude, events: $events}';
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_helper/models/faculty_event.dart';

class Faculty {
  // final String id;
  final String name;
  final double latitude;
  final double longitude;
  final List<FacultyEvent> events;

  Faculty({
    // required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.events,
  });

  factory Faculty.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    List<FacultyEvent> events = [];

    // Fetch events sub-collection
    if (data['events'] != null) {
      events = (data['events'] as List).map((eventData) {
        return FacultyEvent.fromFirestore(eventData);
      }).toList();
    }

    return Faculty(
      // id: doc.id,
      name: data['name'] ?? '',
      latitude: data['latitude']?.toDouble() ?? 0.0,
      longitude: data['longitude']?.toDouble() ?? 0.0,
      events: events,
    );
  }
}
