import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

// Event triggered when the user requests a logout
class AuthLogoutRequested extends AuthEvent {}

// Event to handle when the authentication state changes
class AuthStateChanged extends AuthEvent {
  final User? user;

  AuthStateChanged(this.user);

  @override
  List<Object?> get props => [user];
}

class NewUserCreated extends AuthEvent {
  final User user;

  const NewUserCreated(this.user);

  @override
  List<Object?> get props => [user];
}
