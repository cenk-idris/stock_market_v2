import 'package:equatable/equatable.dart';

sealed class MarketEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class MarketLoadRequested extends MarketEvent {}

class MarketSubscribeToTickersRequested extends MarketEvent {
  final List<String> symbols;

  MarketSubscribeToTickersRequested(this.symbols);

  @override
  List<Object?> get props => [symbols];
}

class MarketDataReceived extends MarketEvent {
  final Map<String, dynamic> data;

  MarketDataReceived(this.data);

  @override
  List<Object?> get props => [data];
}
