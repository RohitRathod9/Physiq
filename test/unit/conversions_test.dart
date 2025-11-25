
import 'package:flutter_test/flutter_test.dart';
import 'package:physiq/utils/conversions.dart';

void main() {
  group('Conversions', () {
    test('kgToLbs converts correctly', () {
      expect(Conversions.kgToLbs(1.0), closeTo(2.20462, 0.0001));
      expect(Conversions.kgToLbs(70.0), closeTo(154.3234, 0.0001));
    });

    test('lbsToKg converts correctly', () {
      expect(Conversions.lbsToKg(2.20462), closeTo(1.0, 0.0001));
      expect(Conversions.lbsToKg(154.32), closeTo(70.0, 0.01));
    });

    test('cmToFeet converts correctly', () {
      expect(Conversions.cmToFeet(30.48), closeTo(1.0, 0.0001));
      expect(Conversions.cmToFeet(180.0), closeTo(5.9055, 0.0001));
    });

    test('cmToInches converts correctly', () {
      expect(Conversions.cmToInches(2.54), closeTo(1.0, 0.0001));
      expect(Conversions.cmToInches(180.0), closeTo(70.866, 0.001));
    });

    test('feetInchesToCm converts correctly', () {
      expect(Conversions.feetInchesToCm(5, 11), closeTo(180.34, 0.01));
      expect(Conversions.feetInchesToCm(6, 0), closeTo(182.88, 0.01));
    });

    test('cmToFeetInchesString formats correctly', () {
      expect(Conversions.cmToFeetInchesString(180.34), "5' 11\"");
      expect(Conversions.cmToFeetInchesString(182.88), "6' 0\"");
    });
  });
}
