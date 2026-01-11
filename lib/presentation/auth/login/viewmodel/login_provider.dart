import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'login_state.dart';

final loginProvider =
StateNotifierProvider<LoginNotifier, LoginState>(
      (ref) => LoginNotifier(),
);

class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier() : super(const LoginState());

  // 🔹 Called when user types
  void onFormChanged({
    required String email,
    required String password,
  }) {
    final isValid =
        email.isNotEmpty &&
            email.contains('@') &&
            password.length >= 6;

    state = state.copyWith(
      isFormValid: isValid,
      error: null,
    );
  }

  // 🔹 Login action
  Future<void> login({
    required String email,
    required String password,
  }) async {
    if (!state.isFormValid) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: replace with real API
      await Future.delayed(const Duration(seconds: 2));

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Invalid email or password',
      );
    }
  }
}
