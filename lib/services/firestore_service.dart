import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final bool useMockData = false; // Set to true to use mock data for development

  Stream<Map<String, dynamic>> streamDailySummary(String uid, DateTime date) {
    if (useMockData) {
      return Stream.value({
        'caloriesLeft': 1434,
        'caloriesEaten': 666,
        'caloriesBurned': 108,
        'proteinLeft': 110,
        'carbsLeft': 160,
        'fatsLeft': 40,
        'waterLeft': 1400,
        'stepsLeft': 4000,
        'macroTarget': {'calories': 2800, 'proteinG': 106, 'fatsG': 78, 'carbsG': 418},
        'streakStatus': 'green'
      });
    }
    final path = 'users/$uid/daily/${DateFormat('yyyy-MM-dd').format(date)}';
    return _db.doc(path).snapshots().map((snapshot) => snapshot.data() ?? {});
  }

  Future<List<Map<String, dynamic>>> fetchRecentMeals(String uid, {int limit = 3}) {
    if (useMockData) {
      return Future.value([
        {
          'id': 'mock_meal_1',
          'name': 'Mock Meal 1',
          'calories': 350,
          'timestamp': Timestamp.now(),
          'thumbnailUrl': 'https://via.placeholder.com/150'
        },
         {
          'id': 'mock_meal_2',
          'name': 'Mock Meal 2',
          'calories': 450,
          'timestamp': Timestamp.now(),
          'thumbnailUrl': 'https://via.placeholder.com/150'
        },
      ]);
    }
    return _db
        .collection('users/$uid/meals')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .get()
        .then((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              data['id'] = doc.id; // Add document ID to the map
              return data;
            }).toList());
  }

  Future<Map<DateTime, String>> fetchMonthStatus(String uid, int year, int month) {
    if (useMockData) {
      return Future.value({
        DateTime(year, month, 1): 'green',
        DateTime(year, month, 2): 'yellow',
        DateTime(year, month, 3): 'red',
      });
    }
    // This implementation is more complex and would require fetching all documents for the month.
    // For now, returning an empty map.
    // A real implementation would query the 'daily' subcollection for the given month.
    return Future.value({});
  }
}
