import 'package:equatable/equatable.dart';
import 'package:echokart/data/models/audio_track.dart';

enum AudioStatus { initial, loading, playing, paused, completed, error }

class AudioState extends Equatable {
  final List<AudioTrack> tracks;
  final int currentTrackIndex;
  final AudioStatus status;
  final Duration position;
  final Duration duration;
  final String? errorMessage;

  const AudioState({
    required this.tracks,
    this.currentTrackIndex = 0,
    this.status = AudioStatus.initial,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.errorMessage,
  });

  AudioTrack get currentTrack => tracks[currentTrackIndex];

  bool get canPlayPrevious => currentTrackIndex > 0;

  bool get canPlayNext => currentTrackIndex < tracks.length - 1;

  AudioState copyWith({
    List<AudioTrack>? tracks,
    int? currentTrackIndex,
    AudioStatus? status,
    Duration? position,
    Duration? duration,
    String? errorMessage,
  }) {
    return AudioState(
      tracks: tracks ?? this.tracks,
      currentTrackIndex: currentTrackIndex ?? this.currentTrackIndex,
      status: status ?? this.status,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    tracks,
    currentTrackIndex,
    status,
    position,
    duration,
    errorMessage,
  ];
}
