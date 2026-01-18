import 'package:flutter_riverpod/flutter_riverpod.dart';

// Your existing LoginState class
class LoginState {
  final bool isLoading;
  final bool isFormValid;
  final String? error;

  const LoginState({
    this.isLoading = false,
    this.isFormValid = false,
    this.error,
  });

  LoginState copyWith({
    bool? isLoading,
    bool? isFormValid,
    String? error,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isFormValid: isFormValid ?? this.isFormValid,
      error: error,
    );
  }
}

// Your LoginNotifier class
class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier() : super(const LoginState());

  void onFormChanged({required String email, required String password}) {
    final isValid = email.isNotEmpty &&
        password.isNotEmpty &&
        email.contains('@');

    state = state.copyWith(
      isFormValid: isValid,
      error: null,
    );
  }

  // IMPORTANT: Change return type from void to Future<bool>
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Example validation (replace with your actual API call)
      if (email == 'test@test.com' && password == 'password') {
        state = state.copyWith(isLoading: false);
        return true; // Login successful
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Invalid email or password',
        );
        return false; // Login failed
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Login failed: ${e.toString()}',
      );
      return false; // Login failed
    }
  }
}

// Your provider
final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  return LoginNotifier();
});