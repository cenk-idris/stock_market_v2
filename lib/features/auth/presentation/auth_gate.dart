import 'package:firebase_ui_auth/firebase_ui_auth.dart' as fui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_market_v2/features/auth/bloc/auth_event.dart';
import 'package:stock_market_v2/features/auth/bloc/auth_state.dart';

import '../../../data/data_providers/auth_firebase_provider.dart';
import '../../../data/repositories/auth_repository.dart';
import '../bloc/auth_bloc.dart';
import 'package:stock_market_v2/features/home/home.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(
        authRepository: AuthRepository(
          authProvider: AuthFirebaseProvider(),
        ),
      ),
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is AuthAuthenticated) {
            return HomeScreen(user: authState.user);
          } else if (authState is AuthUnauthenticated) {
            return fui.SignInScreen(
              providers: [fui.EmailAuthProvider()],
              actions: [
                fui.AuthStateChangeAction<fui.SignedIn>((context, state) {
                  print('SIGNEDIN');
                }),
                fui.AuthStateChangeAction<fui.UserCreated>(
                    (context, state) async {
                  print('USERCREATED');
                  context
                      .read<AuthBloc>()
                      .add(NewUserCreated(state.credential.user!));
                }),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
