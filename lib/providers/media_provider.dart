import 'package:flutter/material.dart';
import '../models/media_state.dart';

class MediaProvider extends ChangeNotifier {
  MediaState _state = const MediaState();
  bool _isLoading = false;

  MediaState get state => _state;
  bool get isLoading => _isLoading;

  void updateMedia({
    String? title,
    String? artist,
    String? albumArtUrl,
    bool? isPlaying,
    String? packageName,
  }) {
    _state = _state.copyWith(
      title: title,
      artist: artist,
      albumArtUrl: albumArtUrl,
      isPlaying: isPlaying,
      packageName: packageName,
      hasSession: true,
    );
    notifyListeners();
  }

  void clearMedia() {
    _state = const MediaState();
    notifyListeners();
  }

  void playPause() {
    _state = _state.copyWith(isPlaying: !_state.isPlaying);
    notifyListeners();
  }

  void next() {}

  void previous() {}
}
