import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart' as app_colors;
import '../../../../core/route/route_name.dart';

// ---------------- Providers ----------------

final navigationProvider = StateNotifierProvider<NavigationNotifier, NavigationState>(
      (ref) => NavigationNotifier(),
);

// This provider controls the visibility
final navbarVisibleProvider = StateProvider<bool>((ref) => true);

class NavigationState {
  final int currentIndex;
  NavigationState({this.currentIndex = 0});
  NavigationState copyWith({int? currentIndex}) {
    return NavigationState(currentIndex: currentIndex ?? this.currentIndex);
  }
}

class NavigationNotifier extends StateNotifier<NavigationState> {
  NavigationNotifier() : super(NavigationState());
  void updateIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }
}

// ---------------- Model & Data ----------------

class NavItem {
  final IconData icon, activeIcon;
  final String label;
  const NavItem({required this.icon, required this.activeIcon, required this.label});
}

final List<NavItem> navItems = [
  const NavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home'),
  const NavItem(icon: Icons.face_outlined, activeIcon: Icons.face, label: 'Child'),
  const NavItem(icon: Icons.how_to_vote_outlined, activeIcon: Icons.how_to_vote, label: 'Voting'),
  const NavItem(icon: Icons.person_outline, activeIcon: Icons.person, label: 'Manager'),
  const NavItem(icon: Icons.directions_run_outlined, activeIcon: Icons.directions_run, label: 'Player'),
];

// ---------------- CustomBottomNavBar Widget ----------------

class CustomBottomNavBar extends ConsumerWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navState = ref.watch(navigationProvider);
    final double bottomPadding = MediaQuery.of(context).padding.bottom;

    // UPDATED: Height set to a stable value based on device padding
    final double barHeight = 65 + bottomPadding;
    const Duration animDuration = Duration(milliseconds: 350);

    return Container(
      height: barHeight,
      decoration: BoxDecoration(
        color: Colors.black, // This background will now slide with the widget
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.08), width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(navItems.length, (index) {
          final isSelected = navState.currentIndex == index;
          final item = navItems[index];

          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (!isSelected) {
                  HapticFeedback.lightImpact();
                  ref.read(navigationProvider.notifier).updateIndex(index);

                  // UPDATED: Always make navbar visible when a tab is clicked
                  ref.read(navbarVisibleProvider.notifier).state = true;
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  // 1. Top Yellow Indicator
                  AnimatedContainer(
                    duration: animDuration,
                    curve: Curves.easeOutCubic,
                    width: isSelected ? 40 : 0,
                    height: 2.5,
                    decoration: BoxDecoration(
                      color: isSelected ? app_colors.AppColors.primary : Colors.transparent,
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(2)),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: bottomPadding > 0 ? 5 : 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 2. Icon with Scale Animation
                          AnimatedScale(
                            duration: animDuration,
                            scale: isSelected ? 1.18 : 1.0,
                            curve: Curves.easeOutBack,
                            child: TweenAnimationBuilder<Color?>(
                              duration: animDuration,
                              tween: ColorTween(
                                begin: Colors.white.withOpacity(0.5),
                                end: isSelected ? app_colors.AppColors.primary : Colors.white.withOpacity(0.5),
                              ),
                              builder: (context, color, child) {
                                return Icon(isSelected ? item.activeIcon : item.icon, color: color, size: 24);
                              },
                            ),
                          ),
                          const SizedBox(height: 5),
                          // 3. Animated Label Text
                          AnimatedDefaultTextStyle(
                            duration: animDuration,
                            curve: Curves.easeInOut,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                              color: isSelected ? app_colors.AppColors.primary : Colors.white.withOpacity(0.5),
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
        }),
      ),
    );
  }
}