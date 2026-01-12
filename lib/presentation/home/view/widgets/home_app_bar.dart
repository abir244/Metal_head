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
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Image.asset(
        'assets/images/image6.png',
        height: 40,
        fit: BoxFit.contain,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: InkWell(
            onTap: onTapNotifications,
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.notifications_none,
                    size: 26,
                    color: AppColors.textPrimary,
                  ),
                ),
                if ((unreadCount ?? 0) > 0)
                  Positioned(
                    right: 2,
                    top: 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        (unreadCount! > 99) ? '99+' : unreadCount!.toString(),
                        style: const TextStyle(
                          color: AppColors.background,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12, left: 4),
          child: InkWell(
            onTap: onTapProfile,
            borderRadius: BorderRadius.circular(18),
            child: CircleAvatar(
              radius: 17,
              backgroundColor: AppColors.surface,
              backgroundImage: (avatarUrl != null && avatarUrl!.isNotEmpty)
                  ? NetworkImage(avatarUrl!)
                  : const AssetImage('assets/images/cr7.png')
                        as ImageProvider,
            ),
          ),
        ),
      ],
    );
  }
}
