import 'package:equatable/equatable.dart';

class Stock extends Equatable {
  final String fullName;
  final String symbol;
  final String assetName;
  final double currentPrice;
  final double previousClose;

  const Stock({
    required this.fullName,
    required this.symbol,
    required this.assetName,
    required this.currentPrice,
    required this.previousClose,
  });

  // Factory constructor to create a Stock from JSON (e.g., from API response)
  factory Stock.fromStockData(Map<String, dynamic> stockData) {
    return Stock(
      fullName: stockData['fullName'],
      symbol: stockData['symbol'],
      assetName: stockData['assetName'],
      currentPrice: stockData['price'],
      previousClose: stockData['previousClose'],
    );
  }

  // CopyWith method to clone and modify Stock instances
  Stock copyWith({
    String? fullName,
    String? symbol,
    String? assetName,
    double? currentPrice,
    double? previousClose,
  }) {
    return Stock(
      fullName: fullName ?? this.fullName,
      symbol: symbol ?? this.symbol,
      assetName: assetName ?? this.assetName,
      currentPrice: currentPrice ?? this.currentPrice,
      previousClose: previousClose ?? this.previousClose,
    );
  }

  @override
  List<Object?> get props =>
      [symbol, currentPrice, fullName, assetName, previousClose];
}
