import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stock_market_v2/data/data_providers/auth_firebase_provider.dart';
import 'package:stock_market_v2/main.dart';

class FirestoreProvider {
  final FirebaseFirestore _firestore;

  FirestoreProvider({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> createUserInFirestore(User user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set({
        'balance': 1000000,
        'stocks': ['sdfsdf', 123, {}, []],
      });
    } on FirebaseException catch (e) {
      logger.e('Firebase Exception: $e', stackTrace: StackTrace.current);
    } catch (e) {
      logger.e('Err: $e', stackTrace: StackTrace.current);
    }
  }
}
