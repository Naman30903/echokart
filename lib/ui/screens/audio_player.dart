import 'package:audioplayers/audioplayers.dart';
import 'package:echokart/bloc/audio_bloc.dart';
import 'package:echokart/bloc/audio_event.dart';
import 'package:echokart/data/models/audio_status.dart';
import 'package:echokart/data/models/audio_track.dart';
import 'package:echokart/ui/widgets/audioprogress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AudioPlayerScreen extends StatelessWidget {
  const AudioPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final audioBloc = AudioBloc(AudioPlayer());
        audioBloc.add(InitializePlayer());
        return audioBloc;
      },
      child: const _AudioPlayerView(),
    );
  }
}

class _AudioPlayerView extends StatelessWidget {
  const _AudioPlayerView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Player'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      ),
      body: BlocBuilder<AudioBloc, AudioState>(
        builder: (context, state) {
          if (state.status == AudioStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }

          final audioBloc = context.read<AudioBloc>();
          final AudioTrack currentTrack = state.currentTrack;

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).colorScheme.surfaceVariant,
                  Theme.of(context).colorScheme.background,
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                // Album art with favorite button
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          currentTrack.imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            currentTrack.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color:
                                currentTrack.isFavorite
                                    ? Colors.red
                                    : Colors.white,
                          ),
                          onPressed: () {
                            context.read<AudioBloc>().add(
                              ToggleFavorite(state.currentTrackIndex),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Track title and artist
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Text(
                        currentTrack.title,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currentTrack.artist,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: Colors.grey.shade600),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Progress bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: AudioProgressBar(audioPlayer: audioBloc.audioPlayer),
                ),
                const SizedBox(height: 24),
                // Playback controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.skip_previous, size: 32),
                      onPressed:
                          state.canPlayPrevious
                              ? () => audioBloc.add(PreviousTrack())
                              : null,
                    ),
                    const SizedBox(width: 16),
                    _buildPlaybackButton(context, state),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.skip_next, size: 32),
                      onPressed:
                          state.canPlayNext
                              ? () => audioBloc.add(NextTrack())
                              : null,
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlaybackButton(BuildContext context, AudioState state) {
    final audioBloc = context.read<AudioBloc>();

    if (state.status == AudioStatus.loading) {
      return Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      );
    } else if (state.status == AudioStatus.playing) {
      return IconButton(
        icon: const Icon(Icons.pause),
        iconSize: 64,
        color: Colors.white,
        style: IconButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          padding: EdgeInsets.zero,
        ),
        onPressed: () => audioBloc.add(PauseAudio()),
      );
    } else if (state.status == AudioStatus.paused ||
        state.status == AudioStatus.initial) {
      return IconButton(
        icon: const Icon(Icons.play_arrow),
        iconSize: 64,
        color: Colors.white,
        style: IconButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          padding: EdgeInsets.zero,
        ),
        onPressed: () => audioBloc.add(PlayAudio()),
      );
    } else {
      return IconButton(
        icon: const Icon(Icons.replay),
        iconSize: 64,
        color: Colors.white,
        style: IconButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          padding: EdgeInsets.zero,
        ),
        onPressed: () {
          audioBloc.add(const SeekAudio(Duration.zero));
          audioBloc.add(PlayAudio());
        },
      );
    }
  }
}
