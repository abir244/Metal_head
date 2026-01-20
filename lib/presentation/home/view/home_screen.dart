import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metalheadd/core/route/route_name.dart';

/// FIX 1: Removed 'hide navbarVisibleProvider'.
/// We need this provider to communicate with the MainWrapper.
import 'package:metalheadd/presentation/home/view/widgets/bottom_navbar.dart';

import '../../../core/constants/app_colors.dart' as app_colors;
import '../viewmodel/home_provider.dart' hide navbarVisibleProvider;
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

    /// FIX 2: Removed 'Scaffold'.
    /// Using a Scaffold here creates a new layer that covers the MainWrapper's Navbar.
    /// We use a Column + Expanded to keep the AppBar at the top and body below.
    return Column(
      children: [
        HomeAppBar(
          avatarUrl: _childImageUrl,
          unreadCount: 3,
          onTapNotifications: () => debugPrint('Notifications tapped'),
          onTapProfile: () => Navigator.pushNamed(context, RouteName.PlayerProfile),
        ),
        Expanded(
          child: _buildBody(context, ref, state),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, HomeState state) {
    if (state.loading && state.upcomingMatches.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
    }

    return NotificationListener<UserScrollNotification>(
      onNotification: (notification) {
        /// FIX 3: Corrected the Provider access.
        /// Now that the import is fixed, this correctly hides/shows the navbar in MainWrapper.
        if (notification.direction == ScrollDirection.reverse) {
          if (ref.read(navbarVisibleProvider)) {
            ref.read(navbarVisibleProvider.notifier).state = false;
          }
        } else if (notification.direction == ScrollDirection.forward) {
          if (!ref.read(navbarVisibleProvider)) {
            ref.read(navbarVisibleProvider.notifier).state = true;
          }
        }
        return true;
      },
      child: RefreshIndicator(
        onRefresh: () async => ref.read(homeProvider.notifier).refresh(),
        color: app_colors.AppColors.primary,
        child: SingleChildScrollView(
          key: const PageStorageKey('home_scroll_key'),
          physics: const AlwaysScrollableScrollPhysics(),
          /// FIX 4: Bottom padding (120) is essential.
          /// This ensures that the last item in the list can be scrolled high enough
          /// so it isn't blocked by the floating navbar.
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),
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
                onPressed: () => Navigator.pushNamed(context, RouteName.votingrights),
              ),

              const SizedBox(height: 24),

              if (state.upcomingMatches.isNotEmpty)
                _buildSection(
                  title: "Upcoming Match",
                  child: GestureDetector(
                    onTap: () {
                      final matchId = state.upcomingMatches.first.id;
                      Navigator.pushNamed(context, RouteName.matchdetails, arguments: matchId);
                    },
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: app_colors.AppColors.textWhite,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}