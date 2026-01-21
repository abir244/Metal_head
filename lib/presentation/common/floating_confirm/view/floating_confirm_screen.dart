import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metalheadd/core/constants/app_colors.dart';

import '../viewmodel/floating_confirm_provider.dart';

class FloatingConfirmScreen extends ConsumerWidget {
  final String title;
  final String message;
  final VoidCallback onConfirm;
  final bool isDarkMode; // ✅ Add this

  const FloatingConfirmScreen({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    required this.isDarkMode, // ✅ Make required
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bgOverlayColor = Colors.black.withOpacity(0.55);
    final cardColor = isDarkMode ? const Color(0xFF1A1A1A) : Colors.white;
    final titleColor = isDarkMode ? Colors.white : Colors.black87;
    final messageColor = isDarkMode ? Colors.white70 : Colors.black54;

    return Material(
      color: bgOverlayColor,
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(color: messageColor),
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: isDarkMode ? Colors.white : Colors.black87,
                        side: BorderSide(
                          color: isDarkMode ? Colors.white38 : Colors.black38,
                        ),
                      ),
                      onPressed: () {
                        ref.read(floatingConfirmProvider.notifier).state = false;
                      },
                      child: const Text('Cancel'),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () {
                        ref.read(floatingConfirmProvider.notifier).state = false;
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
