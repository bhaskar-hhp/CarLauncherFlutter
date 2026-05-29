class MediaState {
  final String title;
  final String artist;
  final String? albumArtUrl;
  final bool isPlaying;
  final String? packageName;
  final bool hasSession;
  final bool isYtMusic;
  final String? sourceName;

  const MediaState({
    this.title = '',
    this.artist = '',
    this.albumArtUrl,
    this.isPlaying = false,
    this.packageName,
    this.hasSession = false,
    this.isYtMusic = false,
    this.sourceName,
  });

  MediaState copyWith({
    String? title,
    String? artist,
    String? albumArtUrl,
    bool? isPlaying,
    String? packageName,
    bool? hasSession,
    bool? isYtMusic,
    String? sourceName,
  }) {
    return MediaState(
      title: title ?? this.title,
      artist: artist ?? this.artist,
      albumArtUrl: albumArtUrl ?? this.albumArtUrl,
      isPlaying: isPlaying ?? this.isPlaying,
      packageName: packageName ?? this.packageName,
      hasSession: hasSession ?? this.hasSession,
      isYtMusic: isYtMusic ?? this.isYtMusic,
      sourceName: sourceName ?? this.sourceName,
    );
  }
}
