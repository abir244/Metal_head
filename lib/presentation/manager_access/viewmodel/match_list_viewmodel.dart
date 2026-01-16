import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metalheadd/presentation/manager_access/model/match_model.dart';

/// 1. Simple Configuration Notifier
final matchConfigProvider = AutoDisposeAsyncNotifierProvider<MatchConfigNotifier, int>(
  MatchConfigNotifier.new,
);

class MatchConfigNotifier extends AutoDisposeAsyncNotifier<int> {
  @override
  Future<int> build() async {
    // Simulate fetching a setting (e.g., how many matches to display)
    await Future.delayed(const Duration(milliseconds: 200));
    return 3;
  }
}

/// 2. Main Match List ViewModel
final matchListProvider = AutoDisposeAsyncNotifierProvider<MatchListViewModel, List<MatchModel>>(
  MatchListViewModel.new,
);

class MatchListViewModel extends AutoDisposeAsyncNotifier<List<MatchModel>> {
  @override
  Future<List<MatchModel>> build() async {
    // Watch the limit from config
    final limit = await ref.watch(matchConfigProvider.future);

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 400));

    // Return filtered mock data
    return _getMockMatches().take(limit).toList();
  }

  /// Public refresh method
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }

  /// Private helper to keep build() clean and reusable
  List<MatchModel> _getMockMatches() {
    final matchDate = DateTime(2025, 7, 18, 18, 30); // 06:30 PM

    return [
      MatchModel(
        homeTeamName: 'Liverpool',
        awayTeamName: 'Chelsea',
        stadium: 'Old Trafford Stadium', // Matched to Figma
        matchDateTime: matchDate,
        homeColor: 0xFFE41E2B,
        awayColor: 0xFF034694,
      ),
      MatchModel(
        homeTeamName: 'Liverpool',
        awayTeamName: 'Chelsea',
        stadium: 'Old Trafford Stadium',
        matchDateTime: matchDate,
        homeColor: 0xFFE41E2B,
        awayColor: 0xFF034694,
      ),
      MatchModel(
        homeTeamName: 'Liverpool',
        awayTeamName: 'Chelsea',
        stadium: 'Old Trafford Stadium',
        matchDateTime: matchDate,
        homeColor: 0xFFE41E2B,
        awayColor: 0xFF034694,
      ),
    ];
  }
}