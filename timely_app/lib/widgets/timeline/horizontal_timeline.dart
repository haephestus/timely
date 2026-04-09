import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:timely/models/chunk.dart';
import 'package:timely/widgets/timeline/hour_rail.dart';
import 'package:timely/widgets/timeline/chunk_overlays.dart';
import 'package:timely/widgets/timeline/now_indicator.dart';

class HorizontalTimeline extends StatefulWidget {
  final List<Chunk> chunks;
  final Chunk? selectedChunk;
  final VoidCallback onLongPress;
  final ValueChanged<Chunk> onChunkSelected;
  final ValueChanged<Chunk> onChunkLongPress;

  const HorizontalTimeline({
    super.key,
    required this.chunks,
    required this.selectedChunk,
    required this.onLongPress,
    required this.onChunkSelected,
    required this.onChunkLongPress,
  });

  static const double hourWidth = 120.0;
  static const double timelineHeight = 84;

  @override
  HorizontalTimelineState createState() => HorizontalTimelineState();
}

class HorizontalTimelineState extends State<HorizontalTimeline> {
  final ScrollController _scrollController = ScrollController();

  double _nowOffset() {
    final now = DateTime.now();
    final hours = now.hour + now.minute / 60;
    return hours * HorizontalTimeline.hourWidth;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToNow();
    });
  }

  void scrollToNow() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      final offset = _nowOffset() - (MediaQuery.of(context).size.width / 2);
      _scrollController.animateTo(
        offset.clamp(0.0, _scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: HorizontalTimeline.timelineHeight,
      child: GestureDetector(
        onLongPress: widget.onLongPress,
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            scrollbars: true,
            dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
              PointerDeviceKind.trackpad,
              PointerDeviceKind.stylus,
            },
          ),
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 24 * HorizontalTimeline.hourWidth,
              height: HorizontalTimeline.timelineHeight,
              child: Stack(
                children: [
                  const HourRail(),
                  ChunkOverlays(
                    chunks: widget.chunks,
                    selectedChunk: widget.selectedChunk,
                    onChunkSelected: widget.onChunkSelected,
                    onChunkLongPress: widget.onChunkLongPress,
                  ),
                  NowIndicator(hourWidth: HorizontalTimeline.hourWidth),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
