
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart' as app_colors;

/// Lightweight CTA banner using only Container/Row/InkWell with AppColors.
/// Layout: [ trophy ] Player of the Match                       [ Vote Now ]
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
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: app_colors.AppColors.surface, // dark card background
        borderRadius: BorderRadius.circular(cornerRadius),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Row(
        children: [
          // Trophy icon bubble – subtle on dark
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: app_colors.AppColors.divider, // subtle circle
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.emoji_events_rounded,
              size: 18,
              color: app_colors.AppColors.textPrimary, // white icon
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
                color: app_colors.AppColors.textPrimary, // white text
                fontWeight: FontWeight.w600,
                fontSize: 14, // compact; bump to 16 if you prefer
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Pill button (primary yellow) – minimal layers
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
    // InkWell here is light; no extra Material layer needed on dark cards.
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(999),
      splashColor: Colors.transparent,   // clean look on dark surfaces
      highlightColor: Colors.transparent, // we’ll handle press with color swap below
      child: _Pressable(
        builder: (pressed) => Container(
          decoration: BoxDecoration(
            color: pressed
                ? app_colors.AppColors.primaryDark // pressed state
                : app_colors.AppColors.textThird,     // normal
            borderRadius: BorderRadius.circular(999),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Text(
            text,
            style: const TextStyle(
              color: app_colors.AppColors.inputText, // black on yellow
              fontWeight: FontWeight.w600,
              fontSize: 13,
              height: 1.1,
            ),
          ),
        ),
      ),
    );
  }
}

/// Ultra-light press detector without Material/Focus overhead.
/// It toggles `pressed` during pointer down/up to let us change colors.
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
