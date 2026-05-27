import 'package:home_widget/home_widget.dart';

import '../models/lunar_date.dart';
import 'lunar_converter.dart';

class HomeWidgetService {
  static Future<void> updateWidgets({
    required DateTime solarDate,
    required LunarDate lunarDate,
    required DateTime monthDate,
  }) async {
    await HomeWidget.saveWidgetData<String>('lunar_month', 'Tháng ${lunarDate.month} Âm');
    await HomeWidget.saveWidgetData<String>('lunar_day', '${lunarDate.day}');
    await HomeWidget.saveWidgetData<String>('solar_date', 'DL: ${solarDate.day}/${solarDate.month}/${solarDate.year}');
    await HomeWidget.saveWidgetData<String>('month_title', 'Tháng ${monthDate.month} - ${monthDate.year}');

    final cells = _buildMonthCells(monthDate, solarDate);
    await HomeWidget.saveWidgetData<String>('month_cells', cells.join('|'));
    await HomeWidget.saveWidgetData<int>('today_solar_day', solarDate.day);
    await HomeWidget.saveWidgetData<int>('today_solar_month', solarDate.month);
    await HomeWidget.saveWidgetData<int>('today_solar_year', solarDate.year);

    await HomeWidget.updateWidget(androidName: 'Lunar2x2WidgetProvider');
    await HomeWidget.updateWidget(androidName: 'Month2x2WidgetProvider');
  }

  static List<String> _buildMonthCells(DateTime monthDate, DateTime today) {
    final firstDay = DateTime(monthDate.year, monthDate.month, 1);
    final startWeekday = firstDay.weekday;
    final gridStart = firstDay.subtract(Duration(days: startWeekday - 1));

    return List.generate(42, (index) {
      final date = gridStart.add(Duration(days: index));
      final lunar = LunarConverter.convertSolar2Lunar(date.day, date.month, date.year, 7.0);
      final isCurrentMonth = date.month == monthDate.month ? 1 : 0;
      final isToday = (date.day == today.day && date.month == today.month && date.year == today.year) ? 1 : 0;
      final lunarText = lunar.day == 1 ? '1/${lunar.month}' : '${lunar.day}';
      return '${date.day},$lunarText,$isCurrentMonth,$isToday';
    });
  }
}
