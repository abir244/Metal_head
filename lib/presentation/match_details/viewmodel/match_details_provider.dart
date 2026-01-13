// lib/presentation/home/match_details/viewmodel/match_details_provider.dart
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ------------ Models ------------
class Team {
  final String id;
  final String name;
  final String shortName;
  final String logoUrl;

  const Team({
    required this.id,
    required this.name,
    required this.shortName,
    required this.logoUrl,
  });
}

class Player {
  final String id;
  final String name;
  final int shirtNumber;
  final String photoUrl; // Added for the UI avatars

  const Player({
    required this.id,
    required this.name,
    required this.shirtNumber,
    required this.photoUrl,
  });
}

class LineupEntry {
  final Player player;
  final String positionLabel; // e.g., "Forward", "Midfielder", "Defender"

  const LineupEntry({required this.player, this.positionLabel = ''});
}

class Lineup {
  final String formation;
  final List<LineupEntry> starters;
  final List<LineupEntry> substitutes;
  final String manager;

  const Lineup({
    required this.formation,
    required this.starters,
    required this.substitutes,
    required this.manager,
  });
}

class MatchDetails {
  final String id;
  final String competition;
  final DateTime kickoff;
  final Team home;
  final Team away;
  final int homeScore;
  final int awayScore;
  final Lineup homeLineup;
  final Lineup awayLineup;
  final String stadium; // Added for the header

  const MatchDetails({
    required this.id,
    required this.competition,
    required this.kickoff,
    required this.home,
    required this.away,
    required this.homeScore,
    required this.awayScore,
    required this.homeLineup,
    required this.awayLineup,
    required this.stadium,
  });
}

/// ------------ Repository ------------
abstract class MatchRepository {
  Future<MatchDetails> fetchMatch(String matchId);
}

class InMemoryMatchRepository implements MatchRepository {
  @override
  Future<MatchDetails> fetchMatch(String matchId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // DYNAMIC LOGIC: Return different teams based on matchId
    Team homeTeam;
    Team awayTeam;
    String stadiumName;

    if (matchId == 'fcb-che') {
      homeTeam = const Team(id: 'FCB', name: 'Barcelona', shortName: 'FCB', logoUrl: '');
      awayTeam = const Team(id: 'CHE', name: 'Chelsea', shortName: 'CHE', logoUrl: '');
      stadiumName = 'Camp Nou';
    } else {
      homeTeam = const Team(id: 'LIV', name: 'Liverpool', shortName: 'LIV', logoUrl: '');
      awayTeam = const Team(id: 'MUN', name: 'Man United', shortName: 'MUN', logoUrl: '');
      stadiumName = 'Old Trafford Stadium';
    }

    // Helper to create players with demo photos
    Player p(String id, String name, int no) => Player(
      id: id,
      name: name,
      shirtNumber: no,
      photoUrl: 'https://i.pravatar.cc/150?u=$id', // Dynamic demo photo
    );

    LineupEntry e(Player player, String pos) => LineupEntry(player: player, positionLabel: pos);

    final homeStarters = [
      e(p('h1', 'Erling Halland', 9), 'Forward'),
      e(p('h2', 'Roger Dokidis', 10), 'Midfielder'),
      e(p('h3', 'Ahmad Dias', 4), 'Defender'),
      e(p('h4', 'Alfredo Dias', 11), 'Forward'),
      e(p('h5', 'Cristofer Mango', 5), 'Defender'),
      e(p('h6', 'Jaylon Rhiel Madsen', 8), 'Midfielder'),
      e(p('h7', 'Ruben Saris', 2), 'Defender'),
      e(p('h8', 'Cooper Baptista', 6), 'Midfielder'),
      e(p('h9', 'Phillip Workman', 3), 'Defender'),
      e(p('h10', 'Jaylon Workman', 7), 'Forward'),
      e(p('h11', 'Abram Curtis', 21), 'Midfielder'),
    ];

    return MatchDetails(
      id: matchId,
      competition: 'Premier League',
      kickoff: DateTime(2025, 7, 18, 18, 30),
      home: homeTeam,
      away: awayTeam,
      homeScore: 0,
      awayScore: 0,
      stadium: stadiumName,
      homeLineup: Lineup(
        formation: '4-3-3',
        starters: homeStarters,
        substitutes: [
          e(p('s1', 'Angel Aminoff', 12), 'Forward'),
          e(p('s2', 'Terry Bergson', 14), 'Midfielder'),
          e(p('s3', 'Brandon Batash', 15), 'Defender'),
          e(p('s4', 'Cristofer Carder', 16), 'Forward'),
        ],
        manager: 'Emerson Bator',
      ),
      awayLineup: Lineup(
        formation: '4-4-2',
        starters: [], // Add away players here if needed
        substitutes: [],
        manager: 'Opponent Manager',
      ),
    );
  }
}

/// ------------ Providers ------------
final matchRepoProvider = Provider<MatchRepository>((ref) => InMemoryMatchRepository());

final matchDetailsProvider = AsyncNotifierProviderFamily<MatchDetailsVM, MatchDetails, String>(
  MatchDetailsVM.new,
);

class MatchDetailsVM extends FamilyAsyncNotifier<MatchDetails, String> {
  @override
  FutureOr<MatchDetails> build(String arg) {
    final repo = ref.watch(matchRepoProvider);
    return repo.fetchMatch(arg);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(matchRepoProvider).fetchMatch(arg));
  }
}