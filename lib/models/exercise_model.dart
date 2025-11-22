class Exercise {
  final String id;
  final String title;
  final String category; // e.g., 'upper_body'
  final String equipment; // 'bodyweight', 'dumbbell', etc.
  final List<String> variations; // Simplified from List<Variation> for now, or use String
  final double defaultMET;
  final String instructions;
  final String? thumbnailUrl;
  final bool userCreated;

  Exercise({
    required this.id,
    required this.title,
    required this.category,
    required this.equipment,
    this.variations = const [],
    this.defaultMET = 3.5,
    required this.instructions,
    this.thumbnailUrl,
    this.userCreated = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'equipment': equipment,
      'variations': variations,
      'defaultMET': defaultMET,
      'instructions': instructions,
      'thumbnailUrl': thumbnailUrl,
      'userCreated': userCreated,
    };
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      category: map['category'] ?? '',
      equipment: map['equipment'] ?? '',
      variations: List<String>.from(map['variations'] ?? []),
      defaultMET: (map['defaultMET'] ?? 3.5).toDouble(),
      instructions: map['instructions'] ?? '',
      thumbnailUrl: map['thumbnailUrl'],
      userCreated: map['userCreated'] ?? false,
    );
  }
}
