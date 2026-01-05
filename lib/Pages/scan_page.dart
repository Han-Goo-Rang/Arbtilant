import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:arbtilant/Data/data_treat.dart';
import 'package:arbtilant/Controller/model_controller.dart';
import 'package:arbtilant/Services/scan_history_service.dart';
import 'package:arbtilant/Services/feedback_service.dart';
import 'package:arbtilant/Services/disease_service.dart';
import 'package:arbtilant/Models/scan_result_model.dart';
import 'package:arbtilant/Widgets/feedback_dialog.dart';
import 'package:arbtilant/Widgets/custom_bottom_nav.dart';
import 'package:arbtilant/core/design_system/index.dart';
import 'package:arbtilant/Pages/scan_detail_page.dart';
import 'package:arbtilant/Pages/home_page.dart';
import 'package:arbtilant/Pages/library_page_new.dart';
import 'package:arbtilant/Pages/history_page.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  CameraController? _camController;
  String? _imagePath;
  DataTreat dt = DataTreat();
  ModelController modelController = ModelController();
  final ScanHistoryService _scanHistoryService = ScanHistoryService();
  final FeedbackService _feedbackService = FeedbackService();
  final DiseaseService _diseaseService = DiseaseService();

  bool _isProcessing = false;
  String? _lastScanResultId;
  int _selectedIndex = 1;
  late Future<void> _initCameraFuture;

  // Camera mode and settings
  String _cameraMode = 'MACRO'; // MACRO, AUTO, WIDE
  bool _flashEnabled = false;
  double _zoomLevel = 1.0;

  @override
  void initState() {
    super.initState();
    _loadModel();
    _initCameraFuture = _initCamera();
  }

  Future<void> _loadModel() async {
    await modelController.loadModel();
  }

  Future<void> _initCamera() async {
    // Check if camera is already initialized and not disposed
    if (_camController != null && _camController!.value.isInitialized) {
      return;
    }

    try {
      var cameras = await availableCameras();
      if (cameras.isEmpty) {
        throw Exception('No cameras available');
      }

      _camController = CameraController(cameras[0], ResolutionPreset.high);
      await _camController!.initialize();

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      log("Error initializing camera: ${e.toString()}");
      rethrow;
    }
  }

  Future<String> _takePicture() async {
    try {
      // Ensure camera is initialized
      if (_camController == null || !_camController!.value.isInitialized) {
        throw Exception('Camera is not initialized');
      }

      Directory root = await getApplicationDocumentsDirectory();
      String dir = "${root.path}/TANAMAN";
      await Directory(dir).create(recursive: true);
      String filePath = "$dir/${DateTime.now().millisecondsSinceEpoch}.jpg";

      debugPrint("📷 Taking picture...");
      XFile img = await _camController!.takePicture();
      debugPrint("✅ Picture taken, saving to: $filePath");

      await img.saveTo(filePath);

      // Verify file was saved
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('Failed to save picture to $filePath');
      }
      final fileSize = await file.length();
      debugPrint("✅ Picture saved successfully ($fileSize bytes)");

      return filePath;
    } catch (e) {
      debugPrint("❌ Error taking picture: ${e.toString()}");
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> _predict(String path) async {
    return await modelController.runModelOnImage(path);
  }

  Future<void> _handleScan() async {
    if (_camController == null ||
        !_camController!.value.isInitialized ||
        _camController!.value.isTakingPicture) {
      return;
    }

    setState(() => _isProcessing = true);

    try {
      // Take picture
      _imagePath = await _takePicture();
      debugPrint("✅ Image path: $_imagePath");

      // Run prediction
      final results = await _predict(_imagePath!);
      debugPrint("✅ Prediction results: ${results.length} predictions");

      if (results.isNotEmpty) {
        final topResult = results[0];

        // Find disease ID from label
        final diseases = await _diseaseService.getAllDiseases();
        String diseaseId = '';
        for (var disease in diseases) {
          if (disease.name == topResult['label'] ||
              disease.englishName == topResult['label']) {
            diseaseId = disease.id;
            break;
          }
        }
        debugPrint("✅ Disease ID: $diseaseId");

        // Save to history
        try {
          final scanResult = await _scanHistoryService.saveScanResult(
            diseaseId: diseaseId,
            imagePath: _imagePath!,
            predictedLabel: topResult['label'],
            confidence: topResult['confidence'],
            top3Predictions: results,
            modelVersion: '1.0',
          );
          debugPrint("✅ Scan result saved: ${scanResult.id}");

          _lastScanResultId = scanResult.id;

          // Show result
          if (mounted) {
            _showResultBottomSheet(results, diseaseId, scanResult);
          }
        } catch (e) {
          debugPrint("❌ Error saving scan result: $e");
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error saving scan: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    } catch (e) {
      debugPrint("❌ Error during scan: $e");
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  void _showResultBottomSheet(
    List<Map<String, dynamic>> results,
    String diseaseId,
    ScanResultModel scanResult,
  ) {
    final topResult = results[0];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.darkBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.lightSurface,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    // Image preview with error handling - use permanent path from scanResult
                    if (scanResult.imagePath.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                          AppSpacing.cardBorderRadius,
                        ),
                        child: Container(
                          height: 240,
                          width: double.infinity,
                          color: AppColors.lightSurface,
                          child: _buildImagePreview(scanResult.imagePath),
                        ),
                      ),
                    const SizedBox(height: AppSpacing.lg),
                    // Detection result
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.cardBorderRadius,
                        ),
                        border: Border.all(
                          color: AppColors.brightGreen,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'DETECTED',
                            style: AppTypography.bodySmall(
                              color: AppColors.brightGreen,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            topResult['label'],
                            style: AppTypography.displayMedium(),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'Confidence Score',
                            style: AppTypography.bodySmall(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: topResult['confidence'],
                              minHeight: 8,
                              backgroundColor: AppColors.lightSurface,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _getConfidenceColor(topResult['confidence']),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            '${(topResult['confidence'] * 100).toStringAsFixed(0)}%',
                            style: AppTypography.headline(
                              color: _getConfidenceColor(
                                topResult['confidence'],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    // Other possibilities
                    Text(
                      'Other Possibilities',
                      style: AppTypography.headline(),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ...results.skip(1).take(2).toList().asMap().entries.map((
                      entry,
                    ) {
                      final result = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              result['label'],
                              style: AppTypography.bodyMedium(),
                            ),
                            Text(
                              '${(result['confidence'] * 100).toStringAsFixed(0)}%',
                              style: AppTypography.bodySmall(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: AppSpacing.lg),
                    // Quick tips
                    Text('Quick Tips', style: AppTypography.headline()),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(
                                AppSpacing.cardBorderRadius,
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.cut,
                                  color: AppColors.warning,
                                  size: 32,
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  'Prune Leaves',
                                  style: AppTypography.label(),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(
                                AppSpacing.cardBorderRadius,
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.water_drop,
                                  color: AppColors.info,
                                  size: 32,
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  'Water care',
                                  style: AppTypography.label(),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    // Action buttons
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ScanDetailPage(scanResult: scanResult),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.brightGreen,
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.md,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppSpacing.buttonBorderRadius,
                            ),
                          ),
                        ),
                        child: Text(
                          'View Treatment Plan',
                          style: AppTypography.label(
                            color: AppColors.darkBackground,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _showFeedbackDialog(topResult, diseaseId);
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: AppColors.brightGreen),
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.md,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppSpacing.buttonBorderRadius,
                                ),
                              ),
                            ),
                            child: Text(
                              'Disease Info',
                              style: AppTypography.label(
                                color: AppColors.brightGreen,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: AppColors.brightGreen),
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.md,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppSpacing.buttonBorderRadius,
                                ),
                              ),
                            ),
                            child: Text(
                              'Save Result',
                              style: AppTypography.label(
                                color: AppColors.brightGreen,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          _showFeedbackDialog(topResult, diseaseId);
                        },
                        child: Text(
                          'Report Incorrect Result',
                          style: AppTypography.bodySmall(
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Build image preview with error handling
  Widget _buildImagePreview(String imagePath) {
    final file = File(imagePath);

    return FutureBuilder<bool>(
      future: file.exists(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.brightGreen),
          );
        }

        if (snapshot.hasError || snapshot.data == false) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_not_supported,
                  size: 48,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Image not found',
                  style: AppTypography.bodySmall(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return Image.file(
          file,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.broken_image,
                    size: 48,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Failed to load image',
                    style: AppTypography.bodySmall(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// Get color based on confidence level
  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.8) {
      return Colors.green;
    } else if (confidence >= 0.6) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  void _showFeedbackDialog(Map<String, dynamic> result, String diseaseId) {
    showDialog(
      context: context,
      builder: (context) => FeedbackDialog(
        predictedLabel: result['label'],
        confidence: result['confidence'],
        onSubmit: (isCorrect, correctedDiseaseId, feedbackText, rating) async {
          if (_lastScanResultId != null) {
            await _feedbackService.saveFeedback(
              scanResultId: _lastScanResultId!,
              diseaseId: diseaseId,
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
          }
        },
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
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
  void dispose() {
    try {
      if (_camController != null && _camController!.value.isInitialized) {
        _camController!.dispose();
      }
    } catch (e) {
      log("Error disposing camera: ${e.toString()}");
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: FutureBuilder<void>(
        future: _initCameraFuture,
        builder: (_, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.brightGreen),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: AppColors.error),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Kamera tidak tersedia',
                    style: AppTypography.bodyLarge(color: AppColors.error),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Error: ${snapshot.error}',
                    style: AppTypography.bodySmall(
                      color: AppColors.textTertiary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              _buildScannerHeader(),
              Expanded(
                child: Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: CameraPreview(_camController!),
                    ),
                    _buildCameraFrame(context),
                    _buildCornerIndicators(),
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: Text(
                        'Point camera at a leaf',
                        textAlign: TextAlign.center,
                        style:
                            AppTypography.bodyMedium(
                              color: AppColors.textPrimary,
                            ).copyWith(
                              shadows: [
                                Shadow(color: Colors.black54, blurRadius: 4),
                              ],
                            ),
                      ),
                    ),
                    if (_isProcessing)
                      Container(
                        color: Colors.black54,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                color: AppColors.brightGreen,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Text(
                                'Analyzing...',
                                style: AppTypography.bodyLarge(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              _buildScannerControls(),
            ],
          );
        },
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildScannerHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      color: AppColors.surface,
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ARBTILANT AI',
                  style: AppTypography.bodySmall(color: AppColors.brightGreen),
                ),
                Text('Scanner', style: AppTypography.headline()),
              ],
            ),
            IconButton(
              icon: Icon(Icons.help_outline, color: AppColors.brightGreen),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraFrame(BuildContext context) {
    final frameSize = MediaQuery.of(context).size.width * 0.75;
    return Center(
      child: Container(
        width: frameSize,
        height: frameSize,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.brightGreen, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildCornerIndicators() {
    final frameSize = MediaQuery.of(context).size.width * 0.75;
    final cornerSize = 20.0;
    final offset = (MediaQuery.of(context).size.width - frameSize) / 2;

    return Stack(
      children: [
        // Top-left corner
        Positioned(
          left: offset,
          top: (MediaQuery.of(context).size.height - frameSize) / 2,
          child: Container(
            width: cornerSize,
            height: cornerSize,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.brightGreen, width: 3),
                left: BorderSide(color: AppColors.brightGreen, width: 3),
              ),
            ),
          ),
        ),
        // Top-right corner
        Positioned(
          right: offset,
          top: (MediaQuery.of(context).size.height - frameSize) / 2,
          child: Container(
            width: cornerSize,
            height: cornerSize,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.brightGreen, width: 3),
                right: BorderSide(color: AppColors.brightGreen, width: 3),
              ),
            ),
          ),
        ),
        // Bottom-left corner
        Positioned(
          left: offset,
          bottom: (MediaQuery.of(context).size.height - frameSize) / 2,
          child: Container(
            width: cornerSize,
            height: cornerSize,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.brightGreen, width: 3),
                left: BorderSide(color: AppColors.brightGreen, width: 3),
              ),
            ),
          ),
        ),
        // Bottom-right corner
        Positioned(
          right: offset,
          bottom: (MediaQuery.of(context).size.height - frameSize) / 2,
          child: Container(
            width: cornerSize,
            height: cornerSize,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.brightGreen, width: 3),
                right: BorderSide(color: AppColors.brightGreen, width: 3),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScannerControls() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      color: AppColors.surface,
      child: Column(
        children: [
          // Mode buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildModeButton('MACRO', _cameraMode == 'MACRO'),
              const SizedBox(width: AppSpacing.lg),
              _buildModeButton('AUTO', _cameraMode == 'AUTO'),
              const SizedBox(width: AppSpacing.lg),
              _buildModeButton('WIDE', _cameraMode == 'WIDE'),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          // Capture button and controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  _flashEnabled ? Icons.flash_on : Icons.flash_off,
                  color: _flashEnabled
                      ? AppColors.warning
                      : AppColors.brightGreen,
                ),
                onPressed: _toggleFlash,
              ),
              GestureDetector(
                onTap: _isProcessing ? null : _handleScan,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isProcessing
                        ? AppColors.textTertiary
                        : AppColors.brightGreen,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.brightGreen.withValues(alpha: 0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: AppColors.darkBackground,
                    size: 40,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.settings, color: AppColors.brightGreen),
                onPressed: _showCameraSettings,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton(String label, bool isActive) {
    return GestureDetector(
      onTap: () => _setMode(label),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isActive ? AppColors.brightGreen : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(AppSpacing.buttonBorderRadius),
        ),
        child: Text(
          label,
          style: AppTypography.bodySmall(
            color: isActive
                ? AppColors.darkBackground
                : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  void _setMode(String mode) {
    setState(() {
      _cameraMode = mode;
    });

    // Apply zoom based on mode
    if (_camController != null && _camController!.value.isInitialized) {
      switch (mode) {
        case 'MACRO':
          _zoomLevel = 1.0; // No zoom for macro
          break;
        case 'AUTO':
          _zoomLevel = 1.5; // Medium zoom
          break;
        case 'WIDE':
          _zoomLevel = 0.5; // Wide angle (less zoom)
          break;
      }
      _camController!.setZoomLevel(_zoomLevel);
    }

    debugPrint('📷 Camera mode changed to: $mode (zoom: $_zoomLevel)');
  }

  Future<void> _toggleFlash() async {
    if (_camController == null || !_camController!.value.isInitialized) {
      return;
    }

    try {
      setState(() {
        _flashEnabled = !_flashEnabled;
      });

      await _camController!.setFlashMode(
        _flashEnabled ? FlashMode.torch : FlashMode.off,
      );

      debugPrint('💡 Flash: ${_flashEnabled ? 'ON' : 'OFF'}');
    } catch (e) {
      debugPrint('❌ Error toggling flash: $e');
      setState(() {
        _flashEnabled = !_flashEnabled;
      });
    }
  }

  void _showCameraSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Camera Settings', style: AppTypography.headline()),
                  const SizedBox(height: AppSpacing.lg),

                  // Zoom control
                  Text('Zoom Level', style: AppTypography.label()),
                  const SizedBox(height: AppSpacing.md),
                  Slider(
                    value: _zoomLevel,
                    min: 0.5,
                    max: 3.0,
                    divisions: 25,
                    label: _zoomLevel.toStringAsFixed(1),
                    activeColor: AppColors.brightGreen,
                    inactiveColor: AppColors.lightSurface,
                    onChanged: (value) {
                      setState(() {
                        _zoomLevel = value;
                      });
                      if (_camController != null &&
                          _camController!.value.isInitialized) {
                        _camController!.setZoomLevel(value);
                      }
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Flash toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Flash', style: AppTypography.label()),
                      Switch(
                        value: _flashEnabled,
                        activeColor: AppColors.brightGreen,
                        onChanged: (value) {
                          setState(() {
                            _flashEnabled = value;
                          });
                          _toggleFlash();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Mode info
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.lightSurface,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.cardBorderRadius,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Mode: $_cameraMode',
                          style: AppTypography.label(),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          _getModeDescription(_cameraMode),
                          style: AppTypography.bodySmall(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brightGreen,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.md,
                        ),
                      ),
                      child: Text(
                        'Close',
                        style: AppTypography.label(
                          color: AppColors.darkBackground,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _getModeDescription(String mode) {
    switch (mode) {
      case 'MACRO':
        return 'Best for close-up shots of leaves and small details';
      case 'AUTO':
        return 'Automatic mode for general plant scanning';
      case 'WIDE':
        return 'Wide angle mode for full plant view';
      default:
        return '';
    }
  }
}
