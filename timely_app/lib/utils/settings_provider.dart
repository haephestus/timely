import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class SettingsProvider extends ChangeNotifier {
  bool _darkMode = false;
  bool _is24HourFormat = false;
  bool _saveLastPostion = false;
  bool _showInactiveChunks = false;
  StartingDayOfWeek _weekStart = StartingDayOfWeek.monday;

  bool get darkMode => _darkMode;
  bool get is24HourFormat => _is24HourFormat;
  bool get saveLastPosition => _saveLastPostion;
  bool get showInactiveChunks => _showInactiveChunks;

  StartingDayOfWeek get weekStart => _weekStart;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _darkMode = prefs.getBool('dark_mode') ?? false;
    _saveLastPostion = prefs.getBool('save_last_position') ?? false;
    _is24HourFormat = prefs.getBool('twelve_hour') ?? false;
    _showInactiveChunks = prefs.getBool('show_inactive_chunks') ?? false;
    _weekStart = StartingDayOfWeek.values[prefs.getInt('week_start') ?? 0];
    notifyListeners();
  }

  Future<void> setShowInactiveChunks(bool value) async {
    _showInactiveChunks = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('show_inactive_chunks', value);
    notifyListeners();
  }

  Future<void> setSaveLastPosition(bool value) async {
    _saveLastPostion = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('save_last_position', value);
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    _darkMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', value);
    notifyListeners();
  }

  Future<void> set24HourFormat(bool value) async {
    _is24HourFormat = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('twelve_hour', value);
    notifyListeners();
  }

  Future<void> setWeekStart(StartingDayOfWeek value) async {
    _weekStart = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('week_start', value.index);
    notifyListeners();
  }
}
