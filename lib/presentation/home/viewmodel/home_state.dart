
import '../model/match.dart';
import '../model/child_profile.dart';

class HomeState {
  final bool loading;
  final ChildProfile? child;
  final List<Match> upcomingMatches;
  final List<Match> matchHistory;
  final String? error;

  const HomeState({
    this.loading = false,
    this.child,
    this.upcomingMatches = const [],
    this.matchHistory = const [],
    this.error,
  });

  HomeState copyWith({
    bool? loading,
    ChildProfile? child,
    List<Match>? upcomingMatches,
    List<Match>? matchHistory,
    String? error,
  }) {
    return HomeState(
      loading: loading ?? this.loading,
      child: child ?? this.child,
      upcomingMatches: upcomingMatches ?? this.upcomingMatches,
      matchHistory: matchHistory ?? this.matchHistory,
      error: error,
    );
  }

  static HomeState initial() => const HomeState(loading: true);
}
