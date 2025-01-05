import 'package:event_helper/src/models/faculty.dart';
import 'package:event_helper/src/widgets/event_card.dart';
import 'package:flutter/cupertino.dart';

class FacultyCard extends StatelessWidget {
  final Faculty faculty;

  const FacultyCard({super.key, required this.faculty});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: CupertinoColors.activeGreen, width: 1),
            borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                faculty.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 21,
                ),
              ),
            ),
            Column(
              children: faculty.events.asMap().entries.map((entry) {
                return EventCard(facultyEvent: entry.value);
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}
