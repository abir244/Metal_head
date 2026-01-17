// lib/presentation/voting/view/voting_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metalheadd/core/constants/app_colors.dart';
import '../../home/view/widgets/bottom_navbar.dart';
import '../viewmodel/voting_provider.dart';
import '../widget/voting_rights_card.dart';
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
            centerTitle: false,
            leading: IconButton(
              icon: const Icon(Icons.chevron_left, color: AppColors.textPrimary, size: 28),
              onPressed: () {
                Navigator.of(context).pop();
                ref.read(navbarVisibleProvider.notifier).state = true;
              },
            ),
            title: const Text(
              'Vote for Player of the Match',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 17,
                letterSpacing: -0.3,
              ),
            ),
          ),
          body: state.data.when(
            loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
            error: (e, st) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.red))),
            data: (data) {
              return NotificationListener<UserScrollNotification>(
                onNotification: (notification) {
                  if (notification.direction == ScrollDirection.reverse) {
                    ref.read(navbarVisibleProvider.notifier).state = false;
                  } else if (notification.direction == ScrollDirection.forward) {
                    ref.read(navbarVisibleProvider.notifier).state = true;
                  }
                  return true;
                },
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  children: [
                    VotingRightsCard(
                      rights: data.rights,
                      onAccept: () => ref.read(votingProvider(matchId).notifier).acceptRights(),
                    ),
                    const SizedBox(height: 20),

                    const Padding(
                      padding: EdgeInsets.only(left: 4, bottom: 10),
                      child: Text(
                        'Voting Players List',
                        style: TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),

                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          // Header
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF242424),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 24,
                                  child: Text(
                                    'No.',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.4),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 32),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Name',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.4),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 55,
                                  child: Text(
                                    'Number',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.4),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 70,
                                  child: Text(
                                    'Position',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.4),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Player rows
                          ...List.generate(data.candidates.length, (i) {
                            final player = data.candidates[i];
                            final isSelected = state.selectedCandidateId == player.id;

                            return VotingPlayerRow(
                              index: i + 1,
                              player: player,
                              selected: isSelected,
                              isLastItem: i == data.candidates.length - 1,
                              onTap: () {
                                ref.read(votingProvider(matchId).notifier).selectCandidate(player.id);
                                ref.read(floatingConfirmProvider.notifier).show();
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
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