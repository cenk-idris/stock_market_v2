import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stock_market_v2/features/market/bloc/market_event.dart';

import '../../../data/repositories/stock_repository.dart';
import 'market_state.dart';

class MarketBloc extends Bloc<MarketEvent, MarketState> {
  final StockRepository stockRepository;
  MarketBloc({required this.stockRepository}) : super(MarketInitial()) {
    on<MarketLoadRequested>(_onMarketLoadRequested);
    on<MarketSubscribeToTickersRequested>(_onMarketSubscribeToTickersRequested);
  }

  Future<void> _onMarketLoadRequested(
      MarketLoadRequested event, Emitter<MarketState> emit) async {
    emit(MarketLoading());
    try {
      print(dotenv.env['']);
    } catch (e) {
      emit(MarketError('Failed to fetch market date'));
    }
  }

  Future<void> _onMarketSubscribeToTickersRequested(
      MarketSubscribeToTickersRequested event,
      Emitter<MarketState> emit) async {}
}
