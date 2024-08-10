import 'package:firebase_auth/firebase_auth.dart';

import '../data_providers/auth_firebase_provider.dart';

class AuthRepository {
  final AuthFirebaseProvider authProvider;

  AuthRepository({required this.authProvider});

  Stream<User?> authStateChanges() {
    return authProvider.authStateChanges();
  }

  Future<void> signOut() {
    return authProvider.signOut();
  }

  User? getCurrentUser() {
    return authProvider.getCurrentUser();
  }
}
