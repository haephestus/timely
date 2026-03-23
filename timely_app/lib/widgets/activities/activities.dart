import 'package:flutter/material.dart';
import 'package:timely_app/models/chunk_activity.dart';
import 'package:timely_app/models/chunk.dart';
import 'package:timely_app/screens/activity_manager.dart';

class ChunkActivities extends StatelessWidget {
  final Chunk? chunk;
  final List<ChunkActivity> activities;

  const ChunkActivities({
    super.key,
    required this.chunk,
    required this.activities,
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
            '${chunk!.name} Activities',
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
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => AddActivities(chunk: chunk!),
                        ),
                      );
                    },
                  );
                }
                final activity = activities[index - 1];
                return CheckboxListTile(
                  title: Text(activity.name),
                  subtitle: Text(activity.description),
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
