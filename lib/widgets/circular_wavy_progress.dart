import 'package:flutter/material.dart';

class CircularWavyProgressIndicator extends StatefulWidget {
  final double progress;
  final Color color;
  final Color trackColor;
  final double strokeWidth;

  const CircularWavyProgressIndicator({
    super.key,
    required this.progress,
    this.color = Colors.amber,
    this.trackColor = Colors.grey,
    this.strokeWidth = 4.0,
    double? trackStrokeWidth,
    double? amplitude,
    double? wavelength,
    double? waveSpeed,
  });

  @override
  State<CircularWavyProgressIndicator> createState() =>
      _CircularWavyProgressIndicatorState();
}

class _CircularWavyProgressIndicatorState
    extends State<CircularWavyProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      value: widget.progress.clamp(0.0, 1.0),
      color: widget.color,
      backgroundColor: widget.trackColor,
      strokeWidth: widget.strokeWidth,
    );
  }
}

