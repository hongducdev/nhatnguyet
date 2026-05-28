import 'package:flutter/material.dart';
import '../models/personal_event.dart';
import '../services/personal_event_service.dart';

class PersonalEventsScreen extends StatefulWidget {
  const PersonalEventsScreen({super.key});

  @override
  State<PersonalEventsScreen> createState() => _PersonalEventsScreenState();
}

class _PersonalEventsScreenState extends State<PersonalEventsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<PersonalEvent> _events = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _load();
  }

  Future<void> _load() async {
    final events = await PersonalEventService.loadEvents();
    setState(() => _events = events);
  }

  @override
  Widget build(BuildContext context) {
    final solarEvents = _events.where((e) => !e.isLunar).toList();
    final lunarEvents = _events.where((e) => e.isLunar).toList();

    // Sắp xếp theo thứ tự ngày tăng dần
    solarEvents.sort((a, b) => a.day.compareTo(b.day));
    lunarEvents.sort((a, b) => a.day.compareTo(b.day));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sự kiện cá nhân'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Lịch dương'), Tab(text: 'Lịch âm')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildList(solarEvents),
          _buildList(lunarEvents),
        ],
      ),
    );
  }

  Widget _buildList(List<PersonalEvent> events) {
    if (events.isEmpty) return const Center(child: Text('Không có sự kiện'));
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: events.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, i) {
        final e = events[i];
        
        String dateText = '';
        if (e.repeat == EventRepeat.monthly) {
          dateText = 'Ngày ${e.day} hàng tháng';
        } else if (e.repeat == EventRepeat.yearly) {
          dateText = 'Ngày ${e.day}/${e.month} hàng năm';
        } else {
          dateText = 'Ngày ${e.day}/${e.month}/${e.year}';
        }

        String remindText = e.remindDaysBefore == 0 ? 'Đúng ngày' : 'Báo trước ${e.remindDaysBefore} ngày';

        return Card(
          child: ListTile(
            title: Text(e.title),
            subtitle: Text('$dateText · $remindText${e.description.isEmpty ? '' : ' · ${e.description}'}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () async {
                await PersonalEventService.removeEvent(e.id);
                _load();
              },
            ),
          ),
        );
      },
    );
  }
}
