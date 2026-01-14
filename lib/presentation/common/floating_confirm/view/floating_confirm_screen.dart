import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metalheadd/core/constants/app_colors.dart';

import '../viewmodel/floating_confirm_provider.dart';

class FloatingConfirmScreen extends ConsumerWidget {
  const FloatingConfirmScreen({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
  });

  final String title;
  final String message;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: AppColors.inputText.withOpacity(0.55),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),

              const SizedBox(height: 12),

              Text(
                message,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        ref
                            .read(floatingConfirmProvider
                            .notifier)
                            .state = false;
                      },
                      child: const Text('Cancel'),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ref
                            .read(floatingConfirmProvider
                            .notifier)
                            .state = false;
                        onConfirm();
                      },
                      child: const Text('Confirm'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
