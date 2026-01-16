import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../model/match_model.dart';

class MatchResultSection extends StatelessWidget {
  // ID-Free: Pass the whole object to show real team colors
  final MatchModel match;

  const MatchResultSection({super.key, required this.match});

  /// Helper to get initials
  String _getInitials(String name) {
    if (name.isEmpty) return "";
    List<String> parts = name.trim().split(' ');
    if (parts.length > 1) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return name[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Header with Edit Action
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Match Result",
              style: AppTextStyles.heading16SemiBold.copyWith(
                color: AppColors.textWhite,
              ),
            ),
            GestureDetector(
              onTap: () {
                // Logic to open score editor sheet
              },
              child: Text(
                "Edit",
                style: AppTextStyles.body14Medium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // 2. Score Card
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
          decoration: BoxDecoration(
            color: AppColors.surface, // Depth #121212
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.03)),
          ),
          child: Column(
            children: [
              // Team Avatars & Score Display
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Home Team Avatar
                  _buildTeamAvatar(match.homeTeamName, match.homeColor),

                  // Score Text
                  Column(
                    children: [
                      Text(
                        "0 - 0",
                        style: AppTextStyles.heading24Bold.copyWith(
                          fontSize: 32,
                          color: AppColors.primary, // Yellow
                          letterSpacing: 4,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "FT", // Full Time indicator
                        style: AppTextStyles.overline10Medium.copyWith(
                          color: AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),

                  // Away Team Avatar
                  _buildTeamAvatar(match.awayTeamName, match.awayColor),
                ],
              ),

              const SizedBox(height: 24),

              // 3. Stat Row placeholders
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatLabel("Goal Scorer"),
                  _buildStatLabel("Goal Assist"),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTeamAvatar(String name, int colorValue) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(colorValue),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 2),
          ),
          alignment: Alignment.center,
          child: Text(
            _getInitials(name),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatLabel(String label) {
    return Text(
      label,
      style: AppTextStyles.caption12Regular.copyWith(
        color: AppColors.textGrey,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
