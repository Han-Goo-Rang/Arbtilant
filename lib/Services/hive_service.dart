import 'package:hive_flutter/hive_flutter.dart';
import 'package:arbtilant/Models/disease_model.dart';
import 'package:arbtilant/Models/scan_result_model.dart';
import 'package:arbtilant/Models/feedback_model.dart';

/// Helper function to safely cast Map to Map<String, dynamic>
/// Handles nested maps recursively
Map<String, dynamic> _castToStringDynamicMap(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  if (value is Map) {
    final result = <String, dynamic>{};
    value.forEach((key, val) {
      final stringKey = key.toString();
      if (val is Map) {
        result[stringKey] = _castToStringDynamicMap(val);
      } else if (val is List) {
        result[stringKey] = val.map((item) {
          if (item is Map) {
            return _castToStringDynamicMap(item);
          }
          return item;
        }).toList();
      } else {
        result[stringKey] = val;
      }
    });
    return result;
  }
  throw TypeError();
}

class HiveService {
  static final HiveService _instance = HiveService._internal();

  factory HiveService() {
    return _instance;
  }

  HiveService._internal();

  static const String diseasesBox = 'diseases';
  static const String scanResultsBox = 'scan_results';
  static const String feedbackBox = 'feedback';
  static const String syncMetadataBox = 'sync_metadata';

  /// Initialize Hive
  Future<void> init() async {
    try {
      await Hive.initFlutter();
      print('✅ Hive.initFlutter() completed');

      // Open boxes - use dynamic type for flexibility
      try {
        if (!Hive.isBoxOpen(diseasesBox)) {
          await Hive.openBox(diseasesBox);
          print('✅ Opened $diseasesBox box');
        } else {
          print('⚠️ $diseasesBox box already open');
        }
      } catch (e) {
        print('❌ Error opening $diseasesBox: $e');
      }

      try {
        if (!Hive.isBoxOpen(scanResultsBox)) {
          await Hive.openBox(scanResultsBox);
          print('✅ Opened $scanResultsBox box');
        } else {
          print('⚠️ $scanResultsBox box already open');
        }
      } catch (e) {
        print('❌ Error opening $scanResultsBox: $e');
      }

      try {
        if (!Hive.isBoxOpen(feedbackBox)) {
          await Hive.openBox(feedbackBox);
          print('✅ Opened $feedbackBox box');
        } else {
          print('⚠️ $feedbackBox box already open');
        }
      } catch (e) {
        print('❌ Error opening $feedbackBox: $e');
      }

      try {
        if (!Hive.isBoxOpen(syncMetadataBox)) {
          await Hive.openBox(syncMetadataBox);
          print('✅ Opened $syncMetadataBox box');
        } else {
          print('⚠️ $syncMetadataBox box already open');
        }
      } catch (e) {
        print('❌ Error opening $syncMetadataBox: $e');
      }
    } catch (e) {
      print('❌ Hive initialization error: $e');
      rethrow;
    }
  }

  /// ============ DISEASES ============

  /// Save diseases to local storage
  Future<void> saveDiseases(List<DiseaseModel> diseases) async {
    try {
      final box = Hive.box(diseasesBox);
      await box.clear();
      print('✅ Cleared $diseasesBox box');

      for (var disease in diseases) {
        await box.put(disease.id, disease.toJson());
        print('  - Saved disease: ${disease.name}');
      }
      print('✅ Saved ${diseases.length} diseases to Hive');
    } catch (e) {
      print('❌ Error saving diseases: $e');
      rethrow;
    }
  }

  /// Get all diseases from local storage
  Future<List<DiseaseModel>> getDiseases() async {
    try {
      final box = Hive.box(diseasesBox);
      print('📊 Diseases box has ${box.length} items');

      if (box.isEmpty) {
        print('⚠️ Diseases box is empty');
        return [];
      }

      final diseases = <DiseaseModel>[];
      for (var value in box.values) {
        try {
          diseases.add(DiseaseModel.fromJson(_castToStringDynamicMap(value)));
        } catch (e) {
          print('❌ Error parsing disease: $e');
        }
      }
      print('✅ Retrieved ${diseases.length} diseases from Hive');
      return diseases;
    } catch (e) {
      print('❌ Error getting diseases: $e');
      return [];
    }
  }

  /// Get disease by ID
  Future<DiseaseModel?> getDiseaseById(String id) async {
    try {
      final box = Hive.box(diseasesBox);
      final data = box.get(id);

      if (data == null) {
        return null;
      }

      return DiseaseModel.fromJson(_castToStringDynamicMap(data));
    } catch (e) {
      print('❌ Error getting disease by ID: $e');
      return null;
    }
  }

  /// Search diseases by name or slug
  Future<List<DiseaseModel>> searchDiseases(String query) async {
    try {
      final diseases = await getDiseases();
      final lowerQuery = query.toLowerCase();

      return diseases
          .where(
            (disease) =>
                disease.name.toLowerCase().contains(lowerQuery) ||
                disease.englishName.toLowerCase().contains(lowerQuery) ||
                disease.slug.toLowerCase().contains(lowerQuery),
          )
          .toList();
    } catch (e) {
      print('❌ Error searching diseases: $e');
      return [];
    }
  }

  /// ============ SCAN RESULTS ============

  /// Save scan result
  Future<void> saveScanResult(ScanResultModel scanResult) async {
    try {
      final box = Hive.box(scanResultsBox);
      print('💾 Saving scan result to Hive: ${scanResult.id}');
      await box.put(scanResult.id, scanResult.toJson());
      print('✅ Scan result saved to Hive: ${scanResult.id}');
    } catch (e) {
      print('❌ Error saving scan result: $e');
      rethrow;
    }
  }

