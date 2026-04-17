// activity_manager.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timely/models/chunk_activity.dart';
import 'package:timely/models/chunk.dart' as model;
import 'package:timely/utils/calendar_utils.dart' as cal;
import 'package:timely/utils/database/database.dart';
import 'package:timely/utils/database/services.dart';
import 'package:day_picker/day_picker.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:timely/utils/settings_provider.dart';

class ActivityManager extends StatefulWidget {
  final model.Chunk? chunk;
  final bool isEdit;
  final ChunkActivity? activity;

  const ActivityManager({
    super.key,
    required this.chunk,
    required this.isEdit,
    this.activity,
  });

  @override
  State<ActivityManager> createState() => _ActivityManagerState();
}

class _ActivityManagerState extends State<ActivityManager> {
  final _descriptionController = TextEditingController();

  late final ChunkActivityService _activityService;
  late final AppDb _db;

  ChunkActivity? _activity;
  Frequency _frequency = Frequency.everyday;

  // Time fields
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  void initState() {
    super.initState();
    _db = AppDb();
    _activityService = ChunkActivityService(_db);

    if (widget.isEdit && widget.activity != null) {
      final a = widget.activity!;
      _descriptionController.text = a.description;
      _frequency = a.frequency;

      // Parse existing times if present
      if (a.startTime != null) _startTime = _parseTime(a.startTime!);
      if (a.endTime != null) _endTime = _parseTime(a.endTime!);

      _activity = switch (a) {
        RangeActivity r => RangeActivity(
          id: r.id,
          startDate: r.startDate,
          endDate: r.endDate,
          description: r.description,
          startTime: r.startTime,
          endTime: r.endTime,
        ),
        PeriodicActivity p => PeriodicActivity(
          id: p.id,
          weekday: p.weekday,
          description: p.description,
          startTime: p.startTime,
          endTime: p.endTime,
        ),
        EverydayActivity e => EverydayActivity(
          id: e.id,
          date: e.date,
          description: e.description,
          startTime: e.startTime,
          endTime: e.endTime,
        ),
      };
    } else {
      final now = DateTime.now();
      _activity = EverydayActivity(date: now, description: '');
    }
  }

