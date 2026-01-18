class PerformanceStats {
  final int matches;
  final int goals;
  final int assists;
  final int potm;
  final String attendance;

  PerformanceStats({
    required this.matches,
    required this.goals,
    required this.assists,
    required this.potm,
    required this.attendance,
  });

  factory PerformanceStats.mock() {
    return PerformanceStats(
      matches: 34,
      goals: 29,
      assists: 12,
      potm: 8,
      attendance: "98%",
    );
  }

  factory PerformanceStats.fromJson(Map<String, dynamic> json) {
    return PerformanceStats(
      matches: json['matches'],
      goals: json['goals'],
      assists: json['assists'],
      potm: json['potm'],
      attendance: json['attendance'],
    );
  }

  Map<String, dynamic> toJson() => {
    'matches': matches,
    'goals': goals,
    'assists': assists,
    'potm': potm,
    'attendance': attendance,
  };
}
