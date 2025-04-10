import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioTrack {
  final String title;
  final String artist;
  final String imageUrl;
  final String audioUrl;

  AudioTrack({
    required this.title,
    required this.artist,
    required this.imageUrl,
    required this.audioUrl,
  });
}

class AudioProgressBar extends StatelessWidget {
  final AudioPlayer audioPlayer;

  const AudioProgressBar({super.key, required this.audioPlayer});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration?>(
      stream: audioPlayer.positionStream,
      builder: (context, snapshot) {
        final position = snapshot.data ?? Duration.zero;
        return StreamBuilder<Duration?>(
          stream: audioPlayer.durationStream,
          builder: (context, snapshot) {
            final duration = snapshot.data ?? Duration.zero;
            return Slider(
              value: position.inMilliseconds.toDouble(),
              min: 0,
              max: duration.inMilliseconds.toDouble(),
              onChanged: (value) {
                audioPlayer.seek(Duration(milliseconds: value.round()));
              },
            );
          },
        );
      },
    );
  }
}
