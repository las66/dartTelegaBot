import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

Future<String> randomAnek() async {
  final response = await http.Client().get(Uri.parse('https://www.anekdot.ru/random/anekdot/'));
  var result = '';
  if (response.statusCode == 200) {
    var doc = parse(response.body);
    var nodes = doc
        .getElementsByClassName('content')[0]
        .getElementsByClassName('col-left')[0]
        .querySelectorAll('div[class=topicbox] div[class=text]')[0]
        .nodes;
    for (var node in nodes) {
      var str = node.text;
      result += str == '' ? '\n' : str!;
    }
  }
  return result;
}
