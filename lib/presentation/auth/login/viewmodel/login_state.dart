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
