import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  static const String baseUrl = 'https://api.frankfurter.dev/v2';

  Future<double> getExchangeRate(String from, String to) async {
    final url = Uri.parse('$baseUrl/rate/$from/$to');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return (data['rate'] as num).toDouble();
    } else {
      throw Exception('Failed to fetch exchange rate');
    }
  }

  Future<double> convertCurrency(double amount, String from, String to) async {
    if (from == to) {
      return amount;
    }

    final rate = await getExchangeRate(from, to);

    return amount * rate;
  }
}
