import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stock_market_v2/data/repositories/stock_repository.dart';
import 'package:stock_market_v2/data/repositories/user_repository.dart';

import '../../../market/models/stock_model.dart';
import '../../models/owned_stock_model.dart';

part 'wallet_event.dart';
part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final UserRepository userRepository;
  final StockRepository stockRepository;
  StreamSubscription<Map<String, dynamic>>? _userPortfolioSubscription;
  StreamSubscription<Map<String, dynamic>>? _tickersSubscription;

  WalletBloc({required this.stockRepository, required this.userRepository})
      : super(WalletInitial()) {
    on<WalletLoadRequested>(_onWalletLoadRequested);
    on<WalletDataUpdated>(_onWalletDataUpdated);
    //on<WalletTickersUpdated>(_onWalletTickersUpdated);
  }

  Future<void> _onWalletLoadRequested(
      WalletLoadRequested event, Emitter<WalletState> emit) async {
    emit(WalletLoading());

    try {
      // Subscribe to Firestore document updates
      _userPortfolioSubscription =
          userRepository.getUserPortfolioStream().listen((walletData) async {
        print(walletData);
        add(WalletDataUpdated(walletData));
      });

      // Subscribe to Tickers (WebSocket) updates
      _tickersSubscription =
          stockRepository.getTickersStream().listen((tickersData) {
        //print(tickersData);
      });
    } catch (e) {
      emit(WalletError('Failed to load wallet data'));
    }
  }

  void _onWalletDataUpdated(
      WalletDataUpdated event, Emitter<WalletState> emit) async {
    final double updatedBalance = (event.data['balance'] is int)
        ? (event.data['balance'] as int).toDouble()
        : event.data['balance'];
    List<OwnedStock> ownedStocks = [];

    if (event.data['stocks'] != null) {
      final List<dynamic> stocksDynamic = event.data['stocks'];
      ownedStocks = stocksDynamic.map((stockData) {
        return OwnedStock.fromFirestoreOwnedStockData(stockData);
      }).toList();
    }

    emit(WalletLoaded(balance: updatedBalance, stocks: ownedStocks));
  }
  //
  // Future<void> _onWalletTickersUpdated(
  //     WalletTickersUpdated event, Emitter<WalletState> emit) {
  //   return null;
  // }
}
