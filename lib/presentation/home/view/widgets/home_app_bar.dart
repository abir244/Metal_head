import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';

class HomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const HomeAppBar({
    super.key,
    this.avatarUrl,
    this.onTapNotifications,
    this.onTapProfile,
    this.unreadCount,
  });

  final String? avatarUrl;
  final VoidCallback? onTapNotifications;
  final VoidCallback? onTapProfile;
  final int? unreadCount;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: false,
      titleSpacing: 20,
      shape: Border(
        bottom: BorderSide(
          color: AppColors.textPrimary.withOpacity(0.05),
          width: 1,
        ),
      ),
      title: Hero(
        tag: 'app_logo',
        child: Image.asset(
          'assets/images/image6.png',
          height: 32,
          fit: BoxFit.contain,
        ),
      ),
      actions: [
        /// NOTIFICATIONS
        _AppBarAction(
          onTap: onTapNotifications,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              const Icon(
                Icons.notifications_none_rounded,
                size: 28,
                color: AppColors.textPrimary,
              ),
              if ((unreadCount ?? 0) > 0)
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.background,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        unreadCount! > 9 ? '9+' : unreadCount!.toString(),
                        style: const TextStyle(
                          color: AppColors.background,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),

        /// PROFILE AVATAR
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 8),
          child: GestureDetector(
            onTap: onTapProfile,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.surface,
                backgroundImage: _getAvatar(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  ImageProvider _getAvatar() {
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      return NetworkImage(avatarUrl!);
    }

    return const NetworkImage(
      'https://qz.com/cdn-cgi/image/width=1920,quality=85,format=auto/https://assets.qz.com/media/331423b12c7445264e9346deb167c3de.jpg',
    );
  }
}

/// Helper for consistent icon action styling
class _AppBarAction extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _AppBarAction({
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 44,
        height: 44,
        child: Center(child: child),
      ),
    );
  }
}
