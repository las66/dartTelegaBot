import 'dart:io';

import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';

void main() async {
  final botToken = await File('../bot_token.txt').readAsString();
  final username = (await Telegram(botToken).getMe()).username;

  var teledart = TeleDart(botToken, Event(username!));

  teledart.start();

  teledart
      .onCommand(RegExp('hello', caseSensitive: false))
      .listen((message) => message.reply('hello!'));
}
