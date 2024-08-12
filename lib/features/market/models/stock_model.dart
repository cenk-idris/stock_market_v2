import 'package:equatable/equatable.dart';

class Stock extends Equatable {
  final String fullName;
  final String symbol;
  final String assetName;
  final double price;
  final double previousClose;

  const Stock({
    required this.fullName,
    required this.symbol,
    required this.assetName,
    required this.price,
    required this.previousClose,
  });

  // Factory constructor to create a Stock from JSON (e.g., from API response)
  factory Stock.fromJson(Map<String, dynamic> json, {String symbol = ''}) {
    return Stock(
      fullName: json['fullName'] ?? '',
      symbol: symbol.isNotEmpty ? symbol : json['symbol'],
      assetName:
          json['assetName'] ?? symbol.replaceAll('.', '-').replaceAll(':', '-'),
      price: json['price'] is int
          ? (json['price'] as int).toDouble()
          : json['price'],
      previousClose: json['previousClose'] is int
          ? (json['previousClose'] as int).toDouble()
          : json['previousClose'],
    );
  }

  // CopyWith method to clone and modify Stock instances
  Stock copyWith({
    String? fullName,
    String? symbol,
    String? assetName,
    double? price,
    double? previousClose,
  }) {
    return Stock(
      fullName: fullName ?? this.fullName,
      symbol: symbol ?? this.symbol,
      assetName: assetName ?? this.assetName,
      price: price ?? this.price,
      previousClose: previousClose ?? this.previousClose,
    );
  }

  @override
  List<Object?> get props =>
      [symbol, price, fullName, assetName, previousClose];
}
