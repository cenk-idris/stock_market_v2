import 'dart:convert';

import 'package:http/http.dart' as http;

class PolygonApiProvider {
  final String apiUrl;
  final String apiKey;

  // static field to hold singleton instance
  static PolygonApiProvider? _instance;

  // private named constructor
  PolygonApiProvider._internal({required this.apiUrl, required this.apiKey});

  // factory constructor to return singleton instance
  factory PolygonApiProvider({required String apiUrl, required String apiKey}) {
    _instance ??= PolygonApiProvider._internal(apiUrl: apiUrl, apiKey: apiKey);
    return _instance!;
  }

  Future<Map<String, dynamic>> fetchRawHistoricalData(String symbol,
      String multiplier, String timespan, String from, String to) async {
    final Uri uri = Uri(
      scheme: 'https',
      host: apiUrl,
      path: 'v2/aggs/ticker/$symbol/range/$multiplier/$timespan/$from/$to',
      queryParameters: {
        'adjusted': 'true',
        'sort': 'asc',
        'apiKey': apiKey,
      },
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      print('polygon api returned ${response.statusCode} instead 200');
      throw Exception('polygon api returned ${response.statusCode}');
    }
  }
}
