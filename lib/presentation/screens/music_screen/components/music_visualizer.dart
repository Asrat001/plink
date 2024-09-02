import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../gen/colors.gen.dart';

/// A widget that displays a visual representation of music playback.
///
/// The visualizer consists of a series of bars that animate based on the
/// current playback state.
class MusicVisualizer extends StatefulWidget {
  /// Whether the music is currently playing.
  final bool isPlaying;

  /// Creates a new instance of the `MusicVisualizer` widget.
  const MusicVisualizer({super.key, required this.isPlaying});

  @override
  State<MusicVisualizer> createState() => _MusicVisualizerState();
}

/// The state for the `MusicVisualizer` widget.
///
/// This state manages the animation of the visualizer bars.
class _MusicVisualizerState extends State<MusicVisualizer> {
  /// A random number generator used for generating random waveform values.
  final Random _random = Random();

  /// The current waveform data, represented as a list of integers.
  List<int> _waveform = List.generate(24, (index) => 0);

  /// Updates the visualizer with new random waveform data.
  ///
  /// This method generates a new list of random integers and updates the
  /// `_waveform` state variable. It then delays the next update by 100
  /// milliseconds.
  void _updateVisualizer() {
    Future.doWhile(() async {
      if (mounted) {
        setState(() {
          _waveform = List.generate(24, (index) => _random.nextInt(256));
        });
      }

      await Future.delayed(const Duration(milliseconds: 200));
      return true;
    });
  }

  @override
  void initState() {
    // Start updating the visualizer when the widget is initialized.
    _updateVisualizer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Use a CustomPaint widget to draw the visualizer bars.
        CustomPaint(
          painter: VisualizerPainter(
            // Pass the current waveform data, playback state, and other
            // customization options to the painter.
            waveform: _waveform,
            isPlaying: widget.isPlaying,
            backgroundColor: ColorName.foregroundColor,
          ),
          // Set the size of the visualizer.
          child: const SizedBox(
            width: double.infinity,
            height: 250,
          ),
        ),
      ],
    );
  }
}

/// A custom painter that draws the visualizer bars.
///
/// This painter takes the waveform data, playback state, and other
/// customization options as input and draws the visualizer bars on the canvas.
class VisualizerPainter extends CustomPainter {
  /// The current waveform data, represented as a list of integers.
  final List<int> waveform;

  /// Whether the music is currently playing.
  final bool isPlaying;

  /// The gap between the visualizer bars.
  final double barGap;

  /// The radius of the rounded corners of the visualizer bars.
  final double borderRadius;

  /// The background color of the visualizer.
  final Color backgroundColor;

  /// The smoothing factor for the animation of the visualizer bars.
  final double smoothingFactor;

  /// A list of previous heights for each bar, used for smoothing the animation.
  final List<double> _previousHeights;

  /// Creates a new instance of the `VisualizerPainter` class.
  VisualizerPainter({
    required this.waveform,
    required this.isPlaying,
    this.barGap = 0,
    this.borderRadius = 4.0,
    this.backgroundColor = Colors.black,
    this.smoothingFactor = 0.8,
  }) : _previousHeights = List.filled(waveform.length, 20);

  @override
  void paint(Canvas canvas, Size size) {
    // Only draw the visualizer if the music is playing.
    if (isPlaying) {
      // Draw the background of the visualizer.
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = backgroundColor,
      );

      // Calculate the width of each bar.
      final barWidth =
          (size.width - (waveform.length - 1) * barGap) / waveform.length;

      // Iterate over each bar in the waveform.
      for (int i = 0; i < waveform.length; i++) {
        // Calculate the target height of the bar based on the waveform data.
        final targetHeight = waveform[i] / 250.0 * size.height;

        // Smoothly interpolate between the previous height and the target height.
        _previousHeights[i] = _previousHeights[i] * (1 - smoothingFactor) +
            targetHeight * smoothingFactor;

        // Get the actual height of the bar after smoothing.
        final barHeight = _previousHeights[i];

        // Calculate the x-coordinate of the bar.
        final barX = i * (barWidth + barGap);

        // Set the color of the bar based on its position in the waveform.
        final paint = Paint()
          ..color = i < waveform.length / 2
              ? ColorName.primaryColor.shade500
              : ColorName.primaryColor.shade500
          ..style = PaintingStyle.fill;

        // Draw the bar with rounded corners.
        final barRect = RRect.fromRectAndRadius(
          Rect.fromLTWH(barX, size.height - barHeight, barWidth, barHeight),
          Radius.circular(borderRadius),
        );
        canvas.drawRRect(barRect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // Always repaint the visualizer when the waveform data or playback state
    // changes.
    return true;
  }
}
