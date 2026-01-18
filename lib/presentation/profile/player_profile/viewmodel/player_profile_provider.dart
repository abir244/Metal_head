import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'player_profile_viewmodel.dart';
import '../model/player_profile_state.dart';

final playerProfileProvider = StateNotifierProvider<
    PlayerProfileViewModel, PlayerProfileState>(
      (ref) => PlayerProfileViewModel(),
);
