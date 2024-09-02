import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_market_v2/data/repositories/stock_repository.dart';
import 'package:stock_market_v2/features/stock_detail/blocs/historical_cubit/historical_cubit.dart';
import 'package:stock_market_v2/features/stock_detail/presentation/widgets/stock_history_widget.dart';

import '../../market/bloc/market_bloc.dart';

class StockDetailScreen extends StatelessWidget {
  final String stockSymbol;
  final String assetName;
  StockDetailScreen({super.key, required this.stockSymbol})
      : assetName = stockSymbol.replaceAll('.', '-').replaceAll(':', '-');

  @override
  Widget build(BuildContext context) {
    //print(context.read<MarketBloc>.toString());
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/stock_icons/$assetName.png',
              width: 30,
            ),
            SizedBox(
              width: 10.0,
            ),
            Text(stockSymbol),
          ],
        ),
      ),
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            BlocProvider(
              create: (context) => HistoricalCubit(
                stockSymbol: stockSymbol,
                stockRepository: context.read<StockRepository>(),
              )..loadHistoricalData(
                  stockSymbol, '1', 'day', '2023-07-20', '2024-07-20'),
              child: StockHistoryChart(stockSymbol: stockSymbol),
            ),
          ],
        ),
      ),
    );
  }
}
