import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:timely_app/models/chunk.dart' as model;
import 'package:timely_app/models/chunk_activity.dart';
import 'package:timely_app/screens/chunk_manager.dart';
import 'package:timely_app/utils/database/database.dart' as db;

import 'package:timely_app/widgets/date_header.dart';
import 'package:timely_app/widgets/navbar.dart';
import 'package:timely_app/widgets/timeline/horizontal_timeline.dart';
import 'package:timely_app/widgets/activity/activities_widget.dart';

import 'package:timely_app/utils/database/services.dart' as service;
import 'package:timely_app/utils/calendar_utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CalendarFormat _calendarFormat = CalendarFormat.week;
  final GlobalKey<HorizontalTimelineState> _timelineKey = GlobalKey();
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  late final db.AppDb _database;
  late final service.ChunkActivityService _service;

  List<model.Chunk> _chunks = [];
  model.Chunk? _selectedChunk;
  List<ChunkActivity> _activities = [];

  @override
  void initState() {
    super.initState();
    _database = db.AppDb();
    _service = service.ChunkActivityService(_database);
    _loadChunks();
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

  Future<void> _loadChunks() async {
    final dbChunks = await _service.getAllChunks();
    if (!mounted) return;

    final mappedChunks =
        dbChunks.map((c) {
          return model.Chunk(
            chunkId: c.id ?? 0,
            name: c.name,
            type:
                c.type == 'daily'
                    ? model.ChunkType.daily
                    : model.ChunkType.periodic,
            startHour: c.startHour ?? 0,
            startMinute: c.startMinute, // new
            endHour: c.endHour ?? 0,
            endMinute: c.endMinute, // new
            isActive: c.isActive == 1,
          );
        }).toList();
    setState(() {
      _chunks = mappedChunks;
      _selectedChunk = null;
    });

    if (_selectedChunk != null) {
      await _loadChunkActivities(_selectedChunk!.chunkId!);
    }
  }

  Future<void> _loadChunkActivities(int chunkId) async {
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
    if (_selectedChunk != null) {
      _loadChunkActivities(_selectedChunk!.chunkId!);
    }
    _timelineKey.currentState?.scrollToNow();
  }

  void _openChunkManager() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ChunkManager(isEdit: false)),
    );
    if (result == true) {
      await _loadChunks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.grey.shade300),
              child: Column(
                children: [
                  SizedBox(
                    height: 331,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        /// Top header
                        DateHeader(
                          selectedDay: _selectedDay,
                          onTodayPressed: _goToNow,
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
                                  _focusedDay =
                                      next.isAfter(kLastDay) ? kLastDay : next;
                                } else {
                                  final previous = _focusedDay.subtract(
                                    const Duration(days: 7),
                                  );
                                  _focusedDay =
                                      previous.isBefore(kFirstDay)
                                          ? kFirstDay
                                          : previous;
                                }
                              }
                            });
                          },
                          child: TableCalendar(
                            daysOfWeekVisible: false,
                            headerVisible: false,
                            rowHeight: 48,
                            availableCalendarFormats: const {
                              CalendarFormat.week: 'Week',
                            },
                            availableGestures: AvailableGestures.all,
                            calendarFormat: _calendarFormat,
                            daysOfWeekHeight: 28,
                            focusedDay: _focusedDay,
                            firstDay: kFirstDay,
                            lastDay: kLastDay,
                            selectedDayPredicate:
                                (day) => isSameDay(_selectedDay, day),
                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                _selectedDay = selectedDay;
                                _focusedDay = focusedDay;
                                _selectedChunk =
                                    _chunks.isNotEmpty
                                        ? _getChunkForNow()
                                        : null;
                              });
                              if (_selectedChunk != null) {
                                _loadChunkActivities(_selectedChunk!.chunkId!);
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
                                await _loadChunkActivities(chunk.chunkId!);
                              },
                              onLongPress: _openChunkManager,
                              onChunkLongPress: (chunk) async {
                                final result = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder:
                                        (_) => ChunkManager(
                                          isEdit: true,
                                          chunk: chunk,
                                        ),
                                  ),
                                );
                                if (result == true && mounted) {
                                  await _loadChunks();
                                }
                              },
                            ),
                      ],
                    ),
                  ),

                  /// ACTIVITIES FOR CHUNK
                  Expanded(
                    child: ActivityWidget(
                      db: _database,
                      chunk: _selectedChunk,
                      activities: _activities,
                      onActivityChanged:
                          _selectedChunk != null
                              ? () =>
                                  _loadChunkActivities(_selectedChunk!.chunkId!)
                              : null,
                    ),
                  ),
                ],
              ),
            ),

            // Custom Nav bar
            Navbar(
              items: [
                NavItem(name: "Home", icon: Icons.home_outlined),
                NavItem(name: "Settings", icon: Icons.settings),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
