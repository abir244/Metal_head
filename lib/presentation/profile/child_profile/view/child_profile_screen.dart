import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../home/view/widgets/child_profile_card.dart';
import '../../../home/view/widgets/upcoming_match_card.dart';
import '../../../home/view/widgets/bottom_navbar.dart';
import '../../../home/viewmodel/upcoming_matches_provider.dart';
import '../viewlmodel/child_profile_provider.dart';

class ChildProfileScreen extends ConsumerWidget {
  const ChildProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(childProfileProvider);
    final matchesAsync = ref.watch(upcomingMatchesProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            if (notification.direction == ScrollDirection.reverse) {
              ref.read(navbarVisibleProvider.notifier).state = false;
            } else if (notification.direction == ScrollDirection.forward) {
              ref.read(navbarVisibleProvider.notifier).state = true;
            }
            return true;
          },
          child: profileAsync.when(
            loading: () => const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
            error: (e, _) => Center(
              child: Text(
                'Failed to load profile\n$e',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
            data: (profile) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    const Text(
                      "Child Profile",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// PROFILE CARD
                    ChildProfileCard(
                      child: profile,
                      showTitle: true,
                      avatarRadius: 40,
                      fullView: true,
                    ),

                    /// PARENT INFO
                    buildInfoSection("Parent Info", [
                      InfoRow("Name", profile.parent.name),
                      InfoRow("Email", profile.parent.email),
                      InfoRow("Phone", profile.parent.phone),
                    ]),

                    /// PERFORMANCE STATS
                    buildInfoSection("Performance", [
                      InfoRow("Matches", profile.stats.matches.toString()),
                      InfoRow("Goals", profile.stats.goals.toString()),
                      InfoRow("Assists", profile.stats.assists.toString()),
                      InfoRow("POTM", profile.stats.potm.toString()),
                      InfoRow("Attendance", profile.stats.attendance),
                    ]),

                    /// UPCOMING MATCHES
                    matchesAsync.when(
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                      data: (matches) {
                        if (matches.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SectionTitle("Upcoming Matches"),
                            ...matches.map(
                                  (m) => Padding(
                                padding:
                                const EdgeInsets.only(bottom: 12),
                                child: UpcomingMatchCard(match: m),
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 120),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

//
// =======================
// REUSABLE UI COMPONENTS
// =======================
//

Widget buildInfoSection(String title, List<Widget> rows) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SectionTitle(title),
      InfoCard(rows),
    ],
  );
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 24, bottom: 12),
    child: Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

class InfoCard extends StatelessWidget {
  final List<Widget> children;
  const InfoCard(this.children, {super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFF111111),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(children: children),
  );
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool hasIcon;

  const InfoRow(
      this.label,
      this.value, {
        this.hasIcon = false,
        super.key,
      });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        SizedBox(
          width: 130,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
        ),
        const Text(":  ", style: TextStyle(color: Colors.grey)),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
        if (hasIcon)
          const Icon(
            Icons.sports_soccer,
            size: 16,
            color: Colors.white54,
          ),
      ],
    ),
  );
}
