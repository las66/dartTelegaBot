import 'ExchangeRate.dart';

final _btcAmount = 0.04423945;

String _generateMessage(double btc, double rub, double usd) => '''BTC: $btc
USD: ${usd.toStringAsFixed(2)}
RUB: ${rub.toStringAsFixed(2)}''';

Future<String> maxBtc() async {
  return await updateRates().then((value) {
    return _generateMessage(_btcAmount, btcToRub(_btcAmount), btcToUsd(_btcAmount));
  });
}

double btcToUsd(double btc) {
  var eurBtc = getRate('BTC');
  var eurUsd = getRate('USD');
  if (eurUsd == 0 || eurBtc == 0) {
    return 0;
  }
  return eurUsd / eurBtc * btc;
}

double btcToRub(double btc) {
  var eurBtc = getRate('BTC');
  var eurRub = getRate('RUB');
  if (eurRub == 0 || eurBtc == 0) {
    return 0;
  }
  return eurRub / eurBtc * btc;
}
