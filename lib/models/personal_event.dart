enum EventRepeat {
  none,
  monthly, // Lặp hàng tháng
  yearly, // Lặp hàng năm
}

class PersonalEvent {
  final String id;
  final String title;
  final String description;
  final bool isLunar;
  final int day;
  final int? month; // Null nếu là lặp hàng tháng
  final int? year; // Null nếu lặp hàng năm
  final EventRepeat repeat;
  final int remindDaysBefore; // Báo trước mấy ngày

  PersonalEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.isLunar,
    required this.day,
    this.month,
    this.year,
    this.repeat = EventRepeat.yearly,
    this.remindDaysBefore = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isLunar': isLunar,
      'day': day,
      'month': month,
      'year': year,
      'repeat': repeat.index,
      'remindDaysBefore': remindDaysBefore,
    };
  }

  factory PersonalEvent.fromJson(Map<String, dynamic> json) {
    return PersonalEvent(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      isLunar: json['isLunar'] ?? false,
      day: json['day'] ?? 1,
      month: json['month'],
      year: json['year'],
      repeat: EventRepeat.values[json['repeat'] ?? 2],
      remindDaysBefore: json['remindDaysBefore'] ?? 0,
    );
  }
}

