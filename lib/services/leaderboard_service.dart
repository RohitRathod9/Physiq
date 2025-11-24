import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

class LeaderItem {
  final String uid;
  final String displayName;
  final double score;
  final int rank;

  LeaderItem({
    required this.uid,
    required this.displayName,
    required this.score,
    required this.rank,
  });

  factory LeaderItem.fromMap(Map<String, dynamic> map, int rank) {
    return LeaderItem(
      uid: map['uid'] ?? '',
      displayName: map['displayName'] ?? 'User',
      score: (map['score'] ?? 0).toDouble(),
      rank: rank,
    );
  }
}

class LeaderboardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  Future<List<LeaderItem>> fetchTop10() async {
    try {
      // Try fetching pre-computed top 10
      final doc = await _firestore.collection('leaderboards').doc('top10').get();
      if (doc.exists && doc.data() != null && doc.data()!.containsKey('items')) {
        final List<dynamic> items = doc.data()!['items'];
        return items.asMap().entries.map((e) {
          return LeaderItem.fromMap(e.value, e.key + 1);
        }).toList();
      }
      
      // Fallback: Query users directly (expensive, but fallback)
      final snapshot = await _firestore
          .collection('users')
          .orderBy('leaderboardScore', descending: true)
          .limit(10)
          .get();

      return snapshot.docs.asMap().entries.map((e) {
        final data = e.value.data();
        return LeaderItem(
          uid: e.value.id,
          displayName: data['displayName'] ?? 'User',
          score: (data['leaderboardScore'] ?? 0).toDouble(),
          rank: e.key + 1,
        );
      }).toList();
    } catch (e) {
      print('Error fetching leaderboard: $e');
      return [];
    }
  }

  Future<int> fetchUserRank(String uid) async {
    try {
      final result = await _functions.httpsCallable('getUserRank').call({'uid': uid});
      return result.data['rank'] ?? 0;
    } catch (e) {
      print('Error fetching user rank: $e');
      return 0;
    }
  }
}
