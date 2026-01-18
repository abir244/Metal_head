import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metalheadd/core/constants/app_colors.dart';
import 'package:metalheadd/core/theme/app_text_styles.dart';

import '../../viewmodel/voting_players_provider.dart';
import '../VotingPlayerListScreen.dart';


class VotingPlayerListButton extends ConsumerWidget {
  const VotingPlayerListButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final players = ref.watch(votingPlayersProvider);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VotingPlayerListScreen())),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  const Icon(Icons.group_add_outlined, size: 22, color: AppColors.textPrimary),
                  const SizedBox(width: 12),
                  Text("Voting Player List", style: AppTextStyles.body14SemiBold),
                ]),
                const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textSecondary),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Preview Top 3
          ...players.take(3).map((player) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withOpacity(0.05))),
            child: Row(
              children: [
                CircleAvatar(radius: 10, backgroundImage: NetworkImage(player.photoUrl ?? "")),
                const SizedBox(width: 10),
                Text(player.name, style: AppTextStyles.body14Regular),
              ],
            ),
          )),
          if (players.length > 3)
            Center(child: Text("+ ${players.length - 3} more players", style: AppTextStyles.overline10Medium.copyWith(color: AppColors.primary))),
        ],
      ),
    );
  }
}