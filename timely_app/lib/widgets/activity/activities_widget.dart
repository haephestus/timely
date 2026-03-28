import 'package:flutter/material.dart';
import 'package:timely_app/models/chunk_activity.dart';
import 'package:timely_app/models/chunk.dart';
import 'package:timely_app/screens/activity_manager.dart';
import 'package:timely_app/widgets/activity/activity_card.dart';

class ActivityWidget extends StatelessWidget {
  final Chunk? chunk;
  final List<ChunkActivity> activities;
  final ChunkActivity? selectedActivity;
  final VoidCallback? onActivityChanged;

  const ActivityWidget({
    super.key,
    required this.chunk,
    required this.activities,
    this.selectedActivity,
    required this.onActivityChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (chunk == null) {
      return const Center(child: Text('Select a chunk'));
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Activities for ${chunk!.name}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          if (activities.isEmpty) const Text('No activities planned'),
          Expanded(
            child: ListView.builder(
              itemCount: activities.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ListTile(
                    leading: const Icon(Icons.add),
                    title: const Text('Add activity'),
                    //WARN: ADD activity
                    onTap: () async {
                      final result = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (_) =>
                                  ActivityManager(chunk: chunk!, isEdit: false),
                        ),
                      );
                      if (result == true) {
                        onActivityChanged?.call();
                      }
                    },
                  );
                }
                final activity = activities[index - 1];
                // WARN: builds list of activities
                // add custom listview
                return ActivityCard(activity: activity);
              },
            ),
          ),
        ],
      ),
    );
  }
}
