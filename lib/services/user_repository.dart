import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physiq/models/user_model.dart';
import 'package:physiq/models/leaderboard_model.dart';
import 'package:physiq/services/auth_service.dart';

final userRepositoryProvider = Provider((ref) => UserRepository());

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  // Stream user data
  Stream<UserModel?> streamUser(String uid) {
    if (AppConfig.useMockBackend) {
      // Return mock stream
      return Stream.value(UserModel(
        uid: uid,
        displayName: 'Mock User',
        birthYear: 1995,
        gender: 'male',
        heightCm: 175,
        weightKg: 70,
        goalWeightKg: 75,
        preferences: UserPreferences(),
        leaderboardScore: 123.4,
        invites: UserInvites(code: 'MOCK123', redeemedCount: 2, creditedAmount: 200),
      ));
    }
    return _firestore.collection('users').doc(uid).snapshots().map((doc) {
      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.id, doc.data()!);
      }
      return null;
    });
  }

  // Update user details
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    if (AppConfig.useMockBackend) {
      print('Mock update user: $data');
      return;
    }
    await _firestore.collection('users').doc(uid).update(data);
  }

  // Cloud Functions
  Future<String> createInviteCode() async {
    if (AppConfig.useMockBackend) {
      return 'MOCKCODE123';
    }
    final result = await _functions.httpsCallable('createInviteCode').call();
    return result.data['code'];
  }

  Future<void> claimReferral(String code, String newUserUid) async {
    if (AppConfig.useMockBackend) {
      print('Mock claim referral: $code for $newUserUid');
      return;
    }
    await _functions.httpsCallable('claimReferral').call({
      'code': code,
      'newUserUid': newUserUid,
    });
  }

  Future<void> generateCanonicalPlan() async {
    if (AppConfig.useMockBackend) {
      print('Mock generate plan');
      return;
    }
    await _functions.httpsCallable('generateCanonicalPlan').call();
  }

  Future<void> deleteAccount() async {
    if (AppConfig.useMockBackend) {
      print('Mock delete account');
      return;
    }
    await _functions.httpsCallable('deleteUserData').call();
  }

  // Leaderboard
  Future<List<LeaderboardEntry>> fetchGlobalLeaderboard() async {
    if (AppConfig.useMockBackend) {
      return List.generate(10, (index) => LeaderboardEntry(
        uid: 'user_$index',
        displayName: 'User $index',
        score: 1000.0 - (index * 50),
        streakDays: 10 - index,
      ));
    }
    final snapshot = await _firestore
        .collection('leaderboards')
        .doc('global')
        .collection('users')
        .orderBy('score', descending: true)
        .limit(10)
        .get();
    
    return snapshot.docs.map((doc) => LeaderboardEntry.fromMap(doc.data())).toList();
  }
}
