class AudioTrack {
  final String title;
  final String artist;
  final String imageUrl;
  final String audioPath;
  final bool isAsset; // Flag to indicate if audio is from assets
  bool isFavorite;

  AudioTrack({
    required this.title,
    required this.artist,
    required this.imageUrl,
    required this.audioPath,
    this.isAsset = true, // Default to true for assets
    this.isFavorite = false,
  });

  AudioTrack copyWith({
    String? title,
    String? artist,
    String? imageUrl,
    String? audioPath,
    bool? isAsset,
    bool? isFavorite,
  }) {
    return AudioTrack(
      title: title ?? this.title,
      artist: artist ?? this.artist,
      imageUrl: imageUrl ?? this.imageUrl,
      audioPath: audioPath ?? this.audioPath,
      isAsset: isAsset ?? this.isAsset,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
