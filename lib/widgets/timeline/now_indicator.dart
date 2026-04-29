import 'package:flutter/material.dart';

class NowIndicator extends StatelessWidget {
  final double hourWidth;

  const NowIndicator({super.key, required this.hourWidth});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final x = (now.hour + now.minute / 60) * hourWidth;

    return Positioned(
      left: x,
      top: 0,
      bottom: 0,
      child: Container(width: 2, color: Colors.redAccent),
    );
  }
}
