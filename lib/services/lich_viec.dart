// ============================================================
// lich_viec.dart
// Việc nên làm / không nên làm trong ngày
// Dựa trên: Can Chi ngày + Lục Diệu + Ngũ Hành
// ============================================================

class LichViec {
  /// Việc nên/không nên theo Lục Diệu
  static const Map<String, List<String>> _lucDieuNen = {
    'Tiên Thắng': [
      'Xuất hành, đi xa',
      'Ký kết hợp đồng',
      'Khai trương, mở hàng',
      'Cầu tài, vay vốn',
      'Gặp gỡ đối tác',
    ],
    'Hữu Đức': [
      'Cầu tài lộc',
      'Gặp gỡ quý nhân',
      'Nộp đơn, xin việc',
      'Cúng bái, lễ chùa',
      'Học hành, thi cử',
    ],
    'Tốc Hỷ': [
      'Tổ chức tiệc vui',
      'Đám cưới, hôn lễ',
      'Ra mắt sản phẩm mới',
      'Mua sắm đồ dùng',
      'Thăm hỏi người thân',
    ],
    'Tiểu Cát': [
      'Công việc bình thường',
      'Sửa chữa nhỏ',
      'Mua bán nhỏ',
    ],
    'Xích Khẩu': [],
    'Không Vong': [],
  };

  static const Map<String, List<String>> _lucDieuKhong = {
    'Tiên Thắng': [],
    'Hữu Đức': ['Kiện tụng, tranh chấp'],
    'Tốc Hỷ': ['Khởi công xây dựng (cẩn thận)'],
    'Tiểu Cát': [
      'Khởi sự việc lớn',
      'Đầu tư lớn',
      'Xuất hành xa',
    ],
    'Xích Khẩu': [
      'Ký kết hợp đồng',
      'Kiện tụng, tranh chấp',
      'Kết hôn, đính hôn',
      'Khai trương',
      'Xuất hành',
    ],
    'Không Vong': [
      'Bất kỳ việc lớn nào',
      'Khởi công, động thổ',
      'Ký hợp đồng',
      'Đầu tư, mua bán',
      'Xuất hành xa',
      'Tổ chức sự kiện',
    ],
  };

  /// Việc nên/không nên theo Can ngày (Ngũ Hành Can)
  static const Map<String, List<String>> _canNen = {
    'Giáp': ['Khởi sự, lập kế hoạch', 'Trồng cây, làm vườn'],
    'Ất':   ['Học hành, nghiên cứu', 'Chữa bệnh, khám sức khỏe'],
    'Bính': ['Quảng bá, PR', 'Tổ chức sự kiện'],
    'Đinh': ['Đàm phán, thương lượng'],
    'Mậu':  ['Giao dịch bất động sản', 'Xây dựng, sửa nhà'],
    'Kỷ':   ['Tích lũy, tiết kiệm', 'Chăm sóc gia đình'],
    'Canh': ['Quyết định dứt khoát', 'Giải quyết tranh chấp'],
    'Tân':  ['Trang sức, thẩm mỹ', 'Hội họp, kết giao'],
    'Nhâm': ['Du lịch, khám phá', 'Giao thương buôn bán'],
    'Quý':  ['Lập kế hoạch dài hạn', 'Cúng bái, tâm linh'],
  };

  static const Map<String, List<String>> _canKhong = {
    'Giáp': ['Phá dỡ, tháo dỡ'],
    'Ất':   ['Tranh cãi, kiện tụng'],
    'Bính': ['Việc cần bí mật, kín đáo'],
    'Đinh': ['Quyết định vội vàng'],
    'Mậu':  ['Giao dịch tài chính rủi ro'],
    'Kỷ':   ['Đầu tư mạo hiểm'],
    'Canh': ['Việc cần mềm mỏng, ngoại giao'],
    'Tân':  ['Kiện tụng, tranh cãi'],
    'Nhâm': ['Ở nhà không ra ngoài'],
    'Quý':  ['Khởi sự việc mới lớn'],
  };

  static const _canNames = [
    'Giáp','Ất','Bính','Đinh','Mậu',
    'Kỷ','Canh','Tân','Nhâm','Quý',
  ];

  /// Tổng hợp việc nên/không nên
  /// [lucDieu]: tên Lục Diệu ("Tiên Thắng", ...)
  /// [canDayIdx]: Can ngày (0–9)
  static LichViecResult get(String lucDieu, int canDayIdx) {
    final canName = _canNames[canDayIdx % 10];
    final nen = [
      ..._lucDieuNen[lucDieu] ?? [],
      ..._canNen[canName] ?? [],
    ];
    final khong = [
      ..._lucDieuKhong[lucDieu] ?? [],
      ..._canKhong[canName] ?? [],
    ];

    return LichViecResult(
      lucDieu: lucDieu,
      canNgay: canName,
      nenLam: nen,
      khongNenLam: khong,
    );
  }
}

class LichViecResult {
  final String lucDieu;
  final String canNgay;
  final List<String> nenLam;
  final List<String> khongNenLam;

  const LichViecResult({
    required this.lucDieu,
    required this.canNgay,
    required this.nenLam,
    required this.khongNenLam,
  });
}
