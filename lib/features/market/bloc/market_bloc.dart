import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_market_v2/features/market/bloc/market_event.dart';

import '../../../data/repositories/stock_repository.dart';
import 'market_state.dart';

class MarketBloc extends Bloc<MarketEvent, MarketState> {
  final StockRepository stockRepository;
  MarketBloc({required this.stockRepository}) : super(MarketInitial()) {}
}
