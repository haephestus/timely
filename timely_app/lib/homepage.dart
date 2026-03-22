import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:timely_app/models/chunk.dart' as model;
import 'package:timely_app/models/chunk_activity.dart';
import 'package:timely_app/screens/chunk_manager.dart';
import 'package:timely_app/utils/database/database.dart' as db;

import 'package:timely_app/widgets/timeline/horizontal_timeline.dart';
import 'package:timely_app/widgets/activities/activities.dart';

import 'package:timely_app/utils/database/services.dart' as service;
import 'package:timely_app/utils/calendar_utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// Calendar state
  final CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  late final db.AppDb _database;
  late final service.ChunkActivityService _service;

  /// Chunks and selected chunks
  List<model.Chunk> _chunks = [];
  model.Chunk? _selectedChunk;

  /// fetch ChunkActivities from dbChunks
  List<ChunkActivity> _activities = [];

  @override
  void initState() {
    super.initState();
    _database = db.AppDb();
    _service = service.ChunkActivityService(_database);
    _loadChunks();
  }

  /// fetch chunks from db
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
            endHour: c.endHour ?? 0,
            isActive: c.isActive == 1,
          );
        }).toList();

    setState(() {
      _chunks = mappedChunks;
      _selectedChunk = _chunks.isNotEmpty ? _chunks.first : null;
    });

    // Load activities for the first chunk
    if (_selectedChunk != null) {
      await _loadChunkActivities(_selectedChunk!.chunkId!);
    }
  }

  /// Load activities for a given chunk
  Future<void> _loadChunkActivities(int chunkId) async {
    final dbActivities = await _service.getActivitiesForChunk(chunkId);

    if (!mounted) return;

    setState(() {
      _activities = dbActivities;
    });
  }

  /// load chunk manager
  void _openChunkManager() async {
    final result = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ChunkManager()));

    if (result == true) {
      await _loadChunks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: ,
        destinations: [],
      ),
      */
      body: Column(
        children: [
          /// WEEK CALENDAR (day selector)
          Listener(
            onPointerSignal: (pointerSignal) {
              if (pointerSignal is PointerScrollEvent) {
                if (pointerSignal.scrollDelta.dy > 0) {
                  // Scroll down → next week
                  _focusedDay = _focusedDay.add(const Duration(days: 7));
                } else {
                  // Scroll up → previous week
                  _focusedDay = _focusedDay.subtract(const Duration(days: 7));
                }

                setState(() {});
              }
            },
            child: TableCalendar(
              availableCalendarFormats: const {CalendarFormat.week: 'Week'},
              availableGestures: AvailableGestures.all,
              calendarFormat: _calendarFormat,
              daysOfWeekHeight: 32,
              focusedDay: _focusedDay,
              firstDay: kFirstDay,
              lastDay: kLastDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _selectedChunk = _chunks.isNotEmpty ? _chunks.first : null;
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
          ),

          const SizedBox(height: 8),

          /// HORIZONTAL DAY TIMELINE
          _chunks.isEmpty
              ? Center(
                child: TextButton.icon(
                  label: const Text("Create your first chunk"),
                  onPressed: _openChunkManager,
                  icon: Icon(Icons.add),
                ),
              )
              : HorizontalTimeline(
                chunks: _chunks,
                selectedChunk: _selectedChunk,
                onChunkSelected: (chunk) async {
                  setState(() {
                    _selectedChunk = chunk;
                  });
                  await _loadChunkActivities(chunk.chunkId!);
                },
              ),

          const Divider(height: 1),

          /// ACTIVITIES FOR CHUNK
          Expanded(
            child: ChunkActivities(
              chunk: _selectedChunk,
              activities: _activities,
            ),
          ),
        ],
      ),
    );
  }
}
