part of 'historical_cubit.dart';

sealed class HistoricalState extends Equatable {
  const HistoricalState();
  @override
  List<Object> get props => [];
}

final class HistoricalInitial extends HistoricalState {}
