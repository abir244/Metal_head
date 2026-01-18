import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = StateProvider<bool>((ref) {
  return false; // false = not logged in
});
