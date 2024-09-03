import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stock_market_v2/data/repositories/stock_repository.dart';
import 'package:stock_market_v2/data/repositories/user_repository.dart';

part 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  final StockRepository stockRepository;
  final UserRepository userRepository;
  final String stockSymbol;
  double? currentPrice;
  StreamSubscription<Map<String, dynamic>>? _priceSubscription;

  TransactionCubit(
      {required this.stockRepository,
      required this.userRepository,
      required this.stockSymbol})
      : super(TransactionInitial()) {
    _initialize();
  }

  Future<void> _initialize() async {
    // Try to fetch the latest price from the REST API first
    try {
      final fetchedStockData = await stockRepository.getStockData(stockSymbol);
      currentPrice = fetchedStockData['price'];
      emit(TransactionPriceUpdated(currentPrice!));
    } catch (e) {
      print('Failed to fetch initial stock price from REST API: $e');
    }
    // Start listening to WebSocket price updates
    _subscribeToPriceUpdates();
  }

  void _subscribeToPriceUpdates() {
    _priceSubscription = stockRepository.getFilteredTickersStream().listen(
      (latestTrades) {
        if (latestTrades.containsKey(stockSymbol)) {
          currentPrice = latestTrades[stockSymbol];
          emit(TransactionPriceUpdated(currentPrice!));
        }
      },
      onError: (error) {
        emit(TransactionError('Failed to update stock prices: $error'));
      },
    );
  }

  Future<void> buyStock(String symbol, double quantity) async {
    if (quantity == 0) {
      emit(TransactionError('Quantity must be at leat 0.01'));
      emit(TransactionInitial());
    } else if (currentPrice != null) {
      print('buying $symbol');
      emit(TransactionLoading());
      try {
        final stockData = await stockRepository.getStockData(symbol);
        final String fullName = stockData['fullName'];
        final String assetName = stockData['assetName'];
        await userRepository.buyStock(
            symbol, quantity, currentPrice!, assetName, fullName);
        emit(TransactionSuccess(
            'Successfully bought $quantity shares of $symbol'));
        emit(TransactionInitial());
      } catch (e) {
        print(e.toString());
        emit(TransactionError('Failed to buy stock: ${e.toString()}'));
        emit(TransactionInitial());
      }
    } else {
      emit(TransactionError('Market is likely to be closed, check NYSE hours'));
      emit(TransactionInitial());
    }
  }

  @override
  Future<void> close() {
    print('disposing ticker subscription on transaction cubit');
    _priceSubscription?.cancel();
    return super.close();
  }
}
