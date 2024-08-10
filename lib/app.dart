import 'package:flutter/material.dart';
import 'package:stock_market_v2/features/auth/presentation/auth_gate.dart';

class StonksApp extends StatelessWidget {
  const StonksApp({super.key});

  @override
  Widget build(BuildContex) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StonksApp v2',
      home: AuthGate(),
    );
  }
}
