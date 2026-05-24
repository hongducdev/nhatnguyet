import 'package:flutter_test/flutter_test.dart';
import 'package:nhatnguyet/services/lunar_converter.dart';

void main() {
  group('LunarConverter tests', () {
    test('Convert typical dates', () {
      final d1 = LunarConverter.convertSolar2Lunar(24, 5, 2026, 7.0);
      expect(d1.day, 8);
      expect(d1.month, 4);
      expect(d1.year, 2026);
      expect(d1.canChiYear, 'Bính Ngọ');

      final d2 = LunarConverter.convertSolar2Lunar(1, 1, 2024, 7.0);
      expect(d2.day, 20);
      expect(d2.month, 11);
      expect(d2.year, 2023);
      expect(d2.canChiYear, 'Quý Mão');

      final d3 = LunarConverter.convertSolar2Lunar(10, 2, 2024, 7.0);
      expect(d3.day, 1);
      expect(d3.month, 1);
      expect(d3.year, 2024);
      expect(d3.canChiYear, 'Giáp Thìn');

      // Add a few more from Ho Ngoc Duc test data
      final d4 = LunarConverter.convertSolar2Lunar(21, 3, 2004, 7.0);
      expect(d4.day, 1);
      expect(d4.month, 2);
      expect(d4.year, 2004);
      expect(d4.isLeapMonth, true); // 2004 leap month 2
      expect(d4.canChiYear, 'Giáp Thân');

      final d5 = LunarConverter.convertSolar2Lunar(1, 1, 1999, 7.0);
      expect(d5.day, 14);
      expect(d5.month, 11);
      expect(d5.year, 1998);

      final d6 = LunarConverter.convertSolar2Lunar(24, 12, 1998, 7.0);
      expect(d6.day, 6);
      expect(d6.month, 11);
      expect(d6.year, 1998);

      final d7 = LunarConverter.convertSolar2Lunar(10, 8, 2023, 7.0);
      expect(d7.day, 24);
      expect(d7.month, 6);
      expect(d7.year, 2023);

      final d8 = LunarConverter.convertSolar2Lunar(30, 8, 2025, 7.0);
      expect(d8.day, 8);
      expect(d8.month, 7); // 2025 leap month 6
      expect(d8.year, 2025);
      expect(d8.isLeapMonth, false);

      final d9 = LunarConverter.convertSolar2Lunar(26, 7, 2025, 7.0);
      expect(d9.day, 2);
      expect(d9.month, 6);
      expect(d9.year, 2025);
      expect(d9.isLeapMonth, true); // 2025 leap month 6

      final d10 = LunarConverter.convertSolar2Lunar(9, 2, 2005, 7.0);
      expect(d10.day, 1);
      expect(d10.month, 1);
      expect(d10.year, 2005);
      expect(d10.canChiYear, 'Ất Dậu');
    });
  });
}
