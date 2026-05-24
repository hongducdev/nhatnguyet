import 'package:flutter/material.dart';

import '../models/lunar_day.dart';
import '../services/lunar_converter.dart';
import '../widgets/day_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DateTime _selectedDate;
  late LunarDay _lunar;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _updateLunar();
  }

  void _updateLunar() {
    _lunar = LunarConverter.solarToLunar(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Nhật Nguyệt')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Dương lịch: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            DayCard(lunar: _lunar),
          ],
        ),
      ),
    );
  }
}
