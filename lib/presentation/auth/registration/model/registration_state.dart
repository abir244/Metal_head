class RegistrationState {
  final bool isLoading;
  final bool isFormValid;
  final String? error;

  const RegistrationState({
    this.isLoading = false,
    this.isFormValid = false,
    this.error,
  });

  RegistrationState copyWith({
    bool? isLoading,
    bool? isFormValid,
    String? error,
  }) {
    return RegistrationState(
      isLoading: isLoading ?? this.isLoading,
      isFormValid: isFormValid ?? this.isFormValid,
      error: error,
    );
  }
}
