import 'package:flutter_test/flutter_test.dart';
import 'package:physiq/models/leaderboard_model.dart';

void main() {
  group('Leaderboard Logic Tests', () {
    test('Ranking order is correct based on score', () {
      final users = [
        LeaderboardEntry(uid: '1', displayName: 'A', score: 100),
        LeaderboardEntry(uid: '2', displayName: 'B', score: 200),
        LeaderboardEntry(uid: '3', displayName: 'C', score: 150),
      ];

      users.sort((a, b) => b.score.compareTo(a.score));

      expect(users[0].uid, '2');
      expect(users[1].uid, '3');
      expect(users[2].uid, '1');
    });

    test('Score calculation logic (mock)', () {
      // score = (min(streakDays, 60) * 2.0) + (consistencyPct * 1.5)
      double calculateScore(int streak, int consistency) {
        return (streak.clamp(0, 60) * 2.0) + (consistency * 1.5);
      }

      expect(calculateScore(10, 100), (10 * 2.0) + (100 * 1.5)); // 20 + 150 = 170
      expect(calculateScore(70, 50), (60 * 2.0) + (50 * 1.5));   // 120 + 75 = 195 (capped streak)
    });
  });
}
