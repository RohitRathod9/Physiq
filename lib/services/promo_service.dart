import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class PromoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Generate 6-letter uppercase code
  String _generatePromo6() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final rnd = Random.secure();
    return String.fromCharCodes(Iterable.generate(
      6,
      (_) => chars.codeUnitAt(rnd.nextInt(chars.length)),
    ));
  }

  // Ensure user has a promo code, generating one if needed with uniqueness check
  Future<String> ensurePromoCode(String uid) async {
    // 1. Check if user already has a code
    final userDoc = await _firestore.collection('users').doc(uid).get();
    if (userDoc.exists && userDoc.data()!.containsKey('promoCode')) {
      return userDoc.data()!['promoCode'];
    }

    // 2. Generate and assign new code with retries
    int retries = 5;
    while (retries > 0) {
      final code = _generatePromo6();
      final promoRef = _firestore.collection('promoCodes').doc(code);
      final userRef = _firestore.collection('users').doc(uid);

      try {
        await _firestore.runTransaction((transaction) async {
          final promoDoc = await transaction.get(promoRef);
          if (promoDoc.exists) {
            throw Exception('Collision');
          }

          transaction.set(promoRef, {
            'ownerUid': uid,
            'createdAt': FieldValue.serverTimestamp(),
          });

          transaction.set(userRef, {
            'promoCode': code,
          }, SetOptions(merge: true));
        });

        return code; // Success
      } catch (e) {
        if (e.toString().contains('Collision')) {
          retries--;
          continue;
        }
        rethrow;
      }
    }
    throw Exception('Failed to generate unique promo code after 5 attempts');
  }

  // Record an invite share
  Future<void> logInviteShare(String referrerUid, String code) async {
    await _firestore.collection('invites').add({
      'referrerUid': referrerUid,
      'code': code,
      'createdAt': FieldValue.serverTimestamp(),
      'status': 'pending',
    });
  }
}
