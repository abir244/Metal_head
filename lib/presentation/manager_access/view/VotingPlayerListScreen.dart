import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metalheadd/core/constants/app_colors.dart';
import 'package:metalheadd/core/theme/app_text_styles.dart';
import '../viewmodel/voting_players_provider.dart';

class VotingPlayerListScreen extends ConsumerStatefulWidget {
  const VotingPlayerListScreen({super.key});

  @override
  ConsumerState<VotingPlayerListScreen> createState() => _VotingPlayerListScreenState();
}

class _VotingPlayerListScreenState extends ConsumerState<VotingPlayerListScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numController = TextEditingController();
  final TextEditingController _posController = TextEditingController();

  void _showAddPlayerBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          left: 20, right: 20, top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Add New Player', style: AppTextStyles.heading18SemiBold.copyWith(color: Colors.white)),
            const SizedBox(height: 20),
            _buildInput(_nameController, "Full Name"),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildInput(_numController, "Number", isNum: true)),
                const SizedBox(width: 12),
                Expanded(child: _buildInput(_posController, "Position")),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity, height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                onPressed: () {
                  if (_nameController.text.isNotEmpty) {
                    ref.read(votingPlayersProvider.notifier).addPlayer(
                      name: _nameController.text.trim(),
                      number: _numController.text.trim(),
                      position: _posController.text.trim(),
                    );
                    _nameController.clear(); _numController.clear(); _posController.clear();
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add to List', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(TextEditingController controller, String hint, {bool isNum = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNum ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.hint14Regular,
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final players = ref.watch(votingPlayersProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20), onPressed: () => Navigator.pop(context)),
        title: Text('Voting Player List', style: AppTextStyles.heading18SemiBold.copyWith(color: Colors.white)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header Card
          _buildTopCard(),
          const SizedBox(height: 32),
          Text("Voting Players List", style: AppTextStyles.heading18SemiBold.copyWith(color: Colors.white)),
          const SizedBox(height: 16),
          // Table Labels
          _buildLabels(),
          // Player Rows
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: players.length,
            itemBuilder: (context, index) => _PlayerRow(
              index: index + 1,
              player: players[index],
              isFirst: index == 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withOpacity(0.05))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            const Icon(Icons.emoji_events_outlined, color: Colors.white, size: 22),
            const SizedBox(width: 12),
            Text("Create Voting Player List", style: AppTextStyles.body14SemiBold),
          ]),
          GestureDetector(
            onTap: _showAddPlayerBottomSheet,
            child: Container(padding: const EdgeInsets.all(8), decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle), child: const Icon(Icons.add, color: Colors.black, size: 20)),
          )
        ],
      ),
    );
  }

  Widget _buildLabels() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          SizedBox(width: 30, child: Text("No.", style: _labelStyle)),
          SizedBox(width: 12),
          Expanded(flex: 3, child: Text("Name", style: _labelStyle)),
          Expanded(flex: 1, child: Text("Number", textAlign: TextAlign.center, style: _labelStyle)),
          Expanded(flex: 2, child: Text("Position", textAlign: TextAlign.end, style: _labelStyle)),
        ],
      ),
    );
  }

  static const _labelStyle = TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w500);
}

class _PlayerRow extends StatelessWidget {
  final int index;
  final VotingPlayer player;
  final bool isFirst;

  const _PlayerRow({required this.index, required this.player, this.isFirst = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF161616),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isFirst ? AppColors.primary.withOpacity(0.6) : Colors.white.withOpacity(0.05), width: isFirst ? 1.2 : 1),
      ),
      child: Row(
        children: [
          SizedBox(width: 30, child: Text("$index", style: const TextStyle(color: Colors.white, fontSize: 13))),
          const SizedBox(width: 12),
          Expanded(flex: 3, child: Row(children: [
            CircleAvatar(radius: 14, backgroundImage: NetworkImage(player.photoUrl ?? "")),
            const SizedBox(width: 10),
            Expanded(child: Text(player.name, style: AppTextStyles.body14Medium.copyWith(color: Colors.white), overflow: TextOverflow.ellipsis)),
          ])),
          Expanded(flex: 1, child: Text("#${player.number}", textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13))),
          Expanded(flex: 2, child: Text(player.position, textAlign: TextAlign.end, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13))),
        ],
      ),
    );
  }
}