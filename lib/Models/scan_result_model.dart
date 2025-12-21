class PredictionModel {
  final String label;
  final double confidence;
  final int index;

  PredictionModel({
    required this.label,
    required this.confidence,
    required this.index,
  });

  factory PredictionModel.fromJson(Map<String, dynamic> json) {
    return PredictionModel(
      label: json['label'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      index: json['index'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {'label': label, 'confidence': confidence, 'index': index};
  }
}

class ScanResultModel {
  final String id;
  final String diseaseId;
  final String imagePath; // Now stores permanent file path (not base64)
  final String predictedLabel;
  final double confidence;
  final List<PredictionModel> top3Predictions;
  final String modelVersion;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool synced;

  ScanResultModel({
    required this.id,
    required this.diseaseId,
    required this.imagePath,
    required this.predictedLabel,
    required this.confidence,
    required this.top3Predictions,
    required this.modelVersion,
    required this.createdAt,
    required this.updatedAt,
    this.synced = false,
  });

  factory ScanResultModel.fromJson(Map<String, dynamic> json) {
    return ScanResultModel(
      id: json['id'] as String,
      diseaseId: json['disease_id'] as String,
      imagePath: json['image_path'] as String,
      predictedLabel: json['predicted_label'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      top3Predictions:
          (json['top_3_predictions'] as List?)
              ?.map((e) => PredictionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      modelVersion: json['model_version'] as String,
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
    return {
      'id': id,
      'disease_id': diseaseId,
      'image_path': imagePath,
      'predicted_label': predictedLabel,
      'confidence': confidence,
      'top_3_predictions': top3Predictions.map((e) => e.toJson()).toList(),
      'model_version': modelVersion,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'synced': synced,
    };
  }

  /// Convert to JSON for Supabase (without synced field)
  Map<String, dynamic> toSupabaseJson() {
    return {
      'id': id,
      'disease_id': diseaseId,
      'image_path': imagePath,
      'predicted_label': predictedLabel,
      'confidence': confidence,
      'top_3_predictions': top3Predictions.map((e) => e.toJson()).toList(),
      'model_version': modelVersion,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  ScanResultModel copyWith({
    String? id,
    String? diseaseId,
    String? imagePath,
    String? predictedLabel,
    double? confidence,
    List<PredictionModel>? top3Predictions,
    String? modelVersion,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? synced,
  }) {
    return ScanResultModel(
      id: id ?? this.id,
      diseaseId: diseaseId ?? this.diseaseId,
      imagePath: imagePath ?? this.imagePath,
      predictedLabel: predictedLabel ?? this.predictedLabel,
      confidence: confidence ?? this.confidence,
      top3Predictions: top3Predictions ?? this.top3Predictions,
      modelVersion: modelVersion ?? this.modelVersion,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      synced: synced ?? this.synced,
    );
  }

  @override
  String toString() =>
      'ScanResultModel(id: $id, predictedLabel: $predictedLabel, confidence: $confidence)';
}
