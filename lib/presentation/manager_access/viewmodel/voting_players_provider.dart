import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. The Player Model matching the Figma Table
class VotingPlayer {
  final String id;
  final String name;
  final String number;
  final String position;
  final String? photoUrl;

  VotingPlayer({
    required this.id,
    required this.name,
    required this.number,
    required this.position,
    this.photoUrl,
  });
}

// 2. The Notifier for state management
class VotingPlayersNotifier extends Notifier<List<VotingPlayer>> {
  @override
  List<VotingPlayer> build() {
    // Initial Dummy Data based on your screenshot
    return [
      VotingPlayer(id: '1', name: 'Alex Jordan', number: '10', position: 'Midfielder'),
      VotingPlayer(id: '2', name: 'Corey Franci', number: '10', position: 'Forward'),
      VotingPlayer(id: '3', name: 'Zaire Bator', number: '10', position: 'Midfielder'),
      VotingPlayer(id: '4', name: 'Jaydon Passaquindici', number: '10', position: 'Defender'),
    ];
  }

  void addPlayer({required String name, required String number, required String position}) {
    final newPlayer = VotingPlayer(
      id: DateTime.now().toString(),
      name: name,
      number: number,
      position: position,
      photoUrl: "https://i.pravatar.cc/150?u=$name", // Dynamic dummy avatar
    );
    state = [...state, newPlayer];
  }

  void removePlayer(int index) {
    final newState = [...state];
    newState.removeAt(index);
    state = newState;
  }
}

final votingPlayersProvider = NotifierProvider<VotingPlayersNotifier, List<VotingPlayer>>(() {
  return VotingPlayersNotifier();
});