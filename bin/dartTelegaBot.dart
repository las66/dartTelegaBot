import 'package:dartTelegaBot/secrets.dart' as secret;
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';

import 'Database.dart';
import 'commands/Anek.dart';
import 'commands/Counter.dart' as counter;
import 'commands/MaxBtc.dart';

void main() async {
  final botToken = secret.botToken;
  final username = (await Telegram(botToken).getMe()).username;
  var teledart = TeleDart(botToken, Event(username!));

  await Database.init();

  teledart.start();

  teledart.onCommand(RegExp('hello', caseSensitive: false)).listen((message) => message.reply('hello!'));

  teledart.onCommand(RegExp('help', caseSensitive: false)).listen((message) => message.reply('К вам выехал наряд'));

  teledart.onCommand(RegExp('maxbtc', caseSensitive: false)).listen((message) async {
    await message.reply(await maxBtc());
  });

  teledart.onCommand(RegExp('count.*', caseSensitive: false)).listen((message) async {
    var answer = await counter.processCommand(message.text!);
    if (answer != '') {
      await message.reply(answer);
    }
  });

  teledart.onCommand(RegExp('anek|anekdot', caseSensitive: false)).listen((message) async {
    await message.reply(await randomAnek());
  });

  teledart.onCommand(RegExp('banek|anekb', caseSensitive: false)).listen((message) async {
    await message.reply(await randomBanek());
  });
}
