import 'dart:async';

import 'package:event_helper/src/provider/service_provider.dart';
import 'package:event_helper/src/widgets/faculty_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class FacultyEventViewer extends StatefulWidget {
  const FacultyEventViewer({super.key});

  @override
  State<FacultyEventViewer> createState() => _FacultyEventViewerState();
}

class _FacultyEventViewerState extends State<FacultyEventViewer> {
  Timer? scanTimer;

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

    return Column(
      children:
          serviceProvider.filteredFacultyData.asMap().entries.map((entry) {
        return FacultyCard(faculty: entry.value);
      }).toList(),
    );
  }
}
