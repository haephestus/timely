import 'package:timely/utils/database/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timely/models/chunk_activity.dart';
import 'package:timely/screens/activity_manager.dart';
import 'package:timely/utils/database/database.dart';
import 'package:timely/models/chunk.dart' as model;
import 'package:timely/utils/settings_provider.dart';

class VerticalActivityCard extends StatefulWidget {
  final ChunkActivity? activity;
  final VoidCallback? onDeleted;
  final VoidCallback? onActivityChanged;
  final model.Chunk chunk;
  final AppDb db;

  const VerticalActivityCard({
    required this.activity,
    required this.chunk,
    required this.db,
    this.onActivityChanged,
    this.onDeleted,

    super.key,
  });

  @override
  State<VerticalActivityCard> createState() => _VerticalActivityCardState();
}

class _VerticalActivityCardState extends State<VerticalActivityCard> {
  double _dragOffset = 0;
  bool _isOpen = false;
  static const double _maxDrag = 90;
  static const double _threshold = 70;
  late ChunkActivityService _service;

  @override
  void initState() {
    super.initState();
    _service = ChunkActivityService(widget.db);
  }

  bool _completed = false;
  ({Color bg, Color accent, String label, IconData icon}) get _scheme {
    return switch (widget.activity!) {
      OnceOffActivity() => (
        bg: const Color(0xFFD4B896),
        accent: const Color(0xFFA07850),
        label: 'Daily',
        icon: Icons.repeat,
      ),
      DailyActivity() => (
        bg: const Color(0xFFD4B896),
        accent: const Color(0xFFA07850),
        label: 'Daily',
        icon: Icons.repeat,
      ),
      WeeklyActivity() => (
        bg: const Color(0xFFBFCFD4),
        accent: const Color(0xFF7098A8),
        label: 'Periodic',
        icon: Icons.calendar_month,
      ),
      SeasonalActivity() => (
        bg: const Color(0xFFD4C5A9),
        accent: const Color(0xFF8B7355),
        label: 'Range',
        icon: Icons.date_range,
      ),
    };
  }

  DateTime? _parseTime(String? time) {
    if (time == null) return null;
    final parts = time.split(':');
    if (parts.length != 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, h, m);
  }

  Future<void> _deleteActivity() async {
    if (widget.activity?.id == null) return;
    try {
      await (widget.db.delete(
        widget.db.activities,
      )..where((a) => a.id.equals(widget.activity!.id!))).go();
      widget.onDeleted?.call();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error deleting activity')));
    }
  }

  Future<void> _showDeleteOptions() async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete activity?'),
        content: Text('Delete ${widget.activity!.description}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _deleteActivity();
            },
            child: const Text('Delete'),
          ),
          /*
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _bulkDeleteActivity();
            },
            child: const Text('All', style: TextStyle(color: Colors.red)),
          ),
          */
        ],
      ),
    );
  }

  Future<void> _toggleCompletion(int activityId, bool completed) async {
    if (completed) {
      await _service.setActivityCompleted(activityId);
    } else {
      await _service.setActivityIncomplete(activityId);
    }
    if (!mounted) return;
    setState(() => _completed = completed);
    widget.onActivityChanged?.call();
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final s = _scheme;
    final activity = widget.activity!;
    // free up activity time slot when an activity is marked as completed
    return Stack(
      children: [
        // ── Swipe actions ─────────────────────────────────────
        Positioned.fill(
          right: 24,
          top: 6,
          bottom: 6,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadiusGeometry.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: _showDeleteOptions,
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
                IconButton(
                  onPressed: () async {
                    final result = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ActivityManager(
                          chunk: widget.chunk,
                          isEdit: true,
                          activity: activity,
                        ),
                      ),
                    );
                    if (result == true) widget.onDeleted?.call();
                  },
                  icon: const Icon(Icons.edit, color: Colors.blue),
                ),
              ],
            ),
          ),
        ),

        // ── Card ──────────────────────────────────────────────
        GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              _dragOffset = (_dragOffset + details.delta.dx).clamp(
                -_maxDrag,
                0.0,
              );
            });
          },
          onPanEnd: (_) {
            setState(() {
              if (_dragOffset < -_threshold) {
                _isOpen = true;
                _dragOffset = -_maxDrag;
              } else {
                _isOpen = false;
                _dragOffset = 0;
              }
            });
          },
          onTap: () {
            if (_isOpen) {
              setState(() {
                _isOpen = false;
                _dragOffset = 0;
              });
            }
          },
          onLongPress: () =>
              _toggleCompletion(widget.activity!.id!, _completed),
          child: Transform.translate(
            offset: Offset(-_dragOffset, 0),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              height: 128,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: widget.activity!.completed ? Colors.grey.shade500 : s.bg,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ── LEFT COLUMN: description + frequency icon ────
                  Expanded(
                    flex: 2,
                    child: _TimeColumn(
                      is24HourFormat: settings.is24HourFormat,
                      accent: Colors.white,
                      activity: activity,
                      startTime: _parseTime(activity.startTime),
                      endTime: _parseTime(activity.endTime),
                    ),
                  ),

                  // ── Vertical divider ────────────────────────
                  Container(
                    width: 2,
                    height: 100,
                    margin: const EdgeInsets.symmetric(horizontal: 14),
                    color: Colors.black26,
                  ),
                  // ── RIGHT COLUMN: times + progress bar ──────
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ICON container
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(s.icon, size: 18, color: Colors.white),
                        ),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  activity.description.isEmpty
                                      ? 'No description'
                                      : activity.description,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Time column ───────────────────────────────────────────────────────────────

