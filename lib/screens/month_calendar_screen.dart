import 'package:flutter/material.dart';

import '../models/lunar_date.dart';
import '../services/lunar_converter.dart';

class MonthCalendarScreen extends StatefulWidget {
  const MonthCalendarScreen({super.key});

  @override
  State<MonthCalendarScreen> createState() => _MonthCalendarScreenState();
}

class _MonthCalendarScreenState extends State<MonthCalendarScreen> {
  DateTime _focusedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  List<DateTime> _daysInCalendar(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final startWeekday = firstDay.weekday;
    final gridStart = firstDay.subtract(Duration(days: startWeekday - 1));
    return List.generate(42, (i) => gridStart.add(Duration(days: i)));
  }

  LunarDate _lunarFor(DateTime date) {
    return LunarConverter.convertSolar2Lunar(date.day, date.month, date.year, 7.0);
  }

  String _tietKhiFor(DateTime date) {
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

  List<String> _gioHoangDao(LunarDate lunar) {
    const all = [
      'Tý (23-01)',
      'Sửu (01-03)',
      'Dần (03-05)',
      'Mão (05-07)',
      'Thìn (07-09)',
      'Tỵ (09-11)',
      'Ngọ (11-13)',
      'Mùi (13-15)',
      'Thân (15-17)',
      'Dậu (17-19)',
      'Tuất (19-21)',
      'Hợi (21-23)',
    ];
    final start = lunar.lucDieu.index % 6;
    return List.generate(6, (i) => all[(start + i * 2) % 12]);
  }

  bool _hasEvent(DateTime date, LunarDate lunar) {
    if (lunar.day == 1 || lunar.day == 15) return true;
    if (lunar.month == 4 && lunar.day == 15 && !lunar.isLeapMonth) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final days = _daysInCalendar(_focusedMonth);
    final selectedLunar = _lunarFor(_selectedDate);
    const weekdays = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                IconButton.filledTonal(
                  onPressed: () {
                    setState(() {
                      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
                    });
                  },
                  icon: const Icon(Icons.chevron_left),
                ),
                Expanded(
                  child: Text(
                    'Tháng ${_focusedMonth.month} / ${_focusedMonth.year}',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                IconButton.filledTonal(
                  onPressed: () {
                    setState(() {
                      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
                    });
                  },
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: weekdays
                  .map(
                    (day) => Expanded(
                      child: Text(
                        day,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: day == 'CN' ? colorScheme.error : colorScheme.outline,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: days.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) {
                final date = days[index];
                final lunar = _lunarFor(date);
                final isCurrentMonth = date.month == _focusedMonth.month;
                final isSelected =
                    date.year == _selectedDate.year && date.month == _selectedDate.month && date.day == _selectedDate.day;
                final now = DateTime.now();
                final isToday = date.year == now.year && date.month == now.month && date.day == now.day;
                final hasEvent = _hasEvent(date, lunar);

                return InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? colorScheme.primaryContainer : null,
                      borderRadius: BorderRadius.circular(14),
                      border: isToday && !isSelected
                          ? Border.all(color: colorScheme.primary, width: 1.4)
                          : null,
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${date.day}',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                                  color: isCurrentMonth
                                      ? (isSelected ? colorScheme.onPrimaryContainer : colorScheme.onSurface)
                                      : colorScheme.outline,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${lunar.day}',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: isSelected ? colorScheme.primary : colorScheme.primary.withAlpha(190),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (hasEvent)
                          Positioned(
                            top: 6,
                            right: 6,
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: isSelected ? colorScheme.onPrimaryContainer : colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 0,
              color: colorScheme.surfaceContainerLow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(color: colorScheme.outlineVariant.withAlpha(120)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Card
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'NGÀY ${selectedLunar.day}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tháng ${selectedLunar.month}${selectedLunar.isLeapMonth ? ' (Nhuận)' : ''}',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                'Dương lịch: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.outline,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Info List
                    _buildIconLine(context, Icons.label_important_outline, 'Can Chi', selectedLunar.canChiDay, colorScheme.primary),
                    _buildIconLine(context, Icons.wb_sunny_outlined, 'Tiết khí', _tietKhiFor(_selectedDate), Colors.orange),
                    _buildIconLine(
                      context, 
                      Icons.star_border_rounded, 
                      'Lục Diệu', 
                      '${selectedLunar.lucDieu.name} (${selectedLunar.lucDieu.loai})', 
                      selectedLunar.lucDieu.isHoangDao ? Colors.amber[600]! : colorScheme.error,
                    ),
                    
                    const Divider(height: 32, thickness: 1),

                    // Hoang Dao
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded, size: 20, color: colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Giờ Hoàng Đạo',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _gioHoangDao(selectedLunar).map((time) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: colorScheme.secondaryContainer.withAlpha(150),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: colorScheme.secondaryContainer),
                          ),
                          child: Text(
                            time,
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSecondaryContainer,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    
                    const Divider(height: 32, thickness: 1),

                    // Gợi ý
                    Row(
                      children: [
                        Icon(Icons.task_alt_rounded, size: 20, color: Colors.green[600]),
                        const SizedBox(width: 8),
                        Text(
                          'Gợi ý hoạt động',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (selectedLunar.lichViec.nenLam.isEmpty)
                      Text(
                        'Không có gợi ý cụ thể cho ngày này.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.outline,
                          fontStyle: FontStyle.italic,
                        ),
                      )
                    else
                      ...selectedLunar.lichViec.nenLam.take(4).map(
                            (e) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.check_circle, size: 16, color: Colors.green[600]),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      e,
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        height: 1.3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconLine(BuildContext context, IconData icon, String label, String value, Color iconColor) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: iconColor.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.outline,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
