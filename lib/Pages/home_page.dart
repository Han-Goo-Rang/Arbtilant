import 'package:flutter/material.dart';
import 'package:arbtilant/core/design_system/index.dart';
import 'package:arbtilant/Pages/scan_page.dart';
import 'package:arbtilant/Pages/library_page_new.dart';
import 'package:arbtilant/Pages/history_page.dart';
import 'package:arbtilant/Widgets/custom_bottom_nav.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ScanPage()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LibraryPageNew()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HistoryPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildWelcomeSection(),
              _buildGreetingCard(),
              _buildStatsSection(),
              _buildQuickActionsSection(),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'WELCOME BACK',
                style: AppTypography.bodySmall(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text('Green Thumb', style: AppTypography.headline()),
            ],
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.lightSurface,
            ),
            child: Icon(Icons.person, color: AppColors.brightGreen),
          ),
        ],
      ),
    );
  }

  Widget _buildGreetingCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primaryGreen, AppColors.lightGreen],
          ),
          borderRadius: BorderRadius.circular(AppSpacing.cardBorderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Morning,\nGreen Thumb.',
              style: AppTypography.displayMedium(color: AppColors.textPrimary),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Ready to check your plants today?',
              style: AppTypography.bodyLarge(color: AppColors.textPrimary),
            ),
            const SizedBox(height: AppSpacing.lg),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ScanPage()),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.textPrimary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(
                    AppSpacing.buttonBorderRadius,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.camera_alt,
                      color: AppColors.textPrimary,
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'Start New Scan',
                      style: AppTypography.bodyMedium(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Icon(
                      Icons.arrow_forward,
                      color: AppColors.textPrimary,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              label: 'SAVED',
              value: '12',
              icon: Icons.bookmark,
              color: AppColors.brightGreen,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: _buildStatCard(
              label: 'ACTIVITY',
              value: '5',
              icon: Icons.trending_up,
              color: AppColors.brightGreen,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: _buildStatCard(
              label: 'PEND',
              value: '2',
              icon: Icons.pending_actions,
              color: AppColors.warning,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.cardBorderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: AppSpacing.md),
          Text(value, style: AppTypography.displayMedium()),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: AppTypography.bodySmall(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quick Actions', style: AppTypography.headline()),
          const SizedBox(height: AppSpacing.md),
          _buildActionCard(
            title: 'Diagnose Disease',
            description: 'Identify issues instantly with our AI scanner.',
            icon: Icons.eco,
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ScanPage()),
              );
            },
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _buildSmallActionCard(
                  title: 'Encyclopedia',
                  description: 'Browse 100+ plant species.',
                  icon: Icons.library_books,
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LibraryPageNew(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _buildSmallActionCard(
                  title: 'My Garden',
                  description: 'View past reports & history.',
                  icon: Icons.history,
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HistoryPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.cardBorderRadius),
          border: Border.all(color: AppColors.lightSurface, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.brightGreen.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(
                  AppSpacing.buttonBorderRadius,
                ),
              ),
              child: Icon(icon, color: AppColors.brightGreen, size: 28),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.headline()),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    description,
                    style: AppTypography.bodySmall(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.brightGreen,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallActionCard({
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.cardBorderRadius),
          border: Border.all(color: AppColors.lightSurface, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.brightGreen.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(
                  AppSpacing.buttonBorderRadius,
                ),
              ),
              child: Icon(icon, color: AppColors.brightGreen, size: 20),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(title, style: AppTypography.label()),
            const SizedBox(height: AppSpacing.xs),
            Text(
              description,
              style: AppTypography.bodySmall(color: AppColors.textSecondary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
