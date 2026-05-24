import 'package:flutter/foundation.dart';

@immutable
class LunarDay {
  final int lunarDay;
  final int lunarMonth;
  final int lunarYear;
  final bool isLeapMonth;

  const LunarDay({
    required this.lunarDay,
    required this.lunarMonth,
    required this.lunarYear,
    this.isLeapMonth = false,
  });

  factory LunarDay.empty() => const LunarDay(
        lunarDay: 0,
        lunarMonth: 0,
        lunarYear: 0,
      );

  bool get isEmpty => lunarDay == 0 && lunarMonth == 0 && lunarYear == 0;
}
