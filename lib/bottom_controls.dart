
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttery_audio/fluttery_audio.dart';
import 'package:music_player_app/songs.dart';
import 'package:music_player_app/theme.dart';

class BottomControls extends StatelessWidget {
  final int activeSoundIndex;
  final Function increaseSoundIndex;
  final Function decreaseSoundIndex;

  BottomControls({
    Key key,
    this.activeSoundIndex,
    this.increaseSoundIndex,
    this.decreaseSoundIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Material(
        shadowColor: const Color(0x44000000),
        color: accentColor,
        child: Padding(
          padding: const EdgeInsets.only(top: 40.0, bottom: 50.0),
          child: Column(
            children: <Widget>[
              AudioPlaylistComponent(
                playlistBuilder: (BuildContext context, Playlist playlist, Widget child) {
                  final String songTitle = demoPlaylist.songs[playlist.activeIndex].songTitle;
                  final String artist = demoPlaylist.songs[playlist.activeIndex].artist;

                  return RichText(
                    text: TextSpan(
                      text: '',
                      children: [
                        TextSpan(
                          text: '${activeSoundIndex != null ?
                                    demoPlaylist.songs[activeSoundIndex].songTitle.toUpperCase() :
                                    songTitle}\n',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4.0,
                            height: 1.5
                          )
                        ),
                        TextSpan(
                          text: '${activeSoundIndex != null ?
                                    demoPlaylist.songs[activeSoundIndex].artist :
                                    artist}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.75),
                            fontSize: 12.0,
                            letterSpacing: 3.0,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 34.6),
                child: Row(
                  children: <Widget>[
                    Expanded(child: Container(),),

                    new PreviousButton(
                      decreaseSoundIndex: decreaseSoundIndex,
                      activeSoundIndex: activeSoundIndex
                    ),

                    Expanded(child: Container(),),

                    new PlayPauseButton(),

                    Expanded(child: Container(),),

                    new NextButton(
                      increaseSoundIndex: increaseSoundIndex,
                      activeSoundIndex: activeSoundIndex
                    ),

                    Expanded(child: Container(),),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlayPauseButton extends StatelessWidget {
  const PlayPauseButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AudioComponent(
      updateMe: [
        WatchableAudioProperties.audioPlayerState,
      ],
      playerBuilder: (BuildContext context, AudioPlayer player, Widget child) {

        IconData icon = Icons.music_note;
        Color buttonColor = lightAccentColor;
        Function onPressed;

        if(player.state == AudioPlayerState.playing) {
          icon = Icons.pause;
          onPressed = player.pause;
          buttonColor = Colors.white;
        } else if (player.state == AudioPlayerState.paused
          || player.state == AudioPlayerState.completed) {
          icon = Icons.play_arrow;
          onPressed = player.play;
          buttonColor = Colors.white;
        }

        return RawMaterialButton(
          shape: CircleBorder(),
          fillColor: buttonColor ,
          splashColor: accentColor,
          highlightColor: accentColor.withOpacity(0.5),
          elevation: 10.0,
          highlightElevation: 5.0,
          onPressed: onPressed,
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Icon(
              icon,
              color: darkAccentColor,
              size: 35,
            ),
          ),
        );
      },
    );
  }
}

class PreviousButton extends StatelessWidget {
  final Function decreaseSoundIndex;
  final int activeSoundIndex;

  const PreviousButton({
    Key key,
    this.decreaseSoundIndex,
    this.activeSoundIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AudioPlaylistComponent(
      playlistBuilder: (BuildContext context, Playlist playlist, Widget child) {
        return IconButton(
          splashColor: lightAccentColor,
          highlightColor: Colors.transparent,
          icon: Icon(
            Icons.skip_previous,
            color: Colors.white,
            size: 35.0,
          ),
          onPressed: () {
            if(activeSoundIndex == null) {
              playlist.previous();
            } else {
              decreaseSoundIndex();
              playlist.audioPlayer.loadMedia(Uri.parse(demoPlaylist.songs[activeSoundIndex-1].audioUrl));
            }
          },
        );
      },
    );
  }
}

class NextButton extends StatelessWidget {
  final Function increaseSoundIndex;
  final int activeSoundIndex;

  NextButton({
    Key key,
    this.increaseSoundIndex,
    this.activeSoundIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AudioPlaylistComponent(
      playlistBuilder: (BuildContext context, Playlist playlist, Widget child) {
        return IconButton(
          splashColor: lightAccentColor,
          highlightColor: Colors.transparent,
          icon: Icon(
            Icons.skip_next,
            color: Colors.white,
            size: 35.0,
          ),
          onPressed: () {
            if(activeSoundIndex == null) {
              playlist.next();
            } else {
              increaseSoundIndex();
              playlist.audioPlayer.loadMedia(Uri.parse(demoPlaylist.songs[activeSoundIndex+1].audioUrl));
            }
          },
        );
      },
    );
  }
}
