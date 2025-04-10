import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:audioplayers/audioplayers.dart' as audio_lib;
import 'package:echokart/bloc/audio_event.dart';
import 'package:echokart/data/models/audio_status.dart';
import 'package:echokart/data/models/audio_track.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  final audio_lib.AudioPlayer audioPlayer;
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;

  AudioBloc(this.audioPlayer)
    : super(
        AudioState(
          tracks: [
            AudioTrack(
              title: "Forest Birds",
              artist: "Nature Sounds",
              imageUrl:
                  "https://images.unsplash.com/photo-1506744038136-46273834b3fb",
              audioPath: "audio/forest_birds.mp3",
              isAsset: true,
            ),
            AudioTrack(
              title: "Ocean Waves",
              artist: "Relaxing Sounds",
              imageUrl:
                  "https://images.unsplash.com/photo-1505144808419-1957a94ca61e",
              audioPath: "audio/ocean_waves.mp3", // Asset path
              isAsset: true,
            ),
            AudioTrack(
              title: "Gentle Rain",
              artist: "Sleep Sounds",
              imageUrl:
                  "https://images.unsplash.com/photo-1468476396571-4d6f2a427ee7",
              audioPath: "audio/gentle_rain.mp3", // Asset path
              isAsset: true,
            ),
          ],
        ),
      ) {
    on<InitializePlayer>(_onInitializePlayer);
    on<PlayAudio>(_onPlayAudio);
    on<PauseAudio>(_onPauseAudio);
    on<NextTrack>(_onNextTrack);
    on<PreviousTrack>(_onPreviousTrack);
    on<SeekAudio>(_onSeekAudio);
    on<ToggleFavorite>(_onToggleFavorite);
    on<UpdatePlaybackStatus>(_onUpdatePlaybackStatus);

    _listenToPlayerChanges();
  }

  void _listenToPlayerChanges() {
    _playerStateSubscription = audioPlayer.onPlayerStateChanged.listen((
      audio_lib.PlayerState state,
    ) {
      if (state == audio_lib.PlayerState.playing) {
        add(const UpdatePlaybackStatus(true));
      } else {
        add(const UpdatePlaybackStatus(false));
      }
    });

    _positionSubscription = audioPlayer.onPositionChanged.listen((
      Duration position,
    ) {
      emit(state.copyWith(position: position));
    });

    _durationSubscription = audioPlayer.onDurationChanged.listen((
      Duration duration,
    ) {
      emit(state.copyWith(duration: duration));
    });
  }

  Future<void> _onInitializePlayer(
    InitializePlayer event,
    Emitter<AudioState> emit,
  ) async {
    emit(state.copyWith(status: AudioStatus.loading));

    try {
      final currentTrack = state.currentTrack;
      if (currentTrack.isAsset) {
        // Play from asset
        await audioPlayer.setSource(
          audio_lib.AssetSource(currentTrack.audioPath),
        );
      } else {
        // Play from URL
        await audioPlayer.setSource(
          audio_lib.UrlSource(currentTrack.audioPath),
        );
      }
      emit(state.copyWith(status: AudioStatus.paused));
    } catch (error) {
      emit(
        state.copyWith(
          status: AudioStatus.error,
          errorMessage: 'Failed to initialize player: $error',
        ),
      );
    }
  }

  Future<void> _onPlayAudio(PlayAudio event, Emitter<AudioState> emit) async {
    try {
      final currentTrack = state.currentTrack;
      if (currentTrack.isAsset) {
        await audioPlayer.play(audio_lib.AssetSource(currentTrack.audioPath));
      } else {
        await audioPlayer.play(audio_lib.UrlSource(currentTrack.audioPath));
      }
      emit(state.copyWith(status: AudioStatus.playing));
    } catch (error) {
      emit(
        state.copyWith(
          status: AudioStatus.error,
          errorMessage: 'Failed to play audio: $error',
        ),
      );
    }
  }

  Future<void> _onPauseAudio(PauseAudio event, Emitter<AudioState> emit) async {
    try {
      await audioPlayer.pause();
      emit(state.copyWith(status: AudioStatus.paused));
    } catch (error) {
      emit(
        state.copyWith(
          status: AudioStatus.error,
          errorMessage: 'Failed to pause audio: $error',
        ),
      );
    }
  }

  Future<void> _onNextTrack(NextTrack event, Emitter<AudioState> emit) async {
    if (!state.canPlayNext) return;

    final nextTrackIndex = state.currentTrackIndex + 1;
    emit(
      state.copyWith(
        currentTrackIndex: nextTrackIndex,
        status: AudioStatus.loading,
      ),
    );

    try {
      await audioPlayer.stop();
      final nextTrack = state.currentTrack;
      if (nextTrack.isAsset) {
        await audioPlayer.play(audio_lib.AssetSource(nextTrack.audioPath));
      } else {
        await audioPlayer.play(audio_lib.UrlSource(nextTrack.audioPath));
      }
      emit(state.copyWith(status: AudioStatus.playing));
    } catch (error) {
      emit(
        state.copyWith(
          status: AudioStatus.error,
          errorMessage: 'Failed to play next track: $error',
        ),
      );
    }
  }

  Future<void> _onPreviousTrack(
    PreviousTrack event,
    Emitter<AudioState> emit,
  ) async {
    if (!state.canPlayPrevious) return;

    final prevTrackIndex = state.currentTrackIndex - 1;
    emit(
      state.copyWith(
        currentTrackIndex: prevTrackIndex,
        status: AudioStatus.loading,
      ),
    );

    try {
      await audioPlayer.stop();
      final prevTrack = state.currentTrack;
      if (prevTrack.isAsset) {
        await audioPlayer.play(audio_lib.AssetSource(prevTrack.audioPath));
      } else {
        await audioPlayer.play(audio_lib.UrlSource(prevTrack.audioPath));
      }
      emit(state.copyWith(status: AudioStatus.playing));
    } catch (error) {
      emit(
        state.copyWith(
          status: AudioStatus.error,
          errorMessage: 'Failed to play previous track: $error',
        ),
      );
    }
  }

  Future<void> _onSeekAudio(SeekAudio event, Emitter<AudioState> emit) async {
    try {
      await audioPlayer.seek(event.position);
      emit(state.copyWith(position: event.position));
    } catch (error) {
      emit(
        state.copyWith(
          status: AudioStatus.error,
          errorMessage: 'Failed to seek audio: $error',
        ),
      );
    }
  }

  void _onToggleFavorite(ToggleFavorite event, Emitter<AudioState> emit) {
    final updatedTracks = List<AudioTrack>.from(state.tracks);
    final trackToUpdate = updatedTracks[event.trackIndex];
    updatedTracks[event.trackIndex] = trackToUpdate.copyWith(
      isFavorite: !trackToUpdate.isFavorite,
    );

    emit(state.copyWith(tracks: updatedTracks));
  }

  void _onUpdatePlaybackStatus(
    UpdatePlaybackStatus event,
    Emitter<AudioState> emit,
  ) {
    final newStatus =
        event.isPlaying ? AudioStatus.playing : AudioStatus.paused;
    emit(state.copyWith(status: newStatus));
  }

  @override
  Future<void> close() {
    _playerStateSubscription?.cancel();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    audioPlayer.dispose();
    return super.close();
  }
}
