import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stock_market_v2/data/data_providers/polygon_api_provider.dart';

import '../../features/stock_detail/models/historical_data_model.dart';
import '../data_providers/finnhub_api_provider.dart';

class StockRepository {
  final FinnhubApiProvider finnhubApiProvider;
  final PolygonApiProvider polygonApiProvider;

  // shared tickers state across consumers
  final Map<String, dynamic> _latestTrades = {};
  late StreamController<Map<String, dynamic>> _broadcastController;

  StockRepository(
      {required this.finnhubApiProvider, required this.polygonApiProvider}) {
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
          } else if (data['type'] == 'error') {
            print('Socket returned error message: ${data['msg']}');
          }
        }, onError: (error) {
          _broadcastController.addError(error);
        });
      },
      onCancel: () {
        print('no more active listeners, closing connection and controller');
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

  Future<List<HistoricalData>> getHistoricalData(String symbol,
      String multiplier, String timespan, String from, String to) async {
    final data = await polygonApiProvider.fetchRawHistoricalData(
        symbol, multiplier, timespan, from, to);
    //print(data);
    return (data['results'] as List)
        .map((point) => HistoricalData.fromJson(point))
        .toList();
  }
}
