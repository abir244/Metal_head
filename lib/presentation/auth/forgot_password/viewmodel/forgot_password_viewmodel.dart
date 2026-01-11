import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'forgot_password_state.dart';

class ForgotPasswordViewModel
    extends StateNotifier<ForgotPasswordState> {
  ForgotPasswordViewModel() : super(const ForgotPasswordState());

  void onEmailChanged(String email) {
    final isValid = email.contains('@') && email.contains('.');
    state = state.copyWith(
      isEmailValid: isValid,
      error: null,
    );
  }

  Future<void> sendResetCode(String email) async {
    if (!state.isEmailValid) {
      state = state.copyWith(error: 'Enter a valid email');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      // ⏳ Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      state = state.copyWith(
        isLoading: false,
        success: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Something went wrong',
      );
    }
  }
}
