part of 'transaction_cubit.dart';

sealed class TransactionState extends Equatable {
  const TransactionState();
  @override
  List<Object> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionSuccess extends TransactionState {
  final String message;

  const TransactionSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class TransactionPriceUpdated extends TransactionState {
  final double currentPrice;

  const TransactionPriceUpdated(this.currentPrice);
  @override
  List<Object> get props => [currentPrice];
}

class TransactionError extends TransactionState {
  final String message;

  const TransactionError(this.message);

  @override
  List<Object> get props => [message];
}
