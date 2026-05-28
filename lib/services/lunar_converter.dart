import 'dart:math';

import '../models/lunar_date.dart';
import 'lich_viec.dart';

int _lucDieuIndex(int lunarMonth, int lunarDay) {
  const offset = [
    0, 1, 2, 3, 4, 5, // tháng 1-6
    0, 1, 2, 3, 4, 5, // tháng 7-12
  ];
  final m = ((lunarMonth - 1) % 12);
  final off = offset[m];
  return ((lunarDay - 1 + off) % 6 + 6) % 6;
}

class LunarConverter {
  static const List<String> _can = [
    'Giáp', 'Ất', 'Bính', 'Đinh', 'Mậu', 'Kỷ', 'Canh', 'Tân', 'Nhâm', 'Quý'
  ];

  static const List<String> _chi = [
    'Tý', 'Sửu', 'Dần', 'Mão', 'Thìn', 'Tỵ', 'Ngọ', 'Mùi', 'Thân', 'Dậu', 'Tuất', 'Hợi'
  ];

  static int jdFromDate(int dd, int mm, int yy) {
    int a = ((14 - mm) / 12).floor();
    int y = yy + 4800 - a;
    int m = mm + 12 * a - 3;
    return dd +
        ((153 * m + 2) / 5).floor() +
        365 * y +
        (y / 4).floor() -
        (y / 100).floor() +
        (y / 400).floor() -
        32045;
  }

  static double newMoon(int k) {
    double t = k / 1236.85;
    double t2 = t * t;
    double t3 = t2 * t;
    double dr = pi / 180;
    
    double jde = 2415020.75933 +
        29.53058868 * k +
        0.0001178 * t2 -
        0.000000155 * t3 +
        0.00033 * sin((166.56 + 132.87 * t - 0.009173 * t2) * dr);

    double m = (359.2242 + 29.10535608 * k - 0.0000333 * t2 - 0.00000347 * t3) * dr;
    double mpr = (306.0253 + 385.81691806 * k + 0.0107306 * t2 + 0.00001236 * t3) * dr;
    double f = (21.2964 + 390.67050646 * k - 0.0016528 * t2 - 0.00000239 * t3) * dr;
    
    double djde = (0.1734 - 0.000393 * t) * sin(m) +
        0.0021 * sin(2 * m) -
        0.4068 * sin(mpr) +
        0.0161 * sin(2 * mpr) -
        0.0004 * sin(3 * mpr) +
        0.0104 * sin(2 * f) -
        0.0051 * sin(m + mpr) -
        0.0074 * sin(m - mpr) +
        0.0004 * sin(2 * f + m) -
        0.0004 * sin(2 * f - m) -
        0.0006 * sin(2 * f + mpr) +
        0.0010 * sin(2 * f - mpr) +
        0.0005 * sin(m + 2 * mpr);

    return jde + djde;
  }

  static int sunLongitude(double jdn) {
    double t = (jdn - 2451545.0) / 36525.0;
    double t2 = t * t;
    double dr = pi / 180;
    double m = (357.52910 + 35999.05030 * t - 0.0001559 * t2) * dr;
    double l0 = (280.46645 + 36000.76983 * t + 0.0003032 * t2) * dr;
    double dl = (1.9146 - 0.004817 * t - 0.000014 * t2) * sin(m) +
        (0.019993 - 0.000101 * t) * sin(2 * m) +
        0.00029 * sin(3 * m);
    double l = l0 + dl * dr;
    l = l - 2 * pi * (l / (2 * pi)).floor();
    if (l < 0) l += 2 * pi;
    return (l / pi * 6).floor();
  }

  static int getNewMoonDay(int k, double tz) {
    return (newMoon(k) + 0.5 + tz / 24.0).floor();
  }

  static int getLunarMonth11(int y, double tz) {
    int off = jdFromDate(31, 12, y) - 2415021;
    int k = (off / 29.530588853).floor();
    int nm = getNewMoonDay(k, tz);
    int sunL = sunLongitude(nm - 0.5);
    if (sunL >= 9) {
      nm = getNewMoonDay(k - 1, tz);
    }
    return nm;
  }

  static bool isLeapYear(int y, double tz) {
    int a11 = getLunarMonth11(y, tz);
    int b11 = getLunarMonth11(y + 1, tz);
    return ((b11 - a11) / 29.530588853 + 0.5).floor() == 13;
  }

  static int getLeapMonthOffset(int a11, double tz) {
    int k = ((a11 - 2415021.076998695) / 29.530588853 + 0.5).floor();
    int last = sunLongitude(getNewMoonDay(k, tz) - 0.5);
    int i = 1;
    do {
      int arc = sunLongitude(getNewMoonDay(k + i, tz) - 0.5);
      if (arc == last) {
        return i;
      }
      last = arc;
      i++;
    } while (i < 14);
    return 0;
  }

