import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stock_market_v2/data/data_providers/auth_firebase_provider.dart';
import 'package:stock_market_v2/main.dart';

class FirestoreProvider {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  FirestoreProvider({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserDataStream() {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }
    return _firestore.collection('users').doc(user.uid).snapshots();
  }

  Future<void> createUserInFirestore(User user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set({
        'balance': 1000000,
        'stocks': [],
      });
    } on FirebaseException catch (e) {
      logger.e('Firebase Exception: $e', stackTrace: StackTrace.current);
    } catch (e) {
      logger.e('Err: $e', stackTrace: StackTrace.current);
    }
  }

  double roundTheDecimal(double value, int decimals) {
    num mod = pow(10.0, decimals);
    return ((value * mod).round().toDouble() / mod);
  }

  Future<void> buyStock(String symbol, double quantity, double currentPrice,
      String assetName, String fullName) async {
    final user = _auth.currentUser;
    if (user != null) {
      final costOfPurchase = quantity * currentPrice;
      final userDocRef = _firestore.collection('users').doc(user.uid);

      // atomic operation
      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(userDocRef);
        if (!snapshot.exists) {
          throw Exception("User document does not exist");
        }

        final data = snapshot.data();
        if (data == null || data.isEmpty) {
          throw Exception("User document exists but contains no data");
        }

        final currentBalance = (data['balance'] is int)
            ? (data['balance'] as int).toDouble()
            : data['balance'];
        final stocks = List<Map<String, dynamic>>.from(data['stocks']);

        if (currentBalance < costOfPurchase) {
          throw Exception('Insufficient balance');
        }

        final stockIndex =
            stocks.indexWhere((asset) => asset['symbol'] == symbol);
        // if stock already exist in wallet
        // increament the shares by 'quantity'
        // else and new entry
        if (stockIndex != -1) {
          stocks[stockIndex]['shares'] += quantity;
        } else {
          stocks.add({
            'symbol': symbol,
            'shares': quantity,
            'asset_name': assetName,
            'full_name': fullName
          });
        }

        final updatedBalance =
            roundTheDecimal(currentBalance - costOfPurchase, 2);

        transaction.update(userDocRef, {
          'balance': updatedBalance,
          'stocks': stocks,
        });
      });
    }
  }
}
