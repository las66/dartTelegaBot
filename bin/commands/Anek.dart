import 'dart:convert';
import 'dart:typed_data';

import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

import '../Database.dart';

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
  } else {
    print('ERROR: $response');
  }
  return result;
}

Future<String> randomBanek() async {
  var req = http.Request('Get', Uri.parse('https://baneks.ru/random'))..followRedirects = false;
  var response = await http.Client().send(req);
  final response2 = await http.Client().get(Uri.parse(response.headers['location']!));

  var result = '';
  if (response2.statusCode == 200) {
    var nodes = parse(_convertFromUtf8Bytes(response2.bodyBytes))
        .body!
        .querySelector('section[class=anek-view]')!
        .getElementsByTagName('article')[0]
        .getElementsByTagName('p')[0]
        .nodes;
    for (var node in nodes) {
      var str = node.text;
      result += str!;
    }
  } else {
    print('ERROR: $response2');
  }
  return result;
}

Future<String> randomMudrecAnek(String command, int userId) async {
  var commandList = command.split(' ');
  commandList.removeWhere((it) => it == '');
  if (commandList.length == 1) {
    return await Database.getMudrecAnek();
  } else if (commandList[1] == 'add' || commandList[1].startsWith('add\n')) {
    await Database.addMudrecAnek(command.substring(command.indexOf('add ') + 4), userId);
    return 'Анек добавлен!';
  } else {
    return 'Что-то не так 🤔';
  }
}

String _convertFromUtf8Bytes(Uint8List uint8list) => const Utf8Decoder(allowMalformed: true).convert(uint8list);
