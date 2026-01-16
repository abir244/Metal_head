
// lib/presentation/main_wrapper.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home/view/home_screen.dart';
import 'home/view/widgets/bottom_navbar.dart'; // CustomBottomNavBar + navbarVisibleProvider + navigationProvider
import 'profile/child_profile/view/child_profile_screen.dart';
import 'voting/view/voting_screen.dart';
import 'manager_access/view/manager_access_screen.dart';

class MainWrapper extends ConsumerStatefulWidget {
  const MainWrapper({super.key});

  @override
  ConsumerState<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends ConsumerState<MainWrapper> {
  // Persist scroll positions per tab
  final PageStorageBucket _bucket = PageStorageBucket();

  // Keep your pages in a single place (order MUST match the bottom nav)
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
    final navState = ref.watch(navigationProvider);     // currentIndex
    final isVisible = ref.watch(navbarVisibleProvider); // show/hide bottom bar

    return Scaffold(
      // Allow body to render behind the floating bottom bar for nice translucency
      extendBody: true,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ---- 1) PAGES (state preserved) ----
          PageStorage(
            bucket: _bucket,
            child: IndexedStack(
              index: navState.currentIndex,
              children: _pages.map((page) {
                return SafeArea(
                  // Top safe area for system bars; bottom padding added below
                  top: true,
                  bottom: false,
                  child: Padding(
                    // Add some bottom padding so content doesn't get hidden
                    // under the floating navbar (tweak 80 if your bar is taller/shorter)
                    padding: const EdgeInsets.only(bottom: 80),
                    child: page,
                  ),
                );
              }).toList(),
            ),
          ),

          // ---- 2) FLOATING NAVBAR (slides fully off-screen) ----
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              offset: isVisible ? Offset.zero : const Offset(0, 1),
              child: const CustomBottomNavBar(),
            ),
          ),
        ],
      ),
    );
  }
}
