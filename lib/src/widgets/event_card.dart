import 'package:event_helper/models/faculty_event.dart';
import 'package:event_helper/src/models/faculty_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  final FacultyEvent facultyEvent;

  const EventCard({super.key, required this.facultyEvent});

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: deviceWidth * 0.9,
        decoration: BoxDecoration(
            border: Border.all(color: CupertinoColors.activeOrange, width: 2),
            borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                facultyEvent.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              // Text(
              //   facultyEvent.title,
              //   overflow: TextOverflow.ellipsis,
              //   style: const TextStyle(
              //     fontWeight: FontWeight.w400,
              //     fontSize: 14,
              //   ),
              // ),
              // Text(
              //   DateFormat('d MMMM, EEEE yyyy').format(facultyEvent.timestamp),
              //   style: const TextStyle(
              //     fontWeight: FontWeight.w400,
              //     fontSize: 14,
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
