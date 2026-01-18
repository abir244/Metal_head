import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_notifier.dart';
import 'home_state.dart';
import 'home_repository.dart';

// 1. Repository Provider
final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return FakeHomeRepository();
});

// 2. Home Provider using Notifier
final homeProvider = NotifierProvider<HomeNotifier, HomeState>(() {
  return HomeNotifier();
});

// 3. Navbar visibility provider
final navbarVisibleProvider = StateProvider<bool>((ref) => true);