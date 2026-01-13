// match_details/widget/lineup_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/match_details_provider.dart';

class LineupList extends ConsumerWidget {
  final String matchId;
  const LineupList({super.key, required this.matchId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // This ref.watch automatically fetches data specific to the matchId passed
    final matchAsync = ref.watch(matchDetailsProvider(matchId));

    return matchAsync.when(
      loading: () => const Center(child: CircularProgressIndicator(color: Colors.amber)),
      error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.white))),
      data: (m) {
        return Container(
          color: Colors.black, // Background of the whole screen
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. MATCH HEADER CARD
                _buildHeaderCard(m),
                const SizedBox(height: 24),

                // 2. MANAGER SECTION
                const _SectionTitle(title: 'Manager'),
                _SectionCard(
                  child: _PlayerRow(
                    name: m.homeLineup.manager ?? "Emerson Bator",
                    role: "",
                    photo: "https://i.pravatar.cc/150?u=manager",
                  ),
                ),
                const SizedBox(height: 24),

                // 3. FIRST 11 SECTION
                const _SectionTitle(title: 'The first 11 to be on the pitch'),
                _SectionCard(
                  child: Column(
                    children: [
                      // Map your starters from the dynamic data
                      ...m.homeLineup.starters.asMap().entries.map((entry) {
                        int index = entry.key;
                        var starter = entry.value;

                        // Demo: Highlight the second player like the image (Roger Dokidis)
                        bool isHighlighted = index == 1;

                        return _PlayerRow(
                          name: starter.player.name,
                          role: "Forward", // Demo position
                          photo: "https://i.pravatar.cc/150?u=${starter.player.name}",
                          isHighlighted: isHighlighted,
                          showDivider: index != m.homeLineup.starters.length - 1 && !isHighlighted,
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 4. SUBSTITUTES SECTION
                const _SectionTitle(title: 'Substitution players'),
                _SectionCard(
                  child: Column(
                    children: [
                      ...m.homeLineup.substitutes.asMap().entries.map((entry) {
                        return _PlayerRow(
                          name: entry.value.player.name,
                          role: "Midfielder", // Demo position
                          photo: "https://i.pravatar.cc/150?u=${entry.value.player.name}",
                          showDivider: entry.key != m.homeLineup.substitutes.length - 1,
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Header Widget matching the image
  Widget _buildHeaderCard(dynamic m) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTeamHeaderRow(m.home.name, Colors.blue),
                const SizedBox(height: 12),
                _buildTeamHeaderRow(m.away.name, Colors.red),
                const SizedBox(height: 16),
                Text('Old Trafford Stadium', style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12)),
              ],
            ),
          ),
          // The Blue Vertical Bar from image
          Container(width: 2, height: 60, color: Colors.blueAccent),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('06:30 PM', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 16)),
              Text('18 July 2025', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTeamHeaderRow(String name, Color color) {
    return Row(
      children: [
        Icon(Icons.shield, color: color, size: 20),
        const SizedBox(width: 12),
        Text(name, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

// Sub-widgets for cleaner code
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Text(title, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 13)),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(24),
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(24), child: child),
    );
  }
}

class _PlayerRow extends StatelessWidget {
  final String name;
  final String role;
  final String photo;
  final bool isHighlighted;
  final bool showDivider;

  const _PlayerRow({
    required this.name,
    required this.role,
    required this.photo,
    this.isHighlighted = false,
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: isHighlighted
          ? BoxDecoration(
        border: Border.all(color: Colors.amber.withOpacity(0.6), width: 1.5),
        borderRadius: BorderRadius.circular(20),
      )
          : null,
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(radius: 18, backgroundImage: NetworkImage(photo)),
              const SizedBox(width: 12),
              Expanded(child: Text(name, style: const TextStyle(color: Colors.white, fontSize: 15))),
              Text(role, style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 12)),
            ],
          ),
          if (showDivider) Divider(color: Colors.white.withOpacity(0.05), height: 24, indent: 48),
        ],
      ),
    );
  }
}