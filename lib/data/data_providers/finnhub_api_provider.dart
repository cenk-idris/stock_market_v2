import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:stock_market_v2/constants.dart';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../main.dart';

class FinnhubApiProvider {
  final String apiUrl;
  final String apiKey;
  WebSocketChannel? _webSocketChannel;
  StreamController<Map<String, dynamic>>? _webSocketTickersStreamController;

  // Private named constructor to encapsulate
  FinnhubApiProvider._internal({
    required this.apiUrl,
    required this.apiKey,
  });

  static Future<FinnhubApiProvider> create({
    required String apiUrl,
    required String apiKey,
  }) async {
    final provider =
        FinnhubApiProvider._internal(apiUrl: apiUrl, apiKey: apiKey);
    await provider._initializeAndSubscribe();
    return provider;
  }

  Future<void> _initializeAndSubscribe() async {
    await _connectAndAttachControllerToWebSocket();
    _subscribeToSymbols(stockSymbols);
  }

  Future<void> _connectAndAttachControllerToWebSocket() async {
    if (_webSocketChannel == null) {
      // Initialize the controller,
      _webSocketTickersStreamController =
          StreamController<Map<String, dynamic>>();

      // Try to establish connection with FinnHub WebSocket
      _webSocketChannel =
          WebSocketChannel.connect(Uri.parse('wss://ws.$apiUrl?token=$apiKey'));

      // Test the connection if sink is ready
      try {
        await _webSocketChannel?.ready;
        print('WebSocket is live, Sink can accept subscriptions now');
      } on SocketException catch (e) {
        print('SocketException: ${e.toString()}');
        throw Exception(e);
      } on WebSocketChannelException catch (e) {
        print('WSChannelException: ${e.toString()}');
        throw Exception(e);
      }

      // Listen to the WebSocket stream for incoming messages
      _webSocketChannel!.stream.listen((message) {
        final data = jsonDecode(message);
        _webSocketTickersStreamController?.add(data);
      }, onError: (error) {
        _webSocketTickersStreamController?.addError(error);
      }, onDone: () {
        print('WebSocket connection closed. (onDone received)');
        _webSocketTickersStreamController?.close();
      });
    }
  }

  // Subscribe to stocks
  void _subscribeToSymbols(List<String> stockSymbols) async {
    if (_webSocketChannel == null) {
      print('WebSocketChannel is not initialized.');
      return;
    }
    // loop and subscribe to each symbol
    for (final symbol in stockSymbols) {
      final message = json.encode({'type': 'subscribe', 'symbol': symbol});
      _webSocketChannel!.sink.add(message);
    }
  }

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
    // Cryptos doesn't have company data,
    // so used symbol itself as name
    // otherwise api responds 403
    if (symbol.contains('BINANCE')) {
      return {
        'name': symbol,
      };
    }

    // Construct Uri
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

  Stream<Map<String, dynamic>> getTickersControllerStream() {
    return _webSocketTickersStreamController?.stream ?? const Stream.empty();
  }

  void closeControllerAndWebSocketConnection() {
    print('Disposing Web Socket');
    _webSocketChannel?.sink.close();
    _webSocketTickersStreamController?.close();
  }
}
