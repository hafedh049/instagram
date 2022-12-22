import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

Color bgColor = Colors.black;
AssetsAudioPlayer player = AssetsAudioPlayer.newPlayer();
void play(String state) {
  player.open(
    Audio(
      "assets/${state == 'message' ? 'message' : 'notification'}.mp3",
    ),
    volume: 100,
  );
}
