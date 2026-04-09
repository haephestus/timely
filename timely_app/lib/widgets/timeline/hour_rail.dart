import 'package:flutter/material.dart';
import 'package:timely/widgets/timeline/horizontal_timeline.dart';

class HourRail extends StatelessWidget {
  const HourRail({super.key});

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
            '${hour.toString().padLeft(2, '0')}:00',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        );
      }),
    );
  }
}
