
import 'team.dart';

enum MatchStatus { upcoming, live, finished }

class Match {
  final Team homeTeam;
  final Team awayTeam;
  final DateTime startDate;
  final String leagueName;
  final MatchStatus status;
  final int? scoreHome;
  final int? scoreAway;

  const Match({
    required this.homeTeam,
    required this.awayTeam,
    required this.startDate,
    required this.leagueName,
    required this.status,
    this.scoreHome,
    this.scoreAway,
  });

  // --- mock helpers (align with screenshot) ---
  static List<Match> mockUpcoming() => [
    Match(
      homeTeam: const Team(name: 'Barcelona', logoUrl: 'assets/images/barca.png'),
      awayTeam: const Team(name: 'Man. Utd', logoUrl: 'assets/images/manutd.png'),
      startDate: DateTime(2025, 7, 18, 18, 30),
      leagueName: 'UCL - Road to Final',
      status: MatchStatus.upcoming,
    ),
    Match(
      homeTeam: const Team(name: 'Liverpool', logoUrl: 'assets/images/liverpool.png'),
      awayTeam: const Team(name: 'Chelsea', logoUrl: 'assets/images/chelsea.png'),
      startDate: DateTime(2025, 7, 18, 18, 30),
      leagueName: 'Premier League',
      status: MatchStatus.upcoming,
    ),
    Match(
      homeTeam: const Team(name: 'Man City', logoUrl: 'assets/images/mancity.png'),
      awayTeam: const Team(name: 'Man United', logoUrl: 'assets/images/manutd.png'),
      startDate: DateTime(2025, 7, 19, 18, 30),
      leagueName: 'Premier League',
      status: MatchStatus.upcoming,
    ),
  ];

  static List<Match> mockHistory() => [
    Match(
      homeTeam: const Team(name: 'N Forest', logoUrl: 'assets/images/forest.png'),
      awayTeam: const Team(name: 'Man City', logoUrl: 'assets/images/mancity.png'),
      startDate: DateTime(2025, 7, 20, 18, 30),
      leagueName: 'Premier League',
      status: MatchStatus.finished,
      scoreHome: 0,
      scoreAway: 2,
    ),
  ];
}
