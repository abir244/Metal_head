// lib/presentation/home/view/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metalheadd/presentation/home/view/widgets/home_app_bar.dart';
import 'package:metalheadd/presentation/home/view/widgets/match_list_view.dart';
import 'package:metalheadd/presentation/home/view/widgets/vote_banner.dart';
import '../../../core/constants/app_colors.dart' as app_colors;
import '../../../core/theme/theme_provider.dart';
import '../../home/view/widgets/bottom_navbar.dart';
import '../../home/view/widgets/child_profile_card.dart';
import '../../home/view/widgets/upcoming_match_card.dart';
import '../viewmodel/home_provider.dart' hide navbarVisibleProvider;
import '../viewmodel/home_state.dart';
import '../../../core/route/route_name.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const String _childImageUrl =
      'https://www.planetsport.com/image-library/land/1200/k/kylian-mbappe-psg-france-3-april-2022.webp';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeProvider);
    final isDarkMode = ref.watch(themeProvider); // ✅ move outside widget tree

    return Column(
      children: [
        /// Home App Bar
        HomeAppBar(
          avatarUrl: _childImageUrl,
          unreadCount: 3,
          onTapNotifications: () => debugPrint('Notifications tapped'),
          onTapProfile: () =>
              Navigator.pushNamed(context, RouteName.PlayerProfile),
        ),

        Expanded(
          child: NotificationListener<UserScrollNotification>(
            onNotification: (notification) {
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
              onRefresh: () async =>
                  ref.read(homeProvider.notifier).refresh(),
              color: app_colors.AppColors.primary,
              child: SingleChildScrollView(
                key: const PageStorageKey('home_scroll_key'),
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// CHILD PROFILE
                    if (state.child != null)
                      ChildProfileCard(
                        child: state.child!,
                        showTitle: true,
                        avatarRadius: 40,
                        fullView: true,
                      ),

                    const SizedBox(height: 24),

                    /// VOTE BANNER
                    VoteBanner(
                      onPressed: () =>
                          Navigator.pushNamed(context, RouteName.votingrights),
                    ),

                    const SizedBox(height: 24),

                    /// UPCOMING MATCH
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
                            isDarkMode: isDarkMode, // ✅ dark mode support
                          ),
                        ),
                      ),

                    const SizedBox(height: 24),

                    /// RECENT MATCHES
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
          ),
        ),
      ],
    );
  }

  /// SECTION BUILDER
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
