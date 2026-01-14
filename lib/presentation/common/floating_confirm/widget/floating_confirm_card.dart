import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class FloatingConfirmCard extends StatelessWidget {
  const FloatingConfirmCard({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    required this.onCancel,
    this.isLoading = false,
  });

  final String title;
  final String message;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// 🟡 Title
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          /// 📝 Message
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              /// ❌ Cancel
              Expanded(
                child: OutlinedButton(
                  onPressed: isLoading ? null : onCancel,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    side: const BorderSide(color: AppColors.divider),
                  ),
                  child: const Text('Cancel'),
                ),
              ),

              const SizedBox(width: 12),

              /// ✅ Confirm
              Expanded(
                child: ElevatedButton(
                  onPressed: isLoading ? null : onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.background,
                  ),
                  child: isLoading
                      ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.background,
                    ),
                  )
                      : const Text('Confirm'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
