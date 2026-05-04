import 'package:timely/utils/database/services.dart';
import 'package:flutter/material.dart';
import 'package:timely/models/chunk_activity.dart';
import 'package:timely/screens/activity_manager.dart';
import 'package:timely/utils/database/database.dart';
import 'package:timely/models/chunk.dart' as model;

class HorizontalActivityCard extends StatefulWidget {
  final ChunkActivity activity;
  final VoidCallback? onChanged;
  final VoidCallback? onCompleted;
  final model.Chunk chunk;
  final AppDb db;

  const HorizontalActivityCard({
    required this.onCompleted,
    required this.activity,
    required this.chunk,
    required this.db,
    this.onChanged,
    super.key,
  });

  @override
  State<HorizontalActivityCard> createState() => _HorizontalActivityCardState();
}

class _HorizontalActivityCardState extends State<HorizontalActivityCard> {
  double _dragOffset = 0.0;
  bool _isOpen = false;

  final double _maxDrag = 85;
  final double _threshold = 60;

  late ChunkActivityService _service;

  // Brand colors — intentional, kept as-is for both themes.
  // bg is used at 0.4 alpha so it works on both light and dark backgrounds.
  ({Color bg, Color accent, IconData icon}) get _scheme {
    return switch (widget.activity) {
      OnceOffActivity() => (
        bg: const Color(0xFFD4B896),
        accent: const Color(0xFFA07850),
        icon: Icons.repeat,
      ),
      DailyActivity() => (
        bg: const Color(0xFFD4B896),
        accent: const Color(0xFF7A5230),
        icon: Icons.repeat_rounded,
      ),
      WeeklyActivity() => (
        bg: const Color(0xFFBFCFD4),
        accent: const Color(0xFF3D6B7A),
        icon: Icons.calendar_month,
      ),
      SeasonalActivity() => (
        bg: const Color(0xFFD4C5A9),
        accent: const Color(0xFF6B5535),
        icon: Icons.date_range,
      ),
    };
  }

  int _toMinutes(String? t) {
    if (t == null || !t.contains(':')) return 0;
    final parts = t.split(':');
    final h = int.tryParse(parts[0]) ?? 0;
    final m = int.tryParse(parts[1]) ?? 0;
    return h * 60 + m;
  }

  String _dateText() {
    if (widget.activity is DailyActivity) return 'Everyday';
    if (widget.activity is WeeklyActivity) return 'Weekly';
    if (widget.activity is SeasonalActivity) return 'Date range';
    return 'Once';
  }

  Future<void> _delete() async {
    if (widget.activity.id == null) return;
    await (widget.db.delete(
      widget.db.activities,
    )..where((a) => a.id.equals(widget.activity.id!))).go();
    widget.onChanged?.call();
  }

  Future<void> _edit() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ActivityManager(
          chunk: widget.chunk,
          isEdit: true,
          activity: widget.activity,
        ),
      ),
    );
    if (result == true) widget.onChanged?.call();
  }

  void _handleClose() {
    setState(() {
      _isOpen = false;
      _dragOffset = 0;
    });
  }

  @override
  void initState() {
    super.initState();
    _service = ChunkActivityService(widget.db);
  }

  @override
  Widget build(BuildContext context) {
    final s = _scheme;
    final cs = Theme.of(context).colorScheme;

    final start = _toMinutes(widget.activity.startTime);
    var end = _toMinutes(widget.activity.endTime);

    final now = TimeOfDay.now();
    var nowMinutes = now.hour * 60 + now.minute;

    // ── Overnight normalization ──
    final isOvernight = end <= start;
    if (isOvernight) {
      end += 1440;
      if (nowMinutes < start) nowMinutes += 1440;
    }

    double progress = 0;
    if (end > start) {
      if (nowMinutes > start && nowMinutes < end) {
        progress = (nowMinutes - start) / (end - start);
      } else if (nowMinutes >= end) {
        progress = 1;
      }
    }
    progress = progress.clamp(0.0, 1.0);
    final double actionOpacity = (_dragOffset.abs() / _maxDrag).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// TIME COLUMN
            Column(
              children: [
                _TimeChip(time: widget.activity.startTime ?? '--:--'),
                const Spacer(),
                _TimeChip(time: widget.activity.endTime ?? '--:--'),
              ],
            ),

            const SizedBox(width: 12),

            /// SLIDING CARD
            Expanded(
              child: GestureDetector(
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
                  if (_isOpen) _handleClose();
                },
                onDoubleTap: () {
                  _service.setActivityCompleted(widget.activity.id!);
                  widget.onCompleted?.call();
                },
                child: Stack(
                  children: [
                    /// BACKGROUND ACTIONS
                    Positioned.fill(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.transparent,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: s.accent.withValues(
                                  alpha: actionOpacity,
                                ),
                              ),
                              onPressed: _edit,
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: cs.error.withValues(
                                  alpha: actionOpacity,
                                ), // ← was Colors.red
                              ),
                              onPressed: _delete,
                            ),
                            const SizedBox(width: 12),
                          ],
                        ),
                      ),
                    ),

                    /// CARD
                    Transform.translate(
                      offset: Offset(-_dragOffset, 0),
                      child: Stack(
                        children: [
                          /// Progress line track
                          Positioned(
                            left: 8,
                            top: 12,
                            bottom: 12,
                            child: Container(
                              width: 4,
                              decoration: BoxDecoration(
                                color: cs.onSurface.withAlpha(
                                  40,
                                ), // ← was Colors.black26
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: FractionallySizedBox(
                                  heightFactor: progress,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: s.accent,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          /// Card content
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              padding: const EdgeInsets.fromLTRB(
                                18,
                                18,
                                40,
                                18,
                              ),
                              decoration: BoxDecoration(
                                color: s.bg.withValues(alpha: 0.4),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: PopupMenuButton<String>(
                                      icon: Icon(
                                        Icons.more_horiz,
                                        size: 20,
                                        color: cs
                                            .onSurface, // ← was default (black)
                                      ),
                                      onSelected: (v) {
                                        if (v == 'edit') _edit();
                                        if (v == 'delete') _delete();
                                      },
                                      itemBuilder: (_) => const [
                                        PopupMenuItem(
                                          value: 'edit',
                                          child: Text('Edit'),
                                        ),
                                        PopupMenuItem(
                                          value: 'delete',
                                          child: Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: s.accent.withValues(
                                            alpha: 0.2,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Icon(
                                          s.icon,
                                          size: 24,
                                          color: s.accent,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget
                                                      .activity
                                                      .description
                                                      .isEmpty
                                                  ? 'description'
                                                  : widget.activity.description,
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                                color: cs.onSurface.withAlpha(
                                                  180,
                                                ), // ← was Colors.black54
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                _dateText(),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: cs.onSurface.withAlpha(
                                                    153,
                                                  ), // ← was Colors.black.withValues(alpha:0.6)
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ── TIME CHIP ──
class _TimeChip extends StatelessWidget {
  final String time;

  const _TimeChip({required this.time});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: 60,
      height: 28,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        time,
        style: TextStyle(
          color: cs.onSurface.withAlpha(97), // ← was Colors.black38
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
