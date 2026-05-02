import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timely/models/chunk_activity.dart';
import 'package:timely/models/chunk.dart';
import 'package:timely/screens/activity_manager.dart';
import 'package:timely/utils/database/database.dart' as database;
import 'package:timely/utils/settings_provider.dart';
import 'package:timely/widgets/activity/horizontal_activity_cart.dart';

// TODO: check for incomplete activities, carry them over to next day
// OR show incomplete activity counter
// WARN: hook into service.dart (add prompting to reschedule activities)
// loadChunkActivities -> get all incomplete activities
class ActivityWidget extends StatelessWidget {
  final Chunk? chunk;
  final database.AppDb db;
  final List<ChunkActivity> activities;
  final ChunkActivity? selectedActivity;
  final VoidCallback? onActivityChanged;
  final VoidCallback? onCompleted;
  final ScrollController? scrollController;

  const ActivityWidget({
    super.key,
    required this.db,
    required this.chunk,
    this.selectedActivity,
    required this.activities,
    required this.scrollController,
    required this.onActivityChanged,
    required this.onCompleted,
  });

  @override
  // Hide completed activity
  Widget build(BuildContext context) {
    // TODO: add a way to show incomplete activities
    SettingsProvider settings = context.watch<SettingsProvider>();
    String _fmt12(String? timeStr) {
      if (timeStr == null) return '--:--';
      final parts = timeStr.split(':');
      if (parts.length != 2) return '--:--';
      final h = int.tryParse(parts[0]);
      final m = int.tryParse(parts[1]);
      if (h == null || m == null) return '--:--';
      final hour = h == 0
          ? 12
          : h > 12
          ? h - 12
          : h;
      final period = h >= 12 ? 'PM' : 'AM';
      return '${hour.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')} $period';
    }

    if (chunk == null) {
      return Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: const Center(child: Text('No chunk selected.')),
      );
    }

    final s = chunkScheme(chunk!);

    return Column(
      children: [
        // front layer — chunk header
        Container(
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.transparent),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Chunk icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadiusGeometry.circular(12),
                      color: s.accent.withValues(alpha: 0.25),
                    ),
                    child: Icon(s.icon, color: s.bg, size: 20),
                  ),
                  const SizedBox(width: 12),
                  //Chunk name
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chunk!.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: s.bg,
                            letterSpacing: -0.3,
                          ),
                        ),
                        Text(
                          s.label,
                          style: TextStyle(fontSize: 12, color: s.accent),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      //Chunk frequency
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadiusGeometry.circular(8),
                          color: s.accent.withValues(alpha: 0.2),
                        ),
                        child: Text(
                          chunk!.frequency.name,
                          style: TextStyle(
                            fontSize: 12,
                            color: s.bg,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        settings.is24HourFormat
                            ? '${chunk!.startTimeStr} – ${chunk!.endTimeStr}'
                            : '${_fmt12(chunk!.startTimeStr)} – ${_fmt12(chunk!.endTimeStr)}',
                        style: TextStyle(fontSize: 12, color: s.accent),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Divider(color: s.accent.withValues(alpha: 0.2), height: 1),
              Row(
                children: [
                  // Activities label
                  GestureDetector(
                    onTap: () async {
                      final result = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              ActivityManager(chunk: chunk!, isEdit: false),
                        ),
                      );
                      if (result == true) onActivityChanged?.call();
                    },
                    child: Row(
                      children: [
                        Text(
                          activities.length == 1
                              ? '${activities.length} activity'
                              : '${activities.length} activities',
                          style: TextStyle(fontSize: 12, color: s.accent),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Activity status
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: chunk!.isActive
                          ? s.accent
                          : s.accent.withValues(alpha: 0.4),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    chunk!.isActive ? 'Active' : 'Inactive',
                    style: TextStyle(
                      fontSize: 12,
                      color: chunk!.isActive
                          ? s.accent
                          : s.accent.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // back layer — white activities card with rounded top corners
        Expanded(
          child: Container(
            decoration: BoxDecoration(color: Colors.transparent),
            child: activities.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(s.icon, color: s.bg, size: 40),
                        const SizedBox(height: 12),
                        Text(
                          'No activities yet.',
                          style: TextStyle(fontSize: 14, color: s.accent),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 12,
                    ),
                    itemCount: activities.length,
                    itemBuilder: (context, index) => HorizontalActivityCard(
                      db: db,
                      chunk: chunk!,
                      activity: activities[index],
                      onCompleted: () => onCompleted?.call(),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
