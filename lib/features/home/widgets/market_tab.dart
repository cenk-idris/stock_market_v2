import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_market_v2/features/market/bloc/market_bloc.dart';

import '../../market/bloc/market_state.dart';

class MarketTab extends StatelessWidget {
  const MarketTab({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<MarketBloc, MarketState>(
      builder: (context, state) {
        if (state is MarketLoading) {
          return Center(
            child: Column(
              children: [
                CircularProgressIndicator(
                  value: state.progressValue,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(state.stockBeingSubscribed.isNotEmpty
                    ? 'Fetching data for ${state.stockBeingSubscribed}...'
                    : 'Loading market data...'),
              ],
            ),
          );
        } else {
          return Center(
            child: Text('market state is not Loading'),
          );
        }
      },
    ));
  }
}
