import 'package:flutter/material.dart';
import 'package:timely_app/models/chunk_activity.dart';
import 'package:timely_app/screens/activity_manager.dart';
import 'package:timely_app/utils/database/database.dart';
import 'package:timely_app/models/chunk.dart' as model;

class VerticalActivityCard extends StatefulWidget {
  final ChunkActivity? activity;
  final VoidCallback? onDeleted;
  final model.Chunk chunk;
  final AppDb db;

  const VerticalActivityCard({
    required this.activity,
    required this.chunk,
    required this.db,
    this.onDeleted,
    super.key,
  });

  @override
  State<VerticalActivityCard> createState() => _VerticalActivityCardState();
}

class _VerticalActivityCardState extends State<VerticalActivityCard> {
  double _dragOffset = 0;
  bool _isOpen = false;
  static const double _maxDrag = 80;
  static const double _threshold = 60;

  ({Color bg, Color accent, String label, IconData icon}) get _scheme {
    return switch (widget.activity!) {
      EverydayActivity() => (
        bg: const Color(0xFFD4B896),
        accent: const Color(0xFFA07850),
        label: 'Daily',
        icon: Icons.repeat,
      ),
      PeriodicActivity() => (
        bg: const Color(0xFFBFCFD4),
        accent: const Color(0xFF7098A8),
        label: 'Periodic',
        icon: Icons.calendar_month,
      ),
      RangeActivity() => (
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
      await (widget.db.delete(widget.db.activities)
        ..where((a) => a.id.equals(widget.activity!.id!))).go();
      widget.onDeleted?.call();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error deleting activity')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = _scheme;
    final activity = widget.activity!;

    return Stack(
      children: [
        // ── Swipe actions ─────────────────────────────────────
        Positioned.fill(
          child: Row(
            children: [
              IconButton(
                onPressed: _deleteActivity,
                icon: const Icon(Icons.delete, color: Colors.red),
              ),
              IconButton(
                onPressed: () async {
                  final result = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (_) => ActivityManager(
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
          child: Transform.translate(
            offset: Offset(-_dragOffset, 0),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              height: 156,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: s.bg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ── LEFT COLUMN: description + type icon ────
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
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
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: s.accent.withAlpha(20),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(s.icon, size: 18, color: s.accent),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // ── Vertical divider ────────────────────────
                  Container(
                    width: 2,
                    height: 80,
                    margin: const EdgeInsets.symmetric(horizontal: 14),
                    color: Colors.black26,
                  ),

                  // ── RIGHT COLUMN: times + progress bar ──────
                  Expanded(
                    flex: 2,
                    child: _TimeColumn(
                      accent: s.accent,
                      activity: activity,
                      startTime: _parseTime(activity.startTime),
                      endTime: _parseTime(activity.endTime),
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

  const _TimeColumn({
    required this.accent,
    required this.activity,
    required this.startTime,
    required this.endTime,
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
    return '${t.hour.toString().padLeft(2, '0')}:'
        '${t.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Start / end time labels
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

        if (_isActive) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 8,
              backgroundColor: accent.withAlpha(20),
              valueColor: AlwaysStoppedAnimation<Color>(accent),
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              'In progress',
              style: TextStyle(
                fontSize: 10,
                color: accent.withAlpha(70),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ] else ...[
          Center(
            child: Text(
              _durationText,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black45,
              ),
            ),
          ),
        ],
      ],
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
      crossAxisAlignment:
          alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          time,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        if (label.isNotEmpty)
          Text(
            label,
            style: TextStyle(fontSize: 10, color: accent.withAlpha(70)),
          ),
      ],
    );
  }
}
