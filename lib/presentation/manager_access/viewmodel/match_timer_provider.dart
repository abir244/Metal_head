import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MatchTimerState {
  final Duration duration;
  final bool isLive;

  MatchTimerState({required this.duration, required this.isLive});

  MatchTimerState copyWith({Duration? duration, bool? isLive}) {
    return MatchTimerState(
      duration: duration ?? this.duration,
      isLive: isLive ?? this.isLive,
    );
  }
}

class MatchTimerNotifier extends StateNotifier<MatchTimerState> {
  MatchTimerNotifier() : super(MatchTimerState(duration: Duration.zero, isLive: false));

  Timer? _timer;

  void toggleTimer() {
    if (state.isLive) {
      _timer?.cancel();
      state = state.copyWith(isLive: false);
    } else {
      state = state.copyWith(isLive: true);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        state = state.copyWith(duration: state.duration + const Duration(seconds: 1));
      });
    }
  }

  void reset() {
    _timer?.cancel();
    state = MatchTimerState(duration: Duration.zero, isLive: false);
  }
}

final matchTimerProvider = StateNotifierProvider<MatchTimerNotifier, MatchTimerState>((ref) {
  return MatchTimerNotifier();
});