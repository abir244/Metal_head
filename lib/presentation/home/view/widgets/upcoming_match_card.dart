import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../model/match.dart';

class UpcomingMatchCard extends ConsumerWidget {
  const UpcomingMatchCard({
    super.key,
    required this.match,
    this.onTap,
  });

  final Match match;
  final VoidCallback? onTap;

  /// 🔹 TEAM → IMAGE MAP (INIT HERE)
  static const Map<String, String> _teamImages = {
    'Barcelona': 'barca.png',
    'Chelsea': 'chelsea.png',
    'Liverpool': 'liverpool.png',
    'Manchester United': 'manutd.png',
    'Manchester City': 'mancity.png',
    'Nottingham Forest': 'forest.png',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateStr =
        '${match.startDate.day.toString().padLeft(2, '0')} '
        '${_month(match.startDate.month)} '
        '${match.startDate.year}';

    final timeStr = _formatTime(match.startDate);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.textThird],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Row(
          children: [
            _teamLogo(match.homeTeam.name),
            const SizedBox(width: 12),

            /// CENTER INFO
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    dateStr,
                    style: AppTextStyles.body14Regular.copyWith(
                      color: AppColors.background,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      'VS',
                      style: AppTextStyles.body14Regular.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    timeStr,
                    style: AppTextStyles.body14Regular.copyWith(
                      color: AppColors.background,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),
            _teamLogo(match.awayTeam.name),
          ],
        ),
      ),
    );
  }

  /// 🔹 TEAM LOGO WIDGET
  Widget _teamLogo(String teamName) {
    final imageName = _teamImages[teamName] ?? 'mancity.png';

    return CircleAvatar(
      radius: 22,
      backgroundColor: AppColors.background,
      backgroundImage: AssetImage('assets/images/$imageName'),
    );
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final amPm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $amPm';
  }

  String _month(int m) {
    const names = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return names[m - 1];
  }
}
