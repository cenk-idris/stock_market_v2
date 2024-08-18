import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stock_market_v2/constants.dart';
import 'package:stock_market_v2/features/market/bloc/market_event.dart';

import '../../../data/repositories/stock_repository.dart';
import '../../../main.dart';
import '../models/stock_model.dart';
import 'market_state.dart';

class MarketBloc extends Bloc<MarketEvent, MarketState> {
  final StockRepository stockRepository;
  StreamSubscription<Map<String, dynamic>>? _tickersSubscription;

  MarketBloc({required this.stockRepository}) : super(MarketInitial()) {
    on<MarketLoadRequested>(_onMarketLoadRequested);
    on<MarketSubscribeToTickersRequested>(_onMarketSubscribeToTickersRequested);
    on<MarketDataReceived>(_onMarketDataReceived);
  }

  Future<void> _onMarketLoadRequested(
      MarketLoadRequested event, Emitter<MarketState> emit) async {
    emit(MarketLoading());
    try {
      List<Stock> stocksList = [];
      List<String> successfulSymbols = [];
      double progressVal = 0.0;
      final int stockAmount = stockSymbols.length;
      for (final symbol in stockSymbols) {
        final stockData = await stockRepository.getStockData(symbol);
        print(stockData.toString());
        final stock = Stock.fromStockData(stockData);
        stocksList.add(stock);
        successfulSymbols.add(symbol);
        progressVal += 1.0 / stockAmount;
        emit(MarketLoading(
            progressValue: progressVal, stockBeingSubscribed: stock.fullName));
      }
      if (stocksList.isNotEmpty) {
        emit(MarketLoaded(stocksList));
        add(MarketSubscribeToTickersRequested(successfulSymbols));
      } else {
        emit(MarketError('Market is empty'));
      }
    } catch (e) {
      logger.e(e.toString(), stackTrace: StackTrace.current);
      emit(MarketError('Failed to fetch market date'));
    }
  }

  Future<void> _onMarketSubscribeToTickersRequested(
      MarketSubscribeToTickersRequested event,
      Emitter<MarketState> emit) async {
    if (state is MarketLoaded) {
      try {
        _tickersSubscription =
            stockRepository.getTickersStream().listen((data) {
          if (data['type'] == 'trade') {
            add(MarketDataReceived(data));
          } else if (data['type'] == 'error') {
            print('Socket returned error message: ${data['msg']}');
          }
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> _onMarketDataReceived(
      MarketDataReceived event, Emitter<MarketState> emit) async {
    final currentState = state;
    if (currentState is MarketLoaded) {
      final List<Stock> currentStocks = List.from(currentState.market);

      //Data might hold multiple trade updates
      //for same symbol so lets filter it down
      Map<String, dynamic> latestTrades = {};
      for (final trade in event.data['data']) {
        // same key ? override : new entry
        latestTrades[trade['s']] = trade;
      }
      print(latestTrades.toString());
      //Now we can update the prices
      for (final trade in latestTrades.values) {
        final String targetSymbol = trade['s'];

        print(trade['p']);
        final double updatedPrice =
            (trade['p'] is int) ? (trade['p'] as int).toDouble() : trade['p'];
        final int targetIndex =
            currentStocks.indexWhere((stock) => stock.symbol == targetSymbol);
        if (targetIndex != -1) {
          final Stock updatedStock =
              currentStocks[targetIndex].copyWith(price: updatedPrice);
          currentStocks[targetIndex] = updatedStock;
          //print(currentStocks.toString());
          emit(MarketLoaded(currentStocks));
        }
      }
    }
  }

  @override
  Future<void> close() {
    print('disposing ticker subscription on market bloc');
    _tickersSubscription?.cancel();
    // what would be better approach? This doesn't feel right
    stockRepository.closeControllerAndWebSocketConnection();
    return super.close();
  }
}
