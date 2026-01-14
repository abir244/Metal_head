import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../ ViewModels/manager_provider.dart';


class MatchPublishScreen extends ConsumerStatefulWidget {
  const MatchPublishScreen({super.key});
  @override
  ConsumerState<MatchPublishScreen> createState() => _MatchPublishScreenState();
}

class _MatchPublishScreenState extends ConsumerState<MatchPublishScreen> {
  late TextEditingController _homeScoreController;
  late TextEditingController _awayScoreController;

  @override
  void initState() {
    super.initState();
    final match = ref.read(activeManagerMatchProvider);
    _homeScoreController = TextEditingController(text: match?.homeScore.toString());
    _awayScoreController = TextEditingController(text: match?.awayScore.toString());
  }

  @override
  Widget build(BuildContext context) {
    final match = ref.watch(activeManagerMatchProvider);
    if (match == null) return const Scaffold();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black, title: const Text("Match Result Publish", style: TextStyle(color: Colors.white))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              _scoreInput("Team A Score", _homeScoreController),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text("-", style: TextStyle(color: Colors.white, fontSize: 24))),
              _scoreInput("Team B Score", _awayScoreController),
            ]),
            const SizedBox(height: 30),
            _chipSection("Goal Scorer", match.scorers, (val) {
              final newList = match.scorers.where((s) => s != val).toList();
              ref.read(managerMatchesProvider.notifier).updateMatch(match.copyWith(sc: newList));
            }),
            const SizedBox(height: 30),
            _addSection("Goal Scorer", () {
              ref.read(managerMatchesProvider.notifier).updateMatch(match.copyWith(sc: [...match.scorers, "New Scorer"]));
            }),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFE100), minimumSize: const Size(double.infinity, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
              onPressed: () {
                final updated = match.copyWith(
                  hScore: int.tryParse(_homeScoreController.text),
                  aScore: int.tryParse(_awayScoreController.text),
                  status: MatchProcess.finished,
                );
                ref.read(managerMatchesProvider.notifier).updateMatch(updated);
                Navigator.pop(context);
              },
              child: const Text("Match Result Publish", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }

  Widget _scoreInput(String l, TextEditingController c) => Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(l, style: const TextStyle(color: Colors.white54, fontSize: 12)), const SizedBox(height: 8), TextField(controller: c, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold), decoration: InputDecoration(fillColor: const Color(0xFF111111), filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none)))]));

  Widget _chipSection(String t, List<String> items, Function(String) onDel) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t, style: const TextStyle(color: Colors.white54)), const SizedBox(height: 10), Container(width: double.infinity, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFF111111), borderRadius: BorderRadius.circular(15)), child: Wrap(spacing: 8, children: items.map((i) => Chip(label: Text(i, style: const TextStyle(color: Colors.white, fontSize: 12)), backgroundColor: const Color(0xFF222222), onDeleted: () => onDel(i))).toList()))]);

  Widget _addSection(String l, VoidCallback onAdd) => Row(children: [Expanded(child: Container(padding: const EdgeInsets.symmetric(horizontal: 16), decoration: BoxDecoration(color: const Color(0xFF111111), borderRadius: BorderRadius.circular(30)), child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: "Player", items: const [DropdownMenuItem(value: "Player", child: Text("Select Player", style: TextStyle(color: Colors.white54)))], onChanged: null)))), const SizedBox(width: 10), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFE100), shape: const CircleBorder(), padding: const EdgeInsets.all(15)), onPressed: onAdd, child: const Icon(Icons.add, color: Colors.black))]);
}