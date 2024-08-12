import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../data_providers/finnhub_api_provider.dart';

class StockRepository {
  final FinnhubApiProvider finnhubApiProvider = FinnhubApiProvider(
      apiUrl: dotenv.env['FINNHUB_API_URL'] ?? '',
      apiKey: dotenv.env['FINNHUB_API_KEY'] ?? '');

  StockRepository();

  Future<Map<String, dynamic>> getStockData(String symbol) async {
    try {
      final stockQuoteData = await finnhubApiProvider.fetchStockQuote(symbol);
      final companyProfileData =
          await finnhubApiProvider.fetchCompanyProfile(symbol);

      // Combine the data into one map
      final combinedData = {
        'fullName': companyProfileData['name'],
        'symbol': symbol,
        'price': (stockQuoteData['c'] is int)
            ? (stockQuoteData['c'] as int).toDouble()
            : stockQuoteData['c'],
        'previousClose': (stockQuoteData['pc'] is int)
            ? (stockQuoteData['pc'] as int).toDouble()
            : stockQuoteData['pc'],
      };

      return combinedData;
    } catch (e) {
      throw Exception('getStockDetails Err: ${e.toString()}');
    }
  }
}
