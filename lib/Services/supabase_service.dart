import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:arbtilant/Models/disease_model.dart';
import 'package:arbtilant/Models/scan_result_model.dart';
import 'package:arbtilant/Models/feedback_model.dart';


/// DISABLED: Supabase service is currently disabled.
/// All methods return empty values or throw exceptions.
/// To enable, uncomment the implementation and configure Supabase credentials.
class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  late SupabaseClient _client;

  factory SupabaseService() {
    return _instance;
  }

  SupabaseService._internal();

  /// Initialize Supabase - DISABLED
  Future<void> init() async {
    print('⚠️ Supabase service is disabled');
    throw Exception('Supabase service is currently disabled');
  }

  /// Get Supabase client - DISABLED
  SupabaseClient get client => throw Exception('Supabase service is disabled');

  /// ============ DISEASES ============

  /// Get all diseases from cloud - DISABLED
  Future<List<DiseaseModel>> getDiseases() async {
    print('⚠️ Supabase getDiseases() is disabled');
    return [];
  }

  /// Get disease by ID - DISABLED
  Future<DiseaseModel?> getDiseaseById(String id) async {
    print('⚠️ Supabase getDiseaseById() is disabled');
    return null;
  }

  /// ============ SCAN RESULTS ============

  /// Save scan result to cloud - DISABLED
  Future<void> saveScanResult(ScanResultModel scanResult) async {
    print('⚠️ Supabase saveScanResult() is disabled');
  }

  /// Get all scan results - DISABLED
  Future<List<ScanResultModel>> getScanResults() async {
    print('⚠️ Supabase getScanResults() is disabled');
    return [];
  }

  /// ============ FEEDBACK ============

  /// Save feedback to cloud - DISABLED
  Future<void> saveFeedback(FeedbackModel feedback) async {
    print('⚠️ Supabase saveFeedback() is disabled');
  }

  /// Get all feedback - DISABLED
  Future<List<FeedbackModel>> getFeedback() async {
    print('⚠️ Supabase getFeedback() is disabled');
    return [];
  }

  /// Get feedback statistics - DISABLED
  Future<Map<String, dynamic>> getFeedbackStats() async {
    print('⚠️ Supabase getFeedbackStats() is disabled');
    return {
      'total_feedback': 0,
      'correct_count': 0,
      'incorrect_count': 0,
      'accuracy_rate': 0.0,
    };
  }

  /// ============ SCAN STATS ============

  /// Get scan statistics - DISABLED
  Future<Map<String, dynamic>> getScanStats() async {
    print('⚠️ Supabase getScanStats() is disabled');
    return {'total_scans': 0, 'avg_confidence': 0.0};
  }

  /// ============ CONNECTIVITY ============

  /// Check if connected to internet - DISABLED
  Future<bool> isConnected() async {
    print('⚠️ Supabase isConnected() is disabled');
    return false;
  }

  /// Test Supabase connection and return detailed status - DISABLED
  Future<Map<String, dynamic>> testConnection() async {
    print('⚠️ Supabase testConnection() is disabled');
    return {
      'timestamp': DateTime.now().toIso8601String(),
      'connection_status': 'disabled',
      'message': 'Supabase service is currently disabled',
    };
  }
}
