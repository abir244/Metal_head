import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../model/player.dart';

class PlayerOfMatchCard extends ConsumerWidget {
  const PlayerOfMatchCard({super.key, required this.player, this.onViewMore});

  final Player player;
  final VoidCallback? onViewMore;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          // Circle Avatar with fallback
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.surfaceDark,
            backgroundImage: _getPlayerImage(player.image),
            onBackgroundImageError: (exception, stackTrace) {
              // Handle image loading error silently
              debugPrint('Error loading player image: $exception');
            },
          ),
          const SizedBox(width: 12),
          // Player info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player.name,
                  style: AppTextStyles.body16Regular.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${player.position} • ${player.teamName}',
                  style: AppTextStyles.body14Regular.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          // View button
          TextButton(
            onPressed: onViewMore,
            style: TextButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'View Now',
              style: AppTextStyles.body14Regular.copyWith(
                color: AppColors.background,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ImageProvider<Object> _getPlayerImage(String? imageUrl) {
    if (imageUrl != null && imageUrl.trim().isNotEmpty) {
      final trimmedUrl = imageUrl.trim();

      // Check if it's a valid URI with proper scheme
      final uri = Uri.tryParse(trimmedUrl);
      if (uri != null &&
          uri.hasScheme &&
          (uri.scheme == 'http' || uri.scheme == 'https')) {
        return NetworkImage(trimmedUrl);
      }

      // Check if it's a local asset path
      if (trimmedUrl.startsWith('assets/') ||
          trimmedUrl.startsWith('images/')) {
        return AssetImage(trimmedUrl);
      }

      // Check if it's a base64 encoded image
      if (trimmedUrl.startsWith('data:image/')) {
        try {
          return MemoryImage(Uri.parse(trimmedUrl).data!.contentAsBytes());
        } catch (e) {
          debugPrint('Error parsing base64 image: $e');
        }
      }
    }

    // Return default image
    return const AssetImage('assets/images/cr7.png');
  }
}
