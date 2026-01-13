
// lib/presentation/voting/widget/voting_rights_card.dart
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../voting_rights/model/voting_model.dart';

class VotingRightsCard extends StatelessWidget {
  final VotingRight rights;
  final VoidCallback onAccept;
  const VotingRightsCard({super.key, required this.rights, required this.onAccept});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top line: "Accept Voting Rights" + chevron
          Row(
            children: const [
              Expanded(
                child: Text('Accept Voting Rights',
                    style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
              ),
              Icon(Icons.chevron_right, color: AppColors.textPrimary),
            ],
          ),
          const SizedBox(height: 12),
          // Message bubble
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.primary),
            ),
            child: Text(
              'Parent ${rights.assignedByParentName} has assigned you the right to vote for ${rights.childName} as his Parent Representative.',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: rights.accepted ? AppColors.success : AppColors.primary,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: rights.accepted ? null : onAccept,
              icon: Icon(rights.accepted ? Icons.check_circle : Icons.how_to_vote),
              label: Text(rights.accepted ? 'Accepted' : 'Accept'),
            ),
          ),
        ],
      ),
    );
  }
}
