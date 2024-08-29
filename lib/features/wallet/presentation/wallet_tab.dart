import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../blocs/wallet_bloc/wallet_bloc.dart';
import '../models/owned_stock_model.dart';

class WalletTab extends StatelessWidget {
  const WalletTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletBloc, WalletState>(
      builder: (context, walletState) {
        if (walletState is WalletLoading) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20.0),
                Text('Wallet is loading...'),
              ],
            ),
          );
        } else if (walletState is WalletLoaded) {
          final currencyFormatter = NumberFormat.currency(
            locale: 'en_US',
            symbol: '\$',
          );
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 32.0, vertical: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Your current USD balance:'),
                    Text(
                      currencyFormatter.format(walletState.balance),
                      style: const TextStyle(
                        fontSize: 36.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 22),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My Stonks 🤑',
                      style: TextStyle(fontSize: 32),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Asset worth',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('shares')
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: walletState.stocks.length,
                  itemBuilder: (context, index) {
                    final OwnedStock stock = walletState.stocks[index];
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
                            currencyFormatter.format(
                                stock.shares * (stock.currentPrice ?? 1)),
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(stock.shares.toString())
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}
