// lib/presentation/voting/widget/voting_rights_card.dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../voting_rights/model/voting_model.dart';

class VotingRightsCard extends StatelessWidget {
  final VotingRight rights;
  final VoidCallback onAccept;

  const VotingRightsCard({
    super.key,
    required this.rights,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top line: "Accept Voting Rights" + chevron
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Accept Voting Rights',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.white.withOpacity(0.6),
                size: 20,
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Message bubble
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              'Parent ${rights.assignedByParentName} has assigned you the right to vote for ${rights.childName} as his Parent Representative.',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 13,
                height: 1.4,
                letterSpacing: -0.1,
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Accept button
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: 36,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: rights.accepted
                      ? AppColors.success
                      : AppColors.primary,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                onPressed: rights.accepted ? null : onAccept,
                icon: Icon(
                  rights.accepted ? Icons.check_circle : Icons.how_to_vote,
                  size: 18,
                ),
                label: Text(
                  rights.accepted ? 'Accepted' : 'Accept',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}