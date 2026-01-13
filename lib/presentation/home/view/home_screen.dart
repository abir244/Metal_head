// lib/presentation/home/view/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metalheadd/core/route/route_name.dart';
import 'package:metalheadd/presentation/home/view/widgets/bottom_navbar.dart';
import '../../../core/constants/app_colors.dart' as app_colors;
import '../viewmodel/home_provider.dart';
import 'widgets/home_app_bar.dart';
import 'widgets/child_profile_card.dart';
import 'widgets/upcoming_match_card.dart';
import 'widgets/match_list_view.dart';
import 'widgets/vote_banner.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeProvider);

    return Scaffold(
      backgroundColor: app_colors.AppColors.background,
      appBar: const HomeAppBar(avatarUrl: ''),
      body: state.loading
          ? const Center(child: CircularProgressIndicator(color: Colors.blueAccent))
          : RefreshIndicator(
        onRefresh: () async => ref.read(homeProvider.notifier).refresh(),
        color: app_colors.AppColors.primary,
        backgroundColor: app_colors.AppColors.surface,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (state.child != null)
                ChildProfileCard(
                  child: state.child!,
                  showTitle: true,
                  padding: const EdgeInsets.all(12),
                  avatarRadius: 40,
                ),

              const SizedBox(height: 24),

              VoteBanner(
                onPressed: () {
                  // Navigate to Voting (update route name if needed)
                  Navigator.pushNamed(context,RouteName.votingrights);
                },
              ),

              const SizedBox(height: 24),

              if (state.upcomingMatches.isNotEmpty) ...[
                const _SectionLabel(label: "Upcoming Match"),
                const SizedBox(height: 12),
                // --- NAVIGATE FROM UPCOMING CARD ---
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      RouteName.matchdetails, // Your constant
                      arguments: state.upcomingMatches.first.id, // Pass ID
                    );
                  },
                  child: UpcomingMatchCard(
                    match: state.upcomingMatches.first,
                  ),
                ),
              ],

              const SizedBox(height: 24),

              const _SectionLabel(label: "Recent Matches"),
              const SizedBox(height: 12),

              // --- MATCH LIST VIEW ---
              // Inside MatchListView, the individual match items
              // should trigger the same Navigator logic.
              MatchListView(
                upcomingMatches: state.upcomingMatches,
                matchHistory: state.matchHistory,
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
        color: app_colors.AppColors.textPrimary,
      ),
    );
  }
}