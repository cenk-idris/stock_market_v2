import 'package:equatable/equatable.dart';

sealed class MarketEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class MarketLoadRequested extends MarketEvent {}

class MarketSubscribeToTickers extends MarketEvent {}
