import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../voting_rights/model/voting_model.dart';

class VotingPlayerRow extends StatelessWidget {
  final int index;
  final PlayerCandidate player;
  final bool selected;
  final bool isLastItem;
  final bool isDarkMode; // ✅ fixed type
  final VoidCallback onTap;

  const VotingPlayerRow({
    super.key,
    required this.index,
    required this.player,
    required this.selected,
    this.isLastItem = false,
    required this.onTap,
    required this.isDarkMode, // ✅ fixed
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isDarkMode ? const Color(0xFF1A1A1A) : Colors.white;
    final borderColor = isDarkMode ? Colors.white.withOpacity(0.05) : Colors.black12;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subTextColor = isDarkMode ? Colors.white.withOpacity(0.5) : Colors.black45;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          border: isLastItem
              ? null
              : Border(
            bottom: BorderSide(
              color: borderColor,
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
                  color: selected ? AppColors.primary : subTextColor,
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
                style: TextStyle(
                  color: textColor,
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
                  color: subTextColor,
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
                  color: subTextColor,
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
