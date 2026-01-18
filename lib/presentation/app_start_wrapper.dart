

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth/login/view/login_screen.dart';
import 'main_wrapper.dart';
import 'auth/auth_provider.dart';

class AppStartWrapper extends ConsumerWidget {
  const AppStartWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(authProvider);

    if (isLoggedIn) {
      return const MainWrapper(); // 👈 YOUR CODE
    } else {
      return const LoginScreen();
    }
  }
}














































