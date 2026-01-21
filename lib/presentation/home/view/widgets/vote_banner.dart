
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart' as app_colors;

/// Lightweight CTA banner using only Container/Row/InkWell with AppColors.
/// Layout: [ trophy ] Player of the Match [ Vote Now ]
class VoteBanner extends StatelessWidget {
  const VoteBanner({
    super.key,
    this.title = 'Player of the Match',
    this.buttonText = 'Vote Now',
    this.onPressed,
    this.height = 64,
    this.cornerRadius = 12,
    this.horizontalPadding = 16,
    this.verticalPadding = 10,
    // No more required background/text colors; we use app defaults.
  });

  final String title;
  final String buttonText;
  final VoidCallback? onPressed;
  final double height;
  final double cornerRadius;
  final double horizontalPadding;
  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    // Local defaults for styling
    const Color titleColor = app_colors.AppColors.textPrimary; // white
    const Color cardColor  = app_colors.AppColors.surface;     // dark card

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(cornerRadius),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Row(
        children: [
          // Trophy icon bubble
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: app_colors.AppColors.divider,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.emoji_events_rounded,
              size: 18,
              color: app_colors.AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 12),
          // Title
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: titleColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Pill button
          _PillButton(
            text: buttonText,
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}

/// Minimal pill button with AppColors.primary and primaryDark feedback.
/// Uses only Container + InkWell for a light build.
class _PillButton extends StatelessWidget {
  const _PillButton({required this.text, this.onPressed});
  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed, // null = disabled (non-interactive)
      borderRadius: BorderRadius.circular(999),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: _Pressable(
        builder: (pressed) => Opacity(
          // Subtle visual for disabled state if onPressed == null
          opacity: onPressed == null ? 0.6 : 1.0,
          child: Container(
            decoration: BoxDecoration(
              color: pressed
                  ? app_colors.AppColors.primaryDark
                  : app_colors.AppColors.textThird,
              borderRadius: BorderRadius.circular(999),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: const Text(
              // Using const Text since style doesn't vary with state
              // (except color, which is constant here).
              // If you want to dim text for disabled state, remove const and vary style.
              // For now, keep it simple and performant.
              // Also: AppColors.inputText works as black-on-yellow.
              '',
            ),
          ),
        ),
      ),
    );
  }
}

/// Ultra-light press detector without Material/Focus overhead.
class _Pressable extends StatefulWidget {
  const _Pressable({required this.builder});
  final Widget Function(bool pressed) builder;

  @override
  State<_Pressable> createState() => _PressableState();
}

class _PressableState extends State<_Pressable> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => setState(() => _pressed = true),
      onPointerUp: (_) => setState(() => _pressed = false),
      onPointerCancel: (_) => setState(() => _pressed = false),
      child: widget.builder(_pressed),
    );
  }
}
