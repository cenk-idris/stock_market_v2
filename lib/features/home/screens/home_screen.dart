import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stock_market_v2/data/data_providers/finnhub_api_provider.dart';
import 'package:stock_market_v2/data/repositories/stock_repository.dart';
import 'package:stock_market_v2/features/auth/bloc/auth_bloc.dart';
import 'package:stock_market_v2/features/auth/bloc/auth_event.dart';
import 'package:stock_market_v2/features/market/bloc/market_event.dart';
import 'package:stock_market_v2/features/wallet/blocs/wallet_bloc/wallet_bloc.dart';

import '../../market/bloc/market_bloc.dart';
import '../../market/presentation/market_tab.dart';
import '../widgets/wallet_tab.dart';

class HomeScreen extends StatelessWidget {
  final User user;

  const HomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FinnhubApiProvider>(
      future: FinnhubApiProvider.create(
          apiUrl: dotenv.env['FINNHUB_API_URL'] ?? '',
          apiKey: dotenv.env['FINNHUB_API_KEY'] ?? ''),
      builder:
          (BuildContext context, AsyncSnapshot<FinnhubApiProvider> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.hasData) {
          final finnhubApiProvider = snapshot.data!;

          return MultiRepositoryProvider(
            providers: [
              RepositoryProvider<FinnhubApiProvider>.value(
                value: finnhubApiProvider,
              ),
              RepositoryProvider<StockRepository>(
                create: (context) => StockRepository(
                  finnhubApiProvider: context.read<FinnhubApiProvider>(),
                ),
              )
            ],
            child: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => MarketBloc(
                    stockRepository: context.read<StockRepository>(),
                  )..add(MarketLoadRequested()),
                ),
                BlocProvider(create: (context) => WalletBloc())
              ],
              child: DefaultTabController(
                length: 2,
                child: Scaffold(
                  appBar: AppBar(
                    title: Text('Hi, ${user.email}'),
                    actions: [
                      InkWell(
                        onTap: () {
                          context.read<AuthBloc>().add(AuthLogoutRequested());
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 32.0, vertical: 10),
                          child: Icon(
                            Icons.logout,
                            size: 30,
                          ),
                        ),
                      )
                    ],
                  ),
                  body: const SafeArea(
                    child: TabBarView(
                      children: [
                        MarketTab(),
                        WalletTab(),
                      ],
                    ),
                  ),
                  bottomNavigationBar: const TabBar(
//padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
                    tabs: [
                      Tab(icon: Icon(Icons.area_chart), text: 'Stocks'),
                      Tab(
                          icon: Icon(Icons.account_balance_wallet),
                          text: 'Wallet'),
                    ],
                    indicator: BoxDecoration(),
// labelColor: Colors.black,
// unselectedLabelColor: Colors.grey.shade400,
//indicatorSize: TabBarIndicatorSize.label,
//indicatorWeight: 7.0,
// indicatorPadding: EdgeInsets.all(10.0),
// indicatorColor: Colors.black,
                  ),
                ),
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
