import 'package:flutter/material.dart';
import 'package:timely_app/models/chunk_activity.dart';
import 'package:timely_app/models/chunk.dart' as model;
import 'package:timely_app/utils/database/database.dart';

class AddActivities extends StatefulWidget {
  final model.Chunk chunk;
  const AddActivities({super.key, required this.chunk});

  @override
  State<AddActivities> createState() => _AddActivitiesState();
}

class _AddActivitiesState extends State<AddActivities> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  ActivityType _type = ActivityType.repeatable;
  late final AppDb _db;

  Future<void> _submitActivity() async {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();

    if (name.isEmpty) return;

    await _db
        .into(_db.activities)
        .insert(
          ActivitiesCompanion.insert(
            name: name,
            description: description,
            type: _type.name,
            chunkId: widget.chunk.chunkId!,
          ),
        );
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model.Chunk chunk = widget.chunk;
    return Scaffold(
      appBar: AppBar(title: Text('Add Activity to ${chunk.name}')),
      body: Form(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('Enter Activity Name'),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(hintText: 'Name your activity'),
              ),
              Text('Enter Activity Description'),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(hintText: 'Describe your activity'),
              ),
              Text('How often do you want this activity to repeat?'),
              Wrap(
                spacing: 8,
                children:
                    ActivityType.values.map((type) {
                      return ChoiceChip(
                        label: Text(switch (type) {
                          ActivityType.oneOff => 'Once',
                          ActivityType.range => 'Set Dates',
                          ActivityType.repeatable => 'Everyday',
                        }),
                        selected: _type == type,
                        onSelected: (selected) {
                          if (!selected) return;
                          setState(() {
                            _type = type;
                          });
                        },
                      );
                    }).toList(),
              ),

              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () {
                    _submitActivity();
                  },
                  icon: Icon(Icons.send_sharp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
