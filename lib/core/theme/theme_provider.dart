import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 🔥 Theme provider
/// false = light mode, true = dark mode
final themeProvider = NotifierProvider<ThemeNotifier, bool>(ThemeNotifier.new);

class ThemeNotifier extends Notifier<bool> {
  @override
  bool build() => false; // starts in light mode

  /// Toggle dark / light mode
  void toggleTheme() {
    state = !state;
  }

  /// Optionally: set explicitly
  void setDarkMode(bool isDark) {
    state = isDark;
  }
}
