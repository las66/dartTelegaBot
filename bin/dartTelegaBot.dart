import 'package:dartTelegaBot/secrets.dart' as secret;
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';

import 'MaxBtc.dart';

void main() async {
  final botToken = secret.botToken;
  final username = (await Telegram(botToken).getMe()).username;

  var teledart = TeleDart(botToken, Event(username!));

  teledart.start();

  teledart
      .onCommand(RegExp('hello', caseSensitive: false))
      .listen((message) => message.reply('hello!'));

  teledart
      .onCommand(RegExp('maxbtc', caseSensitive: false))
      .listen((message) async {
    await message.reply(await maxBtc());
  });
}