  /// Get all scan results
  Future<List<ScanResultModel>> getScanResults() async {
    try {
      final box = Hive.box(scanResultsBox);

      if (box.isEmpty) {
        return [];
      }

      return box.values
          .map((e) => ScanResultModel.fromJson(_castToStringDynamicMap(e)))
          .toList();
    } catch (e) {
      print('❌ Error getting scan results: $e');
      return [];
    }
  }

  /// Get scan result by ID
  Future<ScanResultModel?> getScanResultById(String id) async {
    try {
      final box = Hive.box(scanResultsBox);
      final data = box.get(id);

      if (data == null) {
        return null;
      }

      return ScanResultModel.fromJson(_castToStringDynamicMap(data));
    } catch (e) {
      print('❌ Error getting scan result by ID: $e');
      return null;
    }
  }

  /// Delete scan result
  Future<void> deleteScanResult(String id) async {
    try {
      final box = Hive.box(scanResultsBox);
      await box.delete(id);
    } catch (e) {
      print('❌ Error deleting scan result: $e');
    }
  }

  /// Get pending scan results (not synced)
  Future<List<ScanResultModel>> getPendingScanResults() async {
    try {
      final box = Hive.box(scanResultsBox);

      if (box.isEmpty) {
        return [];
      }

      final results = <ScanResultModel>[];
      for (var value in box.values) {
        try {
          final json = _castToStringDynamicMap(value);
          final scan = ScanResultModel.fromJson(json);
          if (!scan.synced) {
            results.add(scan);
          }
        } catch (e) {
          print('❌ Error parsing scan result: $e');
          continue;
        }
      }
      return results;
    } catch (e) {
      print('❌ Error getting pending scan results: $e');
      return [];
    }
  }

  /// Mark scan result as synced
  Future<void> markScanResultAsSynced(String scanResultId) async {
    try {
      final box = Hive.box(scanResultsBox);
      final data = box.get(scanResultId);

      if (data != null) {
        final scanResult = ScanResultModel.fromJson(
          _castToStringDynamicMap(data),
        );
        final syncedResult = scanResult.copyWith(synced: true);
        await box.put(scanResultId, syncedResult.toJson());
      }
    } catch (e) {
      print('❌ Error marking scan as synced: $e');
    }
  }

  /// ============ FEEDBACK ============

  /// Save feedback
  Future<void> saveFeedback(FeedbackModel feedback) async {
    try {
      final box = Hive.box(feedbackBox);
      await box.put(feedback.id, feedback.toJson());
    } catch (e) {
      print('❌ Error saving feedback: $e');
    }
  }

  /// Get all feedback
  Future<List<FeedbackModel>> getFeedback() async {
    try {
      final box = Hive.box(feedbackBox);

      if (box.isEmpty) {
        return [];
      }

      return box.values
          .map((e) => FeedbackModel.fromJson(_castToStringDynamicMap(e)))
          .toList();
    } catch (e) {
      print('❌ Error getting feedback: $e');
      return [];
    }
  }

  /// Get pending feedback (not synced)
  Future<List<FeedbackModel>> getPendingFeedback() async {
    try {
      final allFeedback = await getFeedback();
      return allFeedback.where((f) => !f.synced).toList();
    } catch (e) {
      print('❌ Error getting pending feedback: $e');
      return [];
    }
  }

  /// Mark feedback as synced
  Future<void> markFeedbackAsSynced(String feedbackId) async {
    try {
      final box = Hive.box(feedbackBox);
      final data = box.get(feedbackId);

      if (data != null) {
        final feedback = FeedbackModel.fromJson(_castToStringDynamicMap(data));
        final syncedFeedback = feedback.copyWith(synced: true);
        await box.put(feedbackId, syncedFeedback.toJson());
      }
    } catch (e) {
      print('❌ Error marking feedback as synced: $e');
    }
  }

  /// Delete feedback
  Future<void> deleteFeedback(String id) async {
    try {
      final box = Hive.box(feedbackBox);
      await box.delete(id);
    } catch (e) {
      print('❌ Error deleting feedback: $e');
    }
  }

  /// ============ SYNC METADATA ============

  /// Update sync metadata
  Future<void> updateSyncMetadata(
    String key,
    Map<String, dynamic> metadata,
  ) async {
    try {
      final box = Hive.box(syncMetadataBox);
      await box.put(key, metadata);
    } catch (e) {
      print('❌ Error updating sync metadata: $e');
    }
  }

  /// Get sync metadata
  Future<Map<String, dynamic>?> getSyncMetadata(String key) async {
    try {
      final box = Hive.box(syncMetadataBox);
      final data = box.get(key);

      if (data == null) {
        return null;
      }

      return _castToStringDynamicMap(data);
    } catch (e) {
      print('❌ Error getting sync metadata: $e');
      return null;
    }
  }

  /// Clear all data
  Future<void> clearAll() async {
    try {
      await Hive.box(diseasesBox).clear();
      await Hive.box(scanResultsBox).clear();
      await Hive.box(feedbackBox).clear();
      await Hive.box(syncMetadataBox).clear();
      print('✅ All Hive boxes cleared');
    } catch (e) {
      print('❌ Error clearing all data: $e');
    }
  }

  /// Close Hive
  Future<void> close() async {
    await Hive.close();
  }
}
