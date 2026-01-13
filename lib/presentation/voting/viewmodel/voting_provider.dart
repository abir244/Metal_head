// lib/presentation/voting/viewmodel/voting_provider.dart
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../voting_rights/model/voting_model.dart';
import '../repository.dart';

/// DI for repository
final votingRepoProvider = Provider<VotingRepository>((ref) {
  return InMemoryVotingRepository(); // swap with API impl later
});

/// Ephemeral view state representing the page
class VotePageState {
  final AsyncValue<VotePageData> data;
  final String? selectedCandidateId;
  final bool submitting;

  const VotePageState({
    required this.data,
    this.selectedCandidateId,
    this.submitting = false,
  });

  VotePageState copyWith({
    AsyncValue<VotePageData>? data,
    String? selectedCandidateId,
    bool? submitting,
  }) {
    return VotePageState(
      data: data ?? this.data,
      selectedCandidateId: selectedCandidateId,
      submitting: submitting ?? this.submitting,
    );
  }
}

/// Family provider: pass matchId
final votingProvider = NotifierProviderFamily<VotingVM, VotePageState, String>(
  VotingVM.new,
);

class VotingVM extends FamilyNotifier<VotePageState, String> {
  late final VotingRepository _repo;

  @override
  VotePageState build(String matchId) {
    _repo = ref.watch(votingRepoProvider);

    // start async load and keep initial loading state
    () async {
      final result = await AsyncValue.guard(() => _repo.fetchVotePage(matchId));
      state = state.copyWith(data: result);
    }();

    return const VotePageState(data: AsyncValue.loading());
  }

  Future<void> refresh() async {
    final id = arg;
    state = VotePageState(data: const AsyncValue.loading());
    final result = await AsyncValue.guard(() => _repo.fetchVotePage(id));
    state = VotePageState(data: result);
  }

  void selectCandidate(String candidateId) {
    state = state.copyWith(selectedCandidateId: candidateId);
  }

  Future<void> acceptRights() async {
    final id = arg;
    final current = state.data.valueOrNull;
    if (current == null) return;

    // optimistic state: mark accepted
    final optimistic = current.copyWith(
      rights: current.rights.copyWith(accepted: true),
    );
    state = state.copyWith(data: AsyncValue.data(optimistic));

    try {
      final updated = await _repo.acceptVotingRights(id);
      state = state.copyWith(
        data: AsyncValue.data(
          VotePageData(rights: updated, candidates: current.candidates),
        ),
      );
    } catch (e, st) {
      state = state.copyWith(data: AsyncValue.error(e, st));
      state = state.copyWith(data: AsyncValue.data(current)); // rollback
    }
  }

  Future<void> submitVote() async {
    final id = arg;
    final selected = state.selectedCandidateId;
    final current = state.data.valueOrNull;
    if (selected == null || current == null || !current.rights.accepted) return;

    state = state.copyWith(submitting: true);
    try {
      await _repo.submitVote(id, selected);
    } finally {
      state = state.copyWith(submitting: false);
    }
  }
}

extension on VotePageData {
  VotePageData copyWith({
    VotingRight? rights,
    List<PlayerCandidate>? candidates,
  }) => VotePageData(
    rights: rights ?? this.rights,
    candidates: candidates ?? this.candidates,
  );
}
