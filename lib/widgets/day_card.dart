import 'package:flutter/material.dart';

import '../models/lunar_date.dart';

class DayCard extends StatelessWidget {
  final LunarDate lunar;

  const DayCard({super.key, required this.lunar});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      color: colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Âm lịch: ${lunar.day}/${lunar.month}/${lunar.year}',
              style: theme.textTheme.headlineSmall,
            ),
            if (lunar.isLeapMonth)
              Text(
                'Tháng nhuận',
                style: theme.textTheme.labelLarge
                    ?.copyWith(color: colorScheme.error),
              ),
            const SizedBox(height: 12),
            Text('Ngày: ${lunar.canChiDay}'),
            Text('Năm: ${lunar.canChiYear}'),
            const SizedBox(height: 12),
            Text(
              'Lục diệu: ${lunar.lucDieu.name} (${lunar.lucDieu.loai})',
              style: TextStyle(
                color: lunar.lucDieu.isHoangDao 
                    ? colorScheme.primary 
                    : colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
