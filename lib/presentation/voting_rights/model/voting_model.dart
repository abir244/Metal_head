
// lib/domain/voting/models.dart
class VotingRight {
  final String assignedByParentName;
  final String childName;
  final bool accepted;

  const VotingRight({
    required this.assignedByParentName,
    required this.childName,
    required this.accepted,
  });

  VotingRight copyWith({bool? accepted}) =>
      VotingRight(assignedByParentName: assignedByParentName, childName: childName, accepted: accepted ?? this.accepted);
}

class PlayerCandidate {
  final String id;
  final String name;
  final String number;    // e.g., "#10"
  final String position;  // "Forward", "Midfielder", etc.
  final String avatarUrl; // asset or network path

  const PlayerCandidate({
    required this.id,
    required this.name,
    required this.number,
    required this.position,
    required this.avatarUrl,
  });
}

class VotePageData {
  final VotingRight rights;
  final List<PlayerCandidate> candidates;

  const VotePageData({required this.rights, required this.candidates});
}
