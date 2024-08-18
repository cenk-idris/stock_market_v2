import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../data_providers/finnhub_api_provider.dart';

class StockRepository {
  final FinnhubApiProvider finnhubApiProvider;

  StockRepository({required this.finnhubApiProvider});

  Future<Map<String, dynamic>> getStockData(String symbol) async {
    try {
      final stockQuoteData = await finnhubApiProvider.fetchStockQuote(symbol);
      final companyProfileData =
          await finnhubApiProvider.fetchCompanyProfile(symbol);

      // Combine and preprocess before sending to stock constructor
      final combinedData = {
        'fullName': companyProfileData['name'],
        'symbol': symbol,
        'assetName': symbol.replaceAll('.', '-').replaceAll(':', '-'),
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

  Stream<Map<String, dynamic>> getTickersStream() {
    return finnhubApiProvider.getTickersControllerStream();
  }

  void closeControllerAndWebSocketConnection() {
    finnhubApiProvider.closeControllerAndWebSocketConnection();
  }
}
