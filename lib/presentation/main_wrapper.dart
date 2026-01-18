// lib/presentation/main_wrapper.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metalheadd/presentation/profile/player_screen/player_screen.dart';

import 'home/view/home_screen.dart';
import 'home/view/widgets/bottom_navbar.dart';
import 'profile/child_profile/view/child_profile_screen.dart';
import 'voting/view/voting_screen.dart';
import 'manager_access/view/manager_access_screen.dart';

class MainWrapper extends ConsumerStatefulWidget {
  const MainWrapper({super.key});

  @override
  ConsumerState<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends ConsumerState<MainWrapper> {
  final PageStorageBucket _bucket = PageStorageBucket();

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = const [
      HomeScreen(),          // 0
      ChildProfileScreen(),  // 1
      VotingScreen(),        // 2
      ManagerAccessScreen(), // 3
      PlayerScreen(),        // 4
    ];
  }

  @override
  Widget build(BuildContext context) {
    final int currentIndex = ref.watch(navigationProvider);
    final bool isNavbarVisible = ref.watch(navbarVisibleProvider);

    return WillPopScope(
      onWillPop: () async {
        if (currentIndex != 0) {
          // 👈 Go back to Home instead of closing app
          ref.read(navigationProvider.notifier).updateIndex(0);
          ref.read(navbarVisibleProvider.notifier).state = true;
          return false;
        }
        return true; // allow app exit on Home tab
      },
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            /// Pages
            PageStorage(
              bucket: _bucket,
              child: IndexedStack(
                index: currentIndex,
                children: _pages.map((page) {
                  return SafeArea(
                    top: true,
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 80),
                      child: page,
                    ),
                  );
                }).toList(),
              ),
            ),

            /// Bottom Navbar
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                offset: isNavbarVisible ? Offset.zero : const Offset(0, 1),
                child: const CustomBottomNavBar(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
