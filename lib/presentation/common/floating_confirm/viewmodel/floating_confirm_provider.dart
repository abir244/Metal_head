import 'package:flutter_riverpod/flutter_riverpod.dart';

final floatingConfirmProvider =
StateNotifierProvider<FloatingConfirmNotifier, bool>(
      (ref) => FloatingConfirmNotifier(),
);

class FloatingConfirmNotifier extends StateNotifier<bool> {
  FloatingConfirmNotifier() : super(false);

  void show() => state = true;
  void hide() => state = false;
}
