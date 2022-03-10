import 'dart:convert';

import 'package:dartTelegaBot/secrets.dart' as secret;
import 'package:http/http.dart' as http;

final rateApi = 'http://data.fixer.io/api/latest?access_key=${secret.apiKey}';
Map<String, dynamic> rates = {};

Future<void> updateRates() async {
  var response = await http.get(Uri.parse(rateApi));
  rates = jsonDecode(response.body)['rates'] ?? rates;
}

double getRate(String currency) {
  return rates[currency];
}
