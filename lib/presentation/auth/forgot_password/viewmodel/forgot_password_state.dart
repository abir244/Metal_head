import 'package:flutter/foundation.dart';

@immutable
class ForgotPasswordState {
  final bool isLoading;
  final bool isEmailValid;
  final String? error;
  final bool success;

  const ForgotPasswordState({
    this.isLoading = false,
    this.isEmailValid = false,
    this.error,
    this.success = false,
  });

  ForgotPasswordState copyWith({
    bool? isLoading,
    bool? isEmailValid,
    String? error,
    bool? success,
  }) {
    return ForgotPasswordState(
      isLoading: isLoading ?? this.isLoading,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      error: error,
      success: success ?? this.success,
    );
  }
}
