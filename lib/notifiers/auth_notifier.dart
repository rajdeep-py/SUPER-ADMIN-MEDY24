import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';

class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;

  AuthState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    if (email == 'admin@medy24.com' && password == 'admin123') {
      state = state.copyWith(
        isLoading: false,
        user: User(id: '1', email: email, name: 'Admin User'),
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        error: 'Invalid email or password',
      );
    }
  }

  void logout() {
    state = AuthState();
  }
}
