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
        isYtMusic: data['isYtMusic'] as bool? ?? false,
        sourceName: data['sourceName'] as String?,
      );
      onStateChanged();
    }
  }

  MediaState _currentState = const MediaState();
  MediaState get currentState => _currentState;

  Future<bool> playPause() async {
    try {
      return await _channel.invokeMethod<bool>('playPause') ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> skipNext() async {
    try {
      return await _channel.invokeMethod<bool>('skipNext') ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> skipPrevious() async {
    try {
      return await _channel.invokeMethod<bool>('skipPrevious') ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> launchYtMusic() async {
    try {
      return await _channel.invokeMethod<bool>('launchYtMusic') ?? false;
    } catch (_) {
      return false;
    }
  }

  void dispose() {}
}
