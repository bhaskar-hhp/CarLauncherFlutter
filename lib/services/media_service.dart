import 'package:flutter/services.dart';
import '../models/media_state.dart';

typedef MediaStateCallback = void Function();

class MediaService {
  static const _channel = MethodChannel('com.carlauncher/media_session');
  static const _events = EventChannel('com.carlauncher/media_events');

  final MediaStateCallback onStateChanged;

  MediaService({required this.onStateChanged}) {
    _events.receiveBroadcastStream().listen(_onEvent, onError: (_) {});
  }

  void _onEvent(dynamic data) {
    if (data is Map) {
      _currentState = MediaState(
        hasSession: data['hasSession'] as bool? ?? false,
        title: data['title'] as String? ?? '',
        artist: data['artist'] as String? ?? '',
        albumArtUrl: data['albumArtUrl'] as String?,
        isPlaying: data['isPlaying'] as bool? ?? false,
        packageName: data['packageName'] as String?,
      );
      onStateChanged();
    }
  }

  MediaState _currentState = const MediaState();
  MediaState get currentState => _currentState;

  Future<bool> playPause() async {
    try {
      final result = await _channel.invokeMethod<bool>('playPause');
      return result ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> skipNext() async {
    try {
      final result = await _channel.invokeMethod<bool>('skipNext');
      return result ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> skipPrevious() async {
    try {
      final result = await _channel.invokeMethod<bool>('skipPrevious');
      return result ?? false;
    } catch (_) {
      return false;
    }
  }

  void dispose() {}
}
