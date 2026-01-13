
// match_details/widget/match_tabs.dart
import 'package:flutter/material.dart';
import 'formation_pitch.dart';
import 'formation_selector.dart';
import 'lineup_list.dart';

class MatchTabs extends StatelessWidget {
  final String matchId;
  const MatchTabs({super.key, required this.matchId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            tabs: [
              Tab(text: 'Formation'),
              Tab(text: 'Lineups'),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 500, // give room to TabBarView; adjust based on layout
            child: TabBarView(
              children: [
                // Formation
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      FormationSelector(matchId: matchId),
                      const SizedBox(height: 12),
                      FormationPitch(matchId: matchId),
                    ],
                  ),
                ),
                // Lineups
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: LineupList(matchId: matchId),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
