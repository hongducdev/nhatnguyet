import 'package:flutter/material.dart';

import '../models/lunar_date.dart';
import '../services/day_guidance_service.dart';

class DayDetailPanel extends StatelessWidget {
  final DateTime selectedDate;
  final LunarDate selectedLunar;
  final String tietKhi;
  final List<String> gioHoangDao;
  final List<String> selectedEvents;
  final VietnameseDayGuidance? guidance;

  const DayDetailPanel({
    super.key,
    required this.selectedDate,
    required this.selectedLunar,
    required this.tietKhi,
    required this.gioHoangDao,
    required this.selectedEvents,
    this.guidance,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
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
                        'Dương lịch: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
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
            _buildIconLine(context, Icons.label_important_outline, 'Can Chi', selectedLunar.canChiDay, colorScheme.primary),
            _buildIconLine(context, Icons.wb_sunny_outlined, 'Tiết khí', tietKhi, Colors.orange),
            _buildIconLine(
              context,
              Icons.star_border_rounded,
              'Lục Diệu',
              '${selectedLunar.lucDieu.name} (${selectedLunar.lucDieu.loai})',
              selectedLunar.lucDieu.isHoangDao ? Colors.amber[600]! : colorScheme.error,
            ),
            const Divider(height: 32, thickness: 1),
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
              children: gioHoangDao.map((time) {
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
            if (guidance != null) ...[
              const Divider(height: 32, thickness: 1),
              Row(
                children: [
                  Icon(Icons.insights_rounded, size: 20, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Điểm ngày',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${guidance!.score}/100 · ${_ratingLabel(guidance!.rating)}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                guidance!.summary,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
            ],
            if (selectedEvents.isNotEmpty) ...[
              const Divider(height: 32, thickness: 1),
              Row(
                children: [
                  Icon(Icons.event_available_rounded, size: 20, color: Colors.pink[400]),
                  const SizedBox(width: 8),
                  Text(
                    'Sự kiện trong ngày',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...selectedEvents.map(
                (event) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.fiber_manual_record, size: 10, color: Colors.pink[400]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          event,
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
          ],
        ),
      ),
    );
  }

  String _ratingLabel(VietnameseDayRating rating) {
    switch (rating) {
      case VietnameseDayRating.excellent:
        return 'Rất tốt';
      case VietnameseDayRating.positive:
        return 'Tốt';
      case VietnameseDayRating.balanced:
        return 'Cân bằng';
      case VietnameseDayRating.caution:
        return 'Thận trọng';
    }
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
