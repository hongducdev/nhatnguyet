import 'package:flutter/material.dart';

import '../models/lunar_date.dart';
import 'lunar_converter.dart';

class CalendarEventService {
  static String tietKhiFor(DateTime date) {
    const tietKhi = [
      'Lập Xuân',
      'Vũ Thủy',
      'Kinh Trập',
      'Xuân Phân',
      'Thanh Minh',
      'Cốc Vũ',
      'Lập Hạ',
      'Tiểu Mãn',
      'Mang Chủng',
      'Hạ Chí',
      'Tiểu Thử',
      'Đại Thử',
      'Lập Thu',
      'Xử Thử',
      'Bạch Lộ',
      'Thu Phân',
      'Hàn Lộ',
      'Sương Giáng',
      'Lập Đông',
      'Tiểu Tuyết',
      'Đại Tuyết',
      'Đông Chí',
      'Tiểu Hàn',
      'Đại Hàn',
    ];

    var dayOfYear = 0;
    for (var m = 1; m < date.month; m++) {
      dayOfYear += DateUtils.getDaysInMonth(date.year, m);
    }
    dayOfYear += date.day;

    final idx = ((dayOfYear - 1) / 15.2).floor().clamp(0, 23);
    return tietKhi[idx];
  }

  static List<String> gioHoangDao(LunarDate lunar) {
    const all = [
      'Tý (23-01)','Sửu (01-03)','Dần (03-05)','Mão (05-07)','Thìn (07-09)','Tỵ (09-11)',
      'Ngọ (11-13)','Mùi (13-15)','Thân (15-17)','Dậu (17-19)','Tuất (19-21)','Hợi (21-23)',
    ];
    final start = lunar.lucDieu.index % 6;
    return List.generate(6, (i) => all[(start + i * 2) % 12]);
  }

  static bool hasEvent(DateTime date, LunarDate lunar) => eventTitlesFor(date, lunar).isNotEmpty;

