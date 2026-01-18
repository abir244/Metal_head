import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
// 1. Point this to your MatchModel file
import '../../model/match_model.dart';

class MatchResultSection extends StatelessWidget {
  // 2. Changed type to MatchModel to match your main screen
  final MatchModel match;

  const MatchResultSection({super.key, required this.match});

  /// Helper to get initials (e.g., "Messi" -> "M")
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
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.03)),
          ),
          child: Column(
            children: [
              // Team Avatars & Score Display
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 3. Home Team Avatar using Real Color from Model
                  _buildTeamAvatar(match.homeTeamName, match.homeColor),

                  // Score Text (Now Dynamic)
                  Column(
                    children: [
                      Text(
                        "${match.homeScore ?? 0} - ${match.awayScore ?? 0}",
                        style: AppTextStyles.heading24Bold.copyWith(
                          fontSize: 32,
                          color: AppColors.primary, // Yellow
                          letterSpacing: 4,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "LIVE",
                        style: AppTextStyles.overline10Medium.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  // 4. Away Team Avatar using Real Color from Model
                  _buildTeamAvatar(match.awayTeamName, match.awayColor),
                ],
              ),

              const SizedBox(height: 24),

              // Stat Row placeholders
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
            color: Color(colorValue), // Uses the int color from MatchModel
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
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}