import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metalheadd/core/constants/app_colors.dart';
import 'package:metalheadd/core/theme/app_text_styles.dart';

// Update this import to point to YOUR manager-side details screen
// (The one that accepts MatchModel match)
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

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionHeader(title: 'Match List Management'),
            Expanded(
              child: matchesAsync.when(
                data: (list) => list.isEmpty
                    ? const _EmptyView()
                    : _MatchListView(list: list),
                loading: () => const _LoadingView(),
                error: (e, _) => _ErrorView(
                  error: e.toString(),
                  onRetry: () => ref.read(matchListProvider.notifier).refresh(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary, size: 20),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      title: Text(
        'Manager Access',
        style: AppTextStyles.heading18SemiBold.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Text(
        title,
        style: AppTextStyles.heading16SemiBold.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

class _MatchListView extends StatelessWidget {
  final List<MatchModel> list;
  const _MatchListView({required this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: list.length,
      separatorBuilder: (_, __) => const SizedBox(height: 24),
      itemBuilder: (context, index) {
        final match = list[index];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FIXED: Passing the object directly (No IDs)
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MatchDetailsScreen(match: match),
                  ),
                );
              },
              child: MatchCard(match: match),
            ),
            const SizedBox(height: 8),
            StadiumText(match.stadium),
          ],
        );
      },
    );
  }
}

// -----------------------------
// LOADING, EMPTY, ERROR VIEWS
// -----------------------------

class _LoadingView extends StatelessWidget {
  const _LoadingView();
  @override
  Widget build(BuildContext context) => const Center(child: CircularProgressIndicator(color: AppColors.primary));
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();
  @override
  Widget build(BuildContext context) => Center(child: Text('No matches yet', style: AppTextStyles.body14Regular.copyWith(color: AppColors.textSecondary)));
}

class _ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;
  const _ErrorView({required this.error, required this.onRetry});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Error loading matches', style: TextStyle(color: AppColors.danger)),
          const SizedBox(height: 12),
          TextButton(onPressed: onRetry, child: const Text("Retry")),
        ],
      ),
    );
  }
}