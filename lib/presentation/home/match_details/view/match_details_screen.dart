import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../match_details/viewmodel/match_details_provider.dart';
import '../../../match_details/widget/formation_pitch.dart';
import '../../../match_details/widget/match_header.dart';


class MatchDetailsScreen extends ConsumerWidget {
  final String matchId;
  const MatchDetailsScreen({super.key, required this.matchId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchAsync = ref.watch(matchDetailsProvider(matchId));

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFF0F0F0F),
        body: matchAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: Colors.blueAccent),
          ),
          error: (err, stack) => Center(
            child: Text(
              'Error: $err',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          data: (match) {
            // --- DATA SAFETY CHECK ---
            // If your model is different, change these 3 lines to match your properties:
            // Often it's match.home.name or match.homeLineup.team.name
            final String homeName = _getHomeName(match);
            final String awayName = _getAwayName(match);
            final String score =
                "${match.homeScore ?? 0} - ${match.awayScore ?? 0}";

            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 280,
                    pinned: true,
                    stretch: true,
                    backgroundColor: const Color(0xFF181818),
                    leading: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 20,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    title: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: innerBoxIsScrolled ? 1.0 : 0.0,
                      child: Text(
                        "$homeName $score $awayName",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      background: MatchHeader(matchId: matchId),
                      stretchModes: const [StretchMode.zoomBackground],
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _StickyTabBarDelegate(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFF181818),
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.white10,
                              width: 0.5,
                            ),
                          ),
                        ),
                        child: const TabBar(
                          indicatorColor: Colors.blueAccent,
                          indicatorWeight: 3,
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.grey,
                          tabs: [
                            Tab(text: 'Lineups'),
                            Tab(text: 'Stats'),
                            Tab(text: 'H2H'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ];
              },
              body: TabBarView(
                children: [
                  _buildLineupsTab(match, homeName, awayName),
                  _buildStatsTab(match),
                  const Center(
                    child: Text(
                      'H2H Content',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Helper to extract Home Name safely
  String _getHomeName(dynamic match) {
    try {
      // Try common paths. Update this to match your actual model!
      return match.home?.name ?? match.homeLineup?.team?.name ?? "Home";
    } catch (_) {
      return "Home";
    }
  }

  String _getAwayName(dynamic match) {
    try {
      return match.away?.name ?? match.awayLineup?.team?.name ?? "Away";
    } catch (_) {
      return "Away";
    }
  }

  Widget _buildLineupsTab(dynamic match, String homeName, String awayName) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const SizedBox(height: 12),
        FormationPitch(matchId: matchId), // Visual Pitch
        const SizedBox(height: 20),

        _SectionHeader(title: 'Substitutes: $homeName'),
        if (match.homeLineup?.substitutes != null)
          ...match.homeLineup.substitutes.map(
            (s) => _PlayerRow(player: s.player),
          ),

        const SizedBox(height: 16),

        _SectionHeader(title: 'Substitutes: $awayName'),
        if (match.awayLineup?.substitutes != null)
          ...match.awayLineup.substitutes.map(
            (s) => _PlayerRow(player: s.player),
          ),

        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildStatsTab(dynamic match) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: const [
        _StatBar(
          label: 'Ball Possession',
          home: '55%',
          away: '45%',
          progress: 0.55,
        ),
        _StatBar(
          label: 'Shots on Target',
          home: '4',
          away: '2',
          progress: 0.66,
        ),
        _StatBar(label: 'Corner Kicks', home: '7', away: '3', progress: 0.7),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.white.withOpacity(0.03),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _PlayerRow extends StatelessWidget {
  final dynamic player;
  const _PlayerRow({required this.player});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: Text(
        '${player.shirtNumber ?? ""}',
        style: const TextStyle(color: Colors.blueAccent),
      ),
      title: Text(
        player.name ?? "Unknown",
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }
}

class _StatBar extends StatelessWidget {
  final String label, home, away;
  final double progress;
  const _StatBar({
    required this.label,
    required this.home,
    required this.away,
    required this.progress,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                home,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text(
                away,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: Colors.redAccent,
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
    );
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _StickyTabBarDelegate({required this.child});
  @override
  double get minExtent => 48;
  @override
  double get maxExtent => 48;
  @override
  Widget build(context, offset, overlaps) => child;
  @override
  bool shouldRebuild(old) => false;
}
