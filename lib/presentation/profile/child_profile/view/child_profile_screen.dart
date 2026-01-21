// lib/presentation/child_profile/view/child_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/theme_provider.dart';
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
    final isDarkMode = ref.watch(themeProvider);

    // Dynamic colors based on theme
    final bgColor = isDarkMode ? Colors.black : Colors.grey[100]!;
    final cardColor = isDarkMode ? const Color(0xFF1A1A1A) : Colors.white;
    final titleColor = isDarkMode ? Colors.white : Colors.black87;
    final subtitleColor = isDarkMode ? Colors.white70 : Colors.black54;

    return Scaffold(
      backgroundColor: bgColor,
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
            loading: () => Center(
              child: CircularProgressIndicator(
                color: titleColor,
              ),
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

                    // Screen title
                    Text(
                      "Child Profile",
                      style: TextStyle(
                        color: titleColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Profile Card
                    ChildProfileCard(
                      child: profile,
                      showTitle: true,
                      avatarRadius: 40,
                      fullView: true,
                    ),


                    // Parent Info
                    buildInfoSection(
                      "Parent Info",
                      [
                        InfoRow("Name", profile.parent.name, titleColor, subtitleColor),
                        InfoRow("Email", profile.parent.email, titleColor, subtitleColor),
                        InfoRow("Phone", profile.parent.phone, titleColor, subtitleColor),
                      ],
                      cardColor: cardColor,
                    ),

                    // Performance Stats
                    buildInfoSection(
                      "Performance",
                      [
                        InfoRow("Matches", profile.stats.matches.toString(), titleColor, subtitleColor),
                        InfoRow("Goals", profile.stats.goals.toString(), titleColor, subtitleColor),
                        InfoRow("Assists", profile.stats.assists.toString(), titleColor, subtitleColor),
                        InfoRow("POTM", profile.stats.potm.toString(), titleColor, subtitleColor),
                        InfoRow("Attendance", profile.stats.attendance, titleColor, subtitleColor),
                      ],
                      cardColor: cardColor,
                    ),

                    // Upcoming Matches
                    matchesAsync.when(
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                      data: (matches) {
                        if (matches.isEmpty) return const SizedBox.shrink();
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SectionTitle("Upcoming Matches", titleColor: titleColor),
                            ...matches.map(
                                  (m) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: UpcomingMatchCard(match: m, isDarkMode: isDarkMode),
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

Widget buildInfoSection(String title, List<InfoRow> rows, {required Color cardColor}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SectionTitle(title, titleColor: rows.first.labelColor),
      InfoCard(rows, cardColor: cardColor),
    ],
  );
}

class SectionTitle extends StatelessWidget {
  final String title;
  final Color? titleColor;
  const SectionTitle(this.title, {this.titleColor, super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 24, bottom: 12),
    child: Text(
      title,
      style: TextStyle(
        color: titleColor ?? Theme.of(context).textTheme.titleLarge?.color,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    ),
  );
}

class InfoCard extends StatelessWidget {
  final List<InfoRow> children;
  final Color cardColor;
  const InfoCard(this.children, {required this.cardColor, super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(children: children),
  );
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color labelColor;
  final Color valueColor;

  const InfoRow(
      this.label,
      this.value,
      this.labelColor,
      this.valueColor, {
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
            style: TextStyle(
              color: labelColor,
              fontSize: 13,
            ),
          ),
        ),
        Text(":  ", style: TextStyle(color: labelColor)),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 14,
            ),
          ),
        ),
      ],
    ),
  );
}
