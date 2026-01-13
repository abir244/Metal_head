
// match_details/viewmodel/formation_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PitchSide { home, away }

/// Formation options exposed to the view
const kFormationOptions = <String>[
  '4-2-3-1',
  '4-3-3',
  '3-5-2',
  '5-4-1',
];

/// Simple coordinate on pitch (0..100 normalized)
class PitchCoord {
  final double x; // 0 left, 100 right
  final double y; // 0 top (home goal), 100 bottom (away goal)
  const PitchCoord(this.x, this.y);
}

/// Holds selected formation for each side
class FormationState {
  final String homeFormation;
  final String awayFormation;
  const FormationState({required this.homeFormation, required this.awayFormation});

  FormationState copyWith({String? homeFormation, String? awayFormation}) {
    return FormationState(
      homeFormation: homeFormation ?? this.homeFormation,
      awayFormation: awayFormation ?? this.awayFormation,
    );
  }
}

/// Public provider for formation state
final formationProvider =
StateNotifierProvider<FormationVM, FormationState>((ref) {
  // Defaults; you can also read from match details and initialize accordingly
  return FormationVM(const FormationState(homeFormation: '4-2-3-1', awayFormation: '5-4-1'));
});

class FormationVM extends StateNotifier<FormationState> {
  FormationVM(super.state);

  void setHomeFormation(String f) => state = state.copyWith(homeFormation: f);
  void setAwayFormation(String f) => state = state.copyWith(awayFormation: f);

  /// Returns 11 normalized positions for a given formation string and side.
  /// You can tweak coordinates to match your exact pitch design.
  List<PitchCoord> positionsFor(String formation, PitchSide side) {
    final base = _formationToCoords(formation);
    // Away team mirrored vertically for a face-off look (optional)
    if (side == PitchSide.away) {
      return base.map((c) => PitchCoord(100 - c.x, 100 - c.y)).toList();
    }
    return base;
  }

  /// Basic presets for popular formations (home orientation top->bottom)
  List<PitchCoord> _formationToCoords(String f) {
    switch (f) {
      case '4-2-3-1':
        return const [
          // GK
          PitchCoord(50, 5),
          // Back 4
          PitchCoord(15, 20), PitchCoord(35, 20), PitchCoord(65, 20), PitchCoord(85, 20),
          // Double pivot
          PitchCoord(35, 40), PitchCoord(65, 40),
          // Attacking 3
          PitchCoord(20, 60), PitchCoord(50, 60), PitchCoord(80, 60),
          // ST
          PitchCoord(50, 85),
        ];
      case '4-3-3':
        return const [
          PitchCoord(50, 5),
          PitchCoord(15, 20), PitchCoord(35, 20), PitchCoord(65, 20), PitchCoord(85, 20),
          PitchCoord(30, 40), PitchCoord(50, 45), PitchCoord(70, 40),
          PitchCoord(15, 70), PitchCoord(50, 80), PitchCoord(85, 70),
        ];
      case '3-5-2':
        return const [
          PitchCoord(50, 5),
          PitchCoord(20, 20), PitchCoord(50, 20), PitchCoord(80, 20),
          PitchCoord(15, 40), PitchCoord(35, 45), PitchCoord(50, 50),
          PitchCoord(65, 45), PitchCoord(85, 40),
          PitchCoord(40, 80), PitchCoord(60, 80),
        ];
      case '5-4-1':
      default:
        return const [
          PitchCoord(50, 5),
          // Back 5
          PitchCoord(10, 20), PitchCoord(30, 22), PitchCoord(50, 22), PitchCoord(70, 22), PitchCoord(90, 20),
          // Mid 4
          PitchCoord(25, 45), PitchCoord(45, 48), PitchCoord(55, 48), PitchCoord(75, 45),
          // Lone ST
          PitchCoord(50, 85),
        ];
    }
  }
}

/// Derived providers to read calculated positions for the currently selected formations
final homePositionsProvider = Provider<List<PitchCoord>>((ref) {
  final f = ref.watch(formationProvider).homeFormation;
  return ref.read(formationProvider.notifier).positionsFor(f, PitchSide.home);
});

final awayPositionsProvider = Provider<List<PitchCoord>>((ref) {
  final f = ref.watch(formationProvider).awayFormation;
  return ref.read(formationProvider.notifier).positionsFor(f, PitchSide.away);
});

