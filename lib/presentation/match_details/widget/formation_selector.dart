
// match_details/widget/formation_selector.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/formation_provider.dart';
import '../viewmodel/match_details_provider.dart';

class FormationSelector extends ConsumerWidget {
  final String matchId;
  const FormationSelector({super.key, required this.matchId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchAsync = ref.watch(matchDetailsProvider(matchId));
    final formationState = ref.watch(formationProvider);

    return matchAsync.maybeWhen(
      data: (m) {
        // If you prefer initializing formations based on match data:
        // ref.read(formationProvider.notifier).setHomeFormation(m.homeLineup.formation);
        // ref.read(formationProvider.notifier).setAwayFormation(m.awayLineup.formation);
        return Row(
          children: [
            _FormationDropdown(
              label: '${m.home.shortName} Formation',
              value: formationState.homeFormation,
              onChanged: (f) => ref.read(formationProvider.notifier).setHomeFormation(f),
            ),
            const Spacer(),
            _FormationDropdown(
              label: '${m.away.shortName} Formation',
              value: formationState.awayFormation,
              onChanged: (f) => ref.read(formationProvider.notifier).setAwayFormation(f),
            ),
          ],
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _FormationDropdown extends StatelessWidget {
  final String label;
  final String value;
  final ValueChanged<String> onChanged;
  const _FormationDropdown({required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        const SizedBox(width: 8),
        DropdownButton<String>(
          value: value,
          dropdownColor: const Color(0xFF2A2A2A),
          style: const TextStyle(color: Colors.white),
          items: kFormationOptions
              .map((f) => DropdownMenuItem(value: f, child: Text(f)))
              .toList(),
          onChanged: (f) {
            if (f != null) onChanged(f);
          },
        ),
      ],
    );
  }
}
