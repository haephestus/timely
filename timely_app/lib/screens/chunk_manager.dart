import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift hide Column;
import 'package:timely_app/models/chunk.dart' as model;
import 'package:timely_app/utils/database/database.dart' as db;
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:timely_app/utils/database/services.dart';

class ChunkManager extends StatefulWidget {
  final bool isEdit;
  final model.Chunk? chunk;

  const ChunkManager({super.key, required this.isEdit, this.chunk});

  @override
  State<ChunkManager> createState() => _ChunkManagerState();
}

class _ChunkManagerState extends State<ChunkManager> {
  final _nameController = TextEditingController();
  late final db.AppDb _db;
  late final ChunkActivityService _service;

  model.ChunkType _type = model.ChunkType.daily;

  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    _db = db.AppDb();
    _service = ChunkActivityService(_db);

    if (widget.isEdit && widget.chunk != null) {
      final chunk = widget.chunk!;
      _nameController.text = chunk.name;
      startTime = TimeOfDay(hour: chunk.startHour, minute: chunk.startMinute);
      endTime = TimeOfDay(hour: chunk.endHour, minute: chunk.endMinute);
      _type = chunk.type;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }

  Future<void> _pickTime({required bool isStart}) async {
    Navigator.of(context).push(
      showPicker(
        context: context,
        value:
            isStart
                ? Time(hour: startTime.hour, minute: startTime.minute)
                : Time(hour: endTime.hour, minute: endTime.minute),
        onChange: (Time newTime) {
          if (!mounted) return;
          setState(() {
            final tod = TimeOfDay(hour: newTime.hour, minute: newTime.minute);
            if (isStart) {
              startTime = tod;
            } else {
              endTime = tod;
            }
          });
        },
      ),
    );
  }

  Future<void> _deleteChunk() async {
    if (widget.chunk?.chunkId == null) return;

    try {
      await (_db.delete(_db.chunks)
        ..where((c) => c.id.equals(widget.chunk!.chunkId!))).go();

      debugPrint("Deleting chunk with id: ${widget.chunk!.chunkId}");
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error deleting: $e")));
    }
  }

  Future<void> _submitChunk() async {
    //prevent submitting chunks of the same name and overlaping time
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Name is required")));
      return;
    }
    final startMinutes = startTime.hour * 60 + startTime.minute;
    final endMinutes = endTime.hour * 60 + endTime.minute;

    if (startMinutes >= endMinutes) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Start time must be before end time")),
      );
      return;
    }

    final overlapping = await _service.getOverlappingChunk(
      startTime.hour,
      startTime.minute,
      endTime.hour,
      endTime.minute,
      excludeId: widget.isEdit ? widget.chunk?.chunkId : null,
    );
    if (overlapping != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Time overlaps with chunk'${overlapping.name}'"),
        ),
      );
      return;
    }

    try {
      //update in ChunksCompanion
      if (widget.isEdit && widget.chunk != null) {
        await (_db.update(_db.chunks)
          ..where((c) => c.id.equals(widget.chunk!.chunkId!))).write(
          db.ChunksCompanion(
            name: drift.Value(name),
            type: drift.Value(_type.name),
            startHour: drift.Value(startTime.hour),
            startMinute: drift.Value(startTime.minute),
            endHour: drift.Value(endTime.hour),
            endMinute: drift.Value(endTime.minute),
          ),
        );
      } else {
        await _db
            .into(_db.chunks)
            .insert(
              db.ChunksCompanion.insert(
                name: name,
                type: _type.name,
                startHour: drift.Value(startTime.hour),
                startMinute: drift.Value(startTime.minute),
                endHour: drift.Value(endTime.hour),
                endMinute: drift.Value(endTime.minute),
              ),
            );
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Edit Chunk' : 'Create Chunk'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Chunk Name",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Name your chunk',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Time Range",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _TimeSelector(
                      label: "Start",
                      time: _formatTime(startTime),
                      onTap: () => _pickTime(isStart: true),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _TimeSelector(
                      label: "End",
                      time: _formatTime(endTime),
                      onTap: () => _pickTime(isStart: false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                "Repeat",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                children:
                    model.ChunkType.values.map((type) {
                      return ChoiceChip(
                        label: Text(
                          type == model.ChunkType.daily ? 'Daily' : 'Sporadic',
                        ),
                        selected: _type == type,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => _type = type);
                          }
                        },
                      );
                    }).toList(),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.center,
                child: Wrap(
                  spacing: 12,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _submitChunk,
                      icon: const Icon(Icons.save),
                      label: Text(
                        widget.isEdit ? "Update Chunk" : "Save Chunk",
                      ),
                    ),
                    if (widget.isEdit)
                      ElevatedButton.icon(
                        onPressed: _deleteChunk,
                        icon: const Icon(Icons.delete, color: Colors.red),
                        label: const Text("Delete Chunk"),
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

class _TimeSelector extends StatelessWidget {
  final String label;
  final String time;
  final VoidCallback onTap;

  const _TimeSelector({
    required this.label,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
