import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:arbtilant/Data/data_treat.dart';
import 'package:arbtilant/Controller/model_controller.dart';
import 'package:arbtilant/Services/scan_history_service.dart';
import 'package:arbtilant/Services/feedback_service.dart';
import 'package:arbtilant/Services/disease_service.dart';
import 'package:arbtilant/Widgets/feedback_dialog.dart';
import 'package:arbtilant/Widgets/custom_bottom_nav.dart';
import 'package:arbtilant/core/constants/colors.dart';
import 'package:arbtilant/Pages/disease_detail_page.dart';
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

      XFile img = await _camController!.takePicture();
      await img.saveTo(filePath);
      return filePath;
    } catch (e) {
      log("Error taking picture: ${e.toString()}");
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
      log("Image path: $_imagePath");

      // Run prediction
      final results = await _predict(_imagePath!);

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

        // Save to history
        final scanResult = await _scanHistoryService.saveScanResult(
          diseaseId: diseaseId,
          imagePath: _imagePath!,
          predictedLabel: topResult['label'],
          confidence: topResult['confidence'],
          top3Predictions: results,
          modelVersion: '1.0',
        );

        _lastScanResultId = scanResult.id;

        // Show result
        if (mounted) {
          _showResultBottomSheet(results, diseaseId);
        }
      }
    } catch (e) {
      log("Error during scan: $e");
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
  ) {
    final topResult = results[0];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle bar
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Title
                    Text(
                      'Hasil Deteksi',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Image preview
                    if (_imagePath != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(_imagePath!),
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                    const SizedBox(height: 16),

                    // Result card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.mediumGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.mediumGreen),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/virus.png",
                            width: 40,
                            height: 40,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  topResult['label'],
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  'Confidence: ${(topResult['confidence'] * 100).toStringAsFixed(1)}%',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _buildConfidenceBadge(topResult['confidence']),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Treatment
                    Text(
                      'Treatment:',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      dt.treatment[topResult['index']],
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _showFeedbackDialog(topResult, diseaseId);
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: AppColors.mediumGreen),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Beri Feedback',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.mediumGreen,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await _navigateToDetail(diseaseId);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.mediumGreen,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Lihat Detail',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
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
                  content: Text('Terima kasih atas feedback Anda!'),
                  backgroundColor: AppColors.mediumGreen,
                ),
              );
            }
          }
        },
      ),
    );
  }

  Future<void> _navigateToDetail(String diseaseId) async {
    final disease = await _diseaseService.getDiseaseById(diseaseId);
    if (disease != null && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DiseaseDetailPage(disease: disease),
        ),
      );
    }
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

  Widget _buildConfidenceBadge(double confidence) {
    Color color;
    if (confidence >= 0.8) {
      color = Colors.green;
    } else if (confidence >= 0.5) {
      color = Colors.orange;
    } else {
      color = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '${(confidence * 100).toStringAsFixed(0)}%',
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.mediumGreen,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Scan Tanaman',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: FutureBuilder<void>(
        future: _initCameraFuture,
        builder: (_, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.mediumGreen),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Kamera tidak tersedia',
                    style: GoogleFonts.poppins(fontSize: 16, color: Colors.red),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Error: ${snapshot.error}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Camera Preview
              Expanded(
                child: Stack(
                  children: [
                    // Camera
                    SizedBox(
                      width: double.infinity,
                      child: CameraPreview(_camController!),
                    ),

                    // Overlay frame
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.mediumGreen,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    // Guide text
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: Text(
                        'Posisikan daun di dalam frame',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white,
                          shadows: [
                            Shadow(color: Colors.black54, blurRadius: 4),
                          ],
                        ),
                      ),
                    ),

                    // Processing indicator
                    if (_isProcessing)
                      Container(
                        color: Colors.black54,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                color: AppColors.mediumGreen,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Menganalisis...',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Capture Button
              Container(
                padding: const EdgeInsets.all(24),
                color: Colors.white,
                child: GestureDetector(
                  onTap: _isProcessing ? null : _handleScan,
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: _isProcessing
                          ? Colors.grey
                          : AppColors.mediumGreen,
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, color: Colors.white, size: 28),
                          const SizedBox(width: 12),
                          Text(
                            _isProcessing ? 'Memproses...' : 'PERIKSA',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
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
}
