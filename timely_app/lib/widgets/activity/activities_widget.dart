import 'package:flutter/material.dart';
import 'package:timely/models/chunk_activity.dart';
import 'package:timely/models/chunk.dart';
import 'package:timely/screens/activity_manager.dart';
import 'package:timely/utils/database/database.dart' as database;
import 'package:timely/widgets/activity/vertical_activity_card.dart';
import 'package:timely/widgets/activity/horizontal_activity_card.dart';

class ActivityWidget extends StatelessWidget {
  final Chunk? chunk;
  final database.AppDb db;
  final List<ChunkActivity> activities;
  final ChunkActivity? selectedActivity;
  final VoidCallback? onActivityChanged;

  const ActivityWidget({
    super.key,
    required this.chunk,
    required this.db,
    required this.activities,
    this.selectedActivity,
    required this.onActivityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 6, right: 24, top: 16),
            child: TextButton.icon(
              label: Text(
                chunk != null
                    ? 'Activities for ${chunk!.name}'
                    : 'Select a chunk',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () async {
                if (chunk != null) {
                  final result = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          ActivityManager(chunk: chunk!, isEdit: false),
                    ),
                  );
                  if (result == true) {
                    onActivityChanged?.call();
                  }
                }
              },
            ),
          ),
          if (chunk == null)
            const Padding(
              padding: EdgeInsets.all(96),
              child: Center(child: Text('No chunk selected.')),
            )
          else if (activities.isEmpty)
            const Padding(
              padding: EdgeInsets.all(96),
              child: Center(child: Text('Add activities to this chunk.')),
            )
          else
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: ShaderMask(
                  shaderCallback: (rect) => LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white, Colors.white, Colors.transparent],
                    stops: const [0.15, 0.85, 1.0],
                  ).createShader(rect),
                  blendMode: BlendMode.dstIn,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    itemCount: activities.length,
                    itemBuilder: (context, index) {
                      final activity = activities[index];
                      return VerticalActivityCard(
                        db: db,
                        chunk: chunk!,
                        activity: activity,
                        onDeleted: () => onActivityChanged?.call(),
                      );
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
