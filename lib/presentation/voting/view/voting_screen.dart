// lib/presentation/voting/view/voting_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'; // UPDATED: Required for ScrollDirection
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metalheadd/core/constants/app_colors.dart';
import '../../home/view/widgets/bottom_navbar.dart';
import '../viewmodel/voting_provider.dart';
import '../widget/voting_rights_card.dart';
import '../widget/voting_table_header.dart';
import '../widget/voting_player_row.dart';
import '../../common/floating_confirm/view/floating_confirm_screen.dart';
import '../../common/floating_confirm/viewmodel/floating_confirm_provider.dart';

class VotingScreen extends ConsumerWidget {
  const VotingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchId = 'default_match_id';
    final state = ref.watch(votingProvider(matchId));
    final showFloating = ref.watch(floatingConfirmProvider);

    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.chevron_left, color: AppColors.textPrimary, size: 30),
              onPressed: () {
                // UPDATED: Reset navbar visibility when going back to Home
                ref.read(navbarVisibleProvider.notifier).state = true;
                ref.read(navigationProvider.notifier).updateIndex(0);
              },
            ),
            title: const Text(
              'Vote for Player of the Match',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          body: state.data.when(
            loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
            error: (e, st) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.red))),
            data: (data) {
              // UPDATED: Added NotificationListener to detect scroll direction for navbar hiding
              return NotificationListener<UserScrollNotification>(
                onNotification: (notification) {
                  if (notification.direction == ScrollDirection.reverse) {
                    // User scrolls DOWN -> Hide Navbar
                    ref.read(navbarVisibleProvider.notifier).state = false;
                  } else if (notification.direction == ScrollDirection.forward) {
                    // User scrolls UP -> Show Navbar
                    ref.read(navbarVisibleProvider.notifier).state = true;
                  }
                  return true;
                },
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 120), // Increased bottom padding for safe area
                  children: [
                    VotingRightsCard(
                      rights: data.rights,
                      onAccept: () => ref.read(votingProvider(matchId).notifier).acceptRights(),
                    ),
                    const SizedBox(height: 24),

                    const Padding(
                      padding: EdgeInsets.only(left: 4, bottom: 12),
                      child: Text(
                        'Voting Players List',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF111111),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        children: [
                          const VotingTableHeader(),
                          const Divider(color: Colors.white10, height: 1),
                          ...List.generate(data.candidates.length, (i) {
                            final player = data.candidates[i];
                            final isSelected = state.selectedCandidateId == player.id;

                            return VotingPlayerRow(
                              index: i + 1,
                              player: player,
                              selected: isSelected,
                              onTap: () {
                                ref.read(votingProvider(matchId).notifier).selectCandidate(player.id);
                                ref.read(floatingConfirmProvider.notifier).show();
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        if (showFloating)
          FloatingConfirmScreen(
            title: 'Confirm Vote',
            message: 'Are you sure you want to vote for this player?',
            onConfirm: () async {
              await ref.read(votingProvider(matchId).notifier).submitVote();
              ref.read(floatingConfirmProvider.notifier).hide();

              // UPDATED: Reset navbar visibility when returning Home after success
              ref.read(navbarVisibleProvider.notifier).state = true;
              ref.read(navigationProvider.notifier).updateIndex(0);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Thanks for voting!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
      ],
    );
  }
}