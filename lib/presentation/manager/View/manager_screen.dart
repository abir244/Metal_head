import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../ ViewModels/manager_provider.dart';
import 'match_publish_screen.dart'; // We will create this next

class ManagerAccessScreen extends ConsumerWidget {
  const ManagerAccessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeMatch = ref.watch(activeManagerMatchProvider);
    final allMatches = ref.watch(managerMatchesProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
          onPressed: () {
            if (activeMatch != null) ref.read(selectedMatchIdProvider.notifier).state = null;
          },
        ),
        title: const Text("Manager Access", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (activeMatch == null) ...[
              const _SectionLabel("Match List Management"),
              ...allMatches.map((m) => _MatchCard(match: m)).toList(),
            ] else ...[
              const _SectionLabel("Players Management"),
              _MatchCard(match: activeMatch),
              const SizedBox(height: 20),
              _buildActionRow("Create Voting Player List", Icons.emoji_events_outlined),
              const SizedBox(height: 25),
              _buildResultPreview(context, activeMatch),
              const SizedBox(height: 40),
              const Center(child: Text("Match Time", style: TextStyle(color: Colors.white54))),
              const SizedBox(height: 15),
              _buildTimer(),
              const SizedBox(height: 30),
              _buildControlBtn(ref, activeMatch),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildResultPreview(BuildContext context, ManagerMatch match) => Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Match Result", style: TextStyle(color: Colors.white54)),
          TextButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MatchPublishScreen())),
            child: const Text("Edit", style: TextStyle(color: Color(0xFFFFE100))),
          ),
        ],
      ),
      Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(colors: [Color(0xFF1A1A1A), Color(0xFF0A0A0A)]),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(match.homeLogo, height: 45),
            Text("${match.homeScore} - ${match.awayScore}", style: const TextStyle(color: Color(0xFFFFE100), fontSize: 36, fontWeight: FontWeight.bold)),
            Image.asset(match.awayLogo, height: 45),
          ],
        ),
      )
    ],
  );

  Widget _buildControlBtn(WidgetRef ref, ManagerMatch match) {
    bool isLive = match.status == MatchProcess.live;
    return Center(
      child: GestureDetector(
        onTap: () {
          final newStatus = isLive ? MatchProcess.paused : MatchProcess.live;
          ref.read(managerMatchesProvider.notifier).updateMatch(match.copyWith(status: newStatus));
        },
        child: Container(
          width: 220, padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: isLive ? Colors.transparent : const Color(0xFFFFE100),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color(0xFFFFE100)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(isLive ? "Match Pause" : "Match Start", style: TextStyle(color: isLive ? const Color(0xFFFFE100) : Colors.black, fontWeight: FontWeight.bold)),
              const SizedBox(width: 10),
              Icon(isLive ? Icons.pause : Icons.play_arrow, color: isLive ? const Color(0xFFFFE100) : Colors.black),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionRow(String t, IconData i) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: const Color(0xFF111111), borderRadius: BorderRadius.circular(30)),
    child: Row(children: [Icon(i, color: Colors.white54), const SizedBox(width: 12), Expanded(child: Text(t, style: const TextStyle(color: Colors.white))), const CircleAvatar(backgroundColor: Color(0xFFFFE100), radius: 14, child: Icon(Icons.add, size: 18, color: Colors.black))]),
  );

  Widget _buildTimer() => Row(mainAxisAlignment: MainAxisAlignment.center, children: [_box("00"), const Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text(":", style: TextStyle(color: Colors.white, fontSize: 24))), _box("00")]);
  Widget _box(String v) => Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: const Color(0xFF111111), borderRadius: BorderRadius.circular(12)), child: Text(v, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)));
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 15), child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)));
}

class _MatchCard extends ConsumerWidget {
  final ManagerMatch match;
  const _MatchCard({required this.match});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => ref.read(selectedMatchIdProvider.notifier).state = match.id,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: const Color(0xFF0D0D0D), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withOpacity(0.05))),
        child: Row(
          children: [
            Expanded(child: Column(children: [_row(match.homeTeam, match.homeLogo), const SizedBox(height: 12), _row(match.awayTeam, match.awayLogo)])),
            Container(width: 1, height: 40, color: Colors.blueAccent, margin: const EdgeInsets.symmetric(horizontal: 15)),
            const Column(children: [Text("06:30 PM", style: TextStyle(color: Color(0xFFFFE100), fontWeight: FontWeight.bold)), Text("18 July 2025", style: TextStyle(color: Colors.white54, fontSize: 11))]),
          ],
        ),
      ),
    );
  }
  Widget _row(String n, String l) => Row(children: [Image.asset(l, height: 22), const SizedBox(width: 12), Text(n, style: const TextStyle(color: Colors.white, fontSize: 14))]);
}