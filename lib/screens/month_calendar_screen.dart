import 'package:flutter/material.dart';

import '../services/calendar_event_service.dart';
import '../widgets/day_detail_panel.dart';

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final days = _daysInCalendar(_focusedMonth);
    
    final selectedLunar = CalendarEventService.lunarFor(_selectedDate);
    final selectedEvents = CalendarEventService.eventTitlesFor(_selectedDate, selectedLunar);
    final tietKhi = CalendarEventService.tietKhiFor(_selectedDate);
    final gioHoangDao = CalendarEventService.gioHoangDao(selectedLunar);
    
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
                final lunar = CalendarEventService.lunarFor(date);
                final isCurrentMonth = date.month == _focusedMonth.month;
                final isSelected =
                    date.year == _selectedDate.year && date.month == _selectedDate.month && date.day == _selectedDate.day;
                final now = DateTime.now();
                final isToday = date.year == now.year && date.month == now.month && date.day == now.day;
                final hasEvent = CalendarEventService.hasEvent(date, lunar);

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
                                lunar.day == 1 ? '1/${lunar.month}' : '${lunar.day}',
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
            DayDetailPanel(
              selectedDate: _selectedDate,
              selectedLunar: selectedLunar,
              tietKhi: tietKhi,
              gioHoangDao: gioHoangDao,
              selectedEvents: selectedEvents,
            ),
          ],
        ),
      ),
    );
  }
}

