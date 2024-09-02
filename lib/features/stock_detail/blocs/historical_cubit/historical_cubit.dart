import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stock_market_v2/data/repositories/stock_repository.dart';

import '../../models/historical_data_model.dart';

part 'historical_state.dart';

class HistoricalCubit extends Cubit<HistoricalState> {
  final String stockSymbol;
  final StockRepository stockRepository;
  HistoricalCubit({required this.stockSymbol, required this.stockRepository})
      : super(HistoricalInitial());

  Future<void> loadHistoricalData(String symbol, String multiplier,
      String timespan, String from, String to) async {
    emit(HistoricalLoading());
    try {
      final historicalData = await stockRepository.getHistoricalData(
          symbol, multiplier, timespan, from, to);
      emit(HistoricalLoaded(historicalData));
    } catch (e) {
      emit(HistoricalError(e.toString()));
    }
  }
}
