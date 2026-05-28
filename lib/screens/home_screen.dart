import 'package:flutter/material.dart';

import '../models/lunar_date.dart';
import '../services/lunar_converter.dart';
import '../services/home_widget_service.dart';
import '../widgets/circular_wavy_progress.dart';
import 'add_personal_event_screen.dart';
import 'personal_events_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DateTime _selectedDate;
  late LunarDate _lunar;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _updateLunar();
    _syncToHomeWidget();
  }

  void _syncToHomeWidget() {
    HomeWidgetService.updateWidgets(
      solarDate: _selectedDate,
      lunarDate: _lunar,
      monthDate: DateTime(_selectedDate.year, _selectedDate.month),
    );
  }

  void _updateLunar() {
    _lunar = LunarConverter.convertSolar2Lunar(
      _selectedDate.day,
      _selectedDate.month,
      _selectedDate.year,
      7.0,
    );
  }

  String _getWeekdayString(int weekday) {
    switch (weekday) {
      case 1:
        return 'Thứ Hai';
      case 2:
        return 'Thứ Ba';
      case 3:
        return 'Thứ Tư';
      case 4:
        return 'Thứ Năm';
      case 5:
        return 'Thứ Sáu';
      case 6:
        return 'Thứ Bảy';
      case 7:
        return 'Chủ Nhật';
      default:
        return '';
    }
  }

  int _daysUntilBuddhaBirthday() {
    // Buddha's Birthday is 15th of 4th Lunar Month
    final now = DateTime.now();
    for (int i = 0; i < 365; i++) {
      final date = now.add(Duration(days: i));
      final lunar = LunarConverter.convertSolar2Lunar(
        date.day,
        date.month,
        date.year,
        7.0,
      );
      if (lunar.month == 4 && lunar.day == 15 && !lunar.isLeapMonth) {
        return i;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final daysToBuddha = _daysUntilBuddhaBirthday();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Main Lunar Date Card (Material 3 Style)
              Card(
                elevation: 0,
                color: colorScheme.primaryContainer.withAlpha(102),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Column(
                    children: [
                      Text(
                        '${_lunar.day}',
                        style: theme.textTheme.displayLarge?.copyWith(
                          fontSize: 96,
                          fontWeight: FontWeight.w900,
                          color: colorScheme.primary,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tháng ${_lunar.canChiMonth} · Năm ${_lunar.canChiYear}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Divider(
                        color: colorScheme.primary.withAlpha(38),
                        thickness: 1,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _getWeekdayString(_selectedDate.weekday),
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Dương lịch: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),
              // Section Header: Upcoming Events
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 20,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Sự kiện sắp tới',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Buddha's Birthday Event Card
              Card(
                elevation: 0,
                color: colorScheme.surfaceContainerLow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: colorScheme.outlineVariant.withAlpha(102),
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 12.0,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.amber.withAlpha(38),
                    child: const Icon(
                      Icons.brightness_7,
                      color: Colors.amber,
                    ),
                  ),
                  title: const Text(
                    'Đại Lễ Phật Đản (15/4 Âm Lịch)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    daysToBuddha == 0
                        ? 'Hôm nay là Đại Lễ Phật Đản!'
                        : 'Còn $daysToBuddha ngày nữa',
                  ),
                  trailing: SizedBox(
                    width: 48,
                    height: 48,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularWavyProgressIndicator(
                          progress: daysToBuddha == 0
                              ? 1.0
                              : (354 - daysToBuddha) / 354,
                          color: Colors.amber,
                          trackColor: colorScheme.surfaceContainerHighest,
                          strokeWidth: 4,
                          trackStrokeWidth: 4,
                          amplitude: 3.5,
                          wavelength: 20,
                          waveSpeed: 20,
                        ),
                        Text(
                          daysToBuddha == 0 ? 'Lễ' : '$daysToBuddha',
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // User Event Placeholder Card
              Card(
                elevation: 0,
                color: colorScheme.surfaceContainerLow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: colorScheme.outlineVariant.withAlpha(102),
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 12.0,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: colorScheme.primary.withAlpha(25),
                    child: Icon(
                      Icons.add_rounded,
                      color: colorScheme.primary,
                    ),
                  ),
                  title: const Text(
                    'Thêm sự kiện cá nhân',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text('Nhắc nhở ngày giỗ, cúng bái, rằm...'),
                  onTap: () async {
                    final created = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(builder: (_) => const AddPersonalEventScreen()),
                    );
                    if (created == true && context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PersonalEventsScreen()),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}
