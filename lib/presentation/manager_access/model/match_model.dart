class MatchModel {
  final String homeTeamName;
  final String awayTeamName;
  final String stadium;
  final DateTime matchDateTime;
  final int homeColor;
  final int awayColor;
  final String? homeLogo; // Optional for future use
  final String? awayLogo;

  MatchModel({
    required this.homeTeamName,
    required this.awayTeamName,
    required this.stadium,
    required this.matchDateTime,
    required this.homeColor,
    required this.awayColor,
    this.homeLogo,
    this.awayLogo,
  });
}