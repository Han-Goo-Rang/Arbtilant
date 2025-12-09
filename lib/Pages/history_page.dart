import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:arbtilant/Models/scan_result_model.dart';
import 'package:arbtilant/Services/scan_history_service.dart';
import 'package:arbtilant/Services/feedback_service.dart';
import 'package:arbtilant/core/constants/colors.dart';
import 'package:arbtilant/Widgets/custom_bottom_nav.dart';
import 'package:arbtilant/Pages/home_page.dart';
import 'package:arbtilant/Pages/scan_page.dart';
import 'package:arbtilant/Pages/library_page_new.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final ScanHistoryService _scanHistoryService = ScanHistoryService();
  final FeedbackService _feedbackService = FeedbackService();

  List<ScanResultModel> _scanResults = [];
  Map<String, dynamic> _stats = {};
  bool _isLoading = true;
  int _selectedIndex = 3;

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
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
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
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBgSecondary,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Riwayat Deteksi',
          style: GoogleFonts.poppins(
            color: AppColors.textWhite,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadData,
            tooltip: 'Refresh',
          ),
          // TODO: Enable after Supabase is properly configured
          /*
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: _testSupabaseConnection,
            tooltip: 'Test Supabase',
          ),
          IconButton(
            icon: _isSyncing
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.brightGreen,
                      ),
                    ),
                  )
                : const Icon(Icons.cloud_upload, color: Colors.white),
            onPressed: _isSyncing ? null : _manualSync,
            tooltip: 'Sync ke cloud',
          ),
          */
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: AppColors.brightGreen),
            )
          : Column(
              children: [
                // Stats Card
                _buildStatsCard(),

                // History List
                Expanded(
                  child: _scanResults.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _scanResults.length,
                          itemBuilder: (context, index) {
                            return _buildHistoryCard(_scanResults[index]);
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
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkBgSecondary,
        borderRadius: BorderRadius.circular(12),
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

  Widget _buildStatItem({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(icon, color: AppColors.brightGreen, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textWhite,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGray),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 64, color: AppColors.textGray),
          const SizedBox(height: 16),
          Text(
            'Belum ada riwayat scan',
            style: GoogleFonts.poppins(fontSize: 16, color: AppColors.textGray),
          ),
          const SizedBox(height: 8),
          Text(
            'Mulai scan tanaman untuk melihat riwayat',
            style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textGray),
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
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => _deleteResult(result.id),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        color: AppColors.darkBgSecondary,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Image
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.darkBgTertiary,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child:
                      result.imagePath.isNotEmpty &&
                          File(result.imagePath).existsSync()
                      ? Image.file(File(result.imagePath), fit: BoxFit.cover)
                      : Icon(
                          Icons.image_not_supported,
                          color: AppColors.textGray,
                        ),
                ),
              ),

              const SizedBox(width: 12),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.predictedLabel,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textWhite,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateFormat.format(result.createdAt),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.textGray,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildConfidenceBadge(result.confidence),
                        const SizedBox(width: 8),
                        Text(
                          'v${result.modelVersion}',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: AppColors.textGray,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Arrow
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.brightGreen,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfidenceBadge(double confidence) {
    final percentage = (confidence * 100).toStringAsFixed(0);
    Color color;

    if (confidence >= 0.8) {
      color = AppColors.brightGreen;
    } else if (confidence >= 0.5) {
      color = Colors.orange;
    } else {
      color = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color),
      ),
      child: Text(
        '$percentage%',
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
