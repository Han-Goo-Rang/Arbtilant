import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:arbtilant/Models/disease_model.dart';
import 'package:arbtilant/Models/scan_result_model.dart';
import 'package:arbtilant/Models/feedback_model.dart';
import 'package:arbtilant/core/config/supabase_config.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  late SupabaseClient _client;

  factory SupabaseService() {
    return _instance;
  }

  SupabaseService._internal();

  /// Initialize Supabase
  Future<void> init() async {
    try {
      await Supabase.initialize(
        url: SupabaseConfig.supabaseUrl,
        anonKey: SupabaseConfig.supabaseAnonKey,
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () =>
            throw TimeoutException('Supabase initialization timeout'),
      );
      _client = Supabase.instance.client;
    } catch (e) {
      print('Error initializing Supabase: $e');
      rethrow;
    }
  }

  /// Get Supabase client
  SupabaseClient get client => _client;

  /// ============ DISEASES ============

  /// Get all diseases from cloud
  Future<List<DiseaseModel>> getDiseases() async {
    try {
      final response = await _client.from('diseases').select().order('name');

      return (response as List).map((e) => DiseaseModel.fromJson(e)).toList();
    } catch (e) {
      print('Error fetching diseases: $e');
      rethrow;
    }
  }

  /// Get disease by ID
  Future<DiseaseModel?> getDiseaseById(String id) async {
    try {
      final response = await _client
          .from('diseases')
          .select()
          .eq('id', id)
          .single();

      return DiseaseModel.fromJson(response);
    } catch (e) {
      print('Error fetching disease: $e');
      return null;
    }
  }

  /// ============ SCAN RESULTS ============

  /// Save scan result to cloud
  Future<void> saveScanResult(ScanResultModel scanResult) async {
    try {
      // Build JSON manually to ensure proper formatting
      final json = <String, dynamic>{
        'id': scanResult.id,
        'disease_id': scanResult.diseaseId,
        'image_path': scanResult.imagePath,
        'predicted_label': scanResult.predictedLabel,
        'confidence': scanResult.confidence,
        'top_3_predictions': scanResult.top3Predictions
            .map((e) => e.toJson())
            .toList(),
        'model_version': scanResult.modelVersion,
        'synced': scanResult.synced,
        'created_at': scanResult.createdAt.toIso8601String(),
        'updated_at': scanResult.updatedAt.toIso8601String(),
      };

      print('DEBUG: Sending scan result JSON: $json');
      await _client.from('scan_results').insert(json);
    } catch (e) {
      print('Error saving scan result: $e');
      rethrow;
    }
  }

  /// Get all scan results
  Future<List<ScanResultModel>> getScanResults() async {
    try {
      final response = await _client
          .from('scan_results')
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((e) => ScanResultModel.fromJson(e))
          .toList();
    } catch (e) {
      print('Error fetching scan results: $e');
      rethrow;
    }
  }

  /// ============ FEEDBACK ============

  /// Save feedback to cloud
  Future<void> saveFeedback(FeedbackModel feedback) async {
    try {
      // Build JSON manually to avoid null/empty UUID fields
      final json = <String, dynamic>{
        'id': feedback.id,
        'scan_result_id': feedback.scanResultId,
        'disease_id': feedback.diseaseId,
        'is_correct': feedback.isCorrect,
        'feedback_type': feedback.feedbackType,
        'created_at': feedback.createdAt.toIso8601String(),
        'updated_at': feedback.updatedAt.toIso8601String(),
        'synced': feedback.synced,
      };

      // Only add optional fields if they have values
      if (feedback.correctedDiseaseId != null &&
          feedback.correctedDiseaseId!.isNotEmpty) {
        json['corrected_disease_id'] = feedback.correctedDiseaseId;
      }
      if (feedback.feedbackText != null && feedback.feedbackText!.isNotEmpty) {
        json['feedback_text'] = feedback.feedbackText;
      }
      if (feedback.confidenceRating != null) {
        json['confidence_rating'] = feedback.confidenceRating;
      }

      print('DEBUG: Sending feedback JSON: $json');
      await _client.from('user_feedback').insert(json);
    } catch (e) {
      print('Error saving feedback: $e');
      rethrow;
    }
  }

  /// Get all feedback
  Future<List<FeedbackModel>> getFeedback() async {
    try {
      final response = await _client
          .from('user_feedback')
          .select()
          .order('created_at', ascending: false);

      return (response as List).map((e) => FeedbackModel.fromJson(e)).toList();
    } catch (e) {
      print('Error fetching feedback: $e');
      rethrow;
    }
  }

  /// Get feedback statistics
  Future<Map<String, dynamic>> getFeedbackStats() async {
    try {
      final response = await _client.from('feedback_stats').select();

      if (response.isEmpty) {
        return {
          'total_feedback': 0,
          'correct_count': 0,
          'incorrect_count': 0,
          'accuracy_rate': 0.0,
        };
      }

      return response[0];
    } catch (e) {
      print('Error fetching feedback stats: $e');
      return {
        'total_feedback': 0,
        'correct_count': 0,
        'incorrect_count': 0,
        'accuracy_rate': 0.0,
      };
    }
  }

  /// ============ SCAN STATS ============

  /// Get scan statistics
  Future<Map<String, dynamic>> getScanStats() async {
    try {
      final response = await _client.from('scan_stats').select();

      if (response.isEmpty) {
        return {'total_scans': 0, 'avg_confidence': 0.0};
      }

      return response[0];
    } catch (e) {
      print('Error fetching scan stats: $e');
      return {'total_scans': 0, 'avg_confidence': 0.0};
    }
  }

  /// ============ CONNECTIVITY ============

  /// Check if connected to internet
  Future<bool> isConnected() async {
    try {
      // Simple connectivity check
      await _client.from('diseases').select().limit(1);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Test Supabase connection and return detailed status
  Future<Map<String, dynamic>> testConnection() async {
    final result = <String, dynamic>{
      'timestamp': DateTime.now().toIso8601String(),
      'supabase_url': SupabaseConfig.supabaseUrl,
      'has_anon_key': SupabaseConfig.supabaseAnonKey.isNotEmpty,
    };

    try {
      // Test 1: Check if client is initialized
      result['client_initialized'] = true;

      // Test 2: Try to fetch from diseases table
      try {
        final response = await _client
            .from('diseases')
            .select('id')
            .limit(1)
            .timeout(const Duration(seconds: 30));
        result['diseases_table_accessible'] = true;
        result['diseases_count'] = response.length;
      } catch (e) {
        result['diseases_table_accessible'] = false;
        result['diseases_error'] = e.toString();
      }

      // Test 3: Try to fetch from scan_results table
      try {
        final response = await _client
            .from('scan_results')
            .select('id')
            .limit(1)
            .timeout(const Duration(seconds: 30));
        result['scan_results_table_accessible'] = true;
        result['scan_results_count'] = response.length;
      } catch (e) {
        result['scan_results_table_accessible'] = false;
        result['scan_results_error'] = e.toString();
      }

      // Test 4: Try to fetch from user_feedback table
      try {
        final response = await _client
            .from('user_feedback')
            .select('id')
            .limit(1)
            .timeout(const Duration(seconds: 30));
        result['user_feedback_table_accessible'] = true;
        result['user_feedback_count'] = response.length;
      } catch (e) {
        result['user_feedback_table_accessible'] = false;
        result['user_feedback_error'] = e.toString();
      }

      result['connection_status'] = 'success';
    } catch (e) {
      result['connection_status'] = 'failed';
      result['error'] = e.toString();
    }

    return result;
  }
}
