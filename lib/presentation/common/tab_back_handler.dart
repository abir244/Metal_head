import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../home/view/widgets/bottom_navbar.dart';

class TabBackHandler extends ConsumerWidget {
  final Widget child;

  const TabBackHandler({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WillPopScope(
      onWillPop: () async {
        ref.read(navigationProvider.notifier).updateIndex(0);
        ref.read(navbarVisibleProvider.notifier).state = true;
        return false;
      },
      child: child,
    );
  }
}
