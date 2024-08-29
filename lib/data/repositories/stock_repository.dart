import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../data_providers/finnhub_api_provider.dart';

class StockRepository {
  final FinnhubApiProvider finnhubApiProvider;

  // shared tickers state across consumers
  final Map<String, dynamic> _latestTrades = {};
  late StreamController<Map<String, dynamic>> _broadcastController;

  StockRepository({required this.finnhubApiProvider}) {
    _initializeBroadcastController();
  }

  void _initializeBroadcastController() {
    _broadcastController = StreamController<Map<String, dynamic>>.broadcast(
      onListen: () {
        finnhubApiProvider.getTickersControllerStream().listen((data) {
          if (data['type'] == 'trade') {
            // aggregate the trade data
            for (final trade in data['data']) {
              final tradeSymbol = trade['s'];
              _latestTrades[tradeSymbol] = (trade['p'] is int)
                  ? (trade['p'] as int).toDouble()
                  : trade['p'];
            }
            _broadcastController.add(Map<String, dynamic>.from(_latestTrades));
          }
        }, onError: (error) {
          _broadcastController.addError(error);
        });
      },
      onCancel: () {
        finnhubApiProvider.closeControllerAndWebSocketConnection();
        _broadcastController.close();
      },
    );
  }

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

  Stream<Map<String, dynamic>> getFilteredTickersStream() {
    return _broadcastController.stream;
  }
}
