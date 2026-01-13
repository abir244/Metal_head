// lib/presentation/voting/widget/voting_player_row.dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../voting_rights/model/voting_model.dart';

class VotingPlayerRow extends StatelessWidget {
  final int index;
  final PlayerCandidate player;
  final bool selected;
  final VoidCallback onTap;

  const VotingPlayerRow({
    super.key,
    required this.index,
    required this.player,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark, // same as 0xff333
          borderRadius: BorderRadius.circular(32),
          border: Border(
            bottom: BorderSide(
              color: selected ? AppColors.primary : AppColors.divider,
              width: selected ? 2 : 1,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Index
            Text(
              index.toString(),
              style: TextStyle(
                color: selected ? AppColors.primary : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(width: 16),

            /// Avatar
            CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage(player.avatarUrl),
            ),

            const SizedBox(width: 16),

            /// Player Name
            Expanded(
              child: Text(
                player.name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            /// Jersey Number
            Text(
              '#${player.number}',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),

            const SizedBox(width: 30),

            /// Position
            Text(
              player.position,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
