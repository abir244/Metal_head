import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
// import 'match_timer_provider.dart'; // Ensure this is imported

class MatchStartButton extends ConsumerWidget {
  // 1. You MUST have this parameter defined
  final VoidCallback? onPressed;

  const MatchStartButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Check if match is live to change UI color/text
    // final timerState = ref.watch(matchTimerProvider);
    // final isLive = timerState.isLive;
    const isLive = false; // Placeholder until provider is linked

    return Center(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed, // 2. Trigger the callback here
          borderRadius: BorderRadius.circular(100),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
            decoration: BoxDecoration(
              color: isLive ? AppColors.success : AppColors.primary,
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                  color: (isLive ? AppColors.success : AppColors.primary).withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isLive ? "MATCH LIVE" : "MATCH START",
                  style: AppTextStyles.button16SemiBold.copyWith(
                    color: isLive ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  isLive ? Icons.sensors_rounded : Icons.play_circle_filled_rounded,
                  color: isLive ? Colors.white : Colors.black,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}