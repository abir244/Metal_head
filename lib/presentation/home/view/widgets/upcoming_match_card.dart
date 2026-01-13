// lib/presentation/home/view/widgets/upcoming_match_card.dart

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

  /// 🔹 UPDATED TEAM → IMAGE MAP
  /// Added Liverpool and Chelsea to match your Figma design
  static const Map<String, String> _teamImages = {
    'Barcelona': 'barca.png',
    'Chelsea': 'chelsea.png',
    'Liverpool': 'liverpool.png',
    'Manchester United': 'manutd.png',
    'Manchester City': 'mancity.png',
    'Nottingham Forest': 'forest.png',
    'FCB': 'barca.png', // Added shortnames for robustness
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
      borderRadius: BorderRadius.circular(16), // Slightly rounder to match Figma cards
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          // Using a solid dark color or a more subtle gradient to match the Figma theme
          gradient: LinearGradient(
            colors: [
              const Color(0xFF1E1E1E), // Darker start
              AppColors.primary.withOpacity(0.2), // Faded primary color (Yellow/Blue)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // HOME TEAM LOGO
            _teamLogo(match.homeTeam.name),

            /// CENTER INFO
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    dateStr,
                    style: AppTextStyles.body14Regular.copyWith(
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary, // Using the yellow/primary as the VS background
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'VS',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    timeStr,
                    style: AppTextStyles.body14Regular.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // AWAY TEAM LOGO
            _teamLogo(match.awayTeam.name),
          ],
        ),
      ),
    );
  }

  /// 🔹 UPDATED TEAM LOGO WIDGET
  Widget _teamLogo(String teamName) {
    // If team is not found, it defaults to 'mancity.png'
    final imageName = _teamImages[teamName] ?? 'mancity.png';

    return Column(
      children: [
        CircleAvatar(
          radius: 26, // Slightly larger for better visibility
          backgroundColor: Colors.white.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/images/$imageName',
              errorBuilder: (context, error, stackTrace) =>
                  Image.asset('assets/images/mancity.png'), // Ultimate fallback
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          teamName,
          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
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
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return names[m - 1];
  }
}
