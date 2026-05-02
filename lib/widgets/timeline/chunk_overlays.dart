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
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24 * HorizontalTimeline.hourWidth,
      height: HorizontalTimeline.timelineHeight,
      child: Stack(
        children: widget.chunks.expand((chunk) {
          final scheme = chunkScheme(chunk);
          final isSelected = chunk == widget.selectedChunk;

          final startMinutes = chunk.startTotalMinutes;
          var endMinutes = chunk.endTotalMinutes;
          final isOvernight = endMinutes <= startMinutes;

          // For overnight chunks, extend end past midnight
          if (isOvernight) endMinutes += 24 * 60;

          final left = (startMinutes / 60) * HorizontalTimeline.hourWidth;
          final rawWidth =
              ((endMinutes - startMinutes) / 60) * HorizontalTimeline.hourWidth;

          // Clamp width to edge of the 24h timeline
          final maxWidth = (24 * HorizontalTimeline.hourWidth) - left;
          final width = rawWidth.clamp(0.0, maxWidth);

          final mainSegment = Positioned(
            left: left,
            top: 36,
            width: width,
            height: 44,
            child: _ChunkTile(
              chunk: chunk,
              scheme: scheme,
              isSelected: isSelected,
              isOvernight: isOvernight,
              onTap: () => widget.onChunkSelected(chunk),
              onLongPress: () => widget.onChunkLongPress(chunk),
            ),
          );

          // For overnight chunks also render the bleed segment at hour 0
          if (isOvernight) {
            final bleedMinutes = endMinutes - 24 * 60; // original endMinutes
            final bleedWidth =
                (bleedMinutes / 60) * HorizontalTimeline.hourWidth;

            final bleedSegment = Positioned(
              left: 0,
              top: 36,
              width: bleedWidth.clamp(0.0, 24 * HorizontalTimeline.hourWidth),
              height: 44,
              child: _ChunkTile(
                chunk: chunk,
                scheme: scheme,
                isSelected: isSelected,
                isOvernight: true,
                isContinuation: true,
                onTap: () => widget.onChunkSelected(chunk),
                onLongPress: () => widget.onChunkLongPress(chunk),
              ),
            );

            return [mainSegment, bleedSegment];
          }

          return [mainSegment];
        }).toList(),
      ),
    );
  }
}

class _ChunkTile extends StatelessWidget {
  final Chunk chunk;
  final ({Color bg, Color accent, IconData icon, String label}) scheme;
  final bool isSelected;
  final bool isOvernight;
  final bool isContinuation;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _ChunkTile({
    required this.chunk,
    required this.scheme,
    required this.isSelected,
    required this.isOvernight,
    required this.onTap,
    required this.onLongPress,
    this.isContinuation = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? scheme.accent.withValues(alpha: 0.35)
              : scheme.bg.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(6),
          border: isOvernight
              ? Border.all(
                  color: Colors.indigo.withValues(alpha: 0.4),
                  width: 1,
                )
              : null,
        ),
        child: Row(
          children: [
            if (isContinuation)
              Icon(Icons.arrow_back, size: 12, color: Colors.indigo.shade300),
            Expanded(
              child: Text(
                chunk.name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ),
            const Spacer(),
            if (isOvernight && !isContinuation)
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Icon(
                  Icons.nightlight_round,
                  size: 12,
                  color: Colors.indigo.shade300,
                ),
              ),
            Icon(scheme.icon, size: 18, color: Colors.black54),
          ],
        ),
      ),
    );
  }
}
