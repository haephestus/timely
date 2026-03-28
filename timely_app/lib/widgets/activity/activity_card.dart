import 'package:flutter/material.dart';
import 'package:timely_app/models/chunk_activity.dart';
import 'package:timely_app/utils/database/database.dart';

class ActivityCard extends StatefulWidget {
  final ChunkActivity? activity;
  // final VoidCallback onTap;
  //final VoidCallback onLongPress;
  const ActivityCard({required this.activity, super.key});

  @override
  State<ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
  double _dragOffset = 0;
  bool _isOpen = false;
  static const double _maxDrag = 80;
  static const double _threshold = 60;
  late final AppDb _db;

  Future<void> _deleteActivity() async {
    if (widget.activity?.id == null) return;
    try {
      await (_db.delete(_db.activities)
        ..where((a) => a.id.equals(widget.activity!.id!))).go();

      debugPrint("Deleting activity with id: ${widget.activity!.id!}");
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error deleting activity")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.edit, color: Colors.blue),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.delete, color: Colors.blue),
              ),
            ],
          ),
        ),
        GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              _dragOffset = (_dragOffset + details.delta.dx).clamp(
                -_maxDrag,
                0.0,
              );
            });
          },
          onPanEnd: (_) {
            setState(() {
              if (_dragOffset < -_threshold) {
                _isOpen = true;
                _dragOffset = -_maxDrag;
              } else {
                _isOpen = false;
                _dragOffset = 0;
              }
            });
          },
          onTap: () {
            if (_isOpen) {
              setState(() {
                _isOpen = false;
                _dragOffset = 0;
              });
            }
          },
          child: Transform.translate(
            offset: Offset(_dragOffset, 0),
            child: SizedBox(
              width: double.infinity,
              height: 120,
              child: Card(
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.activity!.name),
                          Text(widget.activity!.description),
                        ],
                      ),
                    ),
                    Checkbox(
                      value: widget.activity!.completed,
                      onChanged: (_) {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
