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

    return WillPopScope(
      onWillPop: () async {
        // 1️⃣ If confirm dialog is visible → close it first
        if (showFloating) {
          ref.read(floatingConfirmProvider.notifier).hide();
          return false;
        }

        // 2️⃣ Otherwise → go back to Home tab
        ref.read(navigationProvider.notifier).updateIndex(0);
        ref.read(navbarVisibleProvider.notifier).state = true;
        return false;
      },
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.background,
              elevation: 0,
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.textPrimary,
                  size: 20,
                ),
                onPressed: () {
                  ref
                      .read(navigationProvider.notifier)
                      .updateIndex(0);
                  ref
                      .read(navbarVisibleProvider.notifier)
                      .state = true;
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

            /// ===============================
            /// BODY
            /// ===============================
            body: state.data.when(
              loading: () => const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              ),
              error: (e, _) => Center(
                child: Text(
                  'Error: $e',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              data: (data) {
                return NotificationListener<UserScrollNotification>(
                  onNotification: (notification) {
                    if (notification.direction ==
                        ScrollDirection.reverse) {
                      ref
                          .read(navbarVisibleProvider.notifier)
                          .state = false;
                    } else if (notification.direction ==
                        ScrollDirection.forward) {
                      ref
                          .read(navbarVisibleProvider.notifier)
                          .state = true;
                    }
                    return true;
                  },
                  child: ListView(
                    padding:
                    const EdgeInsets.fromLTRB(16, 8, 16, 100),
                    children: [
                      /// RIGHTS CARD
                      VotingRightsCard(
                        rights: data.rights,
                        onAccept: () {
                          ref
                              .read(
                            votingProvider(matchId).notifier,
                          )
                              .acceptRights();
                        },
                      ),

                      const SizedBox(height: 20),

                      const Padding(
                        padding:
                        EdgeInsets.only(left: 4, bottom: 10),
                        child: Text(
                          'Voting Players List',
                          style: TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      /// PLAYER TABLE
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            /// HEADER
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: const BoxDecoration(
                                color: Color(0xFF242424),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                              ),
                              child: Row(
                                children: [
                                  _headerText('No.', 24),
                                  const SizedBox(width: 32),
                                  _headerText(
                                    'Name',
                                    null,
                                    flex: 2,
                                  ),
                                  _headerText(
                                    'Number',
                                    55,
                                    align: TextAlign.center,
                                  ),
                                  _headerText(
                                    'Position',
                                    70,
                                    align: TextAlign.end,
                                  ),
                                ],
                              ),
                            ),

                            /// PLAYER ROWS
                            ...List.generate(
                              data.candidates.length,
                                  (i) {
                                final player = data.candidates[i];
                                final isSelected =
                                    state.selectedCandidateId ==
                                        player.id;

                                return VotingPlayerRow(
                                  index: i + 1,
                                  player: player,
                                  selected: isSelected,
                                  isLastItem:
                                  i ==
                                      data.candidates.length -
                                          1,
                                  onTap: () {
                                    ref
                                        .read(
                                      votingProvider(matchId)
                                          .notifier,
                                    )
                                        .selectCandidate(player.id);

                                    ref
                                        .read(
                                      floatingConfirmProvider
                                          .notifier,
                                    )
                                        .show();
                                  },
                                );
                              },
                            ),
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

          /// ===============================
          /// FLOATING CONFIRM OVERLAY
          /// ===============================
          if (showFloating)
            FloatingConfirmScreen(
              title: 'Confirm Vote',
              message:
              'Are you sure you want to vote for this player?',
              onConfirm: () async {
                await ref
                    .read(
                  votingProvider(matchId).notifier,
                )
                    .submitVote();

                ref
                    .read(
                  floatingConfirmProvider.notifier,
                )
                    .hide();

                ref
                    .read(
                  navbarVisibleProvider.notifier,
                )
                    .state = true;

                ref
                    .read(
                  navigationProvider.notifier,
                )
                    .updateIndex(0);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Thanks for voting!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  /// ===============================
  /// HEADER TEXT HELPER
  /// ===============================
  Widget _headerText(
      String text,
      double? width, {
        int flex = 1,
        TextAlign align = TextAlign.start,
      }) {
    final child = Text(
      text,
      textAlign: align,
      style: TextStyle(
        color: Colors.white.withOpacity(0.4),
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
    );

    if (width != null) {
      return SizedBox(width: width, child: child);
    }
    return Expanded(flex: flex, child: child);
  }
}