  static List<String> eventTitlesFor(DateTime date, LunarDate lunar) {
    final events = <String>[];
    final d = date.day;
    final m = date.month;

    if (d == 1 && m == 1) events.add('Tết Dương lịch (Nghỉ lễ toàn quốc)');
    if (d == 9 && m == 1) events.add('Ngày Học sinh - Sinh viên Việt Nam');
    if (d == 3 && m == 2) events.add('Ngày thành lập Đảng Cộng sản Việt Nam (1930)');
    if (d == 14 && m == 2) events.add('Lễ Tình nhân (Valentine)');
    if (d == 27 && m == 2) events.add('Ngày Thầy thuốc Việt Nam');
    if (d == 8 && m == 3) events.add('Ngày Quốc tế Phụ nữ');
    if (d == 20 && m == 3) events.add('Ngày Quốc tế Hạnh phúc');
    if (d == 22 && m == 3) events.add('Ngày Nước Thế giới');
    if (d == 23 && m == 3) events.add('Ngày Khí tượng Thế giới');
    if (d == 26 && m == 3) events.add('Ngày Thành lập Đoàn TNCS Hồ Chí Minh');
    if (d == 1 && m == 4) events.add('Ngày Cá tháng Tư');
    if (d == 7 && m == 4) events.add('Ngày Sức khỏe Thế giới');
    if (d == 21 && m == 4) events.add('Ngày Sách và Văn hóa đọc Việt Nam');
    if (d == 22 && m == 4) events.add('Ngày Trái Đất');
    if (d == 30 && m == 4) events.add('Ngày Giải phóng miền Nam, Thống nhất đất nước (Nghỉ lễ)');
    if (d == 1 && m == 5) events.add('Ngày Quốc tế Lao động (Nghỉ lễ)');
    if (d == 7 && m == 5) events.add('Ngày Chiến thắng Điện Biên Phủ');
    if (d == 8 && m == 5) events.add('Ngày Chữ Thập đỏ & Trăng lưỡi liềm đỏ Thế giới');
    // Ngày của mẹ: Chủ nhật thứ 2 của tháng 5
    if (m == 5 && date.weekday == 7 && d > 7 && d <= 14) events.add('Ngày của Mẹ');
    if (d == 15 && m == 5) events.add('Ngày Quốc tế Gia đình');
    if (d == 19 && m == 5) events.add('Ngày Sinh nhật Chủ tịch Hồ Chí Minh');
    if (d == 22 && m == 5) events.add('Ngày Quốc tế Đa dạng Sinh học');
    if (d == 1 && m == 6) events.add('Ngày Quốc tế Thiếu nhi');
    if (d == 5 && m == 6) events.add('Ngày Môi trường Thế giới');
    // Ngày của cha: Chủ nhật thứ 3 của tháng 6
    if (m == 6 && date.weekday == 7 && d > 14 && d <= 21) events.add('Ngày của Cha');
    if (d == 14 && m == 6) events.add('Ngày Hiến máu Thế giới');
    if (d == 21 && m == 6) events.add('Ngày Báo chí Cách mạng Việt Nam');
    if (d == 28 && m == 6) events.add('Ngày Gia đình Việt Nam');
    if (d == 11 && m == 7) events.add('Ngày Dân số Thế giới');
    if (d == 27 && m == 7) events.add('Ngày Thương binh - Liệt sĩ');
    if (d == 28 && m == 7) events.add('Ngày Thành lập Công đoàn Việt Nam');
    if (d == 19 && m == 8) events.add('Ngày Cách mạng Tháng Tám thành công');
    if (d == 2 && m == 9) events.add('Ngày Quốc khánh Việt Nam (Nghỉ lễ)');
    if (d == 8 && m == 9) events.add('Ngày Quốc tế Xóa mù chữ');
    if (d == 10 && m == 9) events.add('Ngày thành lập Mặt trận Tổ quốc Việt Nam');
    if (d == 23 && m == 9) events.add('Ngày Quốc tế Ngôn ngữ Ký hiệu');
    if (d == 1 && m == 10) events.add('Ngày Quốc tế Người Cao Tuổi');
    if (d == 10 && m == 10) events.add('Ngày Giải phóng Thủ đô Hà Nội');
    if (d == 13 && m == 10) events.add('Ngày Doanh nhân Việt Nam');
    if (d == 20 && m == 10) events.add('Ngày Phụ nữ Việt Nam');
    if (d == 31 && m == 10) events.add('Lễ Halloween');
    if (d == 9 && m == 11) events.add('Ngày Pháp luật Việt Nam');
    if (d == 18 && m == 11) events.add('Ngày hội Đại đoàn kết toàn dân tộc');
    if (d == 19 && m == 11) events.add('Ngày Quốc tế Nam giới');
    if (d == 20 && m == 11) events.add('Ngày Nhà giáo Việt Nam');
    if (d == 23 && m == 11) events.add('Ngày thành lập Hội chữ thập đỏ Việt Nam');
    if (d == 24 && m == 11) events.add('Ngày Văn hóa Việt Nam (Nghỉ nguyên lương)');
    if (d == 1 && m == 12) events.add('Ngày Thế giới phòng chống AIDS');
    if (d == 10 && m == 12) events.add('Ngày Quốc tế Nhân quyền');
    if (d == 19 && m == 12) events.add('Ngày toàn quốc kháng chiến');
    if (d == 22 && m == 12) events.add('Ngày Thành lập Quân đội Nhân dân Việt Nam');
    if (d == 24 && m == 12) events.add('Đêm Giáng sinh (Noel)');
    if (d == 25 && m == 12) events.add('Lễ Giáng sinh');

    final ld = lunar.day;
    final lm = lunar.month;
    final leap = lunar.isLeapMonth;

    if (!leap) {
      if (ld == 1 && lm == 1) events.add('Tết Nguyên Đán (Nghỉ lễ)');
      if (ld == 7 && lm == 1) events.add('Lễ Khai Hạ');
      if (ld == 9 && lm == 1) events.add('Ngày vía Ngọc Hoàng');
      if (ld == 10 && lm == 1) events.add('Ngày vía Thần Tài');
      if (ld == 15 && lm == 1) events.add('Tết Nguyên Tiêu (Lễ Thượng Nguyên)');
      if (ld == 3 && lm == 3) events.add('Tết Hàn Thực');
      if (ld == 10 && lm == 3) events.add('Giỗ Tổ Hùng Vương (Nghỉ lễ)');
      if (ld == 15 && lm == 4) events.add('Lễ Phật Đản');
      if (ld == 5 && lm == 5) events.add('Tết Đoan Ngọ');
      if (ld == 7 && lm == 7) events.add('Lễ Thất Tịch');
      if (ld == 15 && lm == 7) events.add('Rằm tháng 7 / Xá tội vong nhân');
      if (ld == 15 && lm == 7) events.add('Lễ Vu Lan');
      if (ld == 15 && lm == 8) events.add('Tết Trung Thu');
      if (ld == 9 && lm == 9) events.add('Tết Trùng Cửu');
      if (ld == 10 && lm == 10) events.add('Tết Thường Tân');
      if (ld == 15 && lm == 10) events.add('Tết Hạ Nguyên');
      if (ld == 23 && lm == 12) events.add('Tiễn Táo Quân về trời');
    }

    if (ld == 1) events.add('Mùng 1 Âm lịch - Ngày Sóc');
    if (ld == 15) events.add('Rằm Âm lịch - Ngày Vọng');

    return events.toSet().toList();
  }

  static LunarDate lunarFor(DateTime date) {
    return LunarConverter.convertSolar2Lunar(date.day, date.month, date.year, 7.0);
  }
}
