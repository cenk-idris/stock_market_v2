import 'package:flutter/material.dart';

class StockDetailScreen extends StatelessWidget {
  final String stockSymbol;
  final String assetName;
  StockDetailScreen({super.key, required this.stockSymbol})
      : assetName = stockSymbol.replaceAll('.', '-').replaceAll(':', '-');

  @override
  Widget build(BuildContext context) {
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
        child: Text('Stock Detail Screen'),
      ),
    );
  }
}
