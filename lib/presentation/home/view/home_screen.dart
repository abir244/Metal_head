// lib/presentation/home/view/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: app_colors.AppColors.background, // Root Container optimization
        child: state.loading
            ? const Center(child: CircularProgressIndicator(color: Colors.blueAccent))
            : NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            // Optimization: Handle Navbar Visibility logic
            if (notification.direction == ScrollDirection.reverse) {
              ref.read(navbarVisibleProvider.notifier).state = false;
            } else if (notification.direction == ScrollDirection.forward) {
              ref.read(navbarVisibleProvider.notifier).state = true;
            }
            return true;
          },
          child: RefreshIndicator(
            onRefresh: () async => ref.read(homeProvider.notifier).refresh(),
            color: app_colors.AppColors.primary,
            backgroundColor: app_colors.AppColors.surface,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Optimized Profile Card Block
                  if (state.child != null)
                    ChildProfileCard(
                      child: state.child!,
                      showTitle: true,
                      padding: const EdgeInsets.all(12),
                      avatarRadius: 40,
                    ),

                  const SizedBox(height: 24),

                  // 2. Interactive Banner
                  VoteBanner(
                    onPressed: () => Navigator.pushNamed(context, RouteName.votingrights),
                  ),

                  const SizedBox(height: 24),

                  // 3. Optimized Sections using Helper
                  if (state.upcomingMatches.isNotEmpty)
                    _buildSection(
                      title: "Upcoming Match",
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          RouteName.matchdetails,
                          arguments: state.upcomingMatches.first.id,
                        ),
                        child: UpcomingMatchCard(match: state.upcomingMatches.first),
                      ),
                    ),

                  const SizedBox(height: 24),

                  _buildSection(
                    title: "Recent Matches",
                    child: MatchListView(
                      upcomingMatches: state.upcomingMatches,
                      matchHistory: state.matchHistory,
                    ),
                  ),

                  // Safe area padding for the fixed floating navbar
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Optimized Section Builder to reduce code duplication
  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: app_colors.AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}