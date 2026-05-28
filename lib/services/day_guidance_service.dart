enum VietnameseDayRating { excellent, positive, balanced, caution }

enum VietnameseActivityCategory { work, finance, study, travel, family }

enum VietnameseGuidanceLevel { favorable, neutral, caution }

class VietnameseActivityInsight {
  final VietnameseActivityCategory category;
  final VietnameseGuidanceLevel level;
  final String reason;

  const VietnameseActivityInsight({
    required this.category,
    required this.level,
    required this.reason,
  });
}

class VietnameseDayGuidance {
  final String title;
  final String summary;
  final int score;
  final VietnameseDayRating rating;
  final List<String> recommendedActivities;
  final List<String> avoidActivities;
  final List<VietnameseActivityInsight> activityInsights;

  const VietnameseDayGuidance({
    required this.title,
    required this.summary,
    required this.score,
    required this.rating,
    required this.recommendedActivities,
    required this.avoidActivities,
    required this.activityInsights,
  });
}

enum _Season { spring, summer, autumn, winter }

class _GuidanceTemplate {
  final String title;
  final String summary;
  final int baseScore;
  final List<String> recommendedActivities;
  final List<String> avoidActivities;
  final Map<VietnameseActivityCategory, VietnameseGuidanceLevel> categoryLevels;

  const _GuidanceTemplate({
    required this.title,
    required this.summary,
    required this.baseScore,
    required this.recommendedActivities,
    required this.avoidActivities,
    required this.categoryLevels,
  });
}

class _SeasonAdjustment {
  final int scoreDelta;
  final Map<VietnameseActivityCategory, VietnameseGuidanceLevel> categoryOverrides;

  const _SeasonAdjustment({
    required this.scoreDelta,
    required this.categoryOverrides,
  });
}

class DayGuidanceService {
  static const _canToElement = {
    'Giáp': 'Mộc',
    'Ất': 'Mộc',
    'Bính': 'Hỏa',
    'Đinh': 'Hỏa',
    'Mậu': 'Thổ',
    'Kỷ': 'Thổ',
    'Canh': 'Kim',
    'Tân': 'Kim',
    'Nhâm': 'Thủy',
    'Quý': 'Thủy',
  };

  static String elementFromCan(String can) => _canToElement[can] ?? '';

  static const _fallbackTemplate = _GuidanceTemplate(
    title: 'Ngày cân bằng',
    summary: 'Năng lượng ngày ở mức trung tính, phù hợp xử lý việc quan trọng theo kế hoạch rõ ràng.',
    baseScore: 62,
    recommendedActivities: ['Lập kế hoạch', 'Tổng kết công việc', 'Sắp xếp lịch cá nhân'],
    avoidActivities: ['Ra quyết định vội vàng', 'Trì hoãn quá lâu', 'Ôm quá nhiều việc cùng lúc'],
    categoryLevels: {
      VietnameseActivityCategory.work: VietnameseGuidanceLevel.neutral,
      VietnameseActivityCategory.finance: VietnameseGuidanceLevel.neutral,
      VietnameseActivityCategory.study: VietnameseGuidanceLevel.neutral,
      VietnameseActivityCategory.travel: VietnameseGuidanceLevel.neutral,
      VietnameseActivityCategory.family: VietnameseGuidanceLevel.neutral,
    },
  );

