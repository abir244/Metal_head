import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metalheadd/core/constants/app_colors.dart';
import 'package:metalheadd/core/theme/app_text_styles.dart';

import '../../home/view/widgets/bottom_navbar.dart';
import '../../manager_access/view/match_details_screen.dart';

import '../model/match_model.dart';
import '../viewmodel/match_list_viewmodel.dart';
import 'widgets/match_card_widget.dart';
import 'widgets/stadium_text_widget.dart';

class ManagerAccessScreen extends ConsumerWidget {
  const ManagerAccessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchesAsync = ref.watch(matchListProvider);

    return WillPopScope(
      onWillPop: () async {
        // Go back to Home tab instead of popping route
        ref.read(navigationProvider.notifier).updateIndex(0);
        ref.read(navbarVisibleProvider.notifier).state = true;
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(context, ref),
        body: matchesAsync.when(
          data: (list) => list.isEmpty
              ? const _EmptyView()
              : _buildMainContent(context, ref, list),
          loading: () => const _LoadingView(),
          error: (e, _) => _ErrorView(
            error: e.toString(),
            onRetry: () =>
                ref.read(matchListProvider.notifier).refresh(),
          ),
        ),
      ),
    );
  }

  /// ===============================
  /// MAIN CONTENT
  /// ===============================
  Widget _buildMainContent(
      BuildContext context,
      WidgetRef ref,
      List<MatchModel> list,
      ) {
    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: AppColors.surface,
      onRefresh: () async =>
          ref.read(matchListProvider.notifier).refresh(),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: _SectionHeader(
              title: 'Match Management',
              count: list.length,
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return _ManagedMatchTile(match: list[index]);
                },
                childCount: list.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ===============================
  /// APP BAR
  /// ===============================
  PreferredSizeWidget _buildAppBar(
      BuildContext context, WidgetRef ref) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: AppColors.textPrimary,
          size: 20,
        ),
        onPressed: () {
          ref.read(navigationProvider.notifier).updateIndex(0);
          ref.read(navbarVisibleProvider.notifier).state = true;
        },
      ),
      title: Text(
        'Manager Hub',
        style: AppTextStyles.heading18SemiBold.copyWith(
          color: AppColors.textPrimary,
          letterSpacing: -0.5,
        ),
      ),
    );
  }
}

/// ===============================
/// SECTION HEADER
/// ===============================
class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;
  const _SectionHeader({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 3,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title.toUpperCase(),
                style: AppTextStyles.overline10Medium.copyWith(
                  color: AppColors.textPrimary,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Text(
              '$count Matches',
              style: AppTextStyles.label12Medium
                  .copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

/// ===============================
/// MATCH TILE
/// ===============================
class _ManagedMatchTile extends StatelessWidget {
  final MatchModel match;
  const _ManagedMatchTile({required this.match});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MatchDetailsScreen(match: match),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.03)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MatchCard(match: match),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: StadiumText(match.stadium)),
                    Row(
                      children: [
                        Text(
                          'Manage',
                          style: AppTextStyles.label12Medium.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          size: 14,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ===============================
/// STATE VIEWS
/// ===============================
class _LoadingView extends StatelessWidget {
  const _LoadingView();
  @override
  Widget build(BuildContext context) => const Center(
    child: CircularProgressIndicator(
      color: AppColors.primary,
      strokeWidth: 2,
    ),
  );
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();
  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.event_busy_rounded,
            size: 48, color: Colors.white.withOpacity(0.1)),
        const SizedBox(height: 16),
        Text(
          'No scheduled matches',
          style: AppTextStyles.body14Regular
              .copyWith(color: AppColors.textSecondary),
        ),
      ],
    ),
  );
}

class _ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;
  const _ErrorView({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded,
                color: AppColors.danger, size: 40),
            const SizedBox(height: 16),
            Text(
              'Failed to load matches',
              style: AppTextStyles.heading16SemiBold
                  .copyWith(color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption12Regular
                  .copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 140,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surface,
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(
                      color: AppColors.primary, width: 0.5),
                ),
                onPressed: onRetry,
                child: const Text('Try Again'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
