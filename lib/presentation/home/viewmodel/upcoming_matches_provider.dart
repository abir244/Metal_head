import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/match.dart';
import '../model/team.dart';

final upcomingMatchesProvider = FutureProvider<List<Match>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 300));

  return [
    Match(
      id: 'm1',
      homeTeam: const Team(
        name: 'Liverpool',
        logoUrl: 'assets/images/liverpool.png',
      ),
      awayTeam: const Team(
        name: 'Chelsea',
        logoUrl: 'assets/images/chelsea.png',
      ),
      startDate: DateTime(2025, 7, 18, 18, 30),
      leagueName: 'Premier League',
      status: MatchStatus.upcoming,
    ),
  ];
});