  static const _templatesByElement = {
    'Mộc': _GuidanceTemplate(
      title: 'Ngày hành Mộc',
      summary: 'Thuận cho việc phát triển, mở rộng kết nối và bắt đầu chuỗi công việc mới.',
      baseScore: 76,
      recommendedActivities: ['Khởi động dự án', 'Học tập - nghiên cứu', 'Trao đổi với đối tác', 'Lên kế hoạch dài hạn'],
      avoidActivities: ['Chốt việc quá nóng vội', 'Tách đội nhóm đột ngột', 'Bỏ dở giữa chừng'],
      categoryLevels: {
        VietnameseActivityCategory.work: VietnameseGuidanceLevel.favorable,
        VietnameseActivityCategory.finance: VietnameseGuidanceLevel.neutral,
        VietnameseActivityCategory.study: VietnameseGuidanceLevel.favorable,
        VietnameseActivityCategory.travel: VietnameseGuidanceLevel.neutral,
        VietnameseActivityCategory.family: VietnameseGuidanceLevel.favorable,
      },
    ),
    'Hỏa': _GuidanceTemplate(
      title: 'Ngày hành Hỏa',
      summary: 'Năng lượng mạnh, hợp các công việc cần chủ động, truyền thông và tạo ảnh hưởng.',
      baseScore: 72,
      recommendedActivities: ['Thuyết trình', 'Đàm phán', 'Ra mắt ý tưởng', 'Đẩy nhanh đầu việc tồn đọng'],
      avoidActivities: ['Tranh luận căng thẳng', 'Phản hồi thiếu kiểm soát', 'Quyết định khi đang nóng'],
      categoryLevels: {
        VietnameseActivityCategory.work: VietnameseGuidanceLevel.favorable,
        VietnameseActivityCategory.finance: VietnameseGuidanceLevel.neutral,
        VietnameseActivityCategory.study: VietnameseGuidanceLevel.neutral,
        VietnameseActivityCategory.travel: VietnameseGuidanceLevel.neutral,
        VietnameseActivityCategory.family: VietnameseGuidanceLevel.caution,
      },
    ),
    'Thổ': _GuidanceTemplate(
      title: 'Ngày hành Thổ',
      summary: 'Tốt cho các việc củng cố nền tảng và xử lý hạng mục cần độ chắc chắn cao.',
      baseScore: 74,
      recommendedActivities: ['Chuẩn hóa quy trình', 'Rà soát tài chính', 'Hoàn thiện hồ sơ', 'Sắp xếp nhà cửa'],
      avoidActivities: ['Mở rộng quá nhanh', 'Thử nghiệm rủi ro cao', 'Để công việc kéo dài'],
      categoryLevels: {
        VietnameseActivityCategory.work: VietnameseGuidanceLevel.favorable,
        VietnameseActivityCategory.finance: VietnameseGuidanceLevel.favorable,
        VietnameseActivityCategory.study: VietnameseGuidanceLevel.neutral,
        VietnameseActivityCategory.travel: VietnameseGuidanceLevel.caution,
        VietnameseActivityCategory.family: VietnameseGuidanceLevel.favorable,
      },
    ),
    'Kim': _GuidanceTemplate(
      title: 'Ngày hành Kim',
      summary: 'Phù hợp các việc cần tính kỷ luật, chuẩn xác và quyết đoán.',
      baseScore: 71,
      recommendedActivities: ['Ký kết hợp đồng', 'Kiểm tra chất lượng', 'Rà soát pháp lý', 'Dọn dẹp dữ liệu'],
      avoidActivities: ['Chi tiêu cảm tính', 'Cam kết thiếu căn cứ', 'Bỏ qua chi tiết nhỏ'],
      categoryLevels: {
        VietnameseActivityCategory.work: VietnameseGuidanceLevel.favorable,
        VietnameseActivityCategory.finance: VietnameseGuidanceLevel.favorable,
        VietnameseActivityCategory.study: VietnameseGuidanceLevel.neutral,
        VietnameseActivityCategory.travel: VietnameseGuidanceLevel.neutral,
        VietnameseActivityCategory.family: VietnameseGuidanceLevel.caution,
      },
    ),
    'Thủy': _GuidanceTemplate(
      title: 'Ngày hành Thủy',
      summary: 'Thuận cho tư duy linh hoạt, kết nối thông tin và công việc cần sự thích nghi.',
      baseScore: 73,
      recommendedActivities: ['Phân tích dữ liệu', 'Viết nội dung', 'Điều phối giao tiếp', 'Lên phương án dự phòng'],
      avoidActivities: ['Giữ lịch quá cứng', 'Làm việc thiếu phản hồi', 'Quá sa đà vào tiểu tiết'],
      categoryLevels: {
        VietnameseActivityCategory.work: VietnameseGuidanceLevel.neutral,
        VietnameseActivityCategory.finance: VietnameseGuidanceLevel.neutral,
        VietnameseActivityCategory.study: VietnameseGuidanceLevel.favorable,
        VietnameseActivityCategory.travel: VietnameseGuidanceLevel.favorable,
        VietnameseActivityCategory.family: VietnameseGuidanceLevel.neutral,
      },
    ),
  };

