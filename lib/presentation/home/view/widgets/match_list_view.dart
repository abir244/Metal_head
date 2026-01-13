import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Added for Haptic Feedback
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metalheadd/core/route/route_name.dart';
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
    // Watch the tab index to switch between "Upcoming" and "History"
    final tabIndex = ref.watch(matchTabIndexProvider);
    final data = tabIndex == 0 ? upcomingMatches : matchHistory;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MatchTabBar(),
        const SizedBox(height: 16), // Increased spacing for a more "balanced" look

        // ListView configuration for performance within a scrollable parent
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: data.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10), // Gap between cards
          itemBuilder: (context, idx) {
            final match = data[idx];

            return Material(
              color: Colors.transparent, // Ensures the ripple shows on the MatchTile
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  // 1. Add Haptic Feedback for a premium feel
                  HapticFeedback.lightImpact();

                  // 2. Navigation to Match Details
                  Navigator.pushNamed(
                    context,
                    RouteName.matchdetails,
                    arguments: match.id, // match.id must exist in your model!
                  );
                },
                child: MatchTile(match: match),
              ),
            );
          },
        ),
      ],
    );
  }
}