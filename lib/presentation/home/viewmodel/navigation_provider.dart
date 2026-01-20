import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Controls selected bottom navigation index
final navigationProvider = StateNotifierProvider<NavigationNotifier, int>(
      (ref) => NavigationNotifier(),
);

class NavigationNotifier extends StateNotifier<int> {
  NavigationNotifier() : super(0);
  void updateIndex(int index) => state = index;
}

/// Controls bottom navbar visibility
final navbarVisibleProvider = StateProvider<bool>((ref) => true);