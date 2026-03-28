import 'package:flutter/material.dart';
import 'package:timely_app/models/chunk_activity.dart';
import 'package:timely_app/models/chunk.dart' as model;
import 'package:timely_app/utils/calendar_utils.dart' as cal;
import 'package:timely_app/utils/database/database.dart';
import 'package:timely_app/utils/database/services.dart';
import 'package:day_picker/day_picker.dart';

/// should be able to add, delete, edit activities
/// pass a single activity to this screen to manage
class ActivityManager extends StatefulWidget {
  final model.Chunk? chunk;
  final bool isEdit;
  final ChunkActivity? activity;
  const ActivityManager({
    super.key,
    required this.chunk,
    required this.isEdit,
    this.activity,
  });

  @override
  State<ActivityManager> createState() => _ActivityManagerState();
}

class _ActivityManagerState extends State<ActivityManager> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  late final ChunkActivityService _activityService;
  DateTime? selectedDate;
  DateTimeRange? selectedRangeDate;
  DateTime? startDate;
  DateTime? endDate;
  ChunkActivity? _activity;
  ActivityType _type = ActivityType.everyday;
  late final AppDb _db;

  @override
  void initState() {
    super.initState();
    _db = AppDb();
    _activityService = ChunkActivityService(_db);

    if (widget.isEdit && widget.activity != null) {
      //load the activity data into the widget
      _activity = switch (widget.activity!) {
        RangeActivity a => RangeActivity(
          name: a.name,
          startDate: a.startDate,
          endDate: a.endDate,
          description: a.description,
        ),
        PeriodicActivity a => PeriodicActivity(
          weekday: a.weekday,
          name: a.name,
          description: a.description,
        ),
        EverydayActivity a => EverydayActivity(
          date: a.date,
          name: a.name,
          description: a.description,
        ),
      };
    } else if (_type == ActivityType.everyday) {
      final now = DateTime.now();
      _activity = EverydayActivity(date: now, name: "", description: "");
      selectedDate = now;
    }
  }

  Future<void> _rangeDatePicker(ActivityType type) async {
    DateTimeRange? rangeDate = await showDateRangePicker(
      context: context,
      firstDate: cal.kFirstDay,
      lastDate: cal.kLastDay,
      initialEntryMode: DatePickerEntryMode.calendar,
    );
    if (rangeDate != null) {
      setState(() {
        _type = type;
        _activity = RangeActivity(
          name: _nameController.text,
          description: _descriptionController.text,
          startDate: rangeDate.start,
          endDate: rangeDate.end,
        );
      });
    }
  }

  Future<void> _periodicDatePicker(ActivityType type) async {
    List<String> selectedDays = [];

    // Pre-populate if editing an existing activity
    if (_activity is PeriodicActivity) {
      selectedDays = (_activity as PeriodicActivity).weekday;
    }

    final days = [
      DayInWeek(
        "Mon",
        dayKey: "Monday",
        isSelected: selectedDays.contains("Monday"),
      ),
      DayInWeek(
        "Tue",
        dayKey: "Tuesday",
        isSelected: selectedDays.contains("Tuesday"),
      ),
      DayInWeek(
        "Wed",
        dayKey: "Wednesday",
        isSelected: selectedDays.contains("Wednesday"),
      ),
      DayInWeek(
        "Thu",
        dayKey: "Thursday",
        isSelected: selectedDays.contains("Thursday"),
      ),
      DayInWeek(
        "Fri",
        dayKey: "Friday",
        isSelected: selectedDays.contains("Friday"),
      ),
      DayInWeek(
        "Sat",
        dayKey: "Saturday",
        isSelected: selectedDays.contains("Saturday"),
      ),
      DayInWeek(
        "Sun",
        dayKey: "Sunday",
        isSelected: selectedDays.contains("Sunday"),
      ),
    ];

    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Repeat on"),
            content: SelectWeekDays(
              days: days,
              border: false,
              boxDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(30),
              ),
              selectedDaysFillColor: Theme.of(context).colorScheme.primary,
              selectedDayTextColor: Theme.of(context).colorScheme.onPrimary,
              onSelect: (values) => selectedDays = values,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Done"),
              ),
            ],
          ),
    );

    if (selectedDays.isNotEmpty) {
      setState(() {
        _type = type;
        _activity = PeriodicActivity(
          name: _nameController.text,
          description: _descriptionController.text,
          weekday: selectedDays,
        );
      });
    }
  } // should not be a date picker

  // should init activity everyday in activities table
  // can pick more than one day to repeat
  Future<void> _everydayDatePicker(ActivityType type) async {
    setState(() {
      _type = type;
    });
    _activity = EverydayActivity(
      name: _nameController.text,
      description: _descriptionController.text,
    );
  }

  Future<void> _submitActivity() async {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();

    if (name.isEmpty) return;

    try {
      if (widget.isEdit && widget.chunk != null && widget.activity != null) {
        // load the selected activities information and edit
        await switch (_activity!) {
          RangeActivity a => _activityService.updateRangeActivity(
            id: a.id!,
            chunkId: widget.chunk!.chunkId!,
            type: _type.name,
            description: a.description,
            name: a.name,
            startDate: a.startDate.toString(),
            endDate: a.endDate.toString(),
          ),
          PeriodicActivity a => _activityService.updatePeriodicActivity(
            id: a.id!,
            name: _activity!.name,
            type: _type.name,
            weekday: a.weekday.toString(),
            description: a.description,
            chunkId: widget.chunk!.chunkId!,
          ),
          EverydayActivity a => _activityService.updateEverydayActivity(
            id: a.id!,
            type: _type.name,
            name: a.name,
            date: a.date.toString(),
            description: a.description,
            chunkId: widget.chunk!.chunkId!,
          ),
        };
      } else {
        // create the activity, set name, description, type
        // pass activity name
        // pass activity description
        // if ActivityType.periodic -> select date
        // if ActivityType.everyday -> select day of the week
        // if ActivityType.range -> select dates
        await switch (_activity!) {
          RangeActivity a => _activityService.addRangeActivity(
            chunkId: widget.chunk!.chunkId!,
            description: description,
            name: name,
            startDate: a.startDate,
            endDate: a.endDate,
          ),
          PeriodicActivity a => _activityService.addPeriodicActivity(
            name: name,
            weekday: a.weekday.toString(),
            description: description,
            chunkId: widget.chunk!.chunkId!,
          ),
          EverydayActivity _ => _activityService.addEverydayActivity(
            name: name,
            description: description,
            chunkId: widget.chunk!.chunkId!,
          ),
        };
      }
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Chunk saved")));

      Navigator.of(context).pop(true);
    } catch (e, s) {
      debugPrint("DB ERROR: $e");
      debugPrintStack(stackTrace: s);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model.Chunk chunk = widget.chunk!;
    return Scaffold(
      appBar: AppBar(title: Text('Add Activity to ${chunk.name}')),
      body: Form(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            spacing: 24.0,
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
              Text('When to repeat?'),
              Wrap(
                spacing: 8,
                children:
                    ActivityType.values.map((type) {
                      return ChoiceChip(
                        label: Text(switch (type) {
                          ActivityType.periodic => 'Select day(s) ',
                          ActivityType.everyday => 'Everyday',
                          ActivityType.range => 'Select date(s)',
                        }),
                        selected: _type == type,
                        onSelected: (selected) {
                          if (!selected) return;
                          setState(() {
                            switch (type) {
                              case ActivityType.range:
                                _rangeDatePicker(type);
                              case ActivityType.periodic:
                                _periodicDatePicker(type);
                              case ActivityType.everyday:
                                _everydayDatePicker(type);
                            }

                            /// showDatePicker for selected type
                          });
                        },
                      );
                    }).toList(),
              ),
              Align(
                alignment: Alignment.center,
                child: Wrap(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _submitActivity,
                      icon: Icon(Icons.save),
                      label: Text("save"),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => {},
                      icon: Icon(Icons.delete, color: Colors.red),
                      label: Text("delete"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
