import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metalheadd/core/route/route_name.dart';
import 'package:metalheadd/presentation/home/view/widgets/bottom_navbar.dart'
    hide navbarVisibleProvider;

import '../../../core/constants/app_colors.dart' as app_colors;
import '../model/child_profile.dart';
import '../viewmodel/home_provider.dart';
import '../viewmodel/home_state.dart';
import 'widgets/home_app_bar.dart';
import 'widgets/child_profile_card.dart';
import 'widgets/upcoming_match_card.dart';
import 'widgets/match_list_view.dart';
import 'widgets/vote_banner.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const String _childImageUrl =
      'https://www.planetsport.com/image-library/land/1200/k/kylian-mbappe-psg-france-3-april-2022.webp';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeProvider);

    return Scaffold(
      backgroundColor: app_colors.AppColors.background,
      appBar: const HomeAppBar(
        avatarUrl: _childImageUrl,
      ),
      body: _buildBody(context, ref, state),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, HomeState state) {
    // Initial loading (no data yet)
    if (state.loading && state.upcomingMatches.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.blueAccent),
      );
    }

    return NotificationListener<UserScrollNotification>(
      onNotification: (notification) {
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
          key: const PageStorageKey('home_scroll_key'),
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (state.child != null)
                ChildProfileCard(
                  child: state.child!, // ✅ USE EXISTING MODEL
                  showTitle: true,
                  padding: const EdgeInsets.all(12),
                  avatarRadius: 40,
                ),



              const SizedBox(height: 24),

              VoteBanner(
                onPressed: () =>
                    Navigator.pushNamed(context, RouteName.votingrights),
              ),

              const SizedBox(height: 24),

              if (state.upcomingMatches.isNotEmpty)
                _buildSection(
                  title: "Upcoming Match",
                  child: GestureDetector(
                    onTap: () {
                      final matchId = state.upcomingMatches.first.id;
                      Navigator.pushNamed(
                        context,
                        RouteName.matchdetails,
                        arguments: matchId,
                      );
                    },
                    child: UpcomingMatchCard(
                      match: state.upcomingMatches.first,
                    ),
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

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: app_colors.AppColors.textWhite,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}
