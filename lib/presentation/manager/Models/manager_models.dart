enum MatchProcess { upcoming, live, paused, finished }

class FootballMatch {
  final String id;
  final String homeTeam;
  final String awayTeam;
  final String venue;
  final DateTime dateTime;
  final int scoreHome;
  final int scoreAway;
  final MatchProcess process;
  final List<String> scorers;
  final List<String> assists;

  FootballMatch({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    required this.venue,
    required this.dateTime,
    this.scoreHome = 0,
    this.scoreAway = 0,
    this.process = MatchProcess.upcoming,
    this.scorers = const [],
    this.assists = const [],
  });

  // CopyWith for state updates
  FootballMatch copyWith({
    int? scoreHome, int? scoreAway, MatchProcess? process,
    List<String>? scorers, List<String>? assists,
  }) {
    return FootballMatch(
      id: id, homeTeam: homeTeam, awayTeam: awayTeam, venue: venue,
      dateTime: dateTime,
      scoreHome: scoreHome ?? this.scoreHome,
      scoreAway: scoreAway ?? this.scoreAway,
      process: process ?? this.process,
      scorers: scorers ?? this.scorers,
      assists: assists ?? this.assists,
    );
  }
}