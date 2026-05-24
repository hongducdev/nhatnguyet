import '../models/lunar_day.dart';

class LunarConverter {
  static LunarDay solarToLunar(int year, int month, int day) {
    return LunarDay(
      lunarDay: day,
      lunarMonth: month,
      lunarYear: year,
    );
  }

  static ({int year, int month, int day}) lunarToSolar(
    int lunarYear,
    int lunarMonth,
    int lunarDay, {
    bool isLeapMonth = false,
  }) {
    return (year: lunarYear, month: lunarMonth, day: lunarDay);
  }
}
