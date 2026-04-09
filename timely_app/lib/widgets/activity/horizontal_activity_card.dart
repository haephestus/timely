import 'package:flutter/material.dart';
import 'package:timely/models/chunk_activity.dart';
import 'package:timely/screens/activity_manager.dart';
import 'package:timely/utils/database/database.dart';
import 'package:timely/models/chunk.dart' as model;

// ── Fade list wrapper ────────────────────────────────────────────────────────

class FadingListView extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final double fadeHeight;

  const FadingListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.fadeHeight = 48,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback:
          (rect) => LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.white,
              Colors.white,
              Colors.transparent,
            ],
            stops: [
              0.0,
              fadeHeight / rect.height,
              1 - fadeHeight / rect.height,
              1.0,
            ],
          ).createShader(rect),
      blendMode: BlendMode.dstIn,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: fadeHeight, horizontal: 10),
        itemCount: itemCount,
        itemBuilder: itemBuilder,
      ),
    );
  }
}

// ── Activity card ────────────────────────────────────────────────────────────

class HorizontalActivityCard extends StatefulWidget {
  final ChunkActivity? activity;
  final VoidCallback? onDeleted;
  final model.Chunk chunk;
  final AppDb db;

  const HorizontalActivityCard({
    required this.activity,
    required this.chunk,
    required this.db,
    this.onDeleted,
    super.key,
  });

  @override
  State<HorizontalActivityCard> createState() => _HorizontalActivityCardState();
}

class _HorizontalActivityCardState extends State<HorizontalActivityCard> {
  double _dragOffset = 0;
  bool _isOpen = false;
  static const double _maxDrag = 80;
  static const double _threshold = 60;

  ({Color bg, Color accent, String label, IconData icon}) get _scheme =>
      switch (widget.activity!) {
        EverydayActivity() => (
          bg: const Color(0xFFD4B896),
          accent: const Color(0xFF7A5230),
          label: 'Daily',
          icon: Icons.repeat_rounded,
        ),
        PeriodicActivity() => (
          bg: const Color(0xFFBFCFD4),
          accent: const Color(0xFF3D6B7A),
          label: 'Periodic',
          icon: Icons.calendar_month_rounded,
        ),
        RangeActivity() => (
          bg: const Color(0xFFD4C5A9),
          accent: const Color(0xFF6B5535),
          label: 'Range',
          icon: Icons.date_range_rounded,
        ),
      };

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
        // ── Swipe actions ──────────────────────────────────────
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                IconButton(
                  onPressed: _deleteActivity,
                  icon: const Icon(Icons.delete_rounded, color: Colors.red),
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
                  icon: const Icon(Icons.edit_rounded, color: Colors.blue),
                ),
              ],
            ),
          ),
        ),

        // ── Swipeable card ─────────────────────────────────────
        GestureDetector(
          onPanUpdate:
              (d) => setState(() {
                _dragOffset = (_dragOffset + d.delta.dx).clamp(-_maxDrag, 0.0);
              }),
          onPanEnd:
              (_) => setState(() {
                if (_dragOffset < -_threshold) {
                  _isOpen = true;
                  _dragOffset = -_maxDrag;
                } else {
                  _isOpen = false;
                  _dragOffset = 0;
                }
              }),
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
              decoration: BoxDecoration(
                color: s.bg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── TOP: description + type icon ──────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            activity.description.isEmpty
                                ? 'No description'
                                : activity.description,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black.withAlpha(75),
                              height: 1.4,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: s.accent.withAlpha(15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(s.icon, size: 22, color: s.accent),
                        ),
                      ],
                    ),
                  ),

                  // ── Divider ───────────────────────────────────
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.black.withAlpha(8),
                    indent: 16,
                    endIndent: 16,
                  ),

                  // ── BOTTOM: start — bar — end ─────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
                    child: Row(
                      children: [
                        _TimeLabel(
                          time: '--:--',
                          label: 'Start',
                          accent: s.accent,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _ActivityBar(
                            accent: s.accent,
                            isActive: false, // TODO: wire up
                            progress: 0.0, // TODO: wire up
                          ),
                        ),
                        const SizedBox(width: 10),
                        _TimeLabel(
                          time: '--:--',
                          label: 'End',
                          accent: s.accent,
                          alignRight: true,
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

// ── Sub-widgets ──────────────────────────────────────────────────────────────

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
        Text(
          label,
          style: TextStyle(fontSize: 10, color: accent.withAlpha(70)),
        ),
      ],
    );
  }
}

class _ActivityBar extends StatelessWidget {
  final Color accent;
  final bool isActive;
  final double progress;

  const _ActivityBar({
    required this.accent,
    required this.isActive,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    if (isActive) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: LinearProgressIndicator(
          value: progress.clamp(0.0, 1.0),
          minHeight: 8,
          backgroundColor: accent.withAlpha(20),
          valueColor: AlwaysStoppedAnimation<Color>(accent),
        ),
      );
    }

    return Container(
      height: 8,
      decoration: BoxDecoration(
        color: accent.withAlpha(25),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
