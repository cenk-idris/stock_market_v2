import 'package:flutter/material.dart';

class StonksApp extends StatelessWidget {
  const StonksApp({super.key});

  @override
  Widget build(BuildContex) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StonksApp v2',
      home: Center(
        child: Text('Hodl'),
      ),
    );
  }
}
