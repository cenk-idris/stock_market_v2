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
  StreamSubscription<Map<String, dynamic>>? _webSocketTickersSubscription;

  MarketBloc({required this.stockRepository}) : super(MarketInitial()) {
    on<MarketLoadRequested>(_onMarketLoadRequested);
    on<MarketSubscribeToTickersRequested>(_onMarketSubscribeToTickersRequested);
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
        final marketLoadedState = state as MarketLoaded;
        final List<Stock> currentStocks = marketLoadedState.market;
        await stockRepository.subscribeToSymbols(event.symbols);
      } catch (e) {
        print(e);
      }
    }
  }
}
