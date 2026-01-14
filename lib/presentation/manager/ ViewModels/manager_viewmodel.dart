import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Models/manager_models.dart';


// ViewModel for the active match being managed
class MatchManagerViewModel extends StateNotifier<FootballMatch?> {
  MatchManagerViewModel() : super(null);

  Timer? _timer;
  int _seconds = 0;

  void selectMatch(FootballMatch match) => state = match;

  void toggleMatchStatus() {
    if (state == null) return;
    if (state!.process == MatchProcess.upcoming || state!.process == MatchProcess.paused) {
      state = state!.copyWith(process: MatchProcess.live);
      _startTimer();
    } else {
      state = state!.copyWith(process: MatchProcess.paused);
      _timer?.cancel();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _seconds++;
      // In a real app, you'd update a timer provider here
    });
  }

  void addScorer(String name) {
    state = state!.copyWith(scorers: [...state!.scorers, name]);
  }

  void removeScorer(String name) {
    state = state!.copyWith(scorers: state!.scorers.where((n) => n != name).toList());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

// Providers
final matchManagerProvider = StateNotifierProvider<MatchManagerViewModel, FootballMatch?>((ref) {
  return MatchManagerViewModel();
});

final allMatchesProvider = Provider<List<FootballMatch>>((ref) {
  return [
    FootballMatch(id: '1', homeTeam: 'Liverpool', awayTeam: 'Chelsea', venue: 'Old Trafford Stadium', dateTime: DateTime.now()),
    FootballMatch(id: '2', homeTeam: 'Man City', awayTeam: 'Forest', venue: 'Old Trafford Stadium', dateTime: DateTime.now()),
  ];
});