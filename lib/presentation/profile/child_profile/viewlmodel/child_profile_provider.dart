import 'package:flutter_riverpod/flutter_riverpod.dart';
// Ensure these paths match your project structure exactly
import 'package:metalheadd/presentation/home/model/child_profile.dart';
import 'package:metalheadd/presentation/home/model/match.dart';
import 'package:metalheadd/presentation/home/model/team.dart';

// ---------------- PROFILES PROVIDER ----------------
final childProfileProvider = Provider<ChildProfile>((ref) {
  return ChildProfile(
    name: "Michael Smith",
    // UPDATED: Points to your local asset from the list you provided
    imageUrl: "assets/images/child.png",
    school: "Highlands Academy",
    jersey: "15",
    position: "Midfielder",
    birthday: "16/03",
    team: "Team A",
    registeredOn: "15 Jan 2025",
    status: "Active",
    // Optional fields for the "Full View" version of the card
    age: 12,
    height: 155,
    weight: 45,
    foot: "Right",
    notes: "Top scorer in last season",
    parent: ParentInfo(
        name: "Alex Jordan",
        email: "demo123@gmail.com",
        phone: "+999 1234 5678"
    ),
    stats: PerformanceStats(
        matches: 12,
        goals: 5,
        assists: 4,
        potm: 2,
        attendance: "92%"
    ),
  );
});

// ---------------- MATCHES PROVIDER ----------------
final upcomingMatchesProvider = Provider<List<Match>>((ref) {
  return [
    // 1. Liverpool vs Chelsea
    Match(
      id: 'm1',
      homeTeam: const Team(name: 'Liverpool', logoUrl: 'assets/images/liverpool.png'),
      awayTeam: const Team(name: 'Chelsea', logoUrl: 'assets/images/chelsea.png'),
      startDate: DateTime(2025, 7, 18, 18, 30),
      leagueName: 'Premier League',
      status: MatchStatus.upcoming,
    ),
    // 2. Man City vs Man Utd
    Match(
      id: 'm2',
      homeTeam: const Team(name: 'Manchester City', logoUrl: 'assets/images/mancity.png'),
      awayTeam: const Team(name: 'Manchester United', logoUrl: 'assets/images/manutd.png'),
      startDate: DateTime(2025, 7, 18, 18, 30),
      leagueName: 'Premier League',
      status: MatchStatus.upcoming,
    ),
    // 3. N Forest vs Man City
    Match(
      id: 'm3',
      homeTeam: const Team(name: 'Nottingham Forest', logoUrl: 'assets/images/forest.png'),
      awayTeam: const Team(name: 'Manchester City', logoUrl: 'assets/images/mancity.png'),
      startDate: DateTime(2025, 7, 20, 18, 30),
      leagueName: 'Premier League',
      status: MatchStatus.upcoming,
    ),
  ];
});