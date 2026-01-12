
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_state.dart';
import 'home_repository.dart';

class HomeNotifier extends StateNotifier<HomeState> {
  final HomeRepository _repo;

  HomeNotifier(this._repo) : super(HomeState.initial()) {
    loadHome();
  }

  Future<void> loadHome() async {
    try {
      state = state.copyWith(loading: true, error: null);

      final child = await _repo.fetchChildProfile();
      final upcoming = await _repo.fetchUpcomingMatches();
      final history = await _repo.fetchMatchHistory();

      state = state.copyWith(
        loading: false,
        child: child,
        upcomingMatches: upcoming,
        matchHistory: history,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  void refresh() => loadHome();
}

