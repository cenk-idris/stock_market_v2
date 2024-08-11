import 'package:firebase_auth/firebase_auth.dart';
import 'package:stock_market_v2/data/data_providers/firestore_provider.dart';

import '../data_providers/auth_firebase_provider.dart';

class AuthRepository {
  final AuthFirebaseProvider authProvider;
  final FirestoreProvider firestoreProvider;

  AuthRepository({required this.authProvider, required this.firestoreProvider});

  Stream<User?> authStateChanges() {
    return authProvider.authStateChanges();
  }

  Future<void> signOut() {
    return authProvider.signOut();
  }

  User? getCurrentUser() {
    return authProvider.getCurrentUser();
  }

  Future<void> createNewUserRecord(User user) async {
    await firestoreProvider.createUserInFirestore(user);
  }
}
