import 'package:equatable/equatable.dart';

import '../../../data/repositories/stock_repository.dart';

class OwnedStock extends Equatable {
  final String fullName;
  final String symbol;
  final String assetName;
  final double? currentPrice;
  final double shares;

  const OwnedStock({
    required this.fullName,
    required this.symbol,
    required this.assetName,
    this.currentPrice,
    required this.shares,
  });

  static Future<OwnedStock> fromFirestoreOwnedStockData(
      Map<String, dynamic> ownedStockData,
      StockRepository stockRepository) async {
    final String symbol = ownedStockData['symbol'];
    final stockData = await stockRepository.getStockData(symbol);
    final double? currentStockPrice = stockData['price'];
    return OwnedStock(
      fullName: ownedStockData['full_name'],
      symbol: ownedStockData['symbol'],
      assetName: ownedStockData['asset_name'],
      shares: (ownedStockData['shares'] is int)
          ? (ownedStockData['shares'] as int).toDouble()
          : ownedStockData['shares'],
      currentPrice: currentStockPrice,
    );
  }

  OwnedStock copyWith({
    String? fullName,
    String? symbol,
    String? assetName,
    double? shares,
    double? currentPrice,
  }) {
    return OwnedStock(
      fullName: fullName ?? this.fullName,
      symbol: symbol ?? this.symbol,
      assetName: assetName ?? this.assetName,
      shares: shares ?? this.shares,
      currentPrice: currentPrice ?? this.currentPrice,
    );
  }

  @override
  List<Object?> get props =>
      [fullName, symbol, assetName, currentPrice, shares];
}