  static const _seasonAdjustments = {
    _Season.spring: _SeasonAdjustment(
      scoreDelta: 4,
      categoryOverrides: {
        VietnameseActivityCategory.work: VietnameseGuidanceLevel.favorable,
        VietnameseActivityCategory.study: VietnameseGuidanceLevel.favorable,
      },
    ),
    _Season.summer: _SeasonAdjustment(
      scoreDelta: 1,
      categoryOverrides: {
        VietnameseActivityCategory.travel: VietnameseGuidanceLevel.caution,
      },
    ),
    _Season.autumn: _SeasonAdjustment(
      scoreDelta: 3,
      categoryOverrides: {
        VietnameseActivityCategory.finance: VietnameseGuidanceLevel.favorable,
      },
    ),
    _Season.winter: _SeasonAdjustment(
      scoreDelta: -2,
      categoryOverrides: {
        VietnameseActivityCategory.travel: VietnameseGuidanceLevel.caution,
        VietnameseActivityCategory.study: VietnameseGuidanceLevel.favorable,
      },
    ),
  };

  static VietnameseDayGuidance guidance({required String dayElement, required String solarTerm}) {
    final template = _templatesByElement[dayElement] ?? _fallbackTemplate;
    final season = _seasonFor(solarTerm);
    final seasonAdjustment = _seasonAdjustments[season] ?? const _SeasonAdjustment(scoreDelta: 0, categoryOverrides: {});
    final summary = '${template.summary} ${_seasonalHintFor(solarTerm)}';

    var score = template.baseScore + seasonAdjustment.scoreDelta;
    if (score < 0) score = 0;
    if (score > 100) score = 100;

    return VietnameseDayGuidance(
      title: template.title,
      summary: summary,
      score: score,
      rating: _ratingFor(score),
      recommendedActivities: template.recommendedActivities,
      avoidActivities: template.avoidActivities,
      activityInsights: _buildActivityInsights(template, season, seasonAdjustment),
    );
  }

  static VietnameseDayRating _ratingFor(int score) {
    if (score >= 80) return VietnameseDayRating.excellent;
    if (score >= 70) return VietnameseDayRating.positive;
    if (score >= 55) return VietnameseDayRating.balanced;
    return VietnameseDayRating.caution;
  }

  static List<VietnameseActivityInsight> _buildActivityInsights(
    _GuidanceTemplate template,
    _Season season,
    _SeasonAdjustment seasonAdjustment,
  ) {
    return VietnameseActivityCategory.values.map((category) {
      final level = seasonAdjustment.categoryOverrides[category] ??
          template.categoryLevels[category] ??
          VietnameseGuidanceLevel.neutral;
      return VietnameseActivityInsight(
        category: category,
        level: level,
        reason: _reasonFor(category, level, season),
      );
    }).toList();
  }

