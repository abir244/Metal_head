import '../model/match.dart';
import '../model/child_profile.dart';

class HomeState {
  final bool loading;
  final ChildProfile? child;
  final List<Match> upcomingMatches;
  final List<Match> matchHistory;

  const HomeState({
    required this.loading,
    this.child,
    this.upcomingMatches = const [],
    this.matchHistory = const [],
  });

  // Initial state factory
  factory HomeState.initial() => const HomeState(
    loading: true,
    upcomingMatches: [],
    matchHistory: [],
  );
}