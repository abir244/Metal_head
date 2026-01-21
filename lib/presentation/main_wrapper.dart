// lib/presentation/main_wrapper.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/theme_provider.dart';
import 'home/view/home_screen.dart';
import 'home/view/widgets/bottom_navbar.dart';
import 'profile/child_profile/view/child_profile_screen.dart';
import 'voting/view/voting_screen.dart';
import 'manager_access/view/manager_access_screen.dart';
import 'profile/player_screen/player_screen.dart';

class MainWrapper extends ConsumerStatefulWidget {
  const MainWrapper({super.key});

  @override
  ConsumerState<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends ConsumerState<MainWrapper> {
  final PageStorageBucket _bucket = PageStorageBucket();

  final List<Widget> _pages = const [
    HomeScreen(),          // 0
    ChildProfileScreen(),  // 1
    VotingScreen(),        // 2
    ManagerAccessScreen(), // 3
    PlayerScreen(),        // 4
  ];

  @override
  Widget build(BuildContext context) {
    final int currentIndex = ref.watch(navigationProvider);
    final bool isNavbarVisible = ref.watch(navbarVisibleProvider);
    final bool isDarkMode = ref.watch(themeProvider);

    return WillPopScope(
      onWillPop: () async {
        if (currentIndex != 0) {
          ref.read(navigationProvider.notifier).updateIndex(0);
          ref.read(navbarVisibleProvider.notifier).state = true;
          return false;
        }
        return true;
      },
      child: Scaffold(
        extendBody: true,
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        body: PageStorage(
          bucket: _bucket,
          child: IndexedStack(
            index: currentIndex,
            children: _pages,
          ),
        ),
        bottomNavigationBar: AnimatedSlide(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          offset: isNavbarVisible ? Offset.zero : const Offset(0, 1),
          child: const CustomBottomNavBar(),
        ),
      ),
    );
  }
}
