import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../model/match_model.dart';
// 1. Point this to the file where your MatchModel is defined


class ManagerMatchHeader extends StatelessWidget {
  // 2. Updated type to MatchModel
  final MatchModel match;

  const ManagerMatchHeader({super.key, required this.match});

  /// Helper to get initials (e.g. "Manchester City" -> "MC")
  String _getInitials(String name) {
    if (name.isEmpty) return "";
    List<String> parts = name.trim().split(' ');
    if (parts.length > 1 && parts[1].isNotEmpty) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return name[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    // 3. Updated property names to match your MatchModel (matchDateTime)
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
              // Team Names and Real Colors
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 4. Using homeTeamName and homeColor from model
                    _buildTeamRow(match.homeTeamName, match.homeColor),
                    const SizedBox(height: 14),
                    // 5. Using awayTeamName and awayColor from model
                    _buildTeamRow(match.awayTeamName, match.awayColor),
                  ],
                ),
              ),

              // Decorative Blue Divider
              Container(
                width: 2.5,
                height: 52,
                margin: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  color: AppColors.textThird,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              // Time and Date Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    timeText.toUpperCase(),
                    style: AppTextStyles.body14SemiBold.copyWith(
                      color: AppColors.primary, // Your Yellow
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
        // Stadium Footer
        Padding(
          padding: const EdgeInsets.only(left: 6),
          child: Row(
            children: [
              Icon(
                  Icons.location_on_outlined,
                  size: 14,
                  color: AppColors.textSecondary.withOpacity(0.6)
              ),
              const SizedBox(width: 4),
              Text(
                match.stadium,
                style: AppTextStyles.caption12Regular.copyWith(
                  color: AppColors.textSecondary.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Helper to build the team row using the model's integer color
  Widget _buildTeamRow(String name, int colorValue) {
    return Row(
      children: [
        CircleAvatar(
          radius: 14,
          // 6. Convert the integer colorValue to a Flutter Color object
          backgroundColor: Color(colorValue),
          child: Text(
            _getInitials(name),
            style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold
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