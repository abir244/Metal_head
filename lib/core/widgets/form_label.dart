import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../theme/app_text_styles.dart';

class FormLabel extends StatelessWidget {
  final String text;
  final bool isRequired;

  const FormLabel(
      this.text, {
        super.key,
        this.isRequired = true,
      });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          text: text,
          style: AppTextStyles.body14Regular.copyWith(
            color: AppColors.textSecondary,
          ),
          children: isRequired
              ? const [
            TextSpan(
              text: ' *',
              style: TextStyle(color: AppColors.warning),
            ),
          ]
              : [],
        ),
      ),
    );
  }
}
