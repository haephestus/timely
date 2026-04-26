import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timely/utils/settings_provider.dart';
import 'package:provider/provider.dart';

import 'package:timely/utils/notification_utils.dart';
import 'package:timely/models/chunk.dart' as model;
import 'package:timely/models/chunk_activity.dart';
import 'package:timely/screens/chunk_manager.dart';
import 'package:timely/utils/database/database.dart' as db;
import 'package:alarm/alarm.dart';

import 'package:timely/widgets/date_header.dart';
import 'package:timely/widgets/timeline/horizontal_timeline.dart';
import 'package:timely/widgets/activity/activities_widget.dart';

import 'package:timely/utils/database/services.dart' as service;
import 'package:timely/utils/calendar_utils.dart';

class HomePage extends StatefulWidget {
  final ScrollController? scrollController;
  final ValueChanged<model.Chunk?>? onChunkSelected;
  final ValueChanged<model.Chunk?>? onChunkAdded;
  const HomePage({
    this.onChunkSelected,
    this.onChunkAdded,
    this.scrollController,
    super.key,
  });

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final CalendarFormat _calendarFormat = CalendarFormat.week;
  final GlobalKey<HorizontalTimelineState> _timelineKey = GlobalKey();
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  Notify notify = Notify();

  late final db.AppDb _database;
  late final service.ChunkActivityService _service;
  late SettingsProvider settings;

  List<model.Chunk> _chunks = [];
  model.Chunk? _selectedChunk;
  List<ChunkActivity> _activities = [];

  @override
  void initState() {
    super.initState();
    _database = db.AppDb();
    _service = service.ChunkActivityService(_database);
    loadChunks();
  }

