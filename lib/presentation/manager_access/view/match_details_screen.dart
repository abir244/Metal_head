import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metalheadd/core/theme/app_text_styles.dart';
import 'package:metalheadd/core/constants/app_colors.dart';

// Model & ViewModel
import '../model/match_model.dart';
import '../viewmodel/match_timer_provider.dart';

// Widgets
import 'widgets/VotingPlayerListButton.dart';
import 'widgets/MatchResultSection.dart';
import 'widgets/MatchTimePicker.dart';
import 'widgets/StartButton.dart';
import 'widgets/header.dart';

class MatchDetailsScreen extends ConsumerWidget {
  final MatchModel match;

  const MatchDetailsScreen({super.key, required this.match});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(matchTimerProvider);

    return WillPopScope(
      onWillPop: () async {
        // ✅ This screen is pushed → just pop
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(context),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              /// ===============================
              /// HEADER
              /// ===============================
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: ManagerMatchHeader(match: match),
              ),

              const SizedBox(height: 12),

              /// ===============================
              /// MANAGEMENT DASHBOARD
              /// ===============================
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.05),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionLabel("Management Dashboard"),
                    const SizedBox(height: 24),

                    /// PLAYER LIST
                    const VotingPlayerListButton(),

                    const _CustomDivider(),

                    /// SCORE
                    MatchResultSection(match: match),

                    const _CustomDivider(),

                    /// TIMER
                    MatchTimePicker(
                      match: match,
                      onTimeChanged: (newTime) {
                        debugPrint("Time updated: $newTime");
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// ===============================
              /// START / PAUSE BUTTON
              /// ===============================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    MatchStartButton(
                      onPressed: () {
                        ref
                            .read(matchTimerProvider.notifier)
                            .toggleTimer();

                        debugPrint(
                          "Match toggled: ${match.homeTeamName}",
                        );
                      },
                    ),

                    if (timerState.isLive) ...[
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _LiveDot(),
                          const SizedBox(width: 8),
                          Text(
                            "MATCH IS CURRENTLY LIVE",
                            style: AppTextStyles.overline10Medium.copyWith(
                              color: AppColors.success,
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  /// ===============================
  /// APP BAR
  /// ===============================
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
          size: 20,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        'Manager Access',
        style: AppTextStyles.heading18SemiBold.copyWith(
          color: Colors.white,
          letterSpacing: -0.5,
        ),
      ),
    );
  }

  /// ===============================
  /// SECTION LABEL
  /// ===============================
  Widget _buildSectionLabel(String text) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 12,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text.toUpperCase(),
          style: AppTextStyles.overline10Medium.copyWith(
            color: AppColors.textPrimary,
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

/// ===============================
/// DIVIDER
/// ===============================
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

/// ===============================
/// LIVE DOT
/// ===============================
class _LiveDot extends StatefulWidget {
  @override
  State<_LiveDot> createState() => _LiveDotState();
}

class _LiveDotState extends State<_LiveDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: AppColors.success,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