class _TimeColumn extends StatelessWidget {
  final Color accent;
  final ChunkActivity activity;
  final DateTime? startTime;
  final DateTime? endTime;
  final bool is24HourFormat;

  const _TimeColumn({
    required this.accent,
    required this.activity,
    required this.startTime,
    required this.endTime,
    required this.is24HourFormat,
  });

  bool get _isActive {
    if (startTime == null || endTime == null) return false;
    final now = DateTime.now();
    return now.isAfter(startTime!) && now.isBefore(endTime!);
  }

  double get _progress {
    if (startTime == null || endTime == null) return 0.0;
    final now = DateTime.now();
    final total = endTime!.difference(startTime!).inSeconds;
    if (total <= 0) return 0.0;
    final elapsed = now.difference(startTime!).inSeconds;
    return (elapsed / total).clamp(0.0, 1.0);
  }

  String get _durationText {
    if (startTime == null || endTime == null) return '--';
    final diff = endTime!.difference(startTime!);
    final h = diff.inHours;
    final m = diff.inMinutes % 60;
    if (h > 0 && m > 0) return '${h}h ${m}m';
    if (h > 0) return '${h}h';
    return '${m}m';
  }

  String _fmt(DateTime? t) {
    if (t == null) return '--:--';
    if (is24HourFormat) {
      return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
    }
    final hour = t.hour == 0
        ? 12
        : t.hour > 12
        ? t.hour - 12
        : t.hour;
    final period = t.hour >= 12 ? 'PM' : 'AM';
    return '${hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')} $period';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _TimeLabel(time: _fmt(startTime), label: 'Start', accent: accent),
              _TimeLabel(
                time: _fmt(endTime),
                label: 'End',
                accent: accent,
                alignRight: true,
              ),
            ],
          ),

          const SizedBox(height: 8),

          Expanded(
            child: _isActive
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: _progress,
                          minHeight: 8,
                          backgroundColor: Colors.grey.shade400.withAlpha(175),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'In progress',
                        style: TextStyle(
                          fontSize: 10,
                          color: accent.withAlpha(70),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Text(
                      _durationText,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Time label ────────────────────────────────────────────────────────────────

class _TimeLabel extends StatelessWidget {
  final String time;
  final String label;
  final Color accent;
  final bool alignRight;

  const _TimeLabel({
    required this.time,
    required this.label,
    required this.accent,
    this.alignRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignRight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          time,
          style: const TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        if (label.isNotEmpty)
          Text(
            label,
            style: TextStyle(
              fontSize: 8,
              color: Colors.black45,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }
}
