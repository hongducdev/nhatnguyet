import 'package:flutter/material.dart';
import '../models/personal_event.dart';
import '../services/personal_event_service.dart';

class AddPersonalEventScreen extends StatefulWidget {
  const AddPersonalEventScreen({super.key});

  @override
  State<AddPersonalEventScreen> createState() => _AddPersonalEventScreenState();
}

class _AddPersonalEventScreenState extends State<AddPersonalEventScreen> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _dayCtrl = TextEditingController();
  final _monthCtrl = TextEditingController();
  final _yearCtrl = TextEditingController();
  
  bool _isLunar = true;
  EventRepeat _repeat = EventRepeat.yearly;
  int _remindDaysBefore = 0;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _dayCtrl.text = '${now.day}';
    _monthCtrl.text = '${now.month}';
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _dayCtrl.dispose();
    _monthCtrl.dispose();
    _yearCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final day = int.tryParse(_dayCtrl.text.trim());
    final month = _repeat == EventRepeat.monthly ? null : int.tryParse(_monthCtrl.text.trim());
    final year = _repeat == EventRepeat.none ? int.tryParse(_yearCtrl.text.trim()) : null;

    if (_titleCtrl.text.trim().isEmpty || day == null) return;
    if (_repeat != EventRepeat.monthly && month == null) return;

    final event = PersonalEvent(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      isLunar: _isLunar,
      day: day,
      month: month,
      year: year,
      repeat: _repeat,
      remindDaysBefore: _remindDaysBefore,
    );
    await PersonalEventService.addEvent(event);
    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm sự kiện')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Tiêu đề')),
          const SizedBox(height: 10),
          TextField(controller: _descCtrl, decoration: const InputDecoration(labelText: 'Mô tả')),
          const SizedBox(height: 10),
          SwitchListTile(
            value: _isLunar,
            onChanged: (v) => setState(() => _isLunar = v),
            title: Text(_isLunar ? 'Lịch âm' : 'Lịch dương'),
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<EventRepeat>(
            initialValue: _repeat,
            decoration: const InputDecoration(labelText: 'Lặp lại'),
            items: const [
              DropdownMenuItem(value: EventRepeat.none, child: Text('Không lặp (Một lần)')),
              DropdownMenuItem(value: EventRepeat.yearly, child: Text('Hàng năm')),
              DropdownMenuItem(value: EventRepeat.monthly, child: Text('Hàng tháng')),
            ],
            onChanged: (v) => setState(() => _repeat = v!),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _dayCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Ngày'),
                ),
              ),
              const SizedBox(width: 8),
              if (_repeat != EventRepeat.monthly)
                Expanded(
                  child: TextField(
                    controller: _monthCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Tháng'),
                  ),
                ),
              if (_repeat == EventRepeat.none) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _yearCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Năm'),
                  ),
                ),
              ]
            ],
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<int>(
            initialValue: _remindDaysBefore,
            decoration: const InputDecoration(labelText: 'Báo trước'),
            items: const [
              DropdownMenuItem(value: 0, child: Text('Đúng ngày')),
              DropdownMenuItem(value: 1, child: Text('Trước 1 ngày')),
              DropdownMenuItem(value: 3, child: Text('Trước 3 ngày')),
              DropdownMenuItem(value: 7, child: Text('Trước 7 ngày')),
            ],
            onChanged: (v) => setState(() => _remindDaysBefore = v!),
          ),
          const SizedBox(height: 30),
          FilledButton(onPressed: _save, child: const Text('Lưu sự kiện')),
        ],
      ),
    );
  }
}

