part of 'historical_cubit.dart';

sealed class HistoricalState extends Equatable {
  const HistoricalState();
  @override
  List<Object?> get props => [];
}

class HistoricalInitial extends HistoricalState {}

class HistoricalLoading extends HistoricalState {}

class HistoricalLoaded extends HistoricalState {
  final List<HistoricalData> historicalData;

  HistoricalLoaded(this.historicalData);
  @override
  List<Object> get props => [historicalData];
}

class HistoricalError extends HistoricalState {
  final String message;
  const HistoricalError(this.message);

  @override
  List<Object> get props => [message];
}
