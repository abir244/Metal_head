class VotingState {
  final bool isAgreed;
  final bool isLoading;

  const VotingState({
    this.isAgreed = false,
    this.isLoading = false,
  });

  VotingState copyWith({
    bool? isAgreed,
    bool? isLoading,
  }) {
    return VotingState(
      isAgreed: isAgreed ?? this.isAgreed,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
