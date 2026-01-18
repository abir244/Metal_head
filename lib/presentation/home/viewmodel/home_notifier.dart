import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_provider.dart';
import 'home_state.dart';

class HomeNotifier extends Notifier<HomeState> {
  @override
  HomeState build() {
    // Fetch data after initialization
    Future.microtask(() => fetchMatches());
    return HomeState.initial();
  }

  // Refresh method for pull-to-refresh
  Future<void> refresh() async {
    await fetchMatches();
  }

  Future<void> fetchMatches() async {
    // Set loading state while preserving existing data
    state = HomeState(
      loading: true,
      upcomingMatches: state.upcomingMatches,
      matchHistory: state.matchHistory,
      child: state.child,
    );

    try {
      final repo = ref.read(homeRepositoryProvider);

      // Fetch all data
      final child = await repo.fetchChildProfile();
      final upcoming = await repo.fetchUpcomingMatches();
      final history = await repo.fetchMatchHistory();

      // Update state with fetched data
      state = HomeState(
        loading: false,
        child: child,
        upcomingMatches: upcoming,
        matchHistory: history,
      );
    } catch (e) {
      // On error, preserve existing data and stop loading
      state = HomeState(
        loading: false,
        upcomingMatches: state.upcomingMatches,
        matchHistory: state.matchHistory,
        child: state.child,
      );
    }
  }
}