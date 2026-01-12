
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metalheadd/presentation/home/view/widgets/bottom_navbar.dart';
import '../../../core/constants/app_colors.dart' as app_colors;
import '../viewmodel/home_provider.dart';
import 'widgets/home_app_bar.dart';
import 'widgets/child_profile_card.dart';
import 'widgets/upcoming_match_card.dart';
import 'widgets/match_list_view.dart';
import 'widgets/player_of_match_card.dart';
import 'widgets/vote_banner.dart'; // <-- add this import

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeProvider);

    return Scaffold(
      backgroundColor: app_colors.AppColors.background,
      appBar: const HomeAppBar(avatarUrl: ''),
      body: state.loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: () async => ref.read(homeProvider.notifier).refresh(),
        color: app_colors.AppColors.primary,
        backgroundColor: app_colors.AppColors.surface,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
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

              const SizedBox(height: 16),

              // --- Vote banner (CTA) ---
              VoteBanner(
                onPressed: () {
                  // Navigate to your voting route
                  Navigator.pushNamed(context, '/voting');
                },
              ),

              const SizedBox(height: 16),

              if (state.upcomingMatches.isNotEmpty)
                UpcomingMatchCard(match: state.upcomingMatches.first),

              const SizedBox(height: 16),

              // if (state.upcomingMatches.isNotEmpty)
              //   Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         'Players of Match',
              //         style: TextStyle(
              //           fontSize: 16,
              //           fontWeight: FontWeight.w600,
              //           color: app_colors.AppColors.textPrimary,
              //         ),
              //       ),
              //       const SizedBox(height: 8),
              //       const Column(
              //         children: [
              //           // TODO: render PlayerOfMatchCard items here
              //         ],
              //       ),
              //     ],
              //   ),

              const SizedBox(height: 16),

              MatchListView(
                upcomingMatches: state.upcomingMatches,
                matchHistory: state.matchHistory,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
