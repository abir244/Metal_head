import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metalheadd/core/theme/app_text_styles.dart';
import 'package:metalheadd/core/constants/app_colors.dart';
import 'package:metalheadd/presentation/manager_access/model/match_model.dart';

// Widget Imports
import 'package:metalheadd/presentation/manager_access/view/widgets/MatchResultSection.dart';
import 'package:metalheadd/presentation/manager_access/view/widgets/MatchTimePicker.dart';
import 'package:metalheadd/presentation/manager_access/view/widgets/StartButton.dart';
import 'package:metalheadd/presentation/manager_access/view/widgets/VotingPlayerListButton.dart';
import 'package:metalheadd/presentation/manager_access/view/widgets/header.dart';

import '../viewmodel/match_timer_provider.dart';

class MatchDetailsScreen extends ConsumerWidget {
  final MatchModel match;

  const MatchDetailsScreen({super.key, required this.match});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the timer state to update UI reactively
    final timerState = ref.watch(matchTimerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // 1. Top Hero Card (Header)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: ManagerMatchHeader(match: match),
            ),

            const SizedBox(height: 12),

            // 2. Main Smooth Management Dashboard
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface, // Depth #121212
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: Colors.white.withOpacity(0.05),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionLabel("Management Dashboard"),
                  const SizedBox(height: 24),

                  // Player List Action
                  const VotingPlayerListButton(),

                  const _CustomDivider(),

                  // Dynamic Result Tracking
                  MatchResultSection(match: match),

                  const _CustomDivider(),

                  // Interactive / Workable Timer Display
                  // This will show counting time automatically via Riverpod internal watch
                  MatchTimePicker(
                    match: match,
                    onTimeChanged: (newTime) {
                      debugPrint("Time updated to: $newTime");
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 3. Main Action Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: MatchStartButton(
                onPressed: () {
                  // WORKABLE: Toggles the timer start/stop
                  ref.read(matchTimerProvider.notifier).toggleTimer();
                  debugPrint("Match Status Toggled: ${match.homeTeamName}");
                },
              ),
            ),

            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  // Helper for Section Labels
  Widget _buildSectionLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: AppTextStyles.overline10Medium.copyWith(
        color: AppColors.primary,
        letterSpacing: 1.5,
        fontWeight: FontWeight.bold,
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
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        'Manager Access',
        style: AppTextStyles.heading18SemiBold.copyWith(color: Colors.white),
      ),
    );
  }
}

class _CustomDivider extends StatelessWidget {
  const _CustomDivider();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Divider(
        color: Colors.white.withOpacity(0.05),
        thickness: 1,
      ),
    );
  }
}