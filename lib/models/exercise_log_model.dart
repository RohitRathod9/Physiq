import 'package:cloud_firestore/cloud_firestore.dart';

enum ExerciseType {
  cardio,
  weightlifting,
  manual,
  home,
  gym,
  other
}

class ExerciseLog {
  final String id;
  final String userId;
  final String exerciseId; // "run", "cycling", "custom_id", etc.
  final String name;
  final ExerciseType type;
  final DateTime timestamp;
  final int durationMinutes;
  final double calories;
  final String intensity; // "low", "medium", "high"
  final Map<String, dynamic> details; // sets, reps, distance, etc.
  final bool isManualOverride;
  final String source; // "manual", "timer", "wearable"

  ExerciseLog({
    required this.id,
    required this.userId,
    required this.exerciseId,
    required this.name,
    required this.type,
    required this.timestamp,
    required this.durationMinutes,
    required this.calories,
    required this.intensity,
    required this.details,
    this.isManualOverride = false,
    this.source = 'manual',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'exerciseId': exerciseId,
      'name': name,
      'type': type.toString().split('.').last,
      'timestamp': Timestamp.fromDate(timestamp),
      'durationMinutes': durationMinutes,
      'calories': calories,
      'intensity': intensity,
      'details': details,
      'isManualOverride': isManualOverride,
      'source': source,
    };
  }

  factory ExerciseLog.fromMap(Map<String, dynamic> map) {
    return ExerciseLog(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      exerciseId: map['exerciseId'] ?? '',
      name: map['name'] ?? '',
      type: _parseType(map['type']),
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      durationMinutes: map['durationMinutes'] ?? 0,
      calories: (map['calories'] ?? 0).toDouble(),
      intensity: map['intensity'] ?? 'medium',
      details: map['details'] ?? {},
      isManualOverride: map['isManualOverride'] ?? false,
      source: map['source'] ?? 'manual',
    );
  }

  static ExerciseType _parseType(String? type) {
    return ExerciseType.values.firstWhere(
      (e) => e.toString().split('.').last == type,
      orElse: () => ExerciseType.other,
    );
  }
}