  model.Chunk? _getChunkForNow() {
    final currentHour = DateTime.now().hour;
    try {
      return _chunks.firstWhere(
        (c) => currentHour >= c.startHour && currentHour < c.endHour,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> _showUpcomingAlarms() async {
    final alarms = await Alarm.getAlarms();
    final now = DateTime.now();

    // just filter for future alarms, no day restriction
    final upcomingAlarms = alarms.where((a) => a.dateTime.isAfter(now)).toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    debugPrint('Upcoming alarms: ${upcomingAlarms.length}');

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Upcoming Alarms",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        content: upcomingAlarms.isEmpty
            ? const Text('No upcoming alarms')
            : SizedBox(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children: upcomingAlarms.map((alarm) {
                    final timeStr = settings.is24HourFormat
                        ? '${alarm.dateTime.hour.toString().padLeft(2, '0')}:${alarm.dateTime.minute.toString().padLeft(2, '0')}'
                        : TimeOfDay(
                            hour: alarm.dateTime.hour,
                            minute: alarm.dateTime.minute,
                          ).format(context);

                    // show date if it's not today
                    final isToday =
                        alarm.dateTime.day == now.day &&
                        alarm.dateTime.month == now.month &&
                        alarm.dateTime.year == now.year;
                    final subtitle = isToday
                        ? timeStr
                        : '${alarm.dateTime.day}/${alarm.dateTime.month} $timeStr';

                    return ListTile(
                      leading: const Icon(Icons.alarm),
                      title: Text(alarm.notificationSettings.title),
                      subtitle: Text(subtitle),
                      trailing: IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () async {
                          await Alarm.stop(alarm.id);
                          if (!mounted) return;
                          Navigator.pop(context);
                          _showUpcomingAlarms();
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> loadChunks({bool tomorrow = false}) async {
    final dateStr = _selectedDay.toIso8601String().split('T').first;
    final dbChunks = await _service.getTodaysChunks(dateStr);

    if (!mounted) return;

    final mappedChunks = dbChunks.map<model.Chunk>((c) {
      final base = (
        chunkId: c.id,
        name: c.name,
        isActive: c.isActive == 1,
        startHour: c.startHour ?? 0,
        startMinute: c.startMinute ?? 0,
        endHour: c.endHour ?? 0,
        endMinute: c.endMinute ?? 0,
        category: model.mapCategory(c.category),
      );

      return switch (c.frequency) {
        'weekly' => model.ScheduledChunk(
          name: base.name,
          chunkId: base.chunkId,
          isActive: base.isActive,
          startHour: base.startHour,
          startMinute: base.startMinute,
          endHour: base.endHour,
          endMinute: base.endMinute,
          category: base.category,
          selectedDays: c.selectedDays?.split(',') ?? [],
        ),
        'seasonal' => () {
          final parts = (c.date ?? '|').split('|');
          return model.SeasonalChunk(
            name: base.name,
            chunkId: base.chunkId,
            isActive: base.isActive,
            startHour: base.startHour,
            startMinute: base.startMinute,
            endHour: base.endHour,
            endMinute: base.endMinute,
            category: base.category,
            startDate: parts.elementAtOrNull(0) ?? '',
            endDate: parts.elementAtOrNull(1) ?? '',
          );
        }(),
        'onceoff' => model.OnceChunk(
          name: base.name,
          chunkId: base.chunkId,
          isActive: base.isActive,
          startHour: base.startHour,
          startMinute: base.startMinute,
          endHour: base.endHour,
          endMinute: base.endMinute,
          category: base.category,
          date: c.date,
        ),
        _ => model.DailyChunk(
          name: base.name,
          chunkId: base.chunkId,
          isActive: base.isActive,
          startHour: base.startHour,
          startMinute: base.startMinute,
          endHour: base.endHour,
          endMinute: base.endMinute,
          category: base.category,
        ),
      };
    }).toList();

    setState(() {
      _chunks = mappedChunks;
      _selectedChunk = null;
    });

    notify.scheduledToday(_chunks);
    widget.onChunkSelected?.call(null);
    if (_selectedChunk != null) {
      await loadChunkActivities(_selectedChunk!.chunkId!);
    }
  }

  Future<void> loadChunkActivities(int chunkId) async {
    final dbActivities = await _service.getActivitiesForChunk(
      chunkId,
      _selectedDay,
    );
    if (!mounted) return;
    setState(() {
      _activities = dbActivities;
    });
  }

  void _goToNow() {
    final now = DateTime.now();
    setState(() {
      _focusedDay = now;
      _selectedDay = now;
      _selectedChunk = _getChunkForNow();
    });
    widget.onChunkSelected?.call(_selectedChunk);
    if (_selectedChunk != null) {
      loadChunkActivities(_selectedChunk!.chunkId!);
    }
    _timelineKey.currentState?.scrollToNow();
  }

  void _openChunkManager() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ChunkManager(isEdit: false)),
    );
    if (result == true) {
      await loadChunks();
    }
  }

  @override
  Widget build(BuildContext context) {
    settings = context.watch<SettingsProvider>();
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.grey.shade300),
              child: Column(
                children: [
                  SizedBox(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        /// Top header
                        DateHeader(
                          is24HourFormat: settings.is24HourFormat,
                          selectedDay: _selectedDay,
                          onNowPressed: _goToNow,
                        ),

                        /// WEEK CALENDAR
                        Listener(
                          onPointerSignal: (pointerSignal) {
                            setState(() {
                              if (pointerSignal is PointerScrollEvent) {
                                if (pointerSignal.scrollDelta.dy > 0) {
                                  final next = _focusedDay.add(
                                    const Duration(days: 7),
                                  );
                                  _focusedDay = next.isAfter(kLastDay)
                                      ? kLastDay
                                      : next;
                                } else {
                                  final previous = _focusedDay.subtract(
                                    const Duration(days: 7),
                                  );
                                  _focusedDay = previous.isBefore(kFirstDay)
                                      ? kFirstDay
                                      : previous;
                                }
                              }
                            });
                          },
                          child: TableCalendar(
                            //replace this with a setting
                            startingDayOfWeek: settings.weekStart,
                            headerVisible: false,
                            daysOfWeekVisible: false,
                            weekNumbersVisible: true,
                            calendarStyle: CalendarStyle(
                              weekendTextStyle: TextStyle(
                                color: Colors.red.withAlpha(200),
                              ),
                              selectedTextStyle: TextStyle(color: Colors.white),
                              selectedDecoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              todayTextStyle: TextStyle(color: Colors.white),
                              todayDecoration: BoxDecoration(
                                color: Colors.black.withAlpha(70),
                                shape: BoxShape.circle,
                              ),
                              weekNumberTextStyle: TextStyle(
                                color: Colors.red,
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                              ),
                              markerDecoration: BoxDecoration(
                                color: Colors.red,
                              ),
                            ),
                            rowHeight: 48,
                            availableCalendarFormats: const {
                              CalendarFormat.week: 'Week',
                            },
                            // eventLoader: (chunks) { return _getChunkForNow();},
                            availableGestures: AvailableGestures.all,
                            calendarFormat: _calendarFormat,
                            daysOfWeekHeight: 28,
                            focusedDay: _focusedDay,
                            firstDay: kFirstDay,
                            lastDay: kLastDay,
                            selectedDayPredicate: (day) =>
                                isSameDay(_selectedDay, day),
                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                _selectedDay = selectedDay;
                                _focusedDay = focusedDay;
                                _selectedChunk = _chunks.isNotEmpty
                                    ? _getChunkForNow()
                                    : null;
                              });
                              loadChunks();
                              widget.onChunkSelected?.call(_selectedChunk);
                              if (_selectedChunk != null) {
                                loadChunkActivities(_selectedChunk!.chunkId!);
                              }
                            },
                            onPageChanged: (focusedDay) {
                              _focusedDay = focusedDay;
                            },
                          ),
                        ),

                        /// HORIZONTAL DAY TIMELINE
                        _chunks.isEmpty
                            ? Center(
                                child: TextButton.icon(
                                  label: const Text("Create your first chunk"),
                                  onPressed: _openChunkManager,
                                  icon: const Icon(Icons.add),
                                ),
                              )
                            : HorizontalTimeline(
                                key: _timelineKey,
                                chunks: _chunks,
                                selectedChunk: _selectedChunk,
                                onChunkSelected: (chunk) async {
                                  setState(() {
                                    _selectedChunk = chunk;
                                  });
                                  widget.onChunkSelected?.call(chunk);
                                  await loadChunkActivities(chunk.chunkId!);
                                },
                                onLongPress: _showUpcomingAlarms,
                                onChunkLongPress: (chunk) async {
                                  final result = await Navigator.of(context)
                                      .push(
                                        MaterialPageRoute(
                                          builder: (_) => ChunkManager(
                                            isEdit: true,
                                            chunk: chunk,
                                          ),
                                        ),
                                      );
                                  if (result == true && mounted) {
                                    await loadChunks();
                                  }
                                },
                              ),
                      ],
                    ),
                  ),

                  /// ACTIVITIES FOR CHUNK
                  Expanded(
                    child: ActivityWidget(
                      scrollController: widget.scrollController,
                      db: _database,
                      chunk: _selectedChunk,
                      activities: _activities,
                      onActivityChanged: _selectedChunk != null
                          ? () => loadChunkActivities(_selectedChunk!.chunkId!)
                          : null,
                    ),
                  ),
                ],
              ),
            ),
            // Custom Nav bar
          ],
        ),
      ),
    );
  }
}
