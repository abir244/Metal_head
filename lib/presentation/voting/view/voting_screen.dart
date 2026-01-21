import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:metalheadd/core/constants/app_colors.dart';
import '../../../core/theme/theme_provider.dart';
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
    final isDarkMode = ref.watch(themeProvider);

    // Dynamic colors
    final bgColor = isDarkMode ? Colors.black : Colors.grey[100]!;
    final headerBgColor = isDarkMode ? const Color(0xFF242424) : Colors.grey[300]!;
    final cardBgColor = isDarkMode ? const Color(0xFF1A1A1A) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subTextColor = isDarkMode ? Colors.white70 : Colors.black54;
    final headerTextColor = isDarkMode ? Colors.white.withOpacity(0.4) : Colors.black.withOpacity(0.6);

    return WillPopScope(
      onWillPop: () async {
        if (showFloating) {
          ref.read(floatingConfirmProvider.notifier).hide();
          return false;
        }
        ref.read(navigationProvider.notifier).updateIndex(0);
        ref.read(navbarVisibleProvider.notifier).state = true;
        return false;
      },
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: bgColor,
            appBar: AppBar(
              backgroundColor: bgColor,
              elevation: 0,
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded, color: textColor, size: 20),
                onPressed: () {
                  ref.read(navigationProvider.notifier).updateIndex(0);
                  ref.read(navbarVisibleProvider.notifier).state = true;
                },
              ),
              title: Text(
                'Vote for Player of the Match',
                style: TextStyle(color: textColor, fontWeight: FontWeight.w600, fontSize: 17, letterSpacing: -0.3),
              ),
            ),
            body: state.data.when(
              loading: () => Center(child: CircularProgressIndicator(color: AppColors.primary)),
              error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.red))),
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
                      // Voting Rights Card
                      VotingRightsCard(
                        rights: data.rights,
                        onAccept: () => ref.read(votingProvider(matchId).notifier).acceptRights(),
                        isDarkMode: isDarkMode, // ✅ Pass dark mode
                      ),
                      const SizedBox(height: 20),

                      // Players List Title
                      Padding(
                        padding: const EdgeInsets.only(left: 4, bottom: 10),
                        child: Text(
                          'Voting Players List',
                          style: TextStyle(color: subTextColor, fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ),

                      // Player Table
                      Container(
                        decoration: BoxDecoration(color: cardBgColor, borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          children: [
                            // Table Header
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: headerBgColor,
                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                              ),
                              child: Row(
                                children: [
                                  _headerText('No.', 24, headerTextColor),
                                  const SizedBox(width: 32),
                                  _headerText('Name', null, headerTextColor, flex: 2),
                                  _headerText('Number', 55, headerTextColor, align: TextAlign.center),
                                  _headerText('Position', 70, headerTextColor, align: TextAlign.end),
                                ],
                              ),
                            ),

                            // Player Rows
                            ...List.generate(data.candidates.length, (i) {
                              final player = data.candidates[i];
                              final isSelected = state.selectedCandidateId == player.id;

                              return VotingPlayerRow(
                                index: i + 1,
                                player: player,
                                selected: isSelected,
                                isLastItem: i == data.candidates.length - 1,
                                isDarkMode: isDarkMode, // ✅ Pass dark mode
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

          // Floating Confirm Overlay
          if (showFloating)
            FloatingConfirmScreen(
              title: 'Confirm Vote',
              message: 'Are you sure you want to vote for this player?',
              isDarkMode: isDarkMode, // ✅ Pass dark mode
              onConfirm: () async {
                await ref.read(votingProvider(matchId).notifier).submitVote();
                ref.read(floatingConfirmProvider.notifier).hide();
                ref.read(navbarVisibleProvider.notifier).state = true;
                ref.read(navigationProvider.notifier).updateIndex(0);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Thanks for voting!'), backgroundColor: Colors.green),
                );
              },
            ),
        ],
      ),
    );
  }

  /// Header Text Helper
  Widget _headerText(String text, double? width, Color color, {int flex = 1, TextAlign align = TextAlign.start}) {
    final child = Text(text, textAlign: align, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600));
    if (width != null) return SizedBox(width: width, child: child);
    return Expanded(flex: flex, child: child);
  }
}
