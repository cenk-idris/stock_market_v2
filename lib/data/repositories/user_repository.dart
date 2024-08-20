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
}
