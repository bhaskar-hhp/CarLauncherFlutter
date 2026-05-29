class MediaState {
  final String title;
  final String artist;
  final String? albumArtUrl;
  final bool isPlaying;
  final String? packageName;
  final bool hasSession;

  const MediaState({
    this.title = '',
    this.artist = '',
    this.albumArtUrl,
    this.isPlaying = false,
    this.packageName,
    this.hasSession = false,
  });

  MediaState copyWith({
    String? title,
    String? artist,
    String? albumArtUrl,
    bool? isPlaying,
    String? packageName,
    bool? hasSession,
  }) {
    return MediaState(
      title: title ?? this.title,
      artist: artist ?? this.artist,
      albumArtUrl: albumArtUrl ?? this.albumArtUrl,
      isPlaying: isPlaying ?? this.isPlaying,
      packageName: packageName ?? this.packageName,
      hasSession: hasSession ?? this.hasSession,
    );
  }
}
