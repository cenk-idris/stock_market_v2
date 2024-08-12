import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_market_v2/features/market/bloc/market_bloc.dart';

import '../bloc/market_state.dart';

class MarketTab extends StatelessWidget {
  const MarketTab({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MarketBloc, MarketState>(
        builder: (context, state) {
          if (state is MarketLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 20,
                  ),
                  Text(state.stockBeingSubscribed.isNotEmpty
                      ? 'Fetching data for ${state.stockBeingSubscribed}...'
                      : 'Loading market data...'),
                ],
              ),
            );
          } else if (state is MarketLoaded) {
            return const Center(
              child: Text('market state is Loaded'),
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
