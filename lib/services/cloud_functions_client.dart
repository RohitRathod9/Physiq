import 'package:cloud_functions/cloud_functions.dart';

class CloudFunctionsClient {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  Future<void> generateCanonicalPlan({
    required String uid,
    required Map<String, dynamic> profile,
    required int clientPlanVersion,
  }) async {
    await _functions.httpsCallable('generateCanonicalPlan').call({
      'uid': uid,
      'profile': profile,
      'clientPlanVersion': clientPlanVersion,
    });
  }

  Future<void> deleteUserData(String uid) async {
    await _functions.httpsCallable('deleteUserData').call({'uid': uid});
  }

  Future<void> redeemPromoCode(String code, String newUserUid) async {
    await _functions.httpsCallable('redeemPromoCode').call({
      'code': code,
      'newUserUid': newUserUid,
    });
  }

  Future<Map<String, dynamic>> getUserRank(String uid) async {
    final result = await _functions.httpsCallable('getUserRank').call({
      'uid': uid,
    });
    return Map<String, dynamic>.from(result.data);
  }
}
