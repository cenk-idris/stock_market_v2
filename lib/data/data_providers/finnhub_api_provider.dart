import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class FinnhubApiProvider {
  final String apiUrl;
  final String apiKey;
  WebSocketChannel? _webSocketChannel;
  StreamController<Map<String, dynamic>>? _webSocketTickersStreamController;

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

  // Connecting and Subscribe to FinnHub's WebSocket API
  Future<void> subscribeToSymbols(List<String> symbols) async {
    // Try to establish connection with WebSocket
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
  }
}
