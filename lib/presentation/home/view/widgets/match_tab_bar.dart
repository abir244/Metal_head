
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';


final matchTabIndexProvider = StateProvider<int>((ref) => 0); // 0=Upcoming, 1=History

class MatchTabBar extends ConsumerWidget {
  const MatchTabBar({super.key, this.onChanged});
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(matchTabIndexProvider);

    Widget chip(String label, int i) {
      final selected = index == i;
      return InkWell(
        onTap: () {
          ref.read(matchTabIndexProvider.notifier).state = i;
          onChanged?.call(i);
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(label,
              style: AppTextStyles.body14Regular.copyWith(
                color: selected ? AppColors.background : AppColors.textPrimary,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              )),
        ),
      );
    }

    return Row(
      children: [
        chip('Upcoming Match', 0),
        const SizedBox(width: 8),
        chip('Match History', 1),
        const Spacer(),
        TextButton(
          onPressed: () {/* TODO: navigate to full list */},
          child: Text('See All',
              style: AppTextStyles.body14Regular.copyWith(
                  color: AppColors.primary, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}
