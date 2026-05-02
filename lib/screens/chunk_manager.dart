import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift hide Column;
import 'package:provider/provider.dart';
import 'package:timely/models/chunk.dart' as model;
import 'package:timely/utils/database/database.dart' as db;
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:timely/utils/database/services.dart';
import 'package:timely/utils/notification_utils.dart';
import 'package:timely/utils/settings_provider.dart';
import 'package:timely/utils/calendar_utils.dart' as cal;
import 'package:day_picker/day_picker.dart';

// FIX: chunk of different categories and same times can overlap - prevent that
class ChunkManager extends StatefulWidget {
  final bool isEdit;
  final model.Chunk? chunk;

  const ChunkManager({super.key, required this.isEdit, this.chunk});

  @override
  State<ChunkManager> createState() => _ChunkManagerState();
}

class _ChunkManagerState extends State<ChunkManager> {
  final _nameController = TextEditingController();
  late final db.AppDb _db;
  late final ChunkActivityService _service;

  model.ChunkFrequency _frequency = model.ChunkFrequency.daily;
  model.ChunkCategory _category = model.ChunkCategory.work;

  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();
  Notify notify = Notify();

  // Frequency-specific state
  DateTime? _onceoffDate;
  DateTimeRange? _weeklyRange;
  List<String> _weekdays = [];

