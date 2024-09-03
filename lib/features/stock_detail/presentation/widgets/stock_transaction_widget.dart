import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:stock_market_v2/features/stock_detail/blocs/transaction_cubit/transaction_cubit.dart';

class StockTransactionWidget extends StatelessWidget {
  final String stockSymbol;
  final TextEditingController _quantityController = TextEditingController();

  StockTransactionWidget({super.key, required this.stockSymbol});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
    );
    return BlocListener<TransactionCubit, TransactionState>(
      listener: (context, state) {
        if (state is TransactionSuccess) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is TransactionError) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Column(
        children: [
          SizedBox(
            width: 150,
            child: TextField(
              inputFormatters: [
                TextInputFormatter.withFunction((oldValue, newValue) {
                  final commaToDot = newValue.text.replaceAll(',', '.');

                  //print(oldValue.text);
                  //print(newValue.text);
                  return newValue.copyWith(text: commaToDot);
                }),
                FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}')),
              ],
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              controller: _quantityController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '# of shares',
              ),
            ),
          ),
          BlocBuilder<TransactionCubit, TransactionState>(
            builder: (context, state) {
              final currentPrice =
                  BlocProvider.of<TransactionCubit>(context).currentPrice;
              final formattedPrice = currentPrice != null
                  ? currencyFormatter.format(currentPrice)
                  : 'N/A';
              return Column(
                children: [
                  Text('Current stock value: $formattedPrice'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(150, 40),
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white),
                        onPressed: () {
                          final quantity =
                              double.tryParse(_quantityController.text) ?? 0.0;
                          // Trigger the buy stock action
                          context
                              .read<TransactionCubit>()
                              .buyStock(stockSymbol, quantity);
                          _quantityController.clear();
                        },
                        child: const Text('Buy Stonks'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(150, 40),
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white),
                        onPressed: () {
                          final quantity =
                              double.tryParse(_quantityController.text) ?? 0.0;
                          // Trigger the sell stock action

                          context
                              .read<TransactionCubit>()
                              .sellStock(stockSymbol, quantity);
                          _quantityController.clear();
                        },
                        child: const Text('Sell Stonks'),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
