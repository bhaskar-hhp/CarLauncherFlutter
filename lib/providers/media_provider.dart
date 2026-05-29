import 'package:flutter/material.dart';
import '../models/media_state.dart';
import '../services/media_service.dart';

class MediaProvider extends ChangeNotifier {
  MediaState _state = const MediaState();
  late final MediaService _service;

  MediaState get state => _state;

  MediaProvider() {
    _service = MediaService(onStateChanged: _onMediaStateChanged);
    _onMediaStateChanged();
  }

  void _onMediaStateChanged() {
    _state = _service.currentState;
    notifyListeners();
  }

  Future<void> playPause() async {
    await _service.playPause();
  }

  Future<void> next() async {
    await _service.skipNext();
  }

  Future<void> previous() async {
    await _service.skipPrevious();
  }

  Future<void> launchYtMusic() async {
    await _service.launchYtMusic();
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }
}
