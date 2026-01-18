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
    this.avatarRadius = 32,
    this.fullView = false,
  });

  final ChildProfile child;
  final EdgeInsetsGeometry padding;
  final bool showTitle;
  final double avatarRadius;
  final bool fullView;

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
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 24,
                          height: 3,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
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
                      fullView: fullView,
                    ),
                  ],
                )
              else
                Row(
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
                        fullView: fullView,
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
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: radius,
              backgroundColor: AppColors.surfaceDark,
              foregroundImage: _avatarProvider(child.imageUrl),
              onForegroundImageError: (_, __) {},
            ),
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
          style: AppTextStyles.body14Regular.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          child.school,
          style: AppTextStyles.label12Medium.copyWith(
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }

  ImageProvider _avatarProvider(String? url) {
    if (url != null && url.trim().isNotEmpty) {
      if (url.startsWith('http')) {
        return NetworkImage(url);
      }
      return AssetImage(url);
    }
    return const AssetImage('assets/images/cr7.png');
  }
}

class _DefinitionList extends StatelessWidget {
  const _DefinitionList({
    required this.child,
    required this.labelStyle,
    required this.valueStyle,
    this.fullView = false,
  });

  final ChildProfile child;
  final TextStyle labelStyle;
  final TextStyle valueStyle;
  final bool fullView;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _BaselineRow(
          label: 'Jersey',
          value: '#${child.jersey}',
          labelStyle: labelStyle,
          valueStyle: valueStyle,
        ),
        const SizedBox(height: 12),
        if (child.position != null)
          _BaselineRow(
            label: 'Position',
            value: child.position!,
            labelStyle: labelStyle,
            valueStyle: valueStyle,
          ),
        const SizedBox(height: 12),
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
        Expanded(child: Divider(color: AppColors.divider.withOpacity(0.4))),
        const SizedBox(width: 8),
        valueWidget ?? Text(value!, style: valueStyle),
      ],
    );
  }
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
      child: Text(
        text.toUpperCase(),
        style: AppTextStyles.badge12SemiBold.copyWith(
          color: AppColors.success,
        ),
      ),
    );
  }
}
