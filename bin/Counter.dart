import 'Database.dart';

var info = 'Правильное использование:'
    '\n  /команда переменная_безПробелов'
    '\n'
    '\nКомманды:'
    '\n  count++, count--, count'
    '\n'
    '\nПример: '
    '\n  /count++ умников_в_чате';

Future<String> processCommand(String command) async {
  var commandList = command.split(' ');
  commandList.removeWhere((it) => it == '');
  if (commandList.length != 2) {
    return info;
  }
  var count = 0;
  switch (commandList[0].toLowerCase()) {
    case '/count++':
      count = await Database.countPlus1(commandList[1]);
      break;
    case '/count--':
    case '/count—':
      count = await Database.countMinus1(commandList[1]);
      break;
    case '/count':
      var bdCount = await Database.count(commandList[1]);
      count = bdCount ?? 0;
      break;
    default:
      return info;
  }
  return 'Количество ${commandList[1]} = $count';
}
