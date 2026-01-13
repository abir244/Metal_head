
// lib/domain/voting/repository.dart
import 'dart:async';

import '../voting_rights/model/voting_model.dart';


abstract class VotingRepository {
  Future<VotePageData> fetchVotePage(String matchId);
  Future<VotingRight> acceptVotingRights(String matchId);
  Future<void> submitVote(String matchId, String candidateId);
}

/// Demo repository (replace with API-backed implementation)
class InMemoryVotingRepository implements VotingRepository {
  VotingRight _rights = const VotingRight(
    assignedByParentName: 'Erling Haaland',
    childName: 'Roger Dokidis',
    accepted: false,
  );

  final List<PlayerCandidate> _candidates = List.generate(15, (i) {
    final idx = i + 1;
    final positions = ['Forward', 'Midfielder', 'Defender', 'Goalkeeper'];
    final pos = positions[idx % positions.length];
    return PlayerCandidate(
      id: 'p$idx',
      name: ['Alex Jordan','Corey Franci','Zaire Bator','Jaydon Pas','Kadin Bator','Alfredo Vac','Justin Geidt','Zaire Dias','Lincoln Dias','Roger Stent','Jakob Carder','Carter Carder','Craig Down','Omar Culha','Leo Passaq'][i],
      number: '#10',
      position: pos,
      avatarUrl: 'assets/avatars/avatar_${(idx % 6) + 1}.png',
    );
  });

  @override
  Future<VotePageData> fetchVotePage(String matchId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return VotePageData(rights: _rights, candidates: List.unmodifiable(_candidates));
  }

  @override
  Future<VotingRight> acceptVotingRights(String matchId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    _rights = _rights.copyWith(accepted: true);
    return _rights;
  }

  @override
  Future<void> submitVote(String matchId, String candidateId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // No-op in-memory; throw if invalid
    if (!_candidates.any((c) => c.id == candidateId)) {
      throw StateError('Candidate not found');
    }
  }
}
