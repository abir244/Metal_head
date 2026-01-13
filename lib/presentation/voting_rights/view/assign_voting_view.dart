// lib/features/voting/view/assign_voting_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import ' widgets/voting_widgets.dart';
import '../viewmodel/assign_voting_viewmodel.dart';

class AssignVotingView extends ConsumerWidget {
  const AssignVotingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(assignVotingProvider);
    final viewModel = ref.read(assignVotingProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Assign Voting Rights", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: const Icon(Icons.chevron_left, size: 30),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF111111),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PlayerTile(
                name: "Roger Dokidis",
                role: "Midfielder",
                imageUrl: "https://i.pravatar.cc/150?u=1",
              ),
              const SizedBox(height: 24),
              const LabelText("Select Parent to Assign Voting Right"),
              const SizedBox(height: 12),
              const CustomPillField(hint: "Andy Lexsian"),
              const SizedBox(height: 20),

              // Agreement Checkbox
              Row(
                children: [
                  Checkbox(
                    value: state.isAgreed,
                    onChanged: (val) => viewModel.toggleAgreement(val ?? false),
                    activeColor: const Color(0xFFFFE600),
                    side: const BorderSide(color: Colors.white54),
                  ),
                  const Expanded(
                    child: Text("I agree to assign voting rights to this parent",
                        style: TextStyle(color: Colors.white, fontSize: 13)),
                  )
                ],
              ),

              const SizedBox(height: 24),
              YellowPrimaryButton(
                text: "Assign Voting Rights",
                isLoading: state.isLoading,
                onPressed: state.isAgreed ? () => viewModel.submitAssignment() : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}