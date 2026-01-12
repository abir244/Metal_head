
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../model/match.dart';
import 'match_tab_bar.dart';
import 'match_tile.dart';

class MatchListView extends ConsumerWidget {
  const MatchListView({
    super.key,
    required this.upcomingMatches,
    required this.matchHistory,
  });

  final List<Match> upcomingMatches;
  final List<Match> matchHistory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabIndex = ref.watch(matchTabIndexProvider.select((i) => i));
    final data = tabIndex == 0 ? upcomingMatches : matchHistory;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MatchTabBar(),
        const SizedBox(height: 12),

        // Figma: vertical list, gap = 8, no container stroke around the list itself.
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: data.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, idx) => MatchTile(match: data[idx]),
        ),
      ],
    );
  }
}

