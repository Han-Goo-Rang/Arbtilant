import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:arbtilant/Models/scan_result_model.dart';
import 'package:arbtilant/Services/hive_service.dart';
import 'package:arbtilant/Services/image_storage_service.dart';

class ScanHistoryService {
  static final ScanHistoryService _instance = ScanHistoryService._internal();
  final HiveService _hiveService = HiveService();
  final ImageStorageService _imageStorageService = ImageStorageService();
  final Uuid _uuid = const Uuid();

  factory ScanHistoryService() {
    return _instance;
  }

  ScanHistoryService._internal();

  /// Save scan result with image
  Future<ScanResultModel> saveScanResult({
    required String diseaseId,
    required String imagePath, // Temp file path from camera
    required String predictedLabel,
    required double confidence,
    required List<Map<String, dynamic>> top3Predictions,
    required String modelVersion,
  }) async {
    try {
      final predictions = top3Predictions
          .map(
            (p) => PredictionModel(
              label: p['label'] as String,
              confidence: (p['confidence'] as num).toDouble(),
              index: p['index'] as int,
            ),
          )
          .toList();

      final scanId = _uuid.v4();
      print("📸 Processing scan: $scanId");

      // Save image to permanent location
      print("📁 Saving image from: $imagePath");
      final permanentImagePath = await _imageStorageService.saveImage(
        imagePath,
        '$scanId.jpg',
      );
      print("✅ Image saved to: $permanentImagePath");

      final scanResult = ScanResultModel(
        id: scanId,
        diseaseId: diseaseId,
        imagePath: permanentImagePath, // Store permanent path
        predictedLabel: predictedLabel,
        confidence: confidence,
        top3Predictions: predictions,
        modelVersion: modelVersion,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      print("💾 Saving to Hive...");
      await _hiveService.saveScanResult(scanResult);
      print('✅ Scan result saved to Hive: $scanId');
      return scanResult;
    } catch (e) {
      print('❌ Error in saveScanResult: $e');
      rethrow;
    }
  }

  /// Get all scan results
  Future<List<ScanResultModel>> getAllScanResults() async {
    final results = await _hiveService.getScanResults();
    // Sort by date descending (newest first)
    results.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return results;
  }

  /// Get scan result by ID
  Future<ScanResultModel?> getScanResultById(String id) async {
    return await _hiveService.getScanResultById(id);
  }

  /// Get image file from scan result
  Future<File?> getImageFile(ScanResultModel scanResult) async {
    try {
      return await _imageStorageService.getImage(scanResult.imagePath);
    } catch (e) {
      print('❌ Error getting image file: $e');
      return null;
    }
  }

  /// Delete scan result
  Future<void> deleteScanResult(String id) async {
    final scanResult = await _hiveService.getScanResultById(id);
    if (scanResult != null) {
      await _imageStorageService.deleteImage(scanResult.imagePath);
    }
    await _hiveService.deleteScanResult(id);
  }

  /// Get scan statistics
  Future<Map<String, dynamic>> getScanStats() async {
    final allScans = await getAllScanResults();

    int totalScans = allScans.length;

    // Count by disease
    Map<String, int> diseaseCount = {};
    for (var scan in allScans) {
      diseaseCount[scan.predictedLabel] =
          (diseaseCount[scan.predictedLabel] ?? 0) + 1;
    }

    // Average confidence
    double avgConfidence = totalScans > 0
        ? allScans.map((s) => s.confidence).reduce((a, b) => a + b) / totalScans
        : 0;

    return {
      'total_scans': totalScans,
      'disease_count': diseaseCount,
      'average_confidence': avgConfidence,
    };
  }
}
