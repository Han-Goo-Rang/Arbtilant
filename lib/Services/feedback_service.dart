import 'package:uuid/uuid.dart';
import 'package:arbtilant/Models/feedback_model.dart';
import 'package:arbtilant/Services/hive_service.dart';

class FeedbackService {
  static final FeedbackService _instance = FeedbackService._internal();
  final HiveService _hiveService = HiveService();
  final Uuid _uuid = const Uuid();

  factory FeedbackService() {
    return _instance;
  }

  FeedbackService._internal();

  /// Save feedback
  Future<FeedbackModel> saveFeedback({
    required String scanResultId,
    required String diseaseId,
    required bool isCorrect,
    String? correctedDiseaseId,
    String? feedbackText,
    int? confidenceRating,
  }) async {
    final feedback = FeedbackModel(
      id: _uuid.v4(),
      scanResultId: scanResultId,
      diseaseId: diseaseId,
      isCorrect: isCorrect,
      correctedDiseaseId: correctedDiseaseId,
      feedbackText: feedbackText,
      feedbackType: isCorrect ? 'correct' : 'incorrect',
      confidenceRating: confidenceRating,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      synced: false,
    );

    await _hiveService.saveFeedback(feedback);
    return feedback;
  }

  /// Get all feedback
  Future<List<FeedbackModel>> getAllFeedback() async {
    return await _hiveService.getFeedback();
  }

  /// Get pending feedback (not synced)
  Future<List<FeedbackModel>> getPendingFeedback() async {
    return await _hiveService.getPendingFeedback();
  }

  /// Mark feedback as synced
  Future<void> markAsSynced(String feedbackId) async {
    await _hiveService.markFeedbackAsSynced(feedbackId);
  }

  /// Delete feedback
  Future<void> deleteFeedback(String feedbackId) async {
    await _hiveService.deleteFeedback(feedbackId);
  }

  /// Get feedback statistics
  Future<Map<String, dynamic>> getFeedbackStats() async {
    final allFeedback = await getAllFeedback();

    int totalFeedback = allFeedback.length;
    int correctCount = allFeedback.where((f) => f.isCorrect).length;
    int incorrectCount = allFeedback.where((f) => !f.isCorrect).length;
    int pendingSync = allFeedback.where((f) => !f.synced).length;

    double accuracyRate = totalFeedback > 0
        ? (correctCount / totalFeedback) * 100
        : 0;

    return {
      'total': totalFeedback,
      'correct': correctCount,
      'incorrect': incorrectCount,
      'pending_sync': pendingSync,
      'accuracy_rate': accuracyRate,
    };
  }
}
