import 'package:flutter/material.dart';

// chunk.frequency -> admin, exercise, hobby, learn, research, rest, study, sleep & work
// when to repeat -> daily, weekly, seasonal
enum ChunkCategory {
  admin,
  exercise,
  hobby,
  learn,
  research,
  rest,
  study,
  sleep,
  work,
}

enum ChunkFrequency { daily, weekly, seasonal, onceoff }

class Chunk {
  final int? chunkId;
  final String name;
  final ChunkFrequency frequency;
  final ChunkCategory category;
  final int startHour;
  final int startMinute; // new
  final int endHour;
  final int endMinute; // new
  final bool isActive;

  const Chunk({
    required this.chunkId,
    required this.name,
    required this.frequency,
    required this.category,
    required this.startHour,
    required this.startMinute,
    required this.endHour,
    required this.endMinute,
    required this.isActive,
  });

  // Convenience: total minutes since midnight
  int get startTotalMinutes => startHour * 60 + startMinute;
  int get endTotalMinutes => endHour * 60 + endMinute;

  // Formatted strings
  String get startTimeStr =>
      '${startHour.toString().padLeft(2, '0')}:${startMinute.toString().padLeft(2, '0')}';
  String get endTimeStr =>
      '${endHour.toString().padLeft(2, '0')}:${endMinute.toString().padLeft(2, '0')}';
}

final class ScheduledChunk extends Chunk {
  final List<String> selectedDays;
  ScheduledChunk({
    required super.name,
    required super.chunkId,
    required super.isActive,
    required super.startHour,
    required super.startMinute,
    required super.category,
    required super.endHour,
    required super.endMinute,
    required this.selectedDays,
  }) : super(frequency: ChunkFrequency.weekly);
}

class DailyChunk extends Chunk {
  final DateTime? date;
  DailyChunk({
    this.date,
    required super.name,
    required super.chunkId,
    required super.isActive,
    required super.startHour,
    required super.startMinute,
    required super.category,
    required super.endHour,
    required super.endMinute,
  }) : assert(startHour >= 0 && startHour < 24, 'start hour must not be 0'),
       super(frequency: ChunkFrequency.daily);
}

class SeasonalChunk extends Chunk {
  final String startDate;
  final String endDate;
  SeasonalChunk({
    required this.endDate,
    required this.startDate,
    required super.name,
    required super.chunkId,
    required super.endHour,
    required super.category,
    required super.isActive,
    required super.startHour,
    required super.endMinute,
    required super.startMinute,
  }) : super(frequency: ChunkFrequency.seasonal);
}

class OnceChunk extends Chunk {
  final String? day;
  final String? date;
  OnceChunk({
    this.date,
    this.day,
    required super.name,
    required super.chunkId,
    required super.endHour,
    required super.isActive,
    required super.startHour,
    required super.endMinute,
    required super.category,
    required super.startMinute,
  }) : super(frequency: ChunkFrequency.onceoff);
}

/*
* HELPERS */

ChunkFrequency mapFrequency(String? value) => switch (value) {
  'daily' => ChunkFrequency.daily,
  'weekly' => ChunkFrequency.weekly,
  'seasonal' => ChunkFrequency.seasonal,
  'onceoff' => ChunkFrequency.onceoff,
  _ => ChunkFrequency.daily, // fallback
};

ChunkCategory mapCategory(String? value) => switch (value) {
  'admin' => ChunkCategory.admin,
  'exercise' => ChunkCategory.exercise,
  'hobby' => ChunkCategory.hobby,
  'learn' => ChunkCategory.learn,
  'research' => ChunkCategory.research,
  'rest' => ChunkCategory.rest,
  'study' => ChunkCategory.study,
  'sleep' => ChunkCategory.sleep,
  'work' => ChunkCategory.work,
  _ => ChunkCategory.work,
};

({
  Color bg,
  Color accent,
  Color soft,
  Color strong,
  String label,
  IconData icon,
})
chunkScheme(Chunk chunk) {
  return switch (chunk.category) {
    ChunkCategory.work => (
      accent: Color(0xFF8B6355),
      bg: Color(0xFF4A3728),
      soft: Color(0xFFC2A094),
      strong: Color(0xFF6E4E42),
      label: 'Work',
      icon: Icons.work,
    ),

    ChunkCategory.exercise => (
      accent: Color(0xFF4E8B72),
      bg: Color(0xFF2D4A3E),
      soft: Color(0xFF9FC7B5),
      strong: Color(0xFF3F6E5A),
      label: 'Exercise',
      icon: Icons.fitness_center,
    ),

    ChunkCategory.sleep => (
      accent: Color(0xFF4A6B8B),
      bg: Color(0xFF2B3A4A),
      soft: Color(0xFFA3B7CC),
      strong: Color(0xFF3A556E),
      label: 'Sleep',
      icon: Icons.bed,
    ),

    ChunkCategory.study => (
      accent: Color(0xFF7A7040),
      bg: Color(0xFF3D3A28),
      soft: Color(0xFFC9C39A),
      strong: Color(0xFF615933),
      label: 'Study',
      icon: Icons.menu_book,
    ),

    ChunkCategory.learn => (
      accent: Color(0xFF8B6B3D),
      bg: Color(0xFF4A3B28),
      soft: Color(0xFFD1B890),
      strong: Color(0xFF6E552F),
      label: 'Learn',
      icon: Icons.lightbulb,
    ),

    ChunkCategory.research => (
      accent: Color(0xFF3D7A8B),
      bg: Color(0xFF2B3D4A),
      soft: Color(0xFF9EC3CC),
      strong: Color(0xFF2F616E),
      label: 'Research',
      icon: Icons.science,
    ),

    ChunkCategory.hobby => (
      accent: Color(0xFF7A4E8B),
      bg: Color(0xFF3D2B4A),
      soft: Color(0xFFC3A3CC),
      strong: Color(0xFF603D6E),
      label: 'Hobby',
      icon: Icons.palette,
    ),

    ChunkCategory.rest => (
      accent: Color(0xFF6B8B3D),
      bg: Color(0xFF3A4A2B),
      soft: Color(0xFFB7CC9E),
      strong: Color(0xFF556E2F),
      label: 'Rest',
      icon: Icons.self_improvement,
    ),

    ChunkCategory.admin => (
      accent: Color(0xFF8B3D52),
      bg: Color(0xFF4A2B35),
      soft: Color(0xFFCC9EAA),
      strong: Color(0xFF6E2F41),
      label: 'Admin',
      icon: Icons.admin_panel_settings,
    ),
  };
}
