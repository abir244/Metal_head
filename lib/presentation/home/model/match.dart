import 'team.dart';

enum MatchStatus { upcoming, live, finished }

class Match {
  final String id;
  final Team homeTeam;
  final Team awayTeam;
  final DateTime startDate;
  final String leagueName;
  final MatchStatus status;
  final int? scoreHome;
  final int? scoreAway;

  const Match({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    required this.startDate,
    required this.leagueName,
    required this.status,
    this.scoreHome,
    this.scoreAway,
  });

  // --- ADD THESE METHODS TO FIX THE REPOSITORY ERRORS ---
  static List<Match> mockUpcoming() => [
    Match(
      id: 'm1',
      homeTeam: const Team(name: 'Liverpool', logoUrl: 'assets/images/liverpool.png'),
      awayTeam: const Team(name: 'Chelsea', logoUrl: 'assets/images/chelsea.png'),
      startDate: DateTime(2025, 7, 18, 18, 30),
      leagueName: 'Premier League',
      status: MatchStatus.upcoming,
    ),
    Match(
      id: 'm2',
      homeTeam: const Team(name: 'Manchester City', logoUrl: 'assets/images/mancity.png'),
      awayTeam: const Team(name: 'Manchester United', logoUrl: 'assets/images/manutd.png'),
      startDate: DateTime(2025, 7, 18, 18, 30),
      leagueName: 'Premier League',
      status: MatchStatus.upcoming,
    ),
  ];

  static List<Match> mockHistory() => [
    Match(
      id: 'm3',
      homeTeam: const Team(name: 'N Forest', logoUrl: 'assets/images/forest.png'),
      awayTeam: const Team(name: 'Man City', logoUrl: 'assets/images/mancity.png'),
      startDate: DateTime(2025, 7, 10, 15, 00),
      leagueName: 'Premier League',
      status: MatchStatus.finished,
      scoreHome: 0,
      scoreAway: 2,
    ),
  ];
}