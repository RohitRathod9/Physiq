import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardEntry {
  final String uid;
  final String displayName;
  final String country;
  final double score;
  final int streakDays;
  final int consistencyPct;
  final DateTime? lastActive;

  LeaderboardEntry({
    required this.uid,
    required this.displayName,
    this.country = 'IN',
    required this.score,
    this.streakDays = 0,
    this.consistencyPct = 0,
    this.lastActive,
  });

  factory LeaderboardEntry.fromMap(Map<String, dynamic> data) {
    return LeaderboardEntry(
      uid: data['uid'] ?? '',
      displayName: data['displayName'] ?? 'Anonymous',
      country: data['country'] ?? 'IN',
      score: (data['score'] as num?)?.toDouble() ?? 0.0,
      streakDays: data['streakDays'] ?? 0,
      consistencyPct: data['consistencyPct'] ?? 0,
      lastActive: (data['lastActive'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'country': country,
      'score': score,
      'streakDays': streakDays,
      'consistencyPct': consistencyPct,
      'lastActive': lastActive != null ? Timestamp.fromDate(lastActive!) : null,
    };
  }
}
