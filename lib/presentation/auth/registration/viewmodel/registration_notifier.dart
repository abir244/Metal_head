import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/registration_state.dart';


class RegistrationViewModel
    extends StateNotifier<RegistrationState> {
  RegistrationViewModel() : super(const RegistrationState());

  void onFormChanged({
    required String name,
    required String password,
    required String confirmPassword,
  }) {
    final isValid = name.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        password == confirmPassword;

    state = state.copyWith(isFormValid: isValid, error: null);
  }

  Future<void> signUp({
    required String name,
    required String phone,
    required String password,
    required String confirmPassword,
  }) async {
    state = state.copyWith(isLoading: true);

    await Future.delayed(const Duration(seconds: 2));

    state = state.copyWith(isLoading: false);
  }
}
