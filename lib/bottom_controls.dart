
import 'package:flutter/material.dart';
import 'package:fluttery_audio/fluttery_audio.dart';
import 'package:music_player_app/theme.dart';

class BottomControls extends StatelessWidget {
  const BottomControls({
    Key key,
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
              RichText(
                text: TextSpan(
                  text: '',
                  children: [
                    TextSpan(
                      text: 'Song Title\n',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4.0,
                        height: 1.5
                      )
                    ),
                    TextSpan(
                      text: 'Artist Name',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.75),
                        fontSize: 12.0,
                        letterSpacing: 3.0,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 34.6),
                child: Row(
                  children: <Widget>[
                    Expanded(child: Container(),),

                    new PreviousButton(),

                    Expanded(child: Container(),),

                    new PlayPauseButton(),

                    Expanded(child: Container(),),

                    new NextButton(),

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
  const PreviousButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashColor: lightAccentColor,
      highlightColor: Colors.transparent,
      icon: Icon(
        Icons.skip_previous,
        color: Colors.white,
        size: 35.0,
      ),
      onPressed: () {

        // TODO: previous music

      },
    );
  }
}

class NextButton extends StatelessWidget {
  const NextButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashColor: lightAccentColor,
      highlightColor: Colors.transparent,
      icon: Icon(
        Icons.skip_next,
        color: Colors.white,
        size: 35.0,
      ),
      onPressed: () {

        // TODO: next music

      },
    );
  }
}