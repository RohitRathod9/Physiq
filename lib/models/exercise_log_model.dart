class ExerciseLog {
  final String id;
  final String exerciseId;
  final String title;
  final DateTime startedAt;
  final DateTime endedAt;
  final double durationMinutes;
  final double exerciseCalories;
  final int totalReps;
  final List<SetEntry> sets;
  final double epocCalories;
  final Map<String, dynamic> meta; // RPE, notes, source
  final String timezone;

  ExerciseLog({
    required this.id,
    required this.exerciseId,
    required this.title,
    required this.startedAt,
    required this.endedAt,
    required this.durationMinutes,
    required this.exerciseCalories,
    required this.totalReps,
    required this.sets,
    this.epocCalories = 0.0,
    required this.meta,
    required this.timezone,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'exerciseId': exerciseId,
      'title': title,
      'startedAt': startedAt.toIso8601String(),
      'endedAt': endedAt.toIso8601String(),
      'durationMinutes': durationMinutes,
      'exerciseCalories': exerciseCalories,
      'totalReps': totalReps,
      'sets': sets.map((x) => x.toMap()).toList(),
      'epocCalories': epocCalories,
      'meta': meta,
      'timezone': timezone,
    };
  }

  factory ExerciseLog.fromMap(Map<String, dynamic> map) {
    return ExerciseLog(
      id: map['id'] ?? '',
      exerciseId: map['exerciseId'] ?? '',
      title: map['title'] ?? '',
      startedAt: DateTime.parse(map['startedAt']),
      endedAt: DateTime.parse(map['endedAt']),
      durationMinutes: (map['durationMinutes'] ?? 0.0).toDouble(),
      exerciseCalories: (map['exerciseCalories'] ?? 0.0).toDouble(),
      totalReps: map['totalReps'] ?? 0,
      sets: List<SetEntry>.from((map['sets'] ?? []).map((x) => SetEntry.fromMap(x))),
      epocCalories: (map['epocCalories'] ?? 0.0).toDouble(),
      meta: map['meta'] ?? {},
      timezone: map['timezone'] ?? 'UTC',
    );
  }
}

class SetEntry {
  final int reps;
  final double? weight;
  final int? restSeconds;

  SetEntry({required this.reps, this.weight, this.restSeconds});

  Map<String, dynamic> toMap() {
    return {
      'reps': reps,
      'weight': weight,
      'restSeconds': restSeconds,
    };
  }

  factory SetEntry.fromMap(Map<String, dynamic> map) {
    return SetEntry(
      reps: map['reps'] ?? 0,
      weight: map['weight']?.toDouble(),
      restSeconds: map['restSeconds'],
    );
  }
}
