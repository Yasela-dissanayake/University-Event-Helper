import 'package:event_helper/models/faculty.dart';
import 'package:event_helper/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FacultyListScreen extends StatelessWidget {
  FacultyListScreen({super.key});

  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Faculty Events'),
      ),
      body: StreamBuilder<List<Faculty>>(
        stream: _firestoreService.getFaculties(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No faculty data available'));
          }

          final faculties = snapshot.data!;
          return ListView.builder(
            itemCount: faculties.length,
            itemBuilder: (context, index) {
              final faculty = faculties[index];
              return ExpansionTile(
                title: Text(faculty.name),
                children: faculty.events.map((event) {
                  return ListTile(
                    title: Text(event.eventName),
                    subtitle: Text(event.description),
                    trailing: Text(
                      DateFormat('MMM dd, yyyy').format(event.date),
                    ),
                  );
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }
}
