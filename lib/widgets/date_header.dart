import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateHeader extends StatefulWidget {
  final DateTime selectedDay;
  final VoidCallback onNowPressed;
  final bool is24HourFormat;

  const DateHeader({
    super.key,
    required this.selectedDay,
    required this.onNowPressed,
    required this.is24HourFormat,
  });

  @override
  State<DateHeader> createState() => _DateHeaderState();
}

class _DateHeaderState extends State<DateHeader> {
  late DateTime _now;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _scheduleNextMinute();
  }

  void _scheduleNextMinute() {
    // Wait until the next exact minute boundary, then tick every 60s
    final secondsUntilNextMinute = 60 - _now.second;
    _timer = Timer(Duration(seconds: secondsUntilNextMinute), () {
      if (!mounted) return;
      setState(() => _now = DateTime.now());
      _timer = Timer.periodic(const Duration(minutes: 1), (_) {
        if (!mounted) return;
        setState(() => _now = DateTime.now());
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final muted = colorScheme.onSurface.withAlpha(45);
    final timePattern = widget.is24HourFormat ? 'HH:mm' : 'hh:mm a';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── LEFT: date block ──────────────────────────────────
          Container(width: 38),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('EEEE').format(widget.selectedDay),
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    color: Colors.black.withAlpha(80),
                  ),
                ),
                Text(
                  DateFormat('d.yy').format(widget.selectedDay),
                  style: const TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.w900,
                    height: 1.0,
                  ),
                ),
                Text(
                  DateFormat('MMM').format(widget.selectedDay).toUpperCase(),
                  style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.w900,
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ),

          // ── Divider ───────────────────────────────────────────
          Container(
            width: 2,
            height: 100,
            color: colorScheme.onSurface.withAlpha(60),
          ),
          Container(width: 16),

          // ── RIGHT: timezones ──────────────────────────────────
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _TimeBlock(
                    time: DateFormat(timePattern).format(_now),
                    label: 'Local',
                    muted: muted,
                  ),
                  const SizedBox(height: 10),
                  _TimeBlock(
                    time: DateFormat(timePattern).format(_now.toUtc()),
                    label: 'UTC',
                    muted: muted,
                  ),
                  Container(height: 8),
                  ElevatedButton(
                    onPressed: widget.onNowPressed,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(64),
                      ),
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    child: Text("Now", style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeBlock extends StatelessWidget {
  final String time;
  final String label;
  final Color muted;

  const _TimeBlock({
    required this.time,
    required this.label,
    required this.muted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          time,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 11, color: muted, height: 1.3)),
      ],
    );
  }
}
