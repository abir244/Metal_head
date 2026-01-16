
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
class StadiumText extends StatelessWidget {
  final String text;
  const StadiumText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Text(
        text,
        style: AppTextStyles.caption12Regular.copyWith(color: AppColors.textSecondary),
      ),
    );
  }
}