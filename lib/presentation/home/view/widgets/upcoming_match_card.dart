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
    required this.isDarkMode, // ✅ Add dark mode flag
  });

  final Match match;
  final VoidCallback? onTap;
  final bool isDarkMode;

  static const Map<String, String> _teamImages = {
    'Barcelona': 'barca.png',
    'Chelsea': 'chelsea.png',
    'Liverpool': 'liverpool.png',
    'Manchester United': 'manutd.png',
    'Manchester City': 'mancity.png',
    'Nottingham Forest': 'forest.png',
    'FCB': 'barca.png',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateStr =
        '${match.startDate.day.toString().padLeft(2, '0')} ${_month(match.startDate.month)} ${match.startDate.year}';
    final timeStr = _formatTime(match.startDate);

    final bgGradient = isDarkMode
        ? LinearGradient(
      colors: [Color(0xFF1E1E1E), AppColors.surface.withOpacity(0.2)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    )
        : LinearGradient(
      colors: [Colors.white, Colors.grey[200]!],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    final vsBgColor = isDarkMode ? AppColors.primary : Colors.yellow.shade600;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subtitleColor = isDarkMode ? Colors.white70 : Colors.black54;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: bgGradient,
          border: Border.all(color: Colors.black.withOpacity(0.05)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _teamLogo(match.homeTeam.name),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(dateStr,
                      style: AppTextStyles.body14Regular.copyWith(
                        color: subtitleColor,
                        fontWeight: FontWeight.w500,
                      )),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: vsBgColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'VS',
                      style: TextStyle(
                        color: isDarkMode ? Colors.black : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(timeStr,
                      style: AppTextStyles.body14Regular.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
            ),
            _teamLogo(match.awayTeam.name),
          ],
        ),
      ),
    );
  }

  Widget _teamLogo(String teamName) {
    final imageName = _teamImages[teamName] ?? 'mancity.png';
    final bgColor = isDarkMode ? Colors.white12 : Colors.black12;

    return Column(
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: bgColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/images/$imageName',
              errorBuilder: (context, error, stackTrace) =>
                  Image.asset('assets/images/mancity.png'),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          teamName,
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
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
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return names[m - 1];
  }
}
