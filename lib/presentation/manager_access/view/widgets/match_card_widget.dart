import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:metalheadd/core/constants/app_colors.dart';
import 'package:metalheadd/core/theme/app_text_styles.dart';

import '../../model/match_model.dart';

class MatchCard extends StatelessWidget {
  final MatchModel match;
  const MatchCard({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    final timeText = DateFormat('hh:mm a').format(match.matchDateTime);
    final dateText = DateFormat('dd MMMM yyyy').format(match.matchDateTime);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // 1. Teams Column
          Expanded(
            child: Column(
              children: [
                _TeamRow(name: match.homeTeamName, color: match.homeColor),
                const SizedBox(height: 12),
                _TeamRow(name: match.awayTeamName, color: match.awayColor),
              ],
            ),
          ),
          // 2. Vertical Accent Divider (The Blue Line)
          Container(
            width: 2,
            height: 48,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.textThird,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // 3. Time / Date Column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                timeText.toUpperCase(),
                style: AppTextStyles.body14SemiBold.copyWith(color: AppColors.primary),
              ),
              const SizedBox(height: 4),
              Text(
                dateText,
                style: AppTextStyles.caption12Regular.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TeamRow extends StatelessWidget {
  final String name;
  final int color;
  const _TeamRow({required this.name, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: Color(color),
          child: Text(name[0], style: const TextStyle(fontSize: 10, color: Colors.white)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            name,
            style: AppTextStyles.body14SemiBold.copyWith(color: AppColors.textPrimary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}