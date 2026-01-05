import 'dart:io';

import 'package:flutter/material.dart';
import 'package:arbtilant/Models/scan_result_model.dart';
import 'package:arbtilant/Models/disease_model.dart';
import 'package:arbtilant/Services/disease_service.dart';
import 'package:arbtilant/Services/feedback_service.dart';
import 'package:arbtilant/Services/scan_history_service.dart';
import 'package:arbtilant/core/design_system/index.dart';
import 'package:arbtilant/core/widgets/index.dart';
import 'package:arbtilant/Pages/disease_detail_page.dart';
import 'package:arbtilant/Widgets/feedback_dialog.dart';
import 'package:intl/intl.dart';

class ScanDetailPage extends StatefulWidget {
  final ScanResultModel scanResult;

  const ScanDetailPage({super.key, required this.scanResult});

  @override
  State<ScanDetailPage> createState() => _ScanDetailPageState();
}

class _ScanDetailPageState extends State<ScanDetailPage> {
  late DiseaseService _diseaseService;
  late FeedbackService _feedbackService;
  late ScanHistoryService _scanHistoryService;
  DiseaseModel? _disease;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _diseaseService = DiseaseService();
    _feedbackService = FeedbackService();
    _scanHistoryService = ScanHistoryService();
    _loadDiseaseInfo();
  }

  Future<void> _loadDiseaseInfo() async {
    try {
      final disease = await _diseaseService.getDiseaseById(
        widget.scanResult.diseaseId,
      );
      setState(() {
        _disease = disease;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy, HH:mm').format(date);
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.8) {
      return Colors.green;
    } else if (confidence >= 0.6) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  void _showFeedbackDialog() {
    showDialog(
      context: context,
      builder: (context) => FeedbackDialog(
        predictedLabel: widget.scanResult.predictedLabel,
        confidence: widget.scanResult.confidence,
        onSubmit: (isCorrect, correctedDiseaseId, feedbackText, rating) async {
          await _feedbackService.saveFeedback(
            scanResultId: widget.scanResult.id,
            diseaseId: widget.scanResult.diseaseId,
            isCorrect: isCorrect,
            correctedDiseaseId: correctedDiseaseId,
            feedbackText: feedbackText,
            confidenceRating: rating,
          );

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Terima kasih atas feedback Anda!'),
                backgroundColor: AppColors.brightGreen,
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> _deleteScan() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Hapus Scan?', style: AppTypography.headline()),
        content: Text(
          'Apakah Anda yakin ingin menghapus scan ini? Tindakan ini tidak dapat dibatalkan.',
          style: AppTypography.bodyMedium(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Batal',
              style: AppTypography.bodyMedium(color: AppColors.brightGreen),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Hapus',
              style: AppTypography.bodyMedium(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _scanHistoryService.deleteScanResult(widget.scanResult.id);
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Scan berhasil dihapus'),
              backgroundColor: AppColors.brightGreen,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
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
        title: Text('Detail Scan', style: AppTypography.headline()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: AppColors.brightGreen),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (File(widget.scanResult.imagePath).existsSync())
                    Container(
                      width: double.infinity,
                      height: 280,
                      color: AppColors.lightSurface,
                      child: Image.file(
                        File(widget.scanResult.imagePath),
                        fit: BoxFit.cover,
                      ),
                    )
                  else
                    Container(
                      width: double.infinity,
                      height: 280,
                      color: AppColors.lightSurface,
                      child: Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 64,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Metadata',
                                style: AppTypography.bodySmall(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Tanggal & Waktu',
                                        style: AppTypography.bodySmall(
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      const SizedBox(height: AppSpacing.xs),
                                      Text(
                                        _formatDate(
                                          widget.scanResult.createdAt,
                                        ),
                                        style: AppTypography.bodyMedium(),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Model Version',
                                        style: AppTypography.bodySmall(
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      const SizedBox(height: AppSpacing.xs),
                                      Text(
                                        widget.scanResult.modelVersion,
                                        style: AppTypography.bodyMedium(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text('Hasil Deteksi', style: AppTypography.headline()),
                        const SizedBox(height: AppSpacing.md),
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: AppColors.brightGreen.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(
                              AppSpacing.cardBorderRadius,
                            ),
                            border: Border.all(
                              color: AppColors.brightGreen,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/virus.png",
                                    width: 48,
                                    height: 48,
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.scanResult.predictedLabel,
                                          style: AppTypography.headline(),
                                        ),
                                        const SizedBox(height: AppSpacing.xs),
                                        Text(
                                          'Confidence Score',
                                          style: AppTypography.bodySmall(
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.md),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  value: widget.scanResult.confidence,
                                  minHeight: 8,
                                  backgroundColor: AppColors.lightSurface,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    _getConfidenceColor(
                                      widget.scanResult.confidence,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                '${(widget.scanResult.confidence * 100).toStringAsFixed(1)}%',
                                style: AppTypography.label(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          'Top Predictions',
                          style: AppTypography.headline(),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        ...widget.scanResult.top3Predictions
                            .take(3)
                            .toList()
                            .asMap()
                            .entries
                            .map((entry) {
                              final index = entry.key;
                              final prediction = entry.value;
                              return Padding(
                                padding: const EdgeInsets.only(
                                  bottom: AppSpacing.md,
                                ),
                                child: _buildPredictionBar(
                                  index + 1,
                                  prediction.label,
                                  prediction.confidence,
                                ),
                              );
                            }),
                        const SizedBox(height: AppSpacing.lg),
                        if (_disease != null) ...[
                          Text(
                            'Rekomendasi Pengobatan',
                            style: AppTypography.headline(),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          AppCard(
                            child: Text(
                              _disease!.treatment.join('\n'),
                              style: AppTypography.bodyMedium(),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                        ],
                        Text('Feedback', style: AppTypography.headline()),
                        const SizedBox(height: AppSpacing.md),
                        AppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Apakah hasil deteksi ini akurat?',
                                style: AppTypography.bodyMedium(),
                              ),
                              const SizedBox(height: AppSpacing.md),
                              SizedBox(
                                width: double.infinity,
                                child: AppButton(
                                  label: 'Berikan Feedback',
                                  size: AppButtonSize.medium,
                                  onPressed: _showFeedbackDialog,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        if (_disease != null) ...[
                          Text(
                            'Informasi Penyakit',
                            style: AppTypography.headline(),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          AppCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _disease!.name,
                                  style: AppTypography.headline(),
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  _disease!.description,
                                  style: AppTypography.bodyMedium(),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: AppSpacing.md),
                                SizedBox(
                                  width: double.infinity,
                                  child: AppButton(
                                    label: 'Lihat Detail Penyakit',
                                    size: AppButtonSize.medium,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DiseaseDetailPage(
                                                disease: _disease!,
                                              ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                        ],
                        SizedBox(
                          width: double.infinity,
                          child: AppButton(
                            label: 'Hapus Scan',
                            icon: Icons.delete_outline,
                            size: AppButtonSize.large,
                            variant: AppButtonVariant.outlined,
                            onPressed: _deleteScan,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildPredictionBar(int rank, String label, double confidence) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.brightGreen.withValues(alpha: 0.2),
          ),
          child: Center(
            child: Text(
              '$rank',
              style: AppTypography.label(color: AppColors.brightGreen),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTypography.bodyMedium()),
              const SizedBox(height: AppSpacing.xs),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: confidence,
                  minHeight: 6,
                  backgroundColor: AppColors.lightSurface,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getConfidenceColor(confidence),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Text(
          '${(confidence * 100).toStringAsFixed(0)}%',
          style: AppTypography.bodySmall(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
