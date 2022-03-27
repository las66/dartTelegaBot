import 'package:dartTelegaBot/secrets.dart' as secret;
import 'package:teledart/model.dart';
import 'package:teledart/src/teledart/model/message.dart';
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

  teledart.onCommand('hello').listen((message) => message.reply('hello!'));

  teledart.onCommand('help').listen((message) => message.reply('К вам выехал наряд'));

  teledart.onCommand('maxbtc').listen((message) async {
    await message.reply(await maxBtc());
  });

  teledart.onCommand(RegExp('^count.*', caseSensitive: false)).listen((message) async {
    var answer = await counter.processCommand(message.text!);
    if (answer == null) {
      await message.reply(counter.info, parse_mode: 'MarkdownV2');
    } else {
      await message.reply(answer);
    }
  });

  teledart.onCommand('anek').listen((message) async {
    await message.reply(await randomAnek());
  });

  teledart.onCommand('banek').listen((message) async {
    await message.reply(await randomBanek());
  });

  teledart.onCommand('mudrec').listen((message) async {
    await message.reply(await randomMudrecAnek(message.text!, getUserId(message)));
  });
}

int getUserId(TeleDartMessage message) {
  return message.from!.id;
}
