// lib/presentation/voting/view/voting_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metalheadd/core/route/route_name.dart';
import '../../../core/constants/app_colors.dart';
import '../viewmodel/voting_provider.dart';
import '../widget/voting_rights_card.dart';
import '../widget/voting_table_header.dart';
import '../widget/voting_player_row.dart';

class VotingScreen extends ConsumerWidget {
  final String matchId;
  const VotingScreen({super.key, required this.matchId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(votingProvider(matchId));

    return Scaffold(
      backgroundColor: Colors.black, // Pure black background
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Vote for Player of the Match',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: state.data.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFFFFE600))),
        error: (e, st) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.red))),
        data: (data) {
          return Stack(
            children: [
              // --- SCROLLABLE CONTENT ---
              ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 120), // Bottom padding for Submit Bar
                children: [
                  // 1. Accept rights card (styled as an inset container)
                  VotingRightsCard(
                    rights: data.rights,
                    onAccept: () => ref.read(votingProvider(matchId).notifier).acceptRights(),
                  ),

                  const SizedBox(height: 24),

                  // 2. Table Section Header
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

                  // 3. Player Table Card
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF111111),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [
                        const VotingTableHeader(), // Custom header widget
                        const Divider(color: Colors.white10, height: 1),
                        ...List.generate(data.candidates.length, (i) {
                          final player = data.candidates[i];
                          final isSelected = state.selectedCandidateId == player.id;

                          return VotingPlayerRow(
                            index: i + 1,
                            player: player,
                            selected: isSelected,
                            onTap: () => ref.read(votingProvider(matchId).notifier).selectCandidate(player.id),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),

              // --- STICKY SUBMIT BAR ---
              _buildSubmitBar(context, ref, data, state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSubmitBar(BuildContext context, WidgetRef ref, dynamic data, dynamic state) {
    bool canSubmit = data.rights.accepted && state.selectedCandidateId != null;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 34), // Adjust for notch/bottom safe area
        decoration: BoxDecoration(
          color: Colors.black,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.8), blurRadius: 20, offset: const Offset(0, -10))
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFE600), // Primary Yellow
              disabledBackgroundColor: const Color(0xFFFFE600).withOpacity(0.2),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              elevation: 0,
            ),
            onPressed: (canSubmit && !state.submitting)
                ? () async {
              await ref.read(votingProvider(matchId).notifier).submitVote();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Vote submitted successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            }
                : null,
            child: state.submitting
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                : Text(
              'Submit Vote',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: canSubmit ? Colors.black : Colors.white30,
              ),
            ),
          ),
        ),
      ),
    );
  }
}