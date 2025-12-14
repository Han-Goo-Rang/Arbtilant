class DiseaseModel {
  final String id;
  final String slug;
  final String name;
  final String englishName;
  final List<String> scientificNames;
  final String description;
  final List<String> symptoms;
  final List<String> causes;
  final List<String> treatment;
  final List<String> prevention;
  final String severity;
  final String category;
  final List<String> affectedPlants;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  DiseaseModel({
    required this.id,
    required this.slug,
    required this.name,
    required this.englishName,
    required this.scientificNames,
    required this.description,
    required this.symptoms,
    required this.causes,
    required this.treatment,
    required this.prevention,
    required this.severity,
    required this.category,
    required this.affectedPlants,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DiseaseModel.fromJson(Map<String, dynamic> json) {
    return DiseaseModel(
      id: json['id'] as String,
      slug: json['slug'] as String,
      name: json['name'] as String,
      englishName: json['english_name'] as String? ?? '',
      scientificNames: List<String>.from(
        json['scientific_names'] as List? ?? [],
      ),
      description: json['description'] as String,
      symptoms: List<String>.from(json['symptoms'] as List? ?? []),
      causes: List<String>.from(json['causes'] as List? ?? []),
      treatment: List<String>.from(json['treatment'] as List? ?? []),
      prevention: List<String>.from(json['prevention'] as List? ?? []),
      severity: json['severity'] as String,
      category: json['category'] as String,
      affectedPlants: List<String>.from(json['affected_plants'] as List? ?? []),
      imageUrl: json['image_url'] as String?,
      createdAt: DateTime.parse(
        json['created_at'] as String? ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] as String? ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'name': name,
      'english_name': englishName,
      'scientific_names': scientificNames,
      'description': description,
      'symptoms': symptoms,
      'causes': causes,
      'treatment': treatment,
      'prevention': prevention,
      'severity': severity,
      'category': category,
      'affected_plants': affectedPlants,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  DiseaseModel copyWith({
    String? id,
    String? slug,
    String? name,
    String? englishName,
    List<String>? scientificNames,
    String? description,
    List<String>? symptoms,
    List<String>? causes,
    List<String>? treatment,
    List<String>? prevention,
    String? severity,
    String? category,
    List<String>? affectedPlants,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DiseaseModel(
      id: id ?? this.id,
      slug: slug ?? this.slug,
      name: name ?? this.name,
      englishName: englishName ?? this.englishName,
      scientificNames: scientificNames ?? this.scientificNames,
      description: description ?? this.description,
      symptoms: symptoms ?? this.symptoms,
      causes: causes ?? this.causes,
      treatment: treatment ?? this.treatment,
      prevention: prevention ?? this.prevention,
      severity: severity ?? this.severity,
      category: category ?? this.category,
      affectedPlants: affectedPlants ?? this.affectedPlants,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() =>
      'DiseaseModel(id: $id, name: $name, severity: $severity)';
}
