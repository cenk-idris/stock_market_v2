part of 'wallet_bloc.dart';

sealed class WalletEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class WalletLoadRequested extends WalletEvent {}

class WalletDataUpdated extends WalletEvent {
  final Map<String, dynamic> data;

  WalletDataUpdated(this.data);

  @override
  List<Object?> get props => [data];
}

class WalletTickersUpdated extends WalletEvent {
  final Map<String, dynamic> data;

  WalletTickersUpdated(this.data);

  @override
  List<Object?> get props => [data];
}
