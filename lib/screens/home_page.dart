import 'package:event_helper/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  final FirebaseService _firebaseService = FirebaseService();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Faculty Events'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firebaseService.getAllFaculties(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final faculty = snapshot.data!.docs[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ExpansionTile(
                  title: Text(faculty['name']),
                  subtitle: Text(faculty['department']),
                  children: [
                    FacultyEvent(facultyId: faculty.id),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class FacultyEvent extends StatelessWidget {
  final String facultyId;
  final FirebaseService _firebaseService = FirebaseService();

  FacultyEvent({super.key, required this.facultyId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firebaseService.getFacultyEvents(facultyId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('No events found'),
          );
        }

        final event = snapshot.data!.docs.first;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event['title'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(event['description']),
              Text('Venue: ${event['venue']}'),
              Text(
                  'Date: ${(event['date'] as Timestamp).toDate().toString().split('.')[0]}'),
            ],
          ),
        );
      },
    );
  }
}
