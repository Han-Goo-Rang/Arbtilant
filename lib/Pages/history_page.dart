import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:arbtilant/Models/scan_result_model.dart';
import 'package:arbtilant/Services/scan_history_service.dart';
import 'package:arbtilant/Services/feedback_service.dart';
import 'package:arbtilant/core/design_system/index.dart';
import 'package:arbtilant/core/widgets/index.dart';
import 'package:arbtilant/Widgets/custom_bottom_nav.dart';
import 'package:arbtilant/Pages/home_page.dart';
import 'package:arbtilant/Pages/scan_page.dart';
import 'package:arbtilant/Pages/library_page_new.dart';
import 'package:arbtilant/Pages/scan_detail_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final ScanHistoryService _scanHistoryService = ScanHistoryService();
  final FeedbackService _feedbackService = FeedbackService();

  List<ScanResultModel> _scanResults = [];
  List<ScanResultModel> _filteredResults = [];
  Map<String, dynamic> _stats = {};
  bool _isLoading = true;
  int _selectedIndex = 3;

  // Filter options
  String _sortBy = 'recent'; // recent, oldest, accuracy
  String _filterDisease = 'all';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      final results = await _scanHistoryService.getAllScanResults();
      final stats = await _feedbackService.getFeedbackStats();

      setState(() {
        _scanResults = results;
        _stats = stats;
        _isLoading = false;
        _applyFilters();
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _applyFilters() {
    List<ScanResultModel> filtered = List.from(_scanResults);

    // Apply disease filter
    if (_filterDisease != 'all') {
      filtered = filtered
          .where((r) => r.predictedLabel == _filterDisease)
          .toList();
    }

    // Apply sorting
    switch (_sortBy) {
      case 'recent':
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'oldest':
        filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case 'accuracy':
        filtered.sort((a, b) => b.confidence.compareTo(a.confidence));
        break;
    }

    setState(() {
      _filteredResults = filtered;
    });
  }

  Future<void> _deleteResult(String id) async {
    await _scanHistoryService.deleteScanResult(id);
    await _loadData();
  }

  // TODO: Enable after Supabase is properly configured
  /*
  Future<void> _manualSync() async {
    setState(() => _isSyncing = true);

    try {
      final result = await _syncService.forceSyncNow();

      if (mounted) {
        final message = result['success']
            ? 'Sync berhasil!\nFeedback: ${result['feedback_synced']}, Scans: ${result['scans_synced']}'
            : 'Sync gagal: ${result['message'] ?? result['error']}';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: result['success']
                ? AppColors.brightGreen
                : Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSyncing = false);
      }
    }
  }

  Future<void> _testSupabaseConnection() async {
    try {
      final result = await SupabaseService().testConnection();

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Supabase Connection Test',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTestResultItem(
                    'Status',
                    result['connection_status'] ?? 'unknown',
                    result['connection_status'] == 'success',
                  ),
                  const SizedBox(height: 12),
                  _buildTestResultItem(
                    'Client Initialized',
                    result['client_initialized']?.toString() ?? 'false',
                    result['client_initialized'] == true,
                  ),
                  const SizedBox(height: 12),
                  _buildTestResultItem(
                    'Diseases Table',
                    result['diseases_table_accessible'] == true
                        ? 'Accessible (${result['diseases_count']} records)'
                        : 'Error: ${result['diseases_error'] ?? 'unknown'}',
                    result['diseases_table_accessible'] == true,
                  ),
                  const SizedBox(height: 12),
                  _buildTestResultItem(
                    'Scan Results Table',
                    result['scan_results_table_accessible'] == true
                        ? 'Accessible (${result['scan_results_count']} records)'
                        : 'Error: ${result['scan_results_error'] ?? 'unknown'}',
                    result['scan_results_table_accessible'] == true,
                  ),
                  const SizedBox(height: 12),
                  _buildTestResultItem(
                    'User Feedback Table',
                    result['user_feedback_table_accessible'] == true
                        ? 'Accessible (${result['user_feedback_count']} records)'
                        : 'Error: ${result['user_feedback_error'] ?? 'unknown'}',
                    result['user_feedback_table_accessible'] == true,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Close',
                  style: GoogleFonts.poppins(color: AppColors.brightGreen),
                ),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Test failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildTestResultItem(String label, String value, bool isSuccess) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          isSuccess ? Icons.check_circle : Icons.cancel,
          color: isSuccess ? AppColors.brightGreen : Colors.red,
          size: 20,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
  */

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ScanPage()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LibraryPageNew()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        title: Text('Riwayat Deteksi', style: AppTypography.headline()),
        leading: const SizedBox(),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: AppColors.brightGreen),
            )
          : Column(
              children: [
                _buildStatsCard(),
                _buildFilterBar(),
                Expanded(
                  child: _filteredResults.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          itemCount: _filteredResults.length,
                          itemBuilder: (context, index) {
                            return _buildHistoryCard(_filteredResults[index]);
                          },
                        ),
                ),
              ],
            ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.brightGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.cardBorderRadius),
        border: Border.all(color: AppColors.brightGreen, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            label: 'Total Scan',
            value: _scanResults.length.toString(),
            icon: Icons.camera_alt,
          ),
          _buildStatItem(
            label: 'Feedback',
            value: (_stats['total'] ?? 0).toString(),
            icon: Icons.feedback,
          ),
          _buildStatItem(
            label: 'Akurasi',
            value: '${(_stats['accuracy_rate'] ?? 0).toStringAsFixed(0)}%',
            icon: Icons.check_circle,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    final uniqueDiseases = <String>{'all'};
    for (var result in _scanResults) {
      uniqueDiseases.add(result.predictedLabel);
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Urutkan',
            style: AppTypography.bodySmall(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.sm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(
                  label: 'Terbaru',
                  value: 'recent',
                  isSelected: _sortBy == 'recent',
                  onTap: () {
                    setState(() {
                      _sortBy = 'recent';
                      _applyFilters();
                    });
                  },
                ),
                const SizedBox(width: AppSpacing.sm),
                _buildFilterChip(
                  label: 'Terlama',
                  value: 'oldest',
                  isSelected: _sortBy == 'oldest',
                  onTap: () {
                    setState(() {
                      _sortBy = 'oldest';
                      _applyFilters();
                    });
                  },
                ),
                const SizedBox(width: AppSpacing.sm),
                _buildFilterChip(
                  label: 'Akurasi Tinggi',
                  value: 'accuracy',
                  isSelected: _sortBy == 'accuracy',
                  onTap: () {
                    setState(() {
                      _sortBy = 'accuracy';
                      _applyFilters();
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Filter Penyakit',
            style: AppTypography.bodySmall(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.sm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: uniqueDiseases.map((disease) {
                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: _buildFilterChip(
                    label: disease == 'all' ? 'Semua' : disease,
                    value: disease,
                    isSelected: _filterDisease == disease,
                    onTap: () {
                      setState(() {
                        _filterDisease = disease;
                        _applyFilters();
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required String value,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.brightGreen : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.brightGreen : AppColors.lightSurface,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.bodySmall(
            color: isSelected
                ? AppColors.darkBackground
                : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(icon, color: AppColors.brightGreen, size: 24),
        const SizedBox(height: AppSpacing.sm),
        Text(value, style: AppTypography.headline()),
        Text(
          label,
          style: AppTypography.bodySmall(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 80, color: AppColors.textTertiary),
          const SizedBox(height: AppSpacing.md),
          Text('Belum ada riwayat scan', style: AppTypography.headline()),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Mulai scan tanaman untuk melihat riwayat',
            style: AppTypography.bodyMedium(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.xxl),
          AppButton(
            label: 'Mulai Scan',
            icon: Icons.camera_alt,
            size: AppButtonSize.large,
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ScanPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(ScanResultModel result) {
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');

    return Dismissible(
      key: Key(result.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.md),
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(AppSpacing.cardBorderRadius),
        ),
        child: const Icon(Icons.delete, color: AppColors.textPrimary),
      ),
      onDismissed: (_) => _deleteResult(result.id),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScanDetailPage(scanResult: result),
            ),
          );
        },
        child: AppCard(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          isClickable: true,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      AppSpacing.cardBorderRadius,
                    ),
                    color: AppColors.lightSurface,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      AppSpacing.cardBorderRadius,
                    ),
                    child: FutureBuilder<File?>(
                      future: _scanHistoryService.getImageFile(result),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.data != null) {
                          return Image.file(snapshot.data!, fit: BoxFit.cover);
                        }
                        return Icon(
                          Icons.image_not_supported,
                          color: AppColors.textTertiary,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.predictedLabel,
                        style: AppTypography.headline(),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        dateFormat.format(result.createdAt),
                        style: AppTypography.bodySmall(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          _buildConfidenceBadge(result.confidence),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'v${result.modelVersion}',
                            style: AppTypography.bodySmall(
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
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
        ),
      ),
    );
  }

  Widget _buildConfidenceBadge(double confidence) {
    final percentage = (confidence * 100).toStringAsFixed(0);
    Color color;

    if (confidence >= 0.8) {
      color = AppColors.success;
    } else if (confidence >= 0.5) {
      color = AppColors.warning;
    } else {
      color = AppColors.error;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color),
      ),
      child: Text('$percentage%', style: AppTypography.bodySmall(color: color)),
    );
  }
}
