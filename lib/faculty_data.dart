import 'faculty.dart';

final List<Faculty> faculties = [
  Faculty(
    name: 'Faculty of Medicine',
    latitude: 6.999719955566542,
    longitude: 81.09608239052262,
    events: [
      FacultyEvent(
        title: 'Med Symposium',
        description: 'Research presentation by faculty members',
        dateTime: DateTime(2024, 12, 18, 10, 0),
      ),
    ],
    url: 'https://med.pdn.ac.lk/news/morenews/moreevents.html',
    selectors: {
      'event': '.event-card',
      'title': '.event-title',
      'description': '.event-description',
      'date': '.event-date',
    },
  ),
  Faculty(
    name: 'Faculty of Science',
    latitude: 6.998938727012407,
    longitude: 81.09564610780035,
    events: [
      FacultyEvent(
        title: 'Science Symposium',
        description: 'Research presentation by faculty members',
        dateTime: DateTime(2024, 12, 18, 10, 0),
      ),
    ],
    url: 'https://science.example.com',
    selectors: {
      'event': '.science-event',
      'title': '.science-title',
      'description': '.science-description',
      'date': '.science-date',
    },
  ),
  Faculty(
    name: 'Faculty of Engineering',
    latitude: 6.999041888112743,
    longitude: 81.09534570038534,
    events: [
      FacultyEvent(
        title: 'Engineering Exhibition',
        description: 'Annual project showcase by final year students',
        dateTime: DateTime(2024, 12, 15, 9, 0),
      ),
      FacultyEvent(
        title: 'Tech Workshop',
        description: 'Workshop on emerging technologies',
        dateTime: DateTime(2024, 12, 20, 14, 0),
      ),
    ],
    url: 'https://eng.pdn.ac.lk/news-events/',
    selectors: {
      'event': '.entry-title',
      'title': '.entry-title',
      'description': '.entry-excerpt',
      'date': '.post__date-link',
    },
  ),
  // Add more faculties as needed
];
