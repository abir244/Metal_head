
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_notifier.dart';
import 'home_state.dart';
import 'home_repository.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return FakeHomeRepository();
});

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  final repo = ref.read(homeRepositoryProvider);
  return HomeNotifier(repo);
});
