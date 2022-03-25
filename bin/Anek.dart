import 'dart:convert';
import 'dart:typed_data';

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

Future<String> randomBanek() async {
  var req = http.Request('Get', Uri.parse('https://baneks.ru/random'))..followRedirects = false;
  var response = await http.Client().send(req);
  final response2 = await http.Client().get(Uri.parse(response.headers['location']!));

  var result = '';
  if (response2.statusCode == 200) {
    result = parse(convertFromUtf8Bytes(response2.bodyBytes))
        .head!
        .querySelector('meta[name=description]')!
        .attributes['content']!;
  } else {
    print('ERROR: $response2');
  }
  return result;
}

String convertFromUtf8Bytes(Uint8List uint8list) => const Utf8Decoder(allowMalformed: true).convert(uint8list);