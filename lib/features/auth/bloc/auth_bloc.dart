import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../main.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  late final StreamSubscription<User?> _authStateChangesSubscription;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    // Listen to the authentication state changes and emit states accordingly
    _authStateChangesSubscription =
        authRepository.authStateChanges().listen((user) {
      add(AuthStateChanged(user));
    });

    on<AuthStateChanged>(_onAuthStateChanged);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<NewUserCreated>(_onNewUserCreated);
  }

  void _onAuthStateChanged(AuthStateChanged event, Emitter<AuthState> emit) {
    if (event.user != null) {
      emit(AuthAuthenticated(event.user!));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLogoutRequested(
      AuthLogoutRequested event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());
      await authRepository.signOut();
      emit(AuthUnauthenticated());
    } on FirebaseAuthException catch (e) {
      logger.e("This is a FirebaseAuthException", error: 'Test Error');
    } catch (e) {
      logger.e("This is a _onLogoutRequested", error: 'Test Error');
    }
  }

  Future<void> _onNewUserCreated(
      NewUserCreated event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.createNewUserRecord(event.user);
      emit(AuthAuthenticated(event.user));
    } on FirebaseAuthException catch (e) {
      logger.e('FirebaseAuthException', stackTrace: StackTrace.current);
      emit(AuthError('Failed to create user in Firestore: ${e.toString()}'));
    } catch (e) {
      logger.e('Err: ${e.toString()}', stackTrace: StackTrace.current);
      emit(AuthError('Failed to create user in Firestore: ${e.toString()}'));
    }
  }

  @override
  Future<void> close() async {
    super.close();
    // Cancel the stream subscription when the bloc is closed
    _authStateChangesSubscription.cancel();
    return super.close();
  }
}
