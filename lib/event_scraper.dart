import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

void main() async {
  var url = Uri.parse('https://example.com');
  var response = await http.get(url);

  if (response.statusCode == 200) {
    var document = parse(response.body);
    var titleElement = document.querySelector('title');
    if (titleElement != null) {
      print('Title: ${titleElement.text}');
    } else {
      print('Title element not found');
    }
  } else {
    print('Failed to load data, status code: ${response.statusCode}');
  }
}
