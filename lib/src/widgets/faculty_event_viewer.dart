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
    print('Filtered Faculty Data: ${serviceProvider.filteredFacultyData}');

    return Column(
      children:
          serviceProvider.filteredFacultyData.asMap().entries.map((entry) {
        return FacultyCard(faculty: entry.value);
      }).toList(),
    );
  }
}
