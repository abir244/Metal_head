import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/route/route_name.dart';
 // To reset index on logout
import '../../../home/view/widgets/bottom_navbar.dart';
import '../viewmodel/player_profile_provider.dart';

class PlayerProfileScreen extends ConsumerWidget {
  const PlayerProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(playerProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Profile', style: AppTextStyles.heading18SemiBold.copyWith(color: Colors.white)),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: state.loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            // 1. TOP PROFILE SECTION
            _buildHeader(state),

            const SizedBox(height: 32),

            // 2. QUICK STATS GRID
            Row(
              children: [
                _buildStatCard('Matches', state.matches.toString(), Icons.directions),
                const SizedBox(width: 12),
                _buildStatCard('Goals', state.goals.toString(), Icons.sports_soccer),
                const SizedBox(width: 12),
                _buildStatCard('Assists', state.assists.toString(), Icons.star_border_purple500_rounded),
              ],
            ),

            const SizedBox(height: 32),

            // 3. PHYSICAL ATTRIBUTES & DETAILS
            _buildSectionLabel("Player Attributes"),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Column(
                children: [
                  _buildInfoRow('Nationality', 'Netherlands', Icons.flag_outlined),
                  _buildDivider(),
                  _buildInfoRow('Age', '24 Years', Icons.calendar_today_outlined),
                  _buildDivider(),
                  _buildInfoRow('Height', '185 cm', Icons.height),
                  _buildDivider(),
                  _buildInfoRow('Preferred Foot', 'Right', Icons.ads_click),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // 4. LOGOUT BUTTON
            _buildLogoutButton(context, ref),

            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(dynamic state) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              child: CircleAvatar(
                radius: 55,
                backgroundColor: AppColors.surface,
                backgroundImage: NetworkImage(state.avatarUrl),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              child: const Icon(Icons.edit, size: 16, color: Colors.black),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(state.name, style: AppTextStyles.heading24Bold.copyWith(color: Colors.white)),
        const SizedBox(height: 4),
        Text(
          state.position.toUpperCase(),
          style: AppTextStyles.overline10Medium.copyWith(color: AppColors.primary, letterSpacing: 2),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.textSecondary, size: 20),
            const SizedBox(height: 8),
            Text(value, style: AppTextStyles.heading20SemiBold.copyWith(color: Colors.white)),
            Text(label, style: AppTextStyles.caption12Regular),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 18),
          const SizedBox(width: 12),
          Text(label, style: AppTextStyles.body14Regular.copyWith(color: AppColors.textSecondary)),
          const Spacer(),
          Text(value, style: AppTextStyles.body14SemiBold.copyWith(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text.toUpperCase(),
        style: AppTextStyles.overline10Medium.copyWith(color: AppColors.textSecondary, letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(color: Colors.white.withOpacity(0.05), height: 24);
  }

  Widget _buildLogoutButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _handleLogout(context, ref),
        icon: const Icon(Icons.logout_rounded, size: 18),
        label: const Text('Logout Account'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.danger,
          side: const BorderSide(color: AppColors.danger),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }

  void _handleLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Logout', style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure you want to sign out?', style: TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              // 1. Reset navigation state so next login starts at Home
              ref.read(navigationProvider.notifier).updateIndex(0);

              // 2. Wipe current route and go to login
              Navigator.pushNamedAndRemoveUntil(
                context,
                RouteName.login,
                    (route) => false,
              );
            },
            child: const Text('Logout', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }
}