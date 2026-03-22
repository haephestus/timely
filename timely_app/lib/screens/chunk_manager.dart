import 'package:flutter/material.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:timely_app/models/chunk.dart';
import 'package:timely_app/utils/database/database.dart';

class ChunkManager extends StatefulWidget {
  const ChunkManager({super.key});

  @override
  State<ChunkManager> createState() => _ChunkManagerState();
}

class _ChunkManagerState extends State<ChunkManager> {
  final _nameController = TextEditingController();
  late final AppDb _db;

  ChunkType _type = ChunkType.daily;

  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    _db = AppDb();
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
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? startTime : endTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }

  Future<void> _submitChunk() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    try {
      await _db
          .into(_db.chunks)
          .insert(
            ChunksCompanion.insert(
              name: name,
              type: _type.name,
              startHour: Value(startTime.hour),
              endHour: Value(endTime.hour),
            ),
          );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Chunk submitted")));

      Navigator.of(context).pop(true);
    } catch (e, s) {
      debugPrint("INSERT ERROR: $e");
      debugPrintStack(stackTrace: s);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chunk Manager')),
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

              /// SIDE BY SIDE TIME PICKERS
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
                    ChunkType.values.map((type) {
                      return ChoiceChip(
                        label: Text(
                          type == ChunkType.daily ? 'Daily' : 'Sporadic',
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
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: _submitChunk,
                  icon: const Icon(Icons.send),
                  label: const Text("Save Chunk"),
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
