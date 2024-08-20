part of 'wallet_bloc.dart';

sealed class WalletState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class WalletLoaded extends WalletState {
  final double balance;
  final List<OwnedStock> stocks;

  WalletLoaded({required this.balance, required this.stocks});

  @override
  List<Object?> get props => [balance, stocks];
}

class WalletError extends WalletState {
  final String message;

  WalletError(this.message);

  @override
  List<Object?> get props => [message];
}
