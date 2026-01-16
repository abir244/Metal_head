
import 'package:flutter/material.dart';
import 'package:metalheadd/core/constants/app_colors.dart';
import 'package:metalheadd/core/theme/app_text_styles.dart';

class VotingPlayerListButton extends StatelessWidget {
  final VoidCallback? onTap;

  const VotingPlayerListButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap ?? () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // LEFT SIDE — ICON + TEXT
            Row(
              children: [
                const Icon(
                  Icons.group_add_outlined,
                  size: 22,
                  color: AppColors.textPrimary,
                ),
                const SizedBox(width: 12),
                Text(
                  "Create Voting Player List",
                  style: AppTextStyles.body14Regular.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),

            // RIGHT SIDE — YELLOW CIRCLE (+)
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
              child: const Icon(
                Icons.add,
                size: 22,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
