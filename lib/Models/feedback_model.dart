class FeedbackModel {
  final String id;
  final String scanResultId;
  final String diseaseId;
  final bool isCorrect;
  final String? correctedDiseaseId;
  final String? feedbackText;
  final String feedbackType;
  final int? confidenceRating;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool synced;

  FeedbackModel({
    required this.id,
    required this.scanResultId,
    required this.diseaseId,
    required this.isCorrect,
    this.correctedDiseaseId,
    this.feedbackText,
    required this.feedbackType,
    this.confidenceRating,
    required this.createdAt,
    required this.updatedAt,
    this.synced = false,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['id'] as String,
      scanResultId: json['scan_result_id'] as String,
      diseaseId: json['disease_id'] as String,
      isCorrect: json['is_correct'] as bool,
      correctedDiseaseId: json['corrected_disease_id'] as String?,
      feedbackText: json['feedback_text'] as String?,
      feedbackType: json['feedback_type'] as String? ?? 'correct',
      confidenceRating: json['confidence_rating'] as int?,
      createdAt: DateTime.parse(
        json['created_at'] as String? ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] as String? ?? DateTime.now().toIso8601String(),
      ),
      synced: json['synced'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'id': id,
      'scan_result_id': scanResultId,
      'disease_id': diseaseId,
      'is_correct': isCorrect,
      'feedback_type': feedbackType,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'synced': synced,
    };

    // Only include optional fields if they have values
    if (correctedDiseaseId != null && correctedDiseaseId!.isNotEmpty) {
      json['corrected_disease_id'] = correctedDiseaseId!;
    }
    if (feedbackText != null && feedbackText!.isNotEmpty) {
      json['feedback_text'] = feedbackText!;
    }
    if (confidenceRating != null) {
      json['confidence_rating'] = confidenceRating!;
    }

    return json;
  }

  /// Convert to JSON for Supabase (without synced field)
  Map<String, dynamic> toSupabaseJson() {
    final json = <String, dynamic>{
      'id': id,
      'scan_result_id': scanResultId,
      'disease_id': diseaseId,
      'is_correct': isCorrect,
      'feedback_type': feedbackType,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };

    // Only include optional fields if they have values
    if (correctedDiseaseId != null && correctedDiseaseId!.isNotEmpty) {
      json['corrected_disease_id'] = correctedDiseaseId!;
    }
    if (feedbackText != null && feedbackText!.isNotEmpty) {
      json['feedback_text'] = feedbackText!;
    }
    if (confidenceRating != null) {
      json['confidence_rating'] = confidenceRating!;
    }

    return json;
  }

  FeedbackModel copyWith({
    String? id,
    String? scanResultId,
    String? diseaseId,
    bool? isCorrect,
    String? correctedDiseaseId,
    String? feedbackText,
    String? feedbackType,
    int? confidenceRating,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? synced,
  }) {
    return FeedbackModel(
      id: id ?? this.id,
      scanResultId: scanResultId ?? this.scanResultId,
      diseaseId: diseaseId ?? this.diseaseId,
      isCorrect: isCorrect ?? this.isCorrect,
      correctedDiseaseId: correctedDiseaseId ?? this.correctedDiseaseId,
      feedbackText: feedbackText ?? this.feedbackText,
      feedbackType: feedbackType ?? this.feedbackType,
      confidenceRating: confidenceRating ?? this.confidenceRating,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      synced: synced ?? this.synced,
    );
  }

  @override
  String toString() =>
      'FeedbackModel(id: $id, isCorrect: $isCorrect, synced: $synced)';
}
