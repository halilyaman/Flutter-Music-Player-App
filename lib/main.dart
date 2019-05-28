
import 'package:flutter/material.dart';
import 'package:music_player_app/bottom_controls.dart';
import 'package:music_player_app/radial_seek_bar.dart';
import 'package:music_player_app/songs.dart';
import 'package:music_player_app/theme.dart';
import 'package:fluttery_audio/fluttery_audio.dart';

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
    return AudioPlaylist(
      playlist: demoPlaylist.songs.map((DemoSong song) {
        return song.audioUrl;
      }).toList(growable: false),
      playbackState: PlaybackState.paused,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios
            ),
            color: const Color(0xFF2A7C9C),
            onPressed: (){},
          ),
          title: Text(""),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.menu
              ),
              color: const Color(0xFF2A7C9C),
              onPressed: (){},
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            // Seek bar
            new SeekBarControls(),

            // Visualizer
            Container(
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
            ),

            // Song title, artist name and controls
            new BottomControls(),
          ],
        ),
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
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0.0, 0.0, size.width, size.height),
      wavePaint
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}
