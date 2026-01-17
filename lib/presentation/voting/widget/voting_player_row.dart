// lib/presentation/voting/widget/voting_player_row.dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../voting_rights/model/voting_model.dart';

class VotingPlayerRow extends StatelessWidget {
  final int index;
  final PlayerCandidate player;
  final bool selected;
  final bool isLastItem;
  final VoidCallback onTap;

  const VotingPlayerRow({
    super.key,
    required this.index,
    required this.player,
    required this.selected,
    this.isLastItem = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          border: isLastItem
              ? null
              : Border(
            bottom: BorderSide(
              color: Colors.white.withOpacity(0.05),
              width: 1,
            ),
          ),
          borderRadius: isLastItem
              ? const BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          )
              : null,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Index
            SizedBox(
              width: 24,
              child: Text(
                index.toString(),
                style: TextStyle(
                  color: selected ? AppColors.primary : Colors.white.withOpacity(0.6),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Avatar
            CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage(player.avatarUrl),
              backgroundColor: Colors.grey[800],
            ),

            const SizedBox(width: 12),

            // Player Name
            Expanded(
              flex: 2,
              child: Text(
                player.name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.2,
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Jersey Number
            SizedBox(
              width: 55,
              child: Text(
                '#${player.number}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            // Position
            SizedBox(
              width: 70,
              child: Text(
                player.position,
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}