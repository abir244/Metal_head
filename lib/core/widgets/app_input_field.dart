import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppInputField extends StatefulWidget {
  final String hint;
  final bool isPassword;
  final TextInputType keyboardType;
  final Color? backgroundColor;

  // 🔹 NEW (controlled from screen / ViewModel)
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool enabled;

  const AppInputField({
    super.key,
    required this.hint,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.backgroundColor,
    this.controller,
    this.onChanged,
    this.enabled = true,
  });

  @override
  State<AppInputField> createState() => _AppInputFieldState();
}

class _AppInputFieldState extends State<AppInputField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final bool obscure = widget.isPassword ? _obscureText : false;

    return TextField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      enabled: widget.enabled,
      obscureText: obscure,
      keyboardType: widget.keyboardType,
      style: AppTextStyles.input16Regular.copyWith(
        color: AppColors.textPrimary,
      ),
      cursorColor: AppColors.primary,
      decoration: InputDecoration(
        filled: true,
        fillColor: widget.enabled
            ? (widget.backgroundColor ?? AppColors.surface)
            : AppColors.surface.withOpacity(0.5),
        hintText: widget.hint,
        hintStyle: AppTextStyles.hint14Regular.copyWith(
          color: AppColors.textMuted,
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            obscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: AppColors.textMuted,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
    );
  }
}