  static LunarDate convertSolar2Lunar(int dd, int mm, int yy, double tz) {
    int dayNumber = jdFromDate(dd, mm, yy);
    int k = ((dayNumber - 2415021.076998695) / 29.530588853).floor();
    int monthStart = getNewMoonDay(k + 1, tz);
    if (monthStart > dayNumber) {
      monthStart = getNewMoonDay(k, tz);
    }

    int a11 = getLunarMonth11(yy, tz);
    int lunarYear;
    if (a11 >= monthStart) {
      lunarYear = yy;
      a11 = getLunarMonth11(yy - 1, tz);
    } else {
      lunarYear = yy + 1;
    }

    int lunarDay = dayNumber - monthStart + 1;
    int diff = ((monthStart - a11) / 29.530588853 + 0.5).floor();
    int leapMonth = 0;
    
    if (isLeapYear(lunarYear - 1, tz)) {
      int leapMonthDiff = getLeapMonthOffset(a11, tz);
      int leapNM = getNewMoonDay(k - diff + leapMonthDiff, tz);
      if (leapNM > a11) {
        leapMonth = leapMonthDiff;
        if (leapNM > monthStart) {
          leapMonth--;
        }
      }
    }

    int lunarMonth = diff + 11;
    bool isLeap = false;
    if (diff >= leapMonth && leapMonth > 0) {
      lunarMonth = diff + 10;
      if (diff == leapMonth) {
        isLeap = true;
      }
    }
    if (lunarMonth > 12) {
      lunarMonth -= 12;
    }
    if (lunarMonth >= 11 && diff < 4) {
      lunarYear--;
    }

    String canChiY = '${_can[(lunarYear + 6) % 10]} ${_chi[(lunarYear + 8) % 12]}';
    final yearCanIdx = (lunarYear + 6) % 10;
    final monthStartCan = (yearCanIdx * 2 + 2) % 10;
    final monthCan = (monthStartCan + lunarMonth - 1) % 10;
    final monthChi = (lunarMonth + 1) % 12;
    String canChiM = '${_can[monthCan]} ${_chi[monthChi]}';
    final canDIdx = (dayNumber + 9) % 10;
    String canChiD = '${_can[canDIdx]} ${_chi[(dayNumber + 1) % 12]}';

    const lucDieuNames = [
      'Tiên Thắng', 'Hữu Đức', 'Tốc Hỷ',
      'Xích Khẩu', 'Tiểu Cát', 'Không Vong',
    ];
    const hoangDaoNames = {
      'Tiên Thắng', 'Hữu Đức', 'Tốc Hỷ', 'Tiểu Cát'
    };
    final ldIdx = _lucDieuIndex(lunarMonth, lunarDay);
    final ldName = lucDieuNames[ldIdx];

    return LunarDate(
      day: lunarDay,
      month: lunarMonth,
      year: lunarYear,
      isLeapMonth: isLeap,
      canChiYear: canChiY,
      canChiMonth: canChiM,
      canChiDay: canChiD,
      lucDieu: LucDieuResult(
        name: ldName,
        isHoangDao: hoangDaoNames.contains(ldName),
        index: ldIdx,
      ),
      lichViec: LichViec.get(ldName, canDIdx),
    );
  }

  static DateTime convertLunar2Solar(int lunarDay, int lunarMonth, int lunarYear, int lunarLeap, double tz) {
    int monthStart;
    int a11;
    if (lunarMonth < 11) {
      a11 = getLunarMonth11(lunarYear - 1, tz);
      monthStart = getNewMoonDay(((a11 - 2415021.076998695) / 29.530588853 + 0.5).floor() + lunarMonth, tz);
    } else {
      a11 = getLunarMonth11(lunarYear, tz);
      monthStart = getNewMoonDay(((a11 - 2415021.076998695) / 29.530588853 + 0.5).floor() + lunarMonth - 12, tz);
    }
    
    int leapMonthOffset = 0;
    if (isLeapYear(lunarYear, tz)) {
      leapMonthOffset = getLeapMonthOffset(a11, tz);
    }
    
    if (lunarLeap == 1) {
      monthStart = getNewMoonDay(((monthStart - 2415021.076998695) / 29.530588853 + 0.5).floor() + 1, tz);
    } else if (leapMonthOffset > 0) {
      int leapMonth = leapMonthOffset - 2;
      if (leapMonth < 0) leapMonth += 12;
      if (lunarMonth > leapMonth && (lunarMonth != 11 || leapMonthOffset == 1)) {
        monthStart = getNewMoonDay(((monthStart - 2415021.076998695) / 29.530588853 + 0.5).floor() + 1, tz);
      }
    }
    
    int jd = monthStart + lunarDay - 1;
    return jdToDate(jd);
  }

  static DateTime jdToDate(int jd) {
    int alpha, a, b, c, d, e, z;
    z = jd + 1;
    
    if (z < 2299161) {
      a = z;
    } else {
      alpha = ((z - 1867216.25) / 36524.25).floor();
      a = z + 1 + alpha - (alpha / 4).floor();
    }
    
    b = a + 1524;
    c = ((b - 122.1) / 365.25).floor();
    d = (365.25 * c).floor();
    e = ((b - d) / 30.6001).floor();
    
    int day = b - d - (30.6001 * e).floor();
    int month = e < 14 ? e - 1 : e - 13;
    int year = month > 2 ? c - 4716 : c - 4715;
    
    return DateTime(year, month, day);
  }

}
