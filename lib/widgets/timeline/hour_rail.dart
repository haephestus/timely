import 'package:flutter/material.dart';
import 'package:timely/widgets/timeline/horizontal_timeline.dart';

class HourRail extends StatelessWidget {
  final bool is24HourFormat;
  const HourRail({super.key, required this.is24HourFormat});

  String _formatHour(int hour) {
    if (is24HourFormat) {
      return '${hour.toString().padLeft(2, '0')}:00';
    }
    if (hour == 0) return '12 AM';
    if (hour == 12) return '12 PM';
    return hour < 12 ? '$hour AM' : '${(hour - 12)} PM';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(24, (hour) {
        return Container(
          width: HorizontalTimeline.hourWidth,
          height: HorizontalTimeline.timelineHeight,
          padding: const EdgeInsets.only(top: 8, left: 6),
          decoration: BoxDecoration(
            border: Border(right: BorderSide(color: Colors.grey.shade400)),
          ),
          child: Text(
            _formatHour(hour),
            style: Theme.of(context).textTheme.labelSmall,
          ),
        );
      }),
    );
  }
}
