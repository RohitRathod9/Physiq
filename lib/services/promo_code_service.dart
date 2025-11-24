import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class PromoCodeService {
  static const String _kPromoCodeKey = 'user_promo_code';

  Future<String> getOrGeneratePromoCode() async {
    final prefs = await SharedPreferences.getInstance();
    String? code = prefs.getString(_kPromoCodeKey);
    
    if (code == null) {
      code = _generateCode();
      await prefs.setString(_kPromoCodeKey, code);
    }
    return code;
  }

  String _generateCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final rnd = Random();
    return String.fromCharCodes(Iterable.generate(
      6,
      (_) => chars.codeUnitAt(rnd.nextInt(chars.length)),
    ));
  }
}
