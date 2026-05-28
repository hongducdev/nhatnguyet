import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/personal_event.dart';

class PersonalEventService {
  static const String _key = 'personal_events';

  static Future<List<PersonalEvent>> loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key) ?? [];
    return jsonList.map((e) => PersonalEvent.fromJson(jsonDecode(e))).toList();
  }

  static Future<void> saveEvents(List<PersonalEvent> events) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = events.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_key, jsonList);
  }

  static Future<void> addEvent(PersonalEvent event) async {
    final events = await loadEvents();
    events.add(event);
    await saveEvents(events);
  }

  static Future<void> removeEvent(String id) async {
    final events = await loadEvents();
    events.removeWhere((e) => e.id == id);
    await saveEvents(events);
  }
}