  @override
  void initState() {
    super.initState();
    _db = db.AppDb();
    _service = ChunkActivityService(_db);

    if (widget.isEdit && widget.chunk != null) {
      final chunk = widget.chunk!;
      _nameController.text = chunk.name;
      startTime = TimeOfDay(hour: chunk.startHour, minute: chunk.startMinute);
      endTime = TimeOfDay(hour: chunk.endHour, minute: chunk.endMinute);
      _frequency = chunk.frequency;
      _category = chunk.category;

      // Restore frequency-specific state by matching the concrete subtype
      switch (chunk) {
        case model.OnceChunk c:
          if (c.date != null) _onceoffDate = DateTime.tryParse(c.date!);

        case model.ScheduledChunk c:
          if (c.selectedDays.isNotEmpty) {
            _weekdays = c.selectedDays;
          }

        case model.SeasonalChunk c:
          final s = DateTime.tryParse(c.startDate);
          final e = DateTime.tryParse(c.endDate);
          if (s != null && e != null) {
            _weeklyRange = DateTimeRange(start: s, end: e);
          }

        default:
          break; // DailyChunk — nothing extra to restore
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // ── Date pickers ────────────────────────────────────────────────────────────

  Future<void> _pickOnceoffDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _onceoffDate ?? DateTime.now(),
      firstDate: cal.kFirstDay,
      lastDate: cal.kLastDay,
    );
    if (picked != null) setState(() => _onceoffDate = picked);
  }

  Future<void> _pickSeasonalRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: cal.kFirstDay,
      lastDate: cal.kLastDay,
      initialDateRange: _weeklyRange,
      initialEntryMode: DatePickerEntryMode.calendar,
    );
    if (picked != null) setState(() => _weeklyRange = picked);
  }

  Future<void> _pickWeekdays() async {
    List<String> selected = List.from(_weekdays);

    final days = [
      DayInWeek(
        'Mon',
        dayKey: 'Monday',
        isSelected: selected.contains('Monday'),
      ),
      DayInWeek(
        'Tue',
        dayKey: 'Tuesday',
        isSelected: selected.contains('Tuesday'),
      ),
      DayInWeek(
        'Wed',
        dayKey: 'Wednesday',
        isSelected: selected.contains('Wednesday'),
      ),
      DayInWeek(
        'Thu',
        dayKey: 'Thursday',
        isSelected: selected.contains('Thursday'),
      ),
      DayInWeek(
        'Fri',
        dayKey: 'Friday',
        isSelected: selected.contains('Friday'),
      ),
      DayInWeek(
        'Sat',
        dayKey: 'Saturday',
        isSelected: selected.contains('Saturday'),
      ),
      DayInWeek(
        'Sun',
        dayKey: 'Sunday',
        isSelected: selected.contains('Sunday'),
      ),
    ];

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Repeat on'),
        content: SelectWeekDays(
          days: days,
          border: false,
          boxDecoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(30),
          ),
          selectedDaysFillColor: Theme.of(context).colorScheme.primary,
          selectedDayTextColor: Theme.of(context).colorScheme.onPrimary,
          onSelect: (values) => selected = values,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );

    setState(() => _weekdays = selected);
  }

  // ── Frequency detail summary widget ─────────────────────────────────────────

  Widget _frequencyDetail() {
    switch (_frequency) {
      case model.ChunkFrequency.daily:
        return const SizedBox.shrink();

      case model.ChunkFrequency.onceoff:
        return _DetailRow(
          icon: Icons.calendar_today,
          text: _onceoffDate != null
              ? '${_onceoffDate!.day}/${_onceoffDate!.month}/${_onceoffDate!.year}'
              : 'Tap to pick a date',
          onTap: _pickOnceoffDate,
          missing: _onceoffDate == null,
        );

      case model.ChunkFrequency.weekly:
        return _DetailRow(
          icon: Icons.repeat,
          text: _weekdays.isEmpty ? 'Tap to pick days' : _weekdays.join(', '),
          onTap: _pickWeekdays,
          missing: _weekdays.isEmpty,
        );

      case model.ChunkFrequency.seasonal:
        return _DetailRow(
          icon: Icons.date_range,
          text: _weeklyRange != null
              ? '${_fmt(_weeklyRange!.start)} → ${_fmt(_weeklyRange!.end)}'
              : 'Tap to pick date seasonal',
          onTap: _pickSeasonalRange,
          missing: _weeklyRange == null,
        );
    }
  }

  String _fmt(DateTime d) => '${d.day}/${d.month}/${d.year}';

  // ── Time ────────────────────────────────────────────────────────────────────

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }

  Future<void> _pickTime({
    required bool isStart,
    required bool timeFormat,
  }) async {
    Navigator.of(context).push(
      showPicker(
        context: context,
        is24HrFormat: timeFormat,
        iosStylePicker: true,
        value: isStart
            ? Time(hour: startTime.hour, minute: startTime.minute)
            : Time(hour: endTime.hour, minute: endTime.minute),
        onChange: (Time newTime) {
          if (!mounted) return;
          setState(() {
            final tod = TimeOfDay(hour: newTime.hour, minute: newTime.minute);
            if (isStart) {
              startTime = tod;
            } else {
              endTime = tod;
            }
          });
        },
      ),
    );
  }

  // ── Delete ──────────────────────────────────────────────────────────────────

  Future<void> _deleteChunk() async {
    if (widget.chunk?.chunkId == null) return;
    try {
      await (_db.delete(
        _db.chunks,
      )..where((c) => c.id.equals(widget.chunk!.chunkId!))).go();
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error deleting: $e")));
    }
    notify.stop(widget.chunk!.chunkId);
  }

  // ── Submit ──────────────────────────────────────────────────────────────────

  Future<void> _submitChunk() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Name is required")));
      return;
    }

    final startMinutes = startTime.hour * 60 + startTime.minute;
    final endMinutes = endTime.hour * 60 + endTime.minute;
    if (startMinutes >= endMinutes) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Start time must be before end time")),
      );
      return;
    }

    // Guard frequency-specific required fields
    if (_frequency == model.ChunkFrequency.onceoff && _onceoffDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please pick a date for this one-off chunk"),
        ),
      );
      return;
    }
    if (_frequency == model.ChunkFrequency.weekly && _weekdays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please pick at least one day")),
      );
      return;
    }
    if (_frequency == model.ChunkFrequency.seasonal && _weeklyRange == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please pick a date seasonal")),
      );
      return;
    }

    // Encode frequency data for DB columns
    final String? dateValue = switch (_frequency) {
      model.ChunkFrequency.onceoff =>
        _onceoffDate!.toIso8601String().split('T').first,
      model.ChunkFrequency.seasonal =>
        '${_weeklyRange!.start.toIso8601String().split('T').first}'
            '|'
            '${_weeklyRange!.end.toIso8601String().split('T').first}',
      _ => null,
    };

    final String? weekdayValue = _frequency == model.ChunkFrequency.weekly
        ? _weekdays.join(',')
        : null;

    final overlapping = await _service.getOverlappingChunk(
      startTime.hour,
      startTime.minute,
      endTime.hour,
      endTime.minute,
      excludeId: widget.isEdit ? widget.chunk?.chunkId : null,
      frequency: _frequency.name,
      selectedDays: _frequency == model.ChunkFrequency.weekly
          ? _weekdays.toString()
          : null,
    );
    if (overlapping != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Time overlaps with chunk '${overlapping.name}'"),
        ),
      );
      return;
    }

    try {
      if (widget.isEdit && widget.chunk != null) {
        await (_db.update(
          _db.chunks,
        )..where((c) => c.id.equals(widget.chunk!.chunkId!))).write(
          db.ChunksCompanion(
            name: drift.Value(name),
            frequency: drift.Value(_frequency.name),
            startHour: drift.Value(startTime.hour),
            startMinute: drift.Value(startTime.minute),
            startDate: drift.Value(
              _weeklyRange?.start.toIso8601String().split("T").first,
            ),
            endDate: drift.Value(
              _weeklyRange?.end.toIso8601String().split("T").first,
            ),
            endHour: drift.Value(endTime.hour),
            endMinute: drift.Value(endTime.minute),
            category: drift.Value(_category.name),
            date: drift.Value(dateValue),
            selectedDays: drift.Value(weekdayValue),
          ),
        );
      } else {
        await _db
            .into(_db.chunks)
            .insert(
              db.ChunksCompanion.insert(
                name: name,
                frequency: _frequency.name,
                startHour: drift.Value(startTime.hour),
                startMinute: drift.Value(startTime.minute),
                endHour: drift.Value(endTime.hour),
                endMinute: drift.Value(endTime.minute),
                category: _category.name,
                date: drift.Value(dateValue),
                startDate: drift.Value(
                  _weeklyRange?.start.toIso8601String().split("T").first,
                ),
                endDate: drift.Value(
                  _weeklyRange?.end.toIso8601String().split("T").first,
                ),
                selectedDays: drift.Value(weekdayValue),
              ),
            );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Chunk saved")));
      Navigator.of(context).pop(true);
    } catch (e, s) {
      debugPrint("DB ERROR: $e");
      debugPrintStack(stackTrace: s);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  // ── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Edit Chunk' : 'Create Chunk'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Chunk Name",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Name your chunk',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Time Range",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _TimeSelector(
                      label: "Start",
                      time: _formatTime(startTime),
                      onTap: () => _pickTime(
                        isStart: true,
                        timeFormat: settings.is24HourFormat,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _TimeSelector(
                      label: "End",
                      time: _formatTime(endTime),
                      onTap: () => _pickTime(
                        isStart: false,
                        timeFormat: settings.is24HourFormat,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                "Repeat",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: model.ChunkFrequency.values.map((frequency) {
                  final label = switch (frequency) {
                    model.ChunkFrequency.daily => 'Daily',
                    model.ChunkFrequency.weekly => 'Weekly',
                    model.ChunkFrequency.seasonal => 'Seasonal',
                    model.ChunkFrequency.onceoff => 'Once-off',
                  };
                  return ChoiceChip(
                    label: Text(label),
                    selected: _frequency == frequency,
                    onSelected: (selected) {
                      if (selected) setState(() => _frequency = frequency);
                      // Auto-open the picker on first selection
                      if (selected) {
                        switch (frequency) {
                          case model.ChunkFrequency.onceoff:
                            _pickOnceoffDate();
                          case model.ChunkFrequency.weekly:
                            _pickWeekdays();
                          case model.ChunkFrequency.seasonal:
                            _pickSeasonalRange();
                          case model.ChunkFrequency.daily:
                            break;
                        }
                      }
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
              // Shows a tappable summary row for the chosen frequency
              _frequencyDetail(),
              const Spacer(),
              const Text(
                "Category",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Wrap(
                spacing: 8,
                children: model.ChunkCategory.values.map((category) {
                  final label = switch (category) {
                    model.ChunkCategory.admin => 'Admin',
                    model.ChunkCategory.exercise => 'Exercise',
                    model.ChunkCategory.hobby => 'Hobby',
                    model.ChunkCategory.learn => 'Learn',
                    model.ChunkCategory.research => 'Research',
                    model.ChunkCategory.rest => 'Rest',
                    model.ChunkCategory.study => 'Study',
                    model.ChunkCategory.sleep => 'Sleep',
                    model.ChunkCategory.work => 'Work',
                  };
                  return ChoiceChip(
                    label: Text(label),
                    selected: _category == category,
                    onSelected: (selected) {
                      if (selected) setState(() => _category = category);
                    },
                  );
                }).toList(),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.center,
                child: Wrap(
                  spacing: 12,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _submitChunk,
                      icon: const Icon(Icons.save),
                      label: Text(
                        widget.isEdit ? "Update Chunk" : "Save Chunk",
                      ),
                    ),
                    if (widget.isEdit)
                      ElevatedButton.icon(
                        onPressed: _deleteChunk,
                        icon: const Icon(Icons.delete, color: Colors.red),
                        label: const Text("Delete Chunk"),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Detail row ───────────────────────────────────────────────────────────────

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final bool missing;

  const _DetailRow({
    required this.icon,
    required this.text,
    required this.onTap,
    this.missing = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = missing
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).colorScheme.primary;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: TextStyle(color: color, fontWeight: FontWeight.w500),
              ),
            ),
            Icon(Icons.edit, size: 16, color: color.withAlpha(150)),
          ],
        ),
      ),
    );
  }
}

// ── Time selector (unchanged) ─────────────────────────────────────────────────

class _TimeSelector extends StatelessWidget {
  final String label;
  final String time;
  final VoidCallback onTap;

  const _TimeSelector({
    required this.label,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