  TimeOfDay _parseTime(String t) {
    final parts = t.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  Future<void> _pickTime({
    required bool isStart,
    required bool timeFormat,
  }) async {
    final chunk = widget.chunk;
    final initial = isStart
        ? (_startTime ?? TimeOfDay(hour: chunk?.startHour ?? 8, minute: 0))
        : (_endTime ?? TimeOfDay(hour: chunk?.endHour ?? 9, minute: 0));

    Navigator.of(context).push(
      showPicker(
        context: context,
        iosStylePicker: true,
        is24HrFormat: timeFormat,
        value: Time(hour: initial.hour, minute: initial.minute),
        minHour: (chunk?.startHour ?? 0).toDouble(),
        minMinute: 0,
        maxMinute: 59,
        maxHour: (chunk?.endHour ?? 24).toDouble(),
        onChange: (Time newTime) {
          // validation now uses total minutes
          if (chunk != null) {
            final pickedMinutes = newTime.hour * 60 + newTime.minute;
            if (pickedMinutes < chunk.startTotalMinutes ||
                pickedMinutes > chunk.endTotalMinutes) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Time must be within ${chunk.startTimeStr} – ${chunk.endTimeStr}',
                  ),
                ),
              );
              return;
            }
          }
          setState(() {
            final tod = TimeOfDay(hour: newTime.hour, minute: newTime.minute);
            if (isStart) {
              _startTime = tod;
            } else {
              _endTime = tod;
            }
          });
        },
      ),
    );
  }

  Future<void> _seasonalDatePicker(Frequency frequency) async {
    final seasonalDate = await showDateRangePicker(
      context: context,
      firstDate: cal.kFirstDay,
      lastDate: cal.kLastDay,
      initialEntryMode: DatePickerEntryMode.calendar,
    );
    if (seasonalDate != null) {
      setState(() {
        _frequency = frequency;
        _activity = RangeActivity(
          description: _descriptionController.text,
          startDate: seasonalDate.start,
          endDate: seasonalDate.end,
        );
      });
    }
  }

  Future<void> _weeklyDatePicker(Frequency frequency) async {
    List<String> selectedDays = [];
    if (_activity is PeriodicActivity) {
      selectedDays = (_activity as PeriodicActivity).weekday;
    }

    final days = [
      DayInWeek(
        'Mon',
        dayKey: 'Monday',
        isSelected: selectedDays.contains('Monday'),
      ),
      DayInWeek(
        'Tue',
        dayKey: 'Tuesday',
        isSelected: selectedDays.contains('Tuesday'),
      ),
      DayInWeek(
        'Wed',
        dayKey: 'Wednesday',
        isSelected: selectedDays.contains('Wednesday'),
      ),
      DayInWeek(
        'Thu',
        dayKey: 'Thursday',
        isSelected: selectedDays.contains('Thursday'),
      ),
      DayInWeek(
        'Fri',
        dayKey: 'Friday',
        isSelected: selectedDays.contains('Friday'),
      ),
      DayInWeek(
        'Sat',
        dayKey: 'Saturday',
        isSelected: selectedDays.contains('Saturday'),
      ),
      DayInWeek(
        'Sun',
        dayKey: 'Sunday',
        isSelected: selectedDays.contains('Sunday'),
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
          onSelect: (values) => selectedDays = values,
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

    if (selectedDays.isNotEmpty) {
      setState(() {
        _frequency = frequency;
        _activity = PeriodicActivity(
          description: _descriptionController.text,
          weekday: selectedDays,
        );
      });
    }
  }

  Future<void> _everydayDatePicker(Frequency frequency) async {
    setState(() {
      _frequency = frequency;
      _activity = EverydayActivity(description: _descriptionController.text);
    });
  }

  Future<void> _submitActivity() async {
    final description = _descriptionController.text.trim();

    if (description.isEmpty) return;

    // Require both times to be set
    if (_startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please set both start and end times')),
      );
      return;
    }

    // Validate start < end
    final startMinutes = _startTime!.hour * 60 + _startTime!.minute;
    final endMinutes = _endTime!.hour * 60 + _endTime!.minute;
    if (startMinutes >= endMinutes) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Start time must be before end time')),
      );
      return;
    }

    final startTimeStr = _formatTime(_startTime!);
    final endTimeStr = _formatTime(_endTime!);

    try {
      if (widget.isEdit && widget.chunk != null && widget.activity != null) {
        await switch (_activity!) {
          RangeActivity a => _activityService.updateRangeActivity(
            id: a.id!,
            chunkId: widget.chunk!.chunkId!,
            frequency: _frequency.name,
            description: description,
            startDate: a.startDate.toIso8601String().split('T').first,
            endDate: a.endDate.toIso8601String().split('T').first,
            startTime: startTimeStr,
            endTime: endTimeStr,
          ),
          PeriodicActivity a => _activityService.updatePeriodicActivity(
            id: a.id!,
            frequency: _frequency.name,
            weekday: a.weekday.join(','),
            description: description,
            chunkId: widget.chunk!.chunkId!,
            startTime: startTimeStr,
            endTime: endTimeStr,
          ),
          EverydayActivity a => _activityService.updateEverydayActivity(
            id: a.id!,
            frequency: _frequency.name,
            date: a.date?.toIso8601String().split('T').first ?? '',
            description: description,
            chunkId: widget.chunk!.chunkId!,
            startTime: startTimeStr,
            endTime: endTimeStr,
          ),
        };
      } else {
        await switch (_activity!) {
          RangeActivity a => _activityService.addRangeActivity(
            chunkId: widget.chunk!.chunkId!,
            description: description,
            startDate: a.startDate,
            endDate: a.endDate,
            startTime: startTimeStr,
            endTime: endTimeStr,
          ),
          PeriodicActivity a => _activityService.addPeriodicActivity(
            weekday: a.weekday.join(','),
            description: description,
            chunkId: widget.chunk!.chunkId!,
            startTime: startTimeStr,
            endTime: endTimeStr,
          ),
          EverydayActivity _ => _activityService.addEverydayActivity(
            description: description,
            chunkId: widget.chunk!.chunkId!,
            startTime: startTimeStr,
            endTime: endTimeStr,
          ),
        };
      }

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Activity saved')));
      Navigator.of(context).pop(true);
    } catch (e, s) {
      debugPrint('DB ERROR: $e');
      debugPrintStack(stackTrace: s);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final chunk = widget.chunk!;
    final chunkWindow = '${chunk.startTimeStr} – ${chunk.endTimeStr}';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEdit
              ? 'Editing Activity for ${chunk.name}'
              : 'Add Activity to ${chunk.name}',
        ),
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 24.0,
            children: [
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: widget.isEdit
                      ? widget.activity!.description
                      : 'Describe your activity',
                ),
              ),

              // ── Time pickers ──────────────────────────────
              Text(
                'Activity time  ($chunkWindow)',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              Row(
                children: [
                  Expanded(
                    child: _TimeTile(
                      label: 'Start',
                      time: _startTime,
                      onTap: () => _pickTime(
                        isStart: true,
                        timeFormat: settings.is24HourFormat,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _TimeTile(
                      label: 'End',
                      time: _endTime,
                      onTap: () => _pickTime(
                        isStart: false,
                        timeFormat: settings.is24HourFormat,
                      ),
                    ),
                  ),
                ],
              ),

              // ── Repeat frequency ───────────────────────────────
              Text(
                widget.isEdit ? 'Edit when to repeat' : 'When to repeat?',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              Wrap(
                spacing: 8,
                children: Frequency.values.map((frequency) {
                  return ChoiceChip(
                    label: Text(switch (frequency) {
                      Frequency.weekly => 'Select day(s)',
                      Frequency.everyday => 'Everyday',
                      Frequency.seasonal => 'Select date(s)',
                    }),
                    selected: _frequency == frequency,
                    onSelected: (selected) {
                      if (!selected) return;
                      switch (frequency) {
                        case Frequency.seasonal:
                          _seasonalDatePicker(frequency);
                        case Frequency.weekly:
                          _weeklyDatePicker(frequency);
                        case Frequency.everyday:
                          _everydayDatePicker(frequency);
                      }
                    },
                  );
                }).toList(),
              ),

              Align(
                alignment: Alignment.center,
                child: ElevatedButton.icon(
                  onPressed: _submitActivity,
                  icon: const Icon(Icons.save),
                  label: Text(widget.isEdit ? 'Update' : 'Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Time tile ────────────────────────────────────────────────────────────────

class _TimeTile extends StatelessWidget {
  final String label;
  final TimeOfDay? time;
  final VoidCallback onTap;

  const _TimeTile({
    required this.label,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).colorScheme.onSurface.withAlpha(60),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time != null ? time!.format(context) : '--:--',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
