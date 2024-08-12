import 'package:equatable/equatable.dart';

import '../models/stock_model.dart';

sealed class MarketState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MarketInitial extends MarketState {}

class MarketLoading extends MarketState {
  final double progressValue;
  final String stockBeingSubscribed;

  MarketLoading({this.progressValue = 0.0, this.stockBeingSubscribed = ''});

  @override
  List<Object?> get props => [progressValue, stockBeingSubscribed];
}

class MarketLoaded extends MarketState {
  final List<Stock> market;

  MarketLoaded(this.market);
}
