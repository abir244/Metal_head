
// lib/presentation/voting/widget/voting_table_header.dart
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class VotingTableHeader extends StatelessWidget {
  const VotingTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          _HeadCell(width: 40, label: 'No.'),
          _HeadCell(flex: 2, label: 'Name'),
          _HeadCell(flex: 1, label: 'Number'),
          _HeadCell(flex: 1, label: 'Position'),
        ],
      ),
    );
  }
}

class _HeadCell extends StatelessWidget {
  final String label;
  final int flex;
  final double? width;
  const _HeadCell({required this.label, this.flex = 1, this.width});

  @override
  Widget build(BuildContext context) {
    final child = Text(label, style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold));
    if (width != null) {
      return SizedBox(width: width, child: child);
    }
    return Expanded(flex: flex, child: child);
  }
}
