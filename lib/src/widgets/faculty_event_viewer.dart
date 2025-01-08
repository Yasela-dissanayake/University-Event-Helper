import 'dart:async';

import 'package:event_helper/screens/home_page.dart';
import 'package:event_helper/src/provider/service_provider.dart';
import 'package:event_helper/src/widgets/faculty_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:event_helper/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FacultyEventViewer extends StatefulWidget {
  const FacultyEventViewer({super.key});

  @override
  State<FacultyEventViewer> createState() => _FacultyEventViewerState();
}

class _FacultyEventViewerState extends State<FacultyEventViewer> {
  Timer? scanTimer;
  final FirebaseService _firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() async {
    var service = context.read<ServiceProvider>();
    await service.startScanEvents();
    Timer.periodic(const Duration(seconds: 30), (timer) async {
      await service.startScanEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    var serviceProvider = context.watch<ServiceProvider>();

    // return Column(
    //   children:
    //       serviceProvider.filteredFacultyData.asMap().entries.map((entry) {
    //     return FacultyCard(faculty: entry.value);
    //   }).toList(),
    // );
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
                  // subtitle: Text(faculty['department']),
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
