
import 'package:flutter/material.dart';
import 'package:music_player_app/bottom_controls.dart';
import 'package:music_player_app/radial_seek_bar.dart';
import 'package:music_player_app/songs.dart';
import 'package:fluttery_audio/fluttery_audio.dart';
import 'package:music_player_app/theme.dart';
import 'package:music_player_app/visualizer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.brown,
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
          backgroundColor: lightAccentColor,
        ),
        drawer: Drawer(
          child: ListView(
            children: _renderMusicList(),
          ),
        ),
        body: Column(
          children: <Widget>[
            // Seek bar
            new SeekBarControls(),

            // Visualizer
            new MusicVisualizer(),

            // Song title, artist name and controls
            new BottomControls(),
          ],
        ),
      ),
    );
  }

  List<Widget> _renderMusicList() {

    List<AudioPlaylistComponent> musicList = new List<AudioPlaylistComponent>();

    for(int i = 0 ; i < demoPlaylist.songs.length; ++i) {
      musicList.add(
        AudioPlaylistComponent(
          playlistBuilder: (BuildContext context, Playlist playlist, Widget widget) {
            return ListTile(
              title: Text(demoPlaylist.songs[i].songTitle),
              subtitle: Text(demoPlaylist.songs[i].artist),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(demoPlaylist.songs[i].albumArtUrl),
              ),
              onTap: () {
              },
            );
          },
        )
      );
    }
    return musicList;
  }
}