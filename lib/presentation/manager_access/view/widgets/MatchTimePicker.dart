import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

// 1. Point this to the file where your MatchModel is defined
import '../../model/match_model.dart';
import '../../viewmodel/match_timer_provider.dart';

class MatchTimePicker extends ConsumerWidget {
  // 2. Updated to use MatchModel
  final MatchModel match;
  final Function(DateTime)? onTimeChanged;

  const MatchTimePicker({super.key, required this.match, this.onTimeChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(matchTimerProvider);

    // Formatting Logic
    String leftVal;
    String rightVal;
    String label;

    // If match is live, show the stopwatch duration
    if (timerState.isLive || timerState.duration > Duration.zero) {
      label = "Match Time (Live)";
      leftVal = timerState.duration.inMinutes.toString().padLeft(2, '0');
      rightVal = (timerState.duration.inSeconds % 60).toString().padLeft(2, '0');
    }
    // If not live, show the scheduled kickoff time from the model
    else {
      label = "Match Time (Scheduled)";
      // 3. Updated to use match.matchDateTime (per your MatchModel definition)
      leftVal = DateFormat('HH').format(match.matchDateTime);
      rightVal = DateFormat('mm').format(match.matchDateTime);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
                label,
                style: AppTextStyles.heading16SemiBold.copyWith(color: Colors.white)
            ),
            if (timerState.isLive) ...[
              const SizedBox(width: 8),
              _LiveIndicator(),
            ]
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _timeBox(leftVal, timerState.isLive),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(":", style: TextStyle(fontSize: 32, color: Colors.white24)),
            ),
            _timeBox(rightVal, timerState.isLive),
          ],
        )
      ],
    );
  }

  Widget _timeBox(String value, bool isLive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 80,
      height: 75,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isLive ? AppColors.primary : Colors.white10
        ),
      ),
      child: Text(
          value,
          style: AppTextStyles.heading24Bold.copyWith(
              fontSize: 32,
              color: AppColors.primary // Your Yellow
          )
      ),
    );
  }
}

class _LiveIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
          color: AppColors.success, // Using your green theme color
          shape: BoxShape.circle
      ),
    );
  }
}