// import 'package:audioplayers/audioplayers.dart';
// import 'package:echokart/data/models/audio_track.dart';
// import 'package:flutter/material.dart';

// class AudioPlayerScreen extends StatefulWidget {
//   const AudioPlayerScreen({super.key});

//   @override
//   State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
// }

// class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   bool _isPlayerInitialized = false;
//   final List<AudioTrack> _tracks = [
//     AudioTrack(
//       title: "Forest Birds",
//       artist: "Nature Sounds",
//       imageUrl: "https://images.unsplash.com/photo-1506744038136-46273834b3fb",
//       audioUrl: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
//     ),
//     AudioTrack(
//       title: "Ocean Waves",
//       artist: "Relaxing Sounds",
//       imageUrl: "https://images.unsplash.com/photo-1505144808419-1957a94ca61e",
//       audioUrl: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3",
//     ),
//     AudioTrack(
//       title: "Gentle Rain",
//       artist: "Sleep Sounds",
//       imageUrl: "https://images.unsplash.com/photo-1468476396571-4d6f2a427ee7",
//       audioUrl: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3",
//     ),
//   ];
//   int _currentTrackIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     _initPlayer();
//   }

//   Future<void> _initPlayer() async {
//     await _audioPlayer.setUrl(_tracks[_currentTrackIndex].audioUrl);
//     setState(() {
//       _isPlayerInitialized = true;
//     });
//   }

//   void _playNextTrack() {
//     if (_currentTrackIndex < _tracks.length - 1) {
//       setState(() {
//         _currentTrackIndex++;
//       });
//       _audioPlayer.setUrl(_tracks[_currentTrackIndex].audioUrl);
//     }
//   }

//   void _playPreviousTrack() {
//     if (_currentTrackIndex > 0) {
//       setState(() {
//         _currentTrackIndex--;
//       });
//       _audioPlayer.setUrl(_tracks[_currentTrackIndex].audioUrl);
//     }
//   }

//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     AudioTrack currentTrack = _tracks[_currentTrackIndex];

//     return Scaffold(
//       appBar: AppBar(title: const Text('Audio Player'), elevation: 0),
//       body:
//           _isPlayerInitialized
//               ? Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const Spacer(),
//                   Container(
//                     width: 280,
//                     height: 280,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.2),
//                           blurRadius: 20,
//                           spreadRadius: 5,
//                         ),
//                       ],
//                     ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(20),
//                       child: Image.network(
//                         currentTrack.imageUrl,
//                         fit: BoxFit.cover,
//                         loadingBuilder: (context, child, loadingProgress) {
//                           if (loadingProgress == null) return child;
//                           return Center(
//                             child: CircularProgressIndicator(
//                               value:
//                                   loadingProgress.expectedTotalBytes != null
//                                       ? loadingProgress.cumulativeBytesLoaded /
//                                           loadingProgress.expectedTotalBytes!
//                                       : null,
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 32),
//                   Text(
//                     currentTrack.title,
//                     style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                       fontWeight: FontWeight.bold,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     currentTrack.artist,
//                     style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                       color: Colors.grey.shade600,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 32),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 24),
//                     child: AudioProgressBar(audioPlayer: _audioPlayer),
//                   ),
//                   const SizedBox(height: 24),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.skip_previous, size: 32),
//                         onPressed:
//                             _currentTrackIndex > 0 ? _playPreviousTrack : null,
//                       ),
//                       const SizedBox(width: 16),
//                       StreamBuilder<PlayerState>(
//                         stream: _audioPlayer.playerStateStream,
//                         builder: (context, snapshot) {
//                           final playerState = snapshot.data;
//                           final processingState = playerState?.processingState;
//                           final playing = playerState?.playing;

//                           if (processingState == ProcessingState.loading ||
//                               processingState == ProcessingState.buffering) {
//                             return Container(
//                               width: 64,
//                               height: 64,
//                               decoration: BoxDecoration(
//                                 color: Theme.of(context).primaryColor,
//                                 shape: BoxShape.circle,
//                               ),
//                               child: const Center(
//                                 child: CircularProgressIndicator(
//                                   valueColor: AlwaysStoppedAnimation<Color>(
//                                     Colors.white,
//                                   ),
//                                 ),
//                               ),
//                             );
//                           } else if (playing != true) {
//                             return IconButton(
//                               icon: const Icon(Icons.play_arrow),
//                               iconSize: 64,
//                               color: Colors.white,
//                               style: IconButton.styleFrom(
//                                 backgroundColor: Theme.of(context).primaryColor,
//                                 padding: EdgeInsets.zero,
//                               ),
//                               onPressed: _audioPlayer.play,
//                             );
//                           } else if (processingState !=
//                               ProcessingState.completed) {
//                             return IconButton(
//                               icon: const Icon(Icons.pause),
//                               iconSize: 64,
//                               color: Colors.white,
//                               style: IconButton.styleFrom(
//                                 backgroundColor: Theme.of(context).primaryColor,
//                                 padding: EdgeInsets.zero,
//                               ),
//                               onPressed: _audioPlayer.pause,
//                             );
//                           } else {
//                             return IconButton(
//                               icon: const Icon(Icons.replay),
//                               iconSize: 64,
//                               color: Colors.white,
//                               style: IconButton.styleFrom(
//                                 backgroundColor: Theme.of(context).primaryColor,
//                                 padding: EdgeInsets.zero,
//                               ),
//                               onPressed: () => _audioPlayer.seek(Duration.zero),
//                             );
//                           }
//                         },
//                       ),
//                       const SizedBox(width: 16),
//                       IconButton(
//                         icon: const Icon(Icons.skip_next, size: 32),
//                         onPressed:
//                             _currentTrackIndex < _tracks.length - 1
//                                 ? _playNextTrack
//                                 : null,
//                       ),
//                     ],
//                   ),
//                   const Spacer(),
//                 ],
//               )
//               : const Center(child: CircularProgressIndicator()),
//     );
//   }
// }
