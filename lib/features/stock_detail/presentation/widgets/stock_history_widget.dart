import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_market_v2/features/stock_detail/blocs/historical_cubit/historical_cubit.dart';

class StockHistoryWidget extends StatelessWidget {
  final String stockSymbol;
  const StockHistoryWidget({super.key, required this.stockSymbol});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoricalCubit, HistoricalState>(
        builder: (context, state) {
      if (state is HistoricalInitial) {
        return Text('State is HistoricalInitial');
      } else {
        return Container();
      }
    });
  }
}
