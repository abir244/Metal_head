class MatchModel {
  final String homeTeamName;
  final String awayTeamName;
  final String stadium;
  final DateTime matchDateTime;
  final int homeColor;
  final int awayColor;
  final String? homeLogo;
  final String? awayLogo;

  // --- ADDED FOR MATCH DETAILS ---
  final int? homeScore;
  final int? awayScore;
  final TeamLineup? homeLineup;
  final TeamLineup? awayLineup;

  MatchModel({
    required this.homeTeamName,
    required this.awayTeamName,
    required this.stadium,
    required this.matchDateTime,
    required this.homeColor,
    required this.awayColor,
    this.homeLogo,
    this.awayLogo,
    this.homeScore,
    this.awayScore,
    this.homeLineup,
    this.awayLineup,
  });
}

/// Represents the lineup and substitutes for a specific team
class TeamLineup {
  final List<Substitute>? substitutes;
  final String? formation; // e.g., "4-3-3"

  TeamLineup({
    this.substitutes,
    this.formation,
  });
}

/// Wrapper for player data specifically in a substitute context
class Substitute {
  final Player player;

  Substitute({required this.player});
}

/// Detailed player information
class Player {
  final String name;
  final int? shirtNumber;
  final String? position; // e.g., "FW", "MID"

  Player({
    required this.name,
    this.shirtNumber,
    this.position,
  });
}