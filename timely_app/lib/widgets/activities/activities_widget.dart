import 'package:flutter/material.dart';
import 'package:timely_app/models/chunk_activity.dart';
import 'package:timely_app/models/chunk.dart';
import 'package:timely_app/screens/activity_manager.dart';

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
                // show ranged activities -> show activity if date in range
                // show everyday activities -> straight forward
                // show periodic activities -> show activity based on date or day
                return CheckboxListTile(
                  title: Text(activity.name),
                  subtitle: Text(activity.description),
                  secondary: Text(activity.type.name),
                  value: activity.completed,
                  onChanged: (_) {},
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