  static String _reasonFor(
    VietnameseActivityCategory category,
    VietnameseGuidanceLevel level,
    _Season season,
  ) {
    String base;
    switch ((category, level)) {
      case (VietnameseActivityCategory.work, VietnameseGuidanceLevel.favorable):
        base = 'Dễ tạo tiến độ nếu có kế hoạch rõ và ưu tiên đúng việc.';
      case (VietnameseActivityCategory.work, VietnameseGuidanceLevel.neutral):
        base = 'Nên giữ nhịp ổn định, tránh đổi hướng đột ngột.';
      case (VietnameseActivityCategory.work, VietnameseGuidanceLevel.caution):
        base = 'Nên hạn chế quyết định nóng và xung đột không cần thiết.';
      case (VietnameseActivityCategory.finance, VietnameseGuidanceLevel.favorable):
        base = 'Phù hợp rà soát ngân sách, chốt khoản mục quan trọng.';
      case (VietnameseActivityCategory.finance, VietnameseGuidanceLevel.neutral):
        base = 'Giữ nguyên kế hoạch chi tiêu, ưu tiên kiểm soát rủi ro.';
      case (VietnameseActivityCategory.finance, VietnameseGuidanceLevel.caution):
        base = 'Tránh đầu tư cảm tính hoặc cam kết tài chính lớn.';
      case (VietnameseActivityCategory.study, VietnameseGuidanceLevel.favorable):
        base = 'Dễ hấp thụ kiến thức mới và hoàn thành phần việc trí tuệ.';
      case (VietnameseActivityCategory.study, VietnameseGuidanceLevel.neutral):
        base = 'Phù hợp ôn tập và hệ thống lại kiến thức hiện có.';
      case (VietnameseActivityCategory.study, VietnameseGuidanceLevel.caution):
        base = 'Tránh học dàn trải, nên tập trung một trọng tâm.';
      case (VietnameseActivityCategory.travel, VietnameseGuidanceLevel.favorable):
        base = 'Thuận cho di chuyển, gặp gỡ và kết nối bên ngoài.';
      case (VietnameseActivityCategory.travel, VietnameseGuidanceLevel.neutral):
        base = 'Di chuyển bình thường, nên chuẩn bị lịch trình trước.';
      case (VietnameseActivityCategory.travel, VietnameseGuidanceLevel.caution):
        base = 'Ưu tiên an toàn và hạn chế lịch trình dày đặc.';
      case (VietnameseActivityCategory.family, VietnameseGuidanceLevel.favorable):
        base = 'Phù hợp tăng tương tác, hàn gắn và chăm sóc gia đạo.';
      case (VietnameseActivityCategory.family, VietnameseGuidanceLevel.neutral):
        base = 'Nên duy trì giao tiếp nhẹ nhàng, tránh hiểu lầm nhỏ.';
      case (VietnameseActivityCategory.family, VietnameseGuidanceLevel.caution):
        base = 'Tránh tranh luận gay gắt, ưu tiên lắng nghe.';
    }

    String tail = '';
    switch ((season, category)) {
      case (_Season.summer, VietnameseActivityCategory.travel):
        tail = ' Mùa hạ nên chú ý sức khỏe và thời gian nghỉ.';
      case (_Season.winter, VietnameseActivityCategory.travel):
        tail = ' Mùa đông cần chừa thêm biên độ thời gian khi đi lại.';
      case (_Season.autumn, VietnameseActivityCategory.finance):
        tail = ' Mùa thu hợp chốt kế hoạch tài chính ngắn hạn.';
      case (_Season.spring, VietnameseActivityCategory.work):
      case (_Season.spring, VietnameseActivityCategory.study):
        tail = ' Mùa xuân thuận để khởi tạo nhịp mới.';
      default:
        tail = '';
    }

    return '$base$tail';
  }

  static String _seasonalHintFor(String solarTerm) {
    switch (_seasonFor(solarTerm)) {
      case _Season.spring:
        return 'Mùa xuân nên ưu tiên khởi động việc mới và tạo đà tăng trưởng.';
      case _Season.summer:
        return 'Mùa hạ hợp đẩy tiến độ, nhưng cần quản trị nhịp làm việc để tránh quá tải.';
      case _Season.autumn:
        return 'Mùa thu phù hợp tối ưu chất lượng, chốt mục tiêu và củng cố kết quả.';
      case _Season.winter:
        return 'Mùa đông hợp rà soát, chuẩn bị nguồn lực và xây nền cho chu kỳ kế tiếp.';
    }
  }

  static _Season _seasonFor(String solarTerm) {
    switch (solarTerm.toLowerCase()) {
      case 'lập xuân':
      case 'vũ thủy':
      case 'kinh trập':
      case 'xuân phân':
      case 'thanh minh':
      case 'cốc vũ':
        return _Season.spring;
      case 'lập hạ':
      case 'tiểu mãn':
      case 'mang chủng':
      case 'hạ chí':
      case 'tiểu thử':
      case 'đại thử':
        return _Season.summer;
      case 'lập thu':
      case 'xử thử':
      case 'bạch lộ':
      case 'thu phân':
      case 'hàn lộ':
      case 'sương giáng':
        return _Season.autumn;
      default:
        return _Season.winter;
    }
  }
}
