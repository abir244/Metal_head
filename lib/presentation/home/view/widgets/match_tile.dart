import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../model/match.dart';

class MatchTile extends StatelessWidget {
  const MatchTile({
    super.key,
    required this.match,
    this.onTap,
    this.tileRadius = 16, // Slightly more rounded for a modern feel
    this.tilePadding = const EdgeInsets.all(16),
  });

  final Match match;
  final VoidCallback? onTap;
  final double tileRadius;
  final EdgeInsetsGeometry tilePadding;

  static const Map<String, String> _teamImages = {
    'Barcelona': 'barca.png',
    'Chelsea': 'chelsea.png',
    'Liverpool': 'liverpool.png',
    'Manchester United': 'manutd.png',
    'Manchester City': 'mancity.png',
    'Nottingham Forest': 'forest.png',
    'N Forest': 'forest.png',
  };

  @override
  Widget build(BuildContext context) {
    final dateStr = '${_day(match.startDate)} ${_monthShort(match.startDate.month)} ${match.startDate.year}';
    final timeStr = _formatTime(match.startDate);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(tileRadius),
        // Subtle shadow to create depth
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.divider.withOpacity(0.5), width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(tileRadius),
        child: Padding(
          padding: tilePadding,
          child: Row(
            children: [
              // LEFT: Teams Section
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _teamRow(match.homeTeam.name),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(height: 1, thickness: 0.5, color: Colors.transparent), // Space between rows
                    ),
                    _teamRow(match.awayTeam.name),
                  ],
                ),
              ),

              // MIDDLE: Modern Vertical Divider
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                width: 3,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.textThird.withOpacity(0.8), // Blue Accent
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              // RIGHT: Schedule Section
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.access_time_filled_rounded,
                            size: 14, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(
                          timeStr,
                          style: AppTextStyles.body14Regular.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      dateStr,
                      style: AppTextStyles.caption12Regular.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _teamRow(String teamName) {
    final imageName = _teamImages[teamName] ?? 'mancity.png';

    return Row(
      children: [
        // Team Logo with background circle for consistency
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.background.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: CircleAvatar(
            radius: 14,
            backgroundColor: Colors.transparent,
            backgroundImage: AssetImage('assets/images/$imageName'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            teamName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body14Regular.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600, // Semi-bold for team names
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime dt) {
    final hour12 = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour12:$minute $ampm';
  }

  String _day(DateTime dt) => dt.day.toString().padLeft(2, '0');

  String _monthShort(int m) {
    const names = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return names[m - 1];
  }
}