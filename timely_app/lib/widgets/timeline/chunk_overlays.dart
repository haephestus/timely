import 'package:flutter/material.dart';
import 'package:timely/models/chunk.dart';
import 'package:timely/widgets/timeline/horizontal_timeline.dart';

class ChunkOverlays extends StatefulWidget {
  final List<Chunk> chunks;
  final Chunk? selectedChunk;
  final ValueChanged<Chunk> onChunkSelected;
  final ValueChanged<Chunk> onChunkLongPress;

  const ChunkOverlays({
    super.key,
    required this.chunks,
    required this.selectedChunk,
    required this.onChunkSelected,
    required this.onChunkLongPress,
  });

  @override
  State<ChunkOverlays> createState() => _ChunkOverlaysState();
}

class _ChunkOverlaysState extends State<ChunkOverlays> {
  //TODO: set up category specific chunk overlays

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24 * HorizontalTimeline.hourWidth,
      height: HorizontalTimeline.timelineHeight,
      child: Stack(
        children: widget.chunks.map((chunk) {
          final _chunkScheme = chunkScheme(chunk);
          final left =
              (chunk.startTotalMinutes / 60) * HorizontalTimeline.hourWidth;
          final width =
              ((chunk.endTotalMinutes - chunk.startTotalMinutes) / 60) *
              HorizontalTimeline.hourWidth;
          final isSelected = chunk == widget.selectedChunk;
          return Positioned(
            left: left,
            top: 36,
            width: width,
            height: 44,
            child: GestureDetector(
              onTap: () => widget.onChunkSelected(chunk),
              onLongPress: () => widget.onChunkLongPress(chunk),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? _chunkScheme.accent.withValues(alpha: 0.35)
                      : _chunkScheme.bg.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Text(
                      chunk.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    Spacer(),
                    Icon(_chunkScheme.icon, size: 18, color: Colors.black54),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
