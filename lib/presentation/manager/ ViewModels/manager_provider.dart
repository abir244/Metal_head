import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- Match Status Enum ---
enum MatchProcess { upcoming, live, paused, finished }

// --- Match Model ---
class ManagerMatch {
  final String id, homeTeam, awayTeam, homeLogo, awayLogo, venue;
  final int homeScore, awayScore;
  final MatchProcess status;
  final List<String> scorers, assists;

  ManagerMatch({
    required this.id, required this.homeTeam, required this.awayTeam,
    required this.homeLogo, required this.awayLogo, required this.venue,
    this.homeScore = 0, this.awayScore = 0,
    this.status = MatchProcess.upcoming,
    this.scorers = const [], this.assists = const [],
  });

  ManagerMatch copyWith({int? hScore, int? aScore, MatchProcess? status, List<String>? sc, List<String>? ass}) {
    return ManagerMatch(
      id: id, homeTeam: homeTeam, awayTeam: awayTeam, venue: venue,
      homeLogo: homeLogo, awayLogo: awayLogo,
      homeScore: hScore ?? homeScore, awayScore: aScore ?? awayScore,
      status: status ?? this.status, scorers: sc ?? scorers, assists: ass ?? assists,
    );
  }
}

// --- VIEWMODEL (The Notifier) ---
class ManagerMatchesNotifier extends Notifier<List<ManagerMatch>> {
  @override
  List<ManagerMatch> build() => [
    ManagerMatch(id: '1', homeTeam: 'Liverpool', awayTeam: 'Chelsea', homeLogo: 'assets/images/liverpool.png', awayLogo: 'assets/images/chelsea.png', venue: 'Old Trafford Stadium'),
    ManagerMatch(id: '2', homeTeam: 'Man City', awayTeam: 'Forest', homeLogo: 'assets/images/mancity.png', awayLogo: 'assets/images/forest.png', venue: 'Old Trafford Stadium'),
    ManagerMatch(id: '3', homeTeam: 'Barcelona', awayTeam: 'Man Utd', homeLogo: 'assets/images/barca.png', awayLogo: 'assets/images/manutd.png', venue: 'Camp Nou'),
  ];

  void updateMatch(ManagerMatch updated) {
    state = [for (final m in state) if (m.id == updated.id) updated else m];
  }
}

final managerMatchesProvider = NotifierProvider<ManagerMatchesNotifier, List<ManagerMatch>>(ManagerMatchesNotifier.new);
final selectedMatchIdProvider = StateProvider<String?>((ref) => null);

// Logic Fix: This grabs the LATEST data from the list for the selected ID
final activeManagerMatchProvider = Provider<ManagerMatch?>((ref) {
  final id = ref.watch(selectedMatchIdProvider);
  if (id == null) return null;
  return ref.watch(managerMatchesProvider).firstWhere((m) => m.id == id);
});