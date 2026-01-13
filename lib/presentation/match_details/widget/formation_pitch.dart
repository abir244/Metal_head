import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodel/formation_provider.dart';
import '../viewmodel/match_details_provider.dart';
// import '../viewmodel/formation_provider.dart'; // Keep your imports
// import '../viewmodel/match_details_provider.dart';

class FormationPitch extends ConsumerWidget {
  final String matchId;
  const FormationPitch({super.key, required this.matchId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Assuming these providers return a list of objects with x, y (0-100)
    final matchAsync = ref.watch(matchDetailsProvider(matchId));
    final homeCoords = ref.watch(homePositionsProvider);
    final awayCoords = ref.watch(awayPositionsProvider);

    return matchAsync.maybeWhen(
      data: (m) {
        final home = m.homeLineup.starters;
        final away = m.awayLineup.starters;

        return AspectRatio(
          aspectRatio: 3 / 4, // Taller ratio looks better on mobile
          child: Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
              // Mowed grass pattern
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF2D5A27), Color(0xFF356E2F)],
                stops: [0.0, 1.0],
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  _PitchPattern(),
                  _PitchLines(),

                  // Use LayoutBuilder to position players correctly based on container size
                  LayoutBuilder(builder: (context, constraints) {
                    return Stack(
                      children: [
                        // Away Players (Top half)
                        for (int i = 0; i < awayCoords.length && i < away.length; i++)
                          _PositionedPlayer(
                            coord: awayCoords[i],
                            name: away[i].player.name,
                            number: away[i].player.shirtNumber,
                            color: const Color(0xFF111827), // Dark jersey
                            textColor: Colors.white,
                            constraints: constraints,
                          ),
                        // Home Players (Bottom half)
                        for (int i = 0; i < homeCoords.length && i < home.length; i++)
                          _PositionedPlayer(
                            coord: homeCoords[i],
                            name: home[i].player.name,
                            number: home[i].player.shirtNumber,
                            color: Colors.white, // White jersey
                            textColor: Colors.black,
                            constraints: constraints,
                          ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _PositionedPlayer extends StatelessWidget {
  final dynamic coord; // PitchCoord
  final String name;
  final int number;
  final Color color;
  final Color textColor;
  final BoxConstraints constraints;

  const _PositionedPlayer({
    required this.coord,
    required this.name,
    required this.number,
    required this.color,
    required this.textColor,
    required this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    // Convert 0-100 coordinates to 0.0-1.0 percentages
    // Football API coords usually treat 0,0 as top-left.
    final double left = (coord.x / 100) * constraints.maxWidth;
    final double top = (coord.y / 100) * constraints.maxHeight;

    return Positioned(
      left: left - 30, // Offset by half of player widget width
      top: top - 30,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
                boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 4, offset: Offset(0, 2))],
              ),
              alignment: Alignment.center,
              child: Text(
                '$number',
                style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              name.split(' ').last, // Show last name only to save space
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w500,
                shadows: [Shadow(color: Colors.black, blurRadius: 4)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PitchPattern extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          tileMode: TileMode.repeated,
          colors: [
            Colors.black.withOpacity(0.05),
            Colors.transparent,
          ],
          stops: const [0.5, 0.5],
        ),
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        return Column(
          children: List.generate(
            10, // Create 10 horizontal stripes
                (index) => Expanded(
              child: Container(
                color: index % 2 == 0 ? Colors.white.withOpacity(0.03) : Colors.transparent,
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _PitchLines extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PitchPainter(),
      size: Size.infinite,
    );
  }
}

class _PitchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final rect = Rect.fromLTWH(10, 10, size.width - 20, size.height - 20);

    // Boundary
    canvas.drawRect(rect, line);
    // Center Line
    canvas.drawLine(Offset(rect.left, size.height / 2), Offset(rect.right, size.height / 2), line);
    // Center Circle
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 40, line);

    // Penalty Areas
    final areaW = size.width * 0.6;
    final areaH = size.height * 0.15;

    // Top Area
    canvas.drawRect(Rect.fromCenter(center: Offset(size.width / 2, rect.top + areaH / 2), width: areaW, height: areaH), line);
    // Bottom Area
    canvas.drawRect(Rect.fromCenter(center: Offset(size.width / 2, rect.bottom - areaH / 2), width: areaW, height: areaH), line);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}