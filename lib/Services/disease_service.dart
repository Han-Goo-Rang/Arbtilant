import 'package:arbtilant/Models/disease_model.dart';
import 'package:arbtilant/Services/hive_service.dart';
import 'package:arbtilant/core/constants/disease_data.dart';

class DiseaseService {
  static final DiseaseService _instance = DiseaseService._internal();
  final HiveService _hiveService = HiveService();

  factory DiseaseService() {
    return _instance;
  }

  DiseaseService._internal();

  /// Initialize diseases - load from constants and cache locally
  Future<void> initializeDiseases() async {
    try {
      // Convert constants to DiseaseModel
      final diseases = allDiseasesData
          .map((data) => DiseaseModel.fromJson(data))
          .toList();

      // Save to local storage
      await _hiveService.saveDiseases(diseases);
      print('✅ Diseases initialized: ${diseases.length} diseases loaded');
    } catch (e) {
      print('❌ Error initializing diseases: $e');
      print('Stack trace: $e');
      // Don't rethrow - app should continue even if diseases fail to load
    }
  }

  /// Get all diseases from local cache
  Future<List<DiseaseModel>> getAllDiseases() async {
    try {
      return await _hiveService.getDiseases();
    } catch (e) {
      print('Error fetching diseases: $e');
      return [];
    }
  }

  /// Get disease by ID
  Future<DiseaseModel?> getDiseaseById(String id) async {
    try {
      return await _hiveService.getDiseaseById(id);
    } catch (e) {
      print('Error getting disease by ID: $e');
      return null;
    }
  }

  /// Search diseases
  Future<List<DiseaseModel>> searchDiseases(String query) async {
    try {
      if (query.isEmpty) {
        return await getAllDiseases();
      }
      return await _hiveService.searchDiseases(query);
    } catch (e) {
      print('Error searching diseases: $e');
      return [];
    }
  }

  /// Get diseases by category
  Future<List<DiseaseModel>> getDiseasesByCategory(String category) async {
    try {
      final diseases = await getAllDiseases();
      return diseases
          .where(
            (disease) =>
                disease.category.toLowerCase() == category.toLowerCase(),
          )
          .toList();
    } catch (e) {
      print('Error getting diseases by category: $e');
      return [];
    }
  }

  /// Get diseases by severity
  Future<List<DiseaseModel>> getDiseasesBySeverity(String severity) async {
    try {
      final diseases = await getAllDiseases();
      return diseases
          .where(
            (disease) =>
                disease.severity.toLowerCase() == severity.toLowerCase(),
          )
          .toList();
    } catch (e) {
      print('Error getting diseases by severity: $e');
      return [];
    }
  }

  /// Get all categories
  Future<List<String>> getAllCategories() async {
    try {
      final diseases = await getAllDiseases();
      final categories = <String>{};

      for (var disease in diseases) {
        categories.add(disease.category);
      }

      return categories.toList();
    } catch (e) {
      print('Error getting all categories: $e');
      return [];
    }
  }

  /// Get all severities
  Future<List<String>> getAllSeverities() async {
    try {
      final diseases = await getAllDiseases();
      final severities = <String>{};

      for (var disease in diseases) {
        severities.add(disease.severity);
      }

      return severities.toList();
    } catch (e) {
      print('Error getting all severities: $e');
      return [];
    }
  }

  /// Get affected plants for a disease
  Future<List<String>> getAffectedPlants(String diseaseId) async {
    try {
      final disease = await getDiseaseById(diseaseId);
      return disease?.affectedPlants ?? [];
    } catch (e) {
      print('Error getting affected plants: $e');
      return [];
    }
  }
}
