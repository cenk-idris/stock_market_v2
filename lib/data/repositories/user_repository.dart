import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stock_market_v2/data/data_providers/firestore_provider.dart';

class UserRepository {
  final FirestoreProvider firestoreProvider;

  UserRepository({required this.firestoreProvider});

  Stream<Map<String, dynamic>> getUserPortfolioStream() {
    return firestoreProvider.getUserDataStream().map((snapshot) {
      final data = snapshot.data();
      if (data != null) {
        //print(data);
        return data;
      } else {
        throw Exception('User data not found');
      }
    });
  }

  Future<void> buyStock(String symbol, double quantity, double currentPrice,
      String assetName, String fullName) async {
    await firestoreProvider.buyStock(
        symbol, quantity, currentPrice, assetName, fullName);
  }

  Future<void> sellStock(String symbol, double quantity, double currentPrice,
      String assetName, String fullName) async {
    await firestoreProvider.sellStock(
        symbol, quantity, currentPrice, assetName, fullName);
  }
}
