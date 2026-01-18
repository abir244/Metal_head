import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/player_profile_state.dart';

class PlayerProfileViewModel
    extends StateNotifier<PlayerProfileState> {
  PlayerProfileViewModel()
      : super(const PlayerProfileState(loading: true)) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    state = state.copyWith(
      loading: false,
      name: 'Cristiano Ronaldo',
      position: 'Forward',
      avatarUrl:
      'https://qz.com/cdn-cgi/image/width=1920,quality=85,format=auto/https://assets.qz.com/media/331423b12c7445264e9346deb167c3de.jpg',
      matches: 120,
      goals: 95,
      assists: 40,
    );
  }
}
