import '../services/lich_viec.dart';

class LucDieuResult {
  final String name;
  final bool isHoangDao;
  final int index;

  const LucDieuResult({
    required this.name,
    required this.isHoangDao,
    required this.index,
  });

  String get loai => isHoangDao ? 'Hoàng đạo' : 'Hắc đạo';
}

class LunarDate {
  final int day;
  final int month;
  final int year;
  final bool isLeapMonth;
  final String canChiYear;
  final String canChiDay;
  final LucDieuResult lucDieu;
  final LichViecResult lichViec;

  const LunarDate({
    required this.day,
    required this.month,
    required this.year,
    required this.isLeapMonth,
    required this.canChiYear,
    required this.canChiDay,
    required this.lucDieu,
    required this.lichViec,
  });

  @override
  String toString() =>
      'LunarDate($day/$month/$year${isLeapMonth ? " (Nhuận)" : ""}, Year: $canChiYear, Day: $canChiDay, LucDieu: ${lucDieu.name})';
}
