import 'package:flutter/material.dart';

import '../services/lunar_converter.dart';
import '../services/calendar_event_service.dart';

class DateConverterScreen extends StatefulWidget {
  const DateConverterScreen({super.key});

  @override
  State<DateConverterScreen> createState() => _DateConverterScreenState();
}

class _DateConverterScreenState extends State<DateConverterScreen> {
  bool _solarToLunar = true;
  DateTime _solarDate = DateTime.now();

  final _lunarDayCtrl = TextEditingController();
  final _lunarMonthCtrl = TextEditingController();
  final _lunarYearCtrl = TextEditingController();
  bool _isLeapMonth = false;

  String _result = '';
  String _canChiDay = '';
  String _canChiMonth = '';
  String _canChiYear = '';
  String _tietKhi = '';
  String _lucDieu = '';

  @override
  void initState() {
    super.initState();
    _lunarDayCtrl.text = '${DateTime.now().day}';
    _lunarMonthCtrl.text = '${DateTime.now().month}';
    _lunarYearCtrl.text = '${DateTime.now().year}';
    _convert();
  }

  @override
  void dispose() {
    _lunarDayCtrl.dispose();
    _lunarMonthCtrl.dispose();
    _lunarYearCtrl.dispose();
    super.dispose();
  }

  void _convert() {
    if (_solarToLunar) {
      final lunar = LunarConverter.convertSolar2Lunar(
        _solarDate.day,
        _solarDate.month,
        _solarDate.year,
        7.0,
      );
      final tk = CalendarEventService.tietKhiFor(_solarDate);
      setState(() {
        _result = 'Âm lịch: ${lunar.day}/${lunar.month}/${lunar.year}${lunar.isLeapMonth ? ' (Nhuận)' : ''}';
        _canChiDay = lunar.canChiDay;
        _canChiMonth = lunar.canChiMonth;
        _canChiYear = lunar.canChiYear;
        _tietKhi = tk;
        _lucDieu = '${lunar.lucDieu.name} (${lunar.lucDieu.loai})';
      });
      return;
    }

    final day = int.tryParse(_lunarDayCtrl.text.trim());
    final month = int.tryParse(_lunarMonthCtrl.text.trim());
    final year = int.tryParse(_lunarYearCtrl.text.trim());
    if (day == null || month == null || year == null) {
      setState(() {
        _result = 'Vui lòng nhập đúng ngày tháng năm âm lịch';
        _canChiDay = '';
        _canChiMonth = '';
        _canChiYear = '';
        _tietKhi = '';
        _lucDieu = '';
      });
      return;
    }

    final solar = LunarConverter.convertLunar2Solar(
      day,
      month,
      year,
      _isLeapMonth ? 1 : 0,
      7.0,
    );
    final lunar = LunarConverter.convertSolar2Lunar(
      solar.day,
      solar.month,
      solar.year,
      7.0,
    );
    final tk = CalendarEventService.tietKhiFor(solar);
    setState(() {
      _result = 'Dương lịch: ${solar.day}/${solar.month}/${solar.year}';
      _canChiDay = lunar.canChiDay;
      _canChiMonth = lunar.canChiMonth;
      _canChiYear = lunar.canChiYear;
      _tietKhi = tk;
      _lucDieu = '${lunar.lucDieu.name} (${lunar.lucDieu.loai})';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment<bool>(value: true, label: Text('Dương → Âm')),
                ButtonSegment<bool>(value: false, label: Text('Âm → Dương')),
              ],
              selected: {_solarToLunar},
              onSelectionChanged: (value) {
                setState(() {
                  _solarToLunar = value.first;
                });
                _convert();
              },
            ),
            const SizedBox(height: 16),
            if (_solarToLunar)
              Card(
                child: ListTile(
                  title: const Text('Ngày dương lịch'),
                  subtitle: Text('${_solarDate.day}/${_solarDate.month}/${_solarDate.year}'),
                  trailing: const Icon(Icons.edit_calendar_rounded),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                      initialDate: _solarDate,
                    );
                    if (picked != null) {
                      setState(() {
                        _solarDate = picked;
                      });
                      _convert();
                    }
                  },
                ),
              )
            else
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: _lunarDayCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Ngày âm'),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _lunarMonthCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Tháng âm'),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _lunarYearCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Năm âm'),
                      ),
                      const SizedBox(height: 10),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        value: _isLeapMonth,
                        onChanged: (v) {
                          setState(() {
                            _isLeapMonth = v;
                          });
                        },
                        title: const Text('Tháng nhuận'),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),
            FilledButton(onPressed: _convert, child: const Text('Chuyển đổi')),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _result,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: colorScheme.primary,
                      ),
                    ),
                    if (_canChiDay.isNotEmpty) ...[
                      const Divider(height: 24),
                      _buildInfoRow(context, 'Can Chi Ngày', _canChiDay),
                      _buildInfoRow(context, 'Can Chi Tháng', _canChiMonth),
                      _buildInfoRow(context, 'Can Chi Năm', _canChiYear),
                      _buildInfoRow(context, 'Tiết khí', _tietKhi),
                      _buildInfoRow(context, 'Lục diệu', _lucDieu),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.outline,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

