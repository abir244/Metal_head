import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'; // Required for ScrollDirection
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../home/view/widgets/child_profile_card.dart';
import '../../../home/view/widgets/upcoming_match_card.dart';
import '../../../home/view/widgets/bottom_navbar.dart';
import '../viewlmodel/child_profile_provider.dart';

class ChildProfileScreen extends ConsumerWidget {
  const ChildProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(childProfileProvider);
    final matches = ref.watch(upcomingMatchesProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black, // Root optimization for consistent background
        child: SafeArea(
          child: NotificationListener<UserScrollNotification>(
            onNotification: (notification) {
              // Scroll optimization: Toggle navbar visibility
              if (notification.direction == ScrollDirection.reverse) {
                ref.read(navbarVisibleProvider.notifier).state = false;
              } else if (notification.direction == ScrollDirection.forward) {
                ref.read(navbarVisibleProvider.notifier).state = true;
              }
              return true;
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    "Child Profile",
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // 1. Profile Card
                  ChildProfileCard(child: profile, showTitle: true),

                  // 2. Optimized Info Sections
                  _buildInfoSection("Player Info", [
                    _InfoRow("Full Name", profile.name),
                    _InfoRow("Birthday", profile.birthday),
                    _InfoRow("Primary Position", profile.position, hasIcon: true),
                    _InfoRow("Jersey Number", "#${profile.jersey}"),
                    _InfoRow("Team", profile.team),
                    _InfoRow("Registered On", profile.registeredOn),
                    _StatusRow("Status", profile.status),
                  ]),

                  _buildInfoSection("Parent", [
                    _InfoRow("Parent Name", profile.parent.name),
                    _InfoRow("Email", profile.parent.email),
                    _InfoRow("Phone (optional)", profile.parent.phone),
                  ]),

                  // 3. Upcoming Matches Section
                  if (matches.isNotEmpty) ...[
                    const _SectionTitle("Upcoming Match"),
                    ...matches.map((m) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: UpcomingMatchCard(match: m),
                    )),
                  ],

                  // 4. Optimized Stats Section
                  _buildInfoSection("Performance Stats", [
                    _InfoRow("Matches Played", profile.stats.matches.toString()),
                    _InfoRow("Goals", profile.stats.goals.toString()),
                    _InfoRow("Assists", profile.stats.assists.toString()),
                    _InfoRow("Player of the Match", profile.stats.potm.toString()),
                    _InfoRow("Attendance Rate", profile.stats.attendance),
                  ]),

                  const SizedBox(height: 120), // Space for floating navbar
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Optimized helper to build the Section Title + Card logic
  Widget _buildInfoSection(String title, List<Widget> rows) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title),
        _InfoCard(rows),
      ],
    );
  }
}

// --- Internal Layout Widgets (Stateless for performance) ---

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 24, bottom: 12),
    child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
  );
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;
  const _InfoCard(this.children);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: const Color(0xFF111111), borderRadius: BorderRadius.circular(16)),
    child: Column(children: children),
  );
}

class _InfoRow extends StatelessWidget {
  final String label, value;
  final bool hasIcon;
  const _InfoRow(this.label, this.value, {this.hasIcon = false});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        SizedBox(width: 130, child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13))),
        const Text(":  ", style: TextStyle(color: Colors.grey)),
        Expanded(child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 14))),
        if (hasIcon) const Icon(Icons.sports_soccer, size: 16, color: Colors.white54),
      ],
    ),
  );
}

class _StatusRow extends StatelessWidget {
  final String label, value;
  const _StatusRow(this.label, this.value);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        SizedBox(width: 130, child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13))),
        const Text(":  ", style: TextStyle(color: Colors.grey)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          decoration: BoxDecoration(color: const Color(0xFF002B2B), borderRadius: BorderRadius.circular(20)),
          child: Text(value, style: const TextStyle(color: Colors.tealAccent, fontSize: 11, fontWeight: FontWeight.bold)),
        ),
      ],
    ),
  );
}