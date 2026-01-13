
// match_details/widget/match_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/match_details_provider.dart';

class MatchHeader extends ConsumerWidget {
  final String matchId;
  const MatchHeader({super.key, required this.matchId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchAsync = ref.watch(matchDetailsProvider(matchId));
    return matchAsync.when(
      loading: () => const _HeaderSkeleton(),
      error: (e, _) => _HeaderError(error: e.toString()),
      data: (m) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: const Color(0xFF1F1F1F)),
          child: Row(
            children: [
              _TeamInfo(name: m.home.name, short: m.home.shortName, logo: m.home.logoUrl),
              const Spacer(),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${m.homeScore} - ${m.awayScore}',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white)),
                  const SizedBox(height: 4),
                  Text(m.competition, style: const TextStyle(color: Colors.white70)),
                  Text(_formatDate(m.kickoff), style: const TextStyle(color: Colors.white54)),
                ],
              ),
              const Spacer(),
              _TeamInfo(name: m.away.name, short: m.away.shortName, logo: m.away.logoUrl, alignRight: true),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(DateTime dt) {
    // e.g., "Tue, 13 Jan 2026"
    return '${['Sun','Mon','Tue','Wed','Thu','Fri','Sat'][dt.weekday % 7]}, ${dt.day} '
        '${['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][dt.month - 1]} ${dt.year}';
  }
}

class _HeaderSkeleton extends StatelessWidget {
  const _HeaderSkeleton();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF1F1F1F),
      child: const Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }
}

class _HeaderError extends StatelessWidget {
  final String error;
  const _HeaderError({required this.error});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF1F1F1F),
      child: Text('Error: $error', style: const TextStyle(color: Colors.redAccent)),
    );
  }
}

class _TeamInfo extends StatelessWidget {
  final String name;
  final String short;
  final String logo;
  final bool alignRight;
  const _TeamInfo({required this.name, required this.short, required this.logo, this.alignRight = false});

  @override
  Widget build(BuildContext context) {
    final text = Column(
      crossAxisAlignment: alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        Text(short, style: const TextStyle(color: Colors.white70)),
      ],
    );

    final avatar = CircleAvatar(backgroundImage: AssetImage(logo), radius: 20);

    return Row(
      children: alignRight ? [text, const SizedBox(width: 8), avatar] : [avatar, const SizedBox(width: 8), text],
    );
  }
}

