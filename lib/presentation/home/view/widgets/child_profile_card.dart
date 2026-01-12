import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metalheadd/core/constants/app_colors.dart';
import 'package:metalheadd/core/theme/app_text_styles.dart';
import 'package:metalheadd/presentation/home/model/child_profile.dart';

class ChildProfileCard extends ConsumerWidget {
  const ChildProfileCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.showTitle = true,
    this.avatarRadius = 32, // Increased for better balance
  });

  final ChildProfile child;
  final EdgeInsetsGeometry padding;
  final bool showTitle;
  final double avatarRadius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final isNarrow = w < 360;

        final labelStyle = AppTextStyles.body14Regular.copyWith(
          fontSize: isNarrow ? 12 : 13,
          color: AppColors.textSecondary.withOpacity(0.8),
          fontWeight: FontWeight.w500,
        );
        final valueStyle = AppTextStyles.body14Regular.copyWith(
          fontSize: isNarrow ? 13 : 14,
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        );

        return Container(
          padding: padding,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.divider.withOpacity(0.5)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showTitle) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Child Profile",
                          style: AppTextStyles.body14Regular.copyWith(
                            fontSize: 14,
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 24,
                          height: 3,
                          decoration: BoxDecoration(
                            color: AppColors.primary, // Using primary color for accent
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                    const Icon(Icons.verified_user_rounded,
                        size: 18, color: AppColors.success),
                  ],
                ),
                const SizedBox(height: 16),
              ],

              if (isNarrow)
                Column(
                  children: [
                    _AvatarBlock(child: child, radius: avatarRadius),
                    const SizedBox(height: 20),
                    _DefinitionList(
                      child: child,
                      labelStyle: labelStyle,
                      valueStyle: valueStyle,
                    ),
                  ],
                )
              else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: _AvatarBlock(child: child, radius: avatarRadius),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 3,
                      child: _DefinitionList(
                        child: child,
                        labelStyle: labelStyle,
                        valueStyle: valueStyle,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}

class _AvatarBlock extends StatelessWidget {
  const _AvatarBlock({required this.child, required this.radius});
  final ChildProfile child;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary.withOpacity(0.1), width: 3),
              ),
              child: CircleAvatar(
                radius: radius,
                backgroundColor: AppColors.surfaceDark,
                backgroundImage: _avatarProvider(child.imageUrl),
              ),
            ),
            // THE ACTIVE STATUS DOT ON AVATAR
            Positioned(
              right: 2,
              bottom: 2,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.surface, width: 2),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          child.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.body14Regular.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
        Text(
          child.school,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.label12Medium.copyWith(
            color: AppColors.textMuted,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  ImageProvider _avatarProvider(String? url) {
    if (url != null && url.trim().isNotEmpty) {
      if (url.startsWith('http')) return NetworkImage(url);
      return AssetImage(url);
    }
    return const AssetImage('assets/images/child.png');
  }
}

class _DefinitionList extends StatelessWidget {
  const _DefinitionList({
    required this.child,
    required this.labelStyle,
    required this.valueStyle,
  });

  final ChildProfile child;
  final TextStyle labelStyle;
  final TextStyle valueStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _BaselineRow(
          label: 'Jersey',
          labelStyle: labelStyle,
          value: '#${child.jersey}',
          valueStyle: valueStyle,
        ),
        const SizedBox(height: 12),
        if (child.position != null) ...[
          _BaselineRow(
            label: 'Position',
            labelStyle: labelStyle,
            value: child.position!,
            valueStyle: valueStyle,
          ),
          const SizedBox(height: 12),
        ],
        _BaselineRow(
          label: 'Status',
          labelStyle: labelStyle,
          valueWidget: const _StatusPill(text: 'Active'),
          valueStyle: valueStyle,
        ),
      ],
    );
  }
}

class _BaselineRow extends StatelessWidget {
  const _BaselineRow({
    required this.label,
    required this.labelStyle,
    required this.valueStyle,
    this.value,
    this.valueWidget,
  });

  final String label;
  final String? value;
  final Widget? valueWidget;
  final TextStyle labelStyle;
  final TextStyle valueStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: labelStyle),
        const SizedBox(width: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: CustomPaint(painter: _DashedLinePainter()),
          ),
        ),
        const SizedBox(width: 8),
        valueWidget ?? Text(value!, style: valueStyle),
      ],
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 2, dashSpace = 3, startX = 0;
    final paint = Paint()
      ..color = AppColors.divider.withOpacity(0.4)
      ..strokeWidth = 1;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            text.toUpperCase(),
            style: AppTextStyles.badge12SemiBold.copyWith(
              color: AppColors.success,
              fontSize: 10,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}