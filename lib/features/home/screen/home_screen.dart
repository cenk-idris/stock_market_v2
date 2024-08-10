import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stock_market_v2/features/auth/bloc/auth_bloc.dart';

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
        ),
        body: Center(
          child: Text('logged in nice'),
        ),
      ),
    );
  }
}
