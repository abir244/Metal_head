import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../home/view/widgets/bottom_navbar.dart';

class PlayerScreen extends ConsumerStatefulWidget {
  const PlayerScreen({super.key});

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {

  @override
  void initState() {
    super.initState();

    /// 🔽 Hide bottom navbar when entering PlayerScreen
    Future.microtask(() {
      ref.read(navbarVisibleProvider.notifier).state = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        /// 🔙 Back → Home tab + show navbar
        ref.read(navigationProvider.notifier).updateIndex(0);
        ref.read(navbarVisibleProvider.notifier).state = true;
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            'Player of the Match',
            style: AppTextStyles.heading20SemiBold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
          },
          color: AppColors.primary,
          backgroundColor: AppColors.surface,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Today Player of the Match'),
                const SizedBox(height: 12),
                _buildPlayerOfMatchCard(
                  playerNumber: '10',
                  playerName: 'Jude \nBellingham',
                  score: '0-3',
                  imageUrl:
                  'https://assets.laliga.com/assets/2024/12/27/large/c5b5b7a3480baf01b31091d038f3f16f.jpeg',
                  homeTeamLogo: Icons.sports_soccer,
                  awayTeamLogo: Icons.sports,
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Yesterday Player of the Match'),
                const SizedBox(height: 12),
                _buildPlayerOfMatchCard(
                  playerNumber: '27',
                  playerName: 'Lamine \nYamal',
                  score: '0-2',
                  imageUrl:
                  'https://assets.laliga.com/assets/2024/09/09/large/7d1fd6926895af60e0b19da2e0c025e9.jpeg',
                  homeTeamLogo: Icons.sports_soccer,
                  awayTeamLogo: Icons.sports,
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Performance Stats'),
                const SizedBox(height: 12),
                _buildStatsGrid(),
                const SizedBox(height: 24),
                _buildSectionTitle('Recent Matches'),
                const SizedBox(height: 12),
                _buildRecentMatches(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =====================================================
  // UI HELPERS
  // =====================================================

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.heading18SemiBold.copyWith(
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildPlayerOfMatchCard({
    required String playerNumber,
    required String playerName,
    required String score,
    required String imageUrl,
    required IconData homeTeamLogo,
    required IconData awayTeamLogo,
  }) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.network(imageUrl, fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  child: Text(
                    playerNumber,
                    style: AppTextStyles.heading24Bold.copyWith(
                      fontSize: 80,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Winner',
                        style: AppTextStyles.caption12Regular.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        playerName,
                        style: AppTextStyles.heading20SemiBold.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    final stats = [
      {'label': 'Goals', 'value': '12', 'icon': Icons.sports_soccer},
      {'label': 'Assists', 'value': '8', 'icon': Icons.handshake},
      {'label': 'Matches', 'value': '24', 'icon': Icons.event},
      {'label': 'Minutes', 'value': '1,850', 'icon': Icons.timer},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemCount: stats.length,
      itemBuilder: (_, index) {
        final stat = stats[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(stat['icon'] as IconData,
                  color: AppColors.primary, size: 28),
              const SizedBox(height: 8),
              Text(stat['value'] as String,
                  style: AppTextStyles.heading20SemiBold),
              Text(stat['label'] as String,
                  style: AppTextStyles.caption12Regular),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRecentMatches() {
    final matches = [
      {'opponent': 'Team A', 'result': 'W 3-1', 'performance': 'Good'},
      {'opponent': 'Team B', 'result': 'L 1-2', 'performance': 'Average'},
      {'opponent': 'Team C', 'result': 'W 2-0', 'performance': 'Excellent'},
    ];

    return Column(
      children: matches.map((match) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            children: [
              Icon(Icons.sports, color: AppColors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'vs ${match['opponent']} • ${match['result']}',
                  style: AppTextStyles.body16SemiBold,
                ),
              ),
              Text(
                match['performance'] as String,
                style: AppTextStyles.badge12SemiBold.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
