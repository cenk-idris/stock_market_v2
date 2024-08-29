import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:stock_market_v2/features/market/bloc/market_bloc.dart';

import '../bloc/market_state.dart';

class MarketTab extends StatelessWidget {
  const MarketTab({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MarketBloc, MarketState>(
        builder: (context, marketState) {
          final currencyFormatter = NumberFormat.currency(
            locale: 'en_US',
            symbol: '\$',
          );
          if (marketState is MarketLoading) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LinearProgressIndicator(
                      value: marketState.progressValue,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(marketState.stockBeingSubscribed.isNotEmpty
                        ? 'Successfully fetched data for...'
                        : 'Loading market data...'),
                    Text(marketState.stockBeingSubscribed),
                  ],
                ),
              ),
            );
          } else if (marketState is MarketLoaded) {
            return ListView.separated(
              itemBuilder: (context, index) {
                final stock = marketState.market[index];
                final double percentChange =
                    (stock.currentPrice - stock.previousClose) /
                        stock.previousClose *
                        100;
                return ListTile(
                  onTap: () {},
                  leading: Container(
                    width: 40,
                    child: Image.asset(
                      'assets/stock_icons/${stock.assetName}.png',
                      width: 50,
                      height: 40,
                    ),
                  ),
                  title: Text(stock.symbol),
                  subtitle: Text(stock.fullName),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        currencyFormatter.format(stock.currentPrice),
                        style: TextStyle(
                            fontSize: 15.0,
                            color: percentChange >= 0.0
                                ? Colors.green
                                : Colors.red),
                      ),
                      Text('${percentChange.toStringAsFixed(2)}%')
                    ],
                  ),
                );
              },
              itemCount: marketState.market.length,
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 0.0,
                );
              },
            );
          } else if (marketState is MarketError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning,
                    size: 100,
                    color: Colors.red,
                  ),
                  Text(marketState.message),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text('market state is not Loading'),
            );
          }
        },
      ),
    );
  }
}
