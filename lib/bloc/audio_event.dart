import 'package:equatable/equatable.dart';
import 'package:echokart/data/models/audio_track.dart';

abstract class AudioEvent extends Equatable {
  const AudioEvent();

  @override
  List<Object> get props => [];
}

class InitializePlayer extends AudioEvent {}

class PlayAudio extends AudioEvent {}

class PauseAudio extends AudioEvent {}

class NextTrack extends AudioEvent {}

class PreviousTrack extends AudioEvent {}

class SeekAudio extends AudioEvent {
  final Duration position;

  const SeekAudio(this.position);

  @override
  List<Object> get props => [position];
}

class ToggleFavorite extends AudioEvent {
  final int trackIndex;

  const ToggleFavorite(this.trackIndex);

  @override
  List<Object> get props => [trackIndex];
}

class UpdatePlaybackStatus extends AudioEvent {
  final bool isPlaying;

  const UpdatePlaybackStatus(this.isPlaying);

  @override
  List<Object> get props => [isPlaying];
}
