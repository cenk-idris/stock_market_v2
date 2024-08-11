import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_market_v2/features/auth/bloc/auth_bloc.dart';
import 'package:stock_market_v2/features/auth/bloc/auth_event.dart';

class HomeScreen extends StatelessWidget {
  final User user;

  const HomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
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
                padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 10),
                child: Icon(
                  Icons.logout,
                  size: 30,
                ),
              ),
            )
          ],
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              StocksTab(),
              WalletTab(),
            ],
          ),
        ),
      ),
    );
  }
}
