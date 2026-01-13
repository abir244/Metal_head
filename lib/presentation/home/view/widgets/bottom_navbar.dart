import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart' as app_colors;
import '../../../../core/route/route_name.dart';


// Navigation provider
final navigationProvider =
StateNotifierProvider<NavigationNotifier, NavigationState>(
      (ref) => NavigationNotifier(),
);

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

// Navigation item model
class NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;

  const NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });
}

// List of all nav items
const List<NavItem> navItems = [
  NavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_filled,
      label: 'Home',
    route: RouteName.home,),
  NavItem(
      icon: Icons.child_care_outlined,
      activeIcon: Icons.child_care,
      label: 'Child',
      route: '/child'),
  NavItem(
    icon: Icons.how_to_vote_outlined,
    activeIcon: Icons.how_to_vote,
    label: 'Voting',
    route: RouteName.voting,
  ),


  NavItem(
      icon: Icons.manage_accounts_outlined,
      activeIcon: Icons.manage_accounts,
      label: 'Manager',
      route: '/manager'),
  NavItem(
      icon: Icons.person_outlined,
      activeIcon: Icons.person,
      label: 'Player',
      route: '/player'),
];

// Custom BottomNavigationBar Widget
class CustomBottomNavBar extends ConsumerWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navState = ref.watch(navigationProvider);

    return BottomNavigationBar(
      backgroundColor: app_colors.AppColors.surfaceDark,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: app_colors.AppColors.primary,
      unselectedItemColor: app_colors.AppColors.textMuted,
      currentIndex: navState.currentIndex,
      onTap: (index) {
        ref.read(navigationProvider.notifier).updateIndex(index);
        final route = navItems[index].route;
        Navigator.pushNamed(context, route);
      },
      items: navItems
          .map((item) => BottomNavigationBarItem(
        icon: Icon(item.icon),
        activeIcon: Icon(item.activeIcon),
        label: item.label,
      ))
          .toList(),
    );
  }
}
