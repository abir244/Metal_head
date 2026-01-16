import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../model/match_model.dart';

/// Renamed to ManagerMatchHeader to avoid naming conflicts
class ManagerMatchHeader extends StatelessWidget {
  final MatchModel match;

  const ManagerMatchHeader({super.key, required this.match});

  /// Helper to get initials (e.g. "Liverpool" -> "L", "Man City" -> "MC")
  String _getInitials(String name) {
    List<String> parts = name.trim().split(' ');
    if (parts.length > 1 && parts[1].isNotEmpty) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : "";
  }

  @override
  Widget build(BuildContext context) {
    final timeText = DateFormat('hh:mm a').format(match.matchDateTime);
    final dateText = DateFormat('dd MMMM yyyy').format(match.matchDateTime);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.03)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _teamRow(match.homeTeamName, match.homeColor),
                    const SizedBox(height: 14),
                    _teamRow(match.awayTeamName, match.awayColor),
                  ],
                ),
              ),

              // The Blue Accent Line
              Container(
                width: 2.5,
                height: 52,
                margin: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  color: AppColors.textThird,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.textThird.withOpacity(0.4),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),

              // Time and Date
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    timeText.toUpperCase(),
                    style: AppTextStyles.body14SemiBold.copyWith(
                      color: AppColors.primary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateText,
                    style: AppTextStyles.caption12Regular.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.only(left: 6),
          child: Text(
            match.stadium,
            style: AppTextStyles.caption12Regular.copyWith(
              color: AppColors.textSecondary.withOpacity(0.8),
              letterSpacing: 0.2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _teamRow(String name, int color) {
    return Row(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: Color(color),
          child: Text(
            _getInitials(name),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body14SemiBold.copyWith(
              color: AppColors.textWhite,
            ),
          ),
        ),
      ],
    );
  }
}