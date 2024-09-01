import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stock_market_v2/data/repositories/stock_repository.dart';

part 'historical_state.dart';

class HistoricalCubit extends Cubit<HistoricalState> {
  final String stockSymbol;
  final StockRepository stockRepository;
  HistoricalCubit({required this.stockSymbol, required this.stockRepository})
      : super(HistoricalInitial());
}
