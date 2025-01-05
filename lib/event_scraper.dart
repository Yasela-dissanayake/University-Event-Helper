import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'faculty.dart';

Future<List<FacultyEvent>> fetchEvents(
    String url, Map<String, String> selectors) async {
  var response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    var document = parse(response.body);
    var eventElements = document.querySelectorAll(selectors['event']!);
    List<FacultyEvent> events = [];

    print("3");
    for (var element in eventElements) {
      print("4");
      print("element------ ${element.outerHtml}");
      var titleElement = element.querySelector('a');
      print("titleElement------ ${titleElement?.outerHtml}");
      var title = titleElement?.text ?? 'No title';
      print("title------ ${title}");
      var description =
          element.querySelector(selectors['description']!)?.text ??
              'No description';
      var dateTimeString =
          element.querySelector(selectors['date']!)?.text ?? '';
      var dateTime = DateTime.parse(dateTimeString);

      events.add(FacultyEvent(
        title: title,
        description: description,
        dateTime: dateTime,
      ));
    }

    return events;
  } else {
    throw Exception('Failed to load events');
  }
}
