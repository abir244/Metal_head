import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart' as app_colors;


/// ============================================================
/// PROVIDERS
/// ============================================================

/// Controls selected bottom navigation index
final navigationProvider =
StateNotifierProvider<NavigationNotifier, int>(
      (ref) => NavigationNotifier(),
);

class NavigationNotifier extends StateNotifier<int> {
  NavigationNotifier() : super(0);

  void updateIndex(int index) {
    state = index;
  }
}

/// Controls bottom navbar visibility
final navbarVisibleProvider = StateProvider<bool>((ref) => true);


/// ============================================================
/// MODEL
/// ============================================================

class NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

/// Navigation items list
const List<NavItem> navItems = [
  NavItem(
    icon: Icons.home_outlined,
    activeIcon: Icons.home,
    label: 'Home',
  ),
  NavItem(
    icon: Icons.face_outlined,
    activeIcon: Icons.face,
    label: 'Child',
  ),
  NavItem(
    icon: Icons.how_to_vote_outlined,
    activeIcon: Icons.how_to_vote,
    label: 'Voting',
  ),
  NavItem(
    icon: Icons.person_outline,
    activeIcon: Icons.person,
    label: 'Manager',
  ),
  NavItem(
    icon: Icons.directions_run_outlined,
    activeIcon: Icons.directions_run,
    label: 'Player',
  ),
];


/// ============================================================
/// MAIN BOTTOM NAV BAR
/// ============================================================

class CustomBottomNavBar extends ConsumerWidget {
  const CustomBottomNavBar({super.key});

  static const Duration _animationDuration =
  Duration(milliseconds: 350);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int currentIndex = ref.watch(navigationProvider);
    final double bottomPadding =
        MediaQuery.of(context).padding.bottom;

    return Container(
      height: 65 + bottomPadding,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.08),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: List.generate(
          navItems.length,
              (index) {
            return _BottomNavItem(
              item: navItems[index],
              isSelected: currentIndex == index,
              bottomPadding: bottomPadding,
              onTap: () {
                if (currentIndex != index) {
                  HapticFeedback.lightImpact();

                  // Update tab index
                  ref
                      .read(navigationProvider.notifier)
                      .updateIndex(index);

                  // Ensure navbar is visible
                  ref
                      .read(navbarVisibleProvider.notifier)
                      .state = true;
                }
              },
            );
          },
        ),
      ),
    );
  }
}


/// ============================================================
/// SINGLE NAV ITEM WIDGET
/// ============================================================

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
    required this.bottomPadding,
  });

  final NavItem item;
  final bool isSelected;
  final VoidCallback onTap;
  final double bottomPadding;

  static const Duration _animationDuration =
  Duration(milliseconds: 350);

  @override
  Widget build(BuildContext context) {
    final Color itemColor = isSelected
        ? app_colors.AppColors.primary
        : Colors.white.withOpacity(0.5);

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          children: [
            /// Top indicator
            AnimatedContainer(
              duration: _animationDuration,
              curve: Curves.easeOutCubic,
              width: isSelected ? 40 : 0,
              height: 2.5,
              decoration: BoxDecoration(
                color: isSelected
                    ? app_colors.AppColors.primary
                    : Colors.transparent,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(2),
                ),
              ),
            ),

            /// Icon + Label
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: bottomPadding > 0 ? 5 : 0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedScale(
                      duration: _animationDuration,
                      scale: isSelected ? 1.18 : 1.0,
                      curve: Curves.easeOutBack,
                      child: Icon(
                        isSelected
                            ? item.activeIcon
                            : item.icon,
                        color: itemColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 5),
                    AnimatedDefaultTextStyle(
                      duration: _animationDuration,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w400,
                        color: itemColor,
                        letterSpacing: 0.2,
                      ),
                      child: Text(item.label),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
