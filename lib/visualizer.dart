import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttery_audio/fluttery_audio.dart';
import 'package:music_player_app/theme.dart';

class MusicVisualizer extends StatelessWidget {
  const MusicVisualizer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 125.0,
      child: Visualizer(
        builder: (BuildContext context, List<int> fft) {
          return CustomPaint(
            painter: VisualizerPainter(
              fft: fft,
              height: 125.0,
              color: accentColor
            ),
            child: Container(),
          );
        },
      ),
    );
  }
}

class VisualizerPainter extends CustomPainter{
  final List<int> fft;
  final double height;
  final Color color;
  final Paint wavePaint;

  VisualizerPainter({
    this.fft,
    this.height,
    this.color,
  }) : wavePaint = Paint()
    ..color = color.withOpacity(0.75)
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) async {
    await _renderWaves(canvas, size);
  }

  Future<void> _renderWaves(Canvas canvas, Size size) {
    final histogramLow = _createHistogram(fft, 15, 2, ((fft.length) / 4).floor());
    final histogramHigh = _createHistogram(fft, 15, (fft.length / 4).ceil(), (fft.length / 2).floor());

    _renderHistogram(canvas, size, histogramLow);
    _renderHistogram(canvas, size, histogramHigh);
    sleep(Duration(milliseconds: 1));
    return null;
  }

  void _renderHistogram(Canvas canvas, Size size, List<int> histogram) {
    if(histogram.length == 0) {
      return;
    }

    final pointsToGraph = histogram.length;
    final widthPerSample = (size.width / (pointsToGraph - 2)).floor();
    final points = new List<double>.filled(pointsToGraph * 4, 0.0);

    for(int i = 0; i < histogram.length - 1; ++i) {
      points[i * 4] = (i * widthPerSample).toDouble();
      points[i * 4 + 1] = size.height - histogram[i].toDouble();

      points[i * 4 + 2] = ((i + 1) * widthPerSample).toDouble();
      points[i * 4 + 3] = size.height - histogram[i + 1].toDouble();
    }

    Path path = new Path();
    path.moveTo(0.0, size.height);
    path.lineTo(points[0], points[1]);
    for(int i = 2; i < points.length - 4; i += 2) {
      path.cubicTo(
        points[i - 2] + 10.0, points[i - 1],
        points[i] - 10.0, points[i + 1],
        points[i], points[i + 1]
      );
    }

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, wavePaint);
  }

  List<int> _createHistogram(List<int> samples, int bucketCount, [int start, int end]) {
    if(start == end) {
      return null;
    }

    start = start ?? 0;
    end = end ?? samples.length - 1;
    final sampleCount = end - start + 1;
    final samplesPerBucket = (sampleCount / bucketCount).floor();
    if(samplesPerBucket == 0) {
      return const [];
    }

    final actualSampleCount = sampleCount - (sampleCount % samplesPerBucket);
    List<int> histogram = new List<int>.filled(bucketCount, 0);

    // Add up the frequency amounts for each bucket.
    for(int i = start; i <= start + actualSampleCount; ++i) {
      // Ignore the imaginary half of each FFT sample
      if((i - start) % 2 == 1) {
        continue;
      }

      int bucketIndex = ((i - start) / samplesPerBucket).floor();
      histogram[bucketIndex] += samples[i];
    }

    // Massage the data for visualization
    for(var i = 0; i < histogram.length; ++i) {
      histogram[i] = (histogram[i] / samplesPerBucket).abs().round();
    }

    return histogram;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}