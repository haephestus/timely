import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:timely_app/models/chunk.dart';
import 'package:timely_app/screens/chunk_manager.dart';
import 'package:timely_app/widgets/timeline/hour_rail.dart';
import 'package:timely_app/widgets/timeline/chunk_overlays.dart';
import 'package:timely_app/widgets/timeline/now_indicator.dart';

class HorizontalTimeline extends StatefulWidget {
  final List<Chunk> chunks;
  final Chunk? selectedChunk;
  final ValueChanged<Chunk> onChunkSelected;

  const HorizontalTimeline({
    super.key,
    required this.chunks,
    required this.selectedChunk,
    required this.onChunkSelected,
  });

  static const double hourWidth = 120;
  static const double timelineHeight = 96;

  @override
  State<HorizontalTimeline> createState() => _HorizontalTimelineState();
}

class _HorizontalTimelineState extends State<HorizontalTimeline> {
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
      _scrollToNow();
    });
  }

  void _scrollToNow() {
    final offset = _nowOffset() - (MediaQuery.of(context).size.width / 2);

    _scrollController.jumpTo(
      offset.clamp(0.0, _scrollController.position.maxScrollExtent),
    );
  }

  void _openChunkManager() async {
    final result = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ChunkManager()));

    if (result == true && mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: HorizontalTimeline.timelineHeight,
      child: GestureDetector(
        onLongPress: _openChunkManager,
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
