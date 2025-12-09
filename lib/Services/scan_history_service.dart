import 'package:uuid/uuid.dart';
import 'package:arbtilant/Models/scan_result_model.dart';
import 'package:arbtilant/Services/hive_service.dart';

class ScanHistoryService {
  static final ScanHistoryService _instance = ScanHistoryService._internal();
  final HiveService _hiveService = HiveService();
  final Uuid _uuid = const Uuid();

  factory ScanHistoryService() {
    return _instance;
  }

  ScanHistoryService._internal();

  /// Save scan result
  Future<ScanResultModel> saveScanResult({
    required String diseaseId,
    required String imagePath,
    required String predictedLabel,
    required double confidence,
    required List<Map<String, dynamic>> top3Predictions,
    required String modelVersion,
  }) async {
    final predictions = top3Predictions
        .map(
          (p) => PredictionModel(
            label: p['label'] as String,
            confidence: (p['confidence'] as num).toDouble(),
            index: p['index'] as int,
          ),
        )
        .toList();

    final scanResult = ScanResultModel(
      id: _uuid.v4(),
      diseaseId: diseaseId,
      imagePath: imagePath,
      predictedLabel: predictedLabel,
      confidence: confidence,
      top3Predictions: predictions,
      modelVersion: modelVersion,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _hiveService.saveScanResult(scanResult);
    return scanResult;
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

  /// Delete scan result
  Future<void> deleteScanResult(String id) async {
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
