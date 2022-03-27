import '../Database.dart';

final info = '*Команда count*'
    '\nПрибавляет/убавляет значение требуемой переменной на 1'
    '\n'
    '\nПример использования:'
    '\n`/count\\\+\\\+ умников в чате`'
    '\n`/count\\\-\\\- какая\\\-то\\\_переменная`'
    '\n`/count myVar`'
    '\n`@Bizmolbot можно выбрать тут`';

Future<String?> processCommand(String command) async {
  var indexOfFirstSpace = command.indexOf(' ');
  if (indexOfFirstSpace == -1) {
    return null;
  }
  var varName = command.substring(indexOfFirstSpace + 1);
  if (varName.isEmpty) {
    return null;
  }
  var varCount;
  switch (command.substring(0, indexOfFirstSpace)) {
    case '/count++':
      varCount = await Database.countPlus1(varName);
      break;
    case '/count--':
    case '/count—':
      varCount = await Database.countMinus1(varName);
      break;
    case '/count':
      var bdCount = await Database.count(varName);
      varCount = bdCount ?? 0;
      break;
    default:
      return null;
  }
  return 'Количество $varName = $varCount';
}
