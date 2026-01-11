class OtpState {
  final bool isLoading;
  final bool isOtpValid;
  final String? error;

  const OtpState({
    this.isLoading = false,
    this.isOtpValid = false,
    this.error,
  });

  OtpState copyWith({
    bool? isLoading,
    bool? isOtpValid,
    String? error,
  }) {
    return OtpState(
      isLoading: isLoading ?? this.isLoading,
      isOtpValid: isOtpValid ?? this.isOtpValid,
      error: error,
    );
  }
}
