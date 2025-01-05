import 'faculty.dart';

final List<Faculty> faculties = [
  Faculty(
    name: 'Faculty of Medicine',
    latitude: 6.999719955566542,
    longitude: 81.09608239052262,
    events: [],
    url: 'https://med.pdn.ac.lk/news/morenews/moreevents.html',
    selectors: {
      'event': '.event-card',
      'title': '.event-title',
      'description': '.event-description',
      'date': 'time',
    },
  ),
  Faculty(
    name: 'Faculty of Science',
    latitude: 7.259327119805202,
    longitude: 80.5985746570388,
    events: [],
    url: 'https://sci.pdn.ac.lk/scs/news-events.php',
    selectors: {
      'event': '.entry-title',
      'title': '.entry-title',
      'description': '.entry-content',
      'date': 'time',
    },
  ),
  Faculty(
    name: 'Faculty of Engineering',
    latitude: 6.999041888112743,
    longitude: 81.09534570038534,
    events: [],
    url: 'https://eng.pdn.ac.lk/news-events/',
    selectors: {
      'event': '.entry-title',
      'title': '.entry-title',
      'description': '.entry-excerpt',
      'date': 'time',
    },
  ),
  // Add more faculties as needed
];
