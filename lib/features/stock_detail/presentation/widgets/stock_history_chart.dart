import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:stock_market_v2/features/stock_detail/blocs/historical_cubit/historical_cubit.dart';
import 'package:fl_chart/fl_chart.dart';

class StockHistoryChart extends StatelessWidget {
  final String stockSymbol;
  const StockHistoryChart({super.key, required this.stockSymbol});

  @override
  Widget build(BuildContext context) {
    // Create a DateFormat instance
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    // Get the current date
    DateTime now = DateTime.now();
    // Get the date one week before the current date for week slice
    DateTime oneDayBefore = now.subtract(Duration(days: 4));
    DateTime oneWeekBefore = now.subtract(Duration(days: 7));
    DateTime oneMonthBefore = now.subtract(Duration(days: 30));
    DateTime oneYearBefore = now.subtract(Duration(days: 365));

    return BlocBuilder<HistoricalCubit, HistoricalState>(
        builder: (context, state) {
      if (state is HistoricalInitial) {
        return Text('State is HistoricalInitial');
      } else if (state is HistoricalLoading) {
        return AspectRatio(
          aspectRatio: 1.7,
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 20.0,
                ),
                CircularProgressIndicator(),
                SizedBox(
                  height: 10.0,
                ),
                Text('Graph is loading..'),
              ],
            ),
          ),
        );
      } else if (state is HistoricalLoaded) {
        return Column(
          children: [
            SizedBox(
              height: 20.0,
            ),
            AspectRatio(
              aspectRatio: 1.7,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        dotData: FlDotData(show: false),
                        isCurved: false,
                        spots: state.historicalData
                            .map((data) => FlSpot(
                                data.time.millisecondsSinceEpoch.toDouble(),
                                data.price))
                            .toList(),
                        color: Colors.blue,
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.blue.withOpacity(0.3),
                        ),
                      ),
                    ],
                    titlesData: FlTitlesData(
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Text(value.toInt().toString());
                            }),
                      ),
                      rightTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                return Text(value.toInt().toString());
                              })),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 60,
                            getTitlesWidget: (value, meta) {
                              DateTime date =
                                  DateTime.fromMillisecondsSinceEpoch(
                                      value.toInt());
                              return SideTitleWidget(
                                  angle: 0.5,
                                  axisSide: meta.axisSide,
                                  child: Text(
                                      '${date.year.toString()}-${date.month.toString()}'));
                            }),
                      ),
                    ),
                    gridData: FlGridData(drawHorizontalLine: false),
                    borderData: FlBorderData(
                      show: false,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.read<HistoricalCubit>().loadHistoricalData(
                            stockSymbol,
                            '1',
                            'minute',
                            formatter.format(oneDayBefore),
                            formatter.format(now),
                          );
                    },
                    child: Text('1D'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<HistoricalCubit>().loadHistoricalData(
                          stockSymbol,
                          '1',
                          'hour',
                          formatter.format(oneWeekBefore),
                          formatter.format(now));
                    },
                    child: Text('1W'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<HistoricalCubit>().loadHistoricalData(
                          stockSymbol,
                          '1',
                          'hour',
                          formatter.format(oneMonthBefore),
                          formatter.format(now));
                    },
                    child: Text('1M'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<HistoricalCubit>().loadHistoricalData(
                          stockSymbol,
                          '1',
                          'day',
                          formatter.format(oneYearBefore),
                          formatter.format(now));
                    },
                    child: Text('1Y'),
                  ),
                ],
              ),
            ),
          ],
        );
      } else if (state is HistoricalError) {
        return AspectRatio(
          aspectRatio: 1.7,
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 20.0,
                ),
                Icon(
                  Icons.warning,
                  size: 100,
                  color: Colors.red,
                ),
                Text(state.message),
              ],
            ),
          ),
        );
      } else {
        return Container();
      }
    });
  }
}
