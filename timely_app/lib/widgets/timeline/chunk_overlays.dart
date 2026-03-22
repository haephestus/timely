import 'package:flutter/material.dart';
import 'package:timely_app/models/chunk.dart';
import 'package:timely_app/widgets/timeline/horizontal_timeline.dart';

class ChunkOverlays extends StatelessWidget {
  final List<Chunk> chunks;
  final Chunk? selectedChunk;
  final ValueChanged<Chunk> onChunkSelected;

  const ChunkOverlays({
    super.key,
    required this.chunks,
    required this.selectedChunk,
    required this.onChunkSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24 * HorizontalTimeline.hourWidth,
      height: HorizontalTimeline.timelineHeight,
      child: Stack(
        children:
            chunks.map((chunk) {
              final left = chunk.startHour * HorizontalTimeline.hourWidth;
              final width =
                  (chunk.endHour - chunk.startHour) *
                  HorizontalTimeline.hourWidth;

              final isSelected = chunk == selectedChunk;

              return Positioned(
                left: left,
                top: 36,
                width: width,
                height: 44,
                child: GestureDetector(
                  onTap: () => onChunkSelected(chunk),
                  onLongPress: () {
                    print(chunk.name);
                  },

                  /// Main Container widget
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),

                    /// Chunk box
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? Colors.red.withValues(alpha: 0.35)
                              : Colors.blue.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),

                    /// Chunk title
                    child: Text(
                      chunk.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
