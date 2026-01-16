// lib/presentation/main_wrapper.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home/view/home_screen.dart';
import 'home/view/widgets/bottom_navbar.dart'; // CustomBottomNavBar + providers
import 'profile/child_profile/view/child_profile_screen.dart';
import 'voting/view/voting_screen.dart';
import 'manager_access/view/manager_access_screen.dart';

class MainWrapper extends ConsumerStatefulWidget {
  const MainWrapper({super.key});

  @override
  ConsumerState<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends ConsumerState<MainWrapper> {
  /// Persist scroll position per tab
  final PageStorageBucket _bucket = PageStorageBucket();

  /// Pages must match bottom nav order
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = const [
      HomeScreen(),          // index 0
      ChildProfileScreen(),  // index 1
      VotingScreen(),        // index 2
      ManagerAccessScreen(), // index 3
    ];
  }

  @override
  Widget build(BuildContext context) {
    // 🔴 FIX: navigationProvider returns int, not object
    final int currentIndex = ref.watch(navigationProvider);

    final bool isNavbarVisible =
    ref.watch(navbarVisibleProvider);

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          /// -------------------------------
          /// 1️⃣ PAGES (state preserved)
          /// -------------------------------
          PageStorage(
            bucket: _bucket,
            child: IndexedStack(
              index: currentIndex, // ✅ FIXED
              children: _pages.map((page) {
                return SafeArea(
                  top: true,
                  bottom: false,
                  child: Padding(
                    // Prevent content from being hidden
                    // behind floating navbar
                    padding: const EdgeInsets.only(bottom: 80),
                    child: page,
                  ),
                );
              }).toList(),
            ),
          ),

          /// -------------------------------
          /// 2️⃣ FLOATING BOTTOM NAVBAR
          /// -------------------------------
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              offset:
              isNavbarVisible ? Offset.zero : const Offset(0, 1),
              child: const CustomBottomNavBar(),
            ),
          ),
        ],
      ),
    );
  }
}
