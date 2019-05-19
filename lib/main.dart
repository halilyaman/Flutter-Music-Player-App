import 'dart:math';

import 'package:flutter/material.dart';
import 'package:music_player_app/bottom_controls.dart';
import 'package:music_player_app/songs.dart';
import 'package:music_player_app/theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios
          ),
          color: const Color(0xFFDDDDDD),
          onPressed: (){},
        ),
        title: Text(""),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.menu
            ),
            color: const Color(0xFFDDDDDD),
            onPressed: (){},
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          // Seek bar
          Expanded(
            child: Center(
              child: Container(
                height: 150.0,
                width: 150.0,
                child: RadialSeekBar(
                  trackColor: Color(0xFFDDDDDD),
                  progressPercent: 0.25,
                  progressColor: accentColor,
                  thumbPosition: 0.25,
                  thumbColor: lightAccentColor,
                  innerPadding: EdgeInsets.all(10.0),
                  child: ClipOval(
                    clipper: CircleClipper(),
                    child: Image.network(
                      demoPlaylist.songs[1].albumArtUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Visualizer
          Container(
            width: double.infinity,
            height: 125.0,
          ),

          // Song title, artist name and controls
          new BottomControls(),
        ],
      ),
    );
  }
}

class RadialSeekBar extends StatefulWidget {

  final double trackWidth;
  final Color trackColor;
  final double progressWidth;
  final Color progressColor;
  final double progressPercent;
  final double thumbSize;
  final Color thumbColor;
  final double thumbPosition;
  final EdgeInsets outerPadding;
  final EdgeInsets innerPadding;
  final Widget child;

  RadialSeekBar({
    @required this.child,
    this.progressPercent = 0.0,
    this.progressColor = Colors.black,
    this.progressWidth = 5.0,
    this.thumbPosition = 0.0,
    this.thumbColor = Colors.black,
    this.thumbSize = 12.0,
    this.trackColor = Colors.grey,
    this.trackWidth = 3.0,
    this.outerPadding = const EdgeInsets.all(0.0),
    this.innerPadding = const EdgeInsets.all(0.0),
  });

  @override
  _RadialSeekBarState createState() => _RadialSeekBarState();
}

class _RadialSeekBarState extends State<RadialSeekBar> {

  EdgeInsets _insetsForPainter() {

    final outerThickness = max(
      widget.thumbSize,
      max(
        widget.progressWidth,
        widget.trackWidth
      )
    ) / 2.0;

    return EdgeInsets.all(outerThickness);

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.outerPadding,
      child: CustomPaint(
        foregroundPainter: RadialSeekBarPainter(
          trackWidth: widget.trackWidth,
          trackColor: widget.trackColor,
          progressWidth: widget.progressWidth,
          progressColor: widget.progressColor,
          progressPercent: widget.progressPercent,
          thumbSize: widget.thumbSize,
          thumbColor: widget.thumbColor,
          thumbPosition: widget.thumbPosition,
        ),
        child: Padding(
          padding: _insetsForPainter() + widget.innerPadding,
          child: widget.child,
        ),
      ),
    );
  }
}

class RadialSeekBarPainter extends CustomPainter{

  final double trackWidth;
  final Paint trackPaint;
  final double progressWidth;
  final double progressPercent;
  final Paint progressPaint;
  final double thumbSize;
  final double thumbPosition;
  final Paint thumbPaint;

  RadialSeekBarPainter({
    @required this.progressPercent,
    @required progressColor,
    @required this.progressWidth,
    @required this.thumbPosition,
    @required thumbColor,
    @required this.thumbSize,
    @required trackColor,
    @required this.trackWidth,
  }) : trackPaint = Paint()
        ..color = trackColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = trackWidth,
       progressPaint = Paint()
        ..color = progressColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = progressWidth
        ..strokeCap = StrokeCap.round,
       thumbPaint = Paint()
        ..color = thumbColor
        ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {

    final outerThickness = max(trackWidth, max(progressWidth, thumbSize));
    Size constrainedSize = Size(
      size.width - outerThickness,
      size.height - outerThickness
    );

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(constrainedSize.width, constrainedSize.height) / 2;

    // Paint track.
    canvas.drawCircle(
      center,
      radius,
      trackPaint
    );

    // Paint progress.
    final progressAngle = 2 * pi * progressPercent;
    canvas.drawArc(
      Rect.fromCircle(
        center: center,
        radius: radius,
      ),
      -pi / 2,
      progressAngle,
      false,
      progressPaint
    );

    // Paint thumb.
    final thumbAngle = 2 * pi * thumbPosition - (pi / 2);
    final thumbX = cos(thumbAngle) * radius;
    final thumbY = sin(thumbAngle) * radius;
    final thumbCenter = Offset(thumbX, thumbY) + center;
    final thumbRadius = thumbSize / 2;
    canvas.drawCircle(
      thumbCenter,
      thumbRadius,
      thumbPaint
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {

    return true;
  }

}

class CircleClipper extends CustomClipper<Rect> {
  @override
  getClip(Size size) {
    return Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: min(size.width, size.height) / 2,
    );
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {

    return true;
  }

}
