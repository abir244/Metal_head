import 'package:flutter/material.dart';
import 'package:metalheadd/presentation/voting_rights/view/%20widgets/player_info_tile.dart';

import '../../../core/constants/app_colors.dart';


class AssignVotingRightsPage extends StatefulWidget {
  const AssignVotingRightsPage({super.key});

  @override
  State<AssignVotingRightsPage> createState() => _AssignVotingRightsPageState();
}

class _AssignVotingRightsPageState extends State<AssignVotingRightsPage> {
  bool isAgreed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const Icon(Icons.chevron_left, color: Colors.white, size: 32),
        title: const Text("Assign Voting Rights", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PlayerInfoTile(
                name: "Roger Dokidis",
                position: "Midfielder",
                imageUrl: "https://i.pravatar.cc/150?u=roger",
              ),
              const SizedBox(height: 24),
              const Text("Select Parent to Assign Voting Right",
                  style: TextStyle(color: AppColors.textGrey, fontSize: 13)),
              const SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  hintText: "Andy Lexsian",
                  hintStyle: const TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: AppColors.fieldBackground,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: isAgreed,
                    onChanged: (v) => setState(() => isAgreed = v!),
                    side: const BorderSide(color: Colors.white),
                    checkColor: Colors.black,
                    activeColor: AppColors.primaryYellow,
                  ),
                  const Expanded(
                    child: Text("I agree to assign voting rights to this parent",
                        style: TextStyle(color: Colors.white, fontSize: 13)),
                  )
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryYellow,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Text("Assign Voting Rights"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}