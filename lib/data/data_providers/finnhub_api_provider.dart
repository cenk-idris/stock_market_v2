import 'package:http/http.dart' as http;
import 'dart:convert';

class FinnhubApiProvider {
  final String apiUrl;
  final String apiKey;

  FinnhubApiProvider({required this.apiUrl, required this.apiKey});

  Future<Map<String, dynamic>> fetchStockQuote(String symbol) async {
    final Uri uri = Uri(
        scheme: 'https',
        host: apiUrl,
        path: 'api/v1/quote',
        queryParameters: {
          'symbol': symbol,
          'token': apiKey,
        });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load stock quote');
    }
  }

  Future<Map<String, dynamic>> fetchCompanyProfile(String symbol) async {
    if (symbol.contains('BINANCE')) {
      return {
        'name': symbol,
      };
    }

    final Uri uri = Uri(
      scheme: 'https',
      host: apiUrl,
      path: 'api/v1/stock/profile2',
      queryParameters: {
        'symbol': symbol,
        'token': apiKey,
      },
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
          'Failed to load company profile, response code: ${response.statusCode}');
    }
  }
}
