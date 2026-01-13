// lib/features/voting/viewmodel/assign_voting_viewmodel.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metalheadd/presentation/voting_rights/viewmodel/voting_state.dart';

final assignVotingProvider =
    NotifierProvider<AssignVotingViewModel, VotingState>(() {
      return AssignVotingViewModel();
    });

class AssignVotingViewModel extends Notifier<VotingState> {
  @override
  VotingState build() => VotingState();

  void toggleAgreement(bool value) {
    state = state.copyWith(isAgreed: value);
  }

  Future<void> submitAssignment() async {
    if (!state.isAgreed) return;

    state = state.copyWith(isLoading: true);
    // Simulate API Call
    await Future.delayed(const Duration(seconds: 2));
    state = state.copyWith(isLoading: false);
  }
}
