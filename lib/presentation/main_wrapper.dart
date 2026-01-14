import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home/view/home_screen.dart';
import 'home/view/widgets/bottom_navbar.dart'; // Ensure navbarVisibleProvider is here
import 'manager/View/manager_screen.dart';
import 'profile/child_profile/view/child_profile_screen.dart';
import 'package:metalheadd/presentation/voting/view/voting_screen.dart';
// lib/presentation/main_wrapper.dart

class MainWrapper extends ConsumerWidget {
  const MainWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navState = ref.watch(navigationProvider);
    final isVisible = ref.watch(navbarVisibleProvider);

    return Scaffold(
      // We use extendBody to allow the screens to go behind the navbar
      extendBody: true,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. THE PAGES (Full Screen)
          IndexedStack(
            index: navState.currentIndex,
            children: const [
              HomeScreen(),
              ChildProfileScreen(),
              VotingScreen(),
              ManagerAccessScreen(),
              Center(child: Text("Manager", style: TextStyle(color: Colors.white))),
              Center(child: Text("Player", style: TextStyle(color: Colors.white))),
            ],
          ),

          // 2. THE FLOATING NAVBAR (Slides completely off-screen)
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              offset: isVisible ? Offset.zero : const Offset(0, 1), // Slides 100% down
              child: const CustomBottomNavBar(),
            ),
          ),
        ],
      ),
    );
  }
}