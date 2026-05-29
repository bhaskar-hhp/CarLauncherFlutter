package com.carlauncher.car_launcher_flutter

import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.media.AudioManager
import android.media.MediaMetadata
import android.media.session.MediaController
import android.media.session.MediaSessionManager
import android.media.session.PlaybackState
import android.util.Log
import android.view.KeyEvent
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MediaSessionHandler(private val context: Context) {

    companion object {
        const val CHANNEL = "com.carlauncher/media_session"
        const val EVENTS = "com.carlauncher/media_events"
        private const val TAG = "MediaSessionHandler"
        private const val YT_MUSIC_PACKAGE = "com.google.android.apps.youtube.music"
    }

    private var mediaSessionManager: MediaSessionManager? = null
    private var activeController: MediaController? = null
    private val controllers = mutableListOf<MediaController>()
    private var eventSink: EventChannel.EventSink? = null
    private var audioManager: AudioManager? = null

    private val sessionListener = MediaSessionManager.OnActiveSessionsChangedListener { sessions ->
        controllers.forEach { it.unregisterCallback(controllerCallback) }
        controllers.clear()
        if (sessions != null) {
            controllers.addAll(sessions)
            controllers.forEach { it.registerCallback(controllerCallback) }
        }
        updateFromBestController()
    }

    private val controllerCallback = object : MediaController.Callback() {
        override fun onMetadataChanged(metadata: MediaMetadata?) {
            emitState()
        }
        override fun onPlaybackStateChanged(state: PlaybackState?) {
            emitState()
        }
        override fun onSessionDestroyed() {
            controllers.removeAll { it.transportControls == null }
            updateFromBestController()
        }
    }

    fun start() {
        audioManager = context.getSystemService(Context.AUDIO_SERVICE) as? AudioManager
        try {
            mediaSessionManager = context.getSystemService(Context.MEDIA_SESSION_SERVICE) as? MediaSessionManager
            refreshSessions()
            Log.d(TAG, "Media session tracking started")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to start media tracking", e)
        }
    }

    private fun refreshSessions() {
        controllers.forEach { it.unregisterCallback(controllerCallback) }
        controllers.clear()

        val manager = mediaSessionManager ?: return

        try {
            val cn = ComponentName(context, DummyNotificationListener::class.java)
            manager.getActiveSessions(cn)?.let { sessions ->
                controllers.addAll(sessions)
            }
        } catch (_: Exception) { }

        if (controllers.isEmpty()) {
            try {
                manager.getActiveSessions(null)?.let { sessions ->
                    controllers.addAll(sessions)
                }
            } catch (_: Exception) { }
        }

        controllers.forEach { it.registerCallback(controllerCallback) }
        updateFromBestController()
    }

    fun stop() {
        try {
            mediaSessionManager?.removeOnActiveSessionsChangedListener(sessionListener)
        } catch (_: Exception) { }
        controllers.forEach { it.unregisterCallback(controllerCallback) }
        controllers.clear()
        activeController = null
        mediaSessionManager = null
        eventSink = null
    }

    fun handleMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "playPause" -> {
                val ctrl = activeController
                if (ctrl != null) {
                    val state = ctrl.playbackState?.state
                    if (state == PlaybackState.STATE_PLAYING) {
                        ctrl.transportControls.pause()
                    } else {
                        ctrl.transportControls.play()
                    }
                } else {
                    sendMediaKeyEvent(KeyEvent.KEYCODE_MEDIA_PLAY_PAUSE)
                }
                result.success(true)
            }
            "skipNext" -> {
                if (activeController != null) {
                    activeController?.transportControls?.skipToNext()
                } else {
                    sendMediaKeyEvent(KeyEvent.KEYCODE_MEDIA_NEXT)
                }
                result.success(true)
            }
            "skipPrevious" -> {
                if (activeController != null) {
                    activeController?.transportControls?.skipToPrevious()
                } else {
                    sendMediaKeyEvent(KeyEvent.KEYCODE_MEDIA_PREVIOUS)
                }
                result.success(true)
            }
            "launchYtMusic" -> {
                launchYouTubeMusic()
                result.success(true)
            }
            "getState" -> {
                result.success(buildStateMap())
            }
            else -> result.notImplemented()
        }
    }

    private fun sendMediaKeyEvent(keyCode: Int) {
        try {
            val down = Intent(Intent.ACTION_MEDIA_BUTTON).apply {
                putExtra(Intent.EXTRA_KEY_EVENT, KeyEvent(KeyEvent.ACTION_DOWN, keyCode))
                `package` = null
            }
            context.sendOrderedBroadcast(down, null)

            val up = Intent(Intent.ACTION_MEDIA_BUTTON).apply {
                putExtra(Intent.EXTRA_KEY_EVENT, KeyEvent(KeyEvent.ACTION_UP, keyCode))
                `package` = null
            }
            context.sendOrderedBroadcast(up, null)

            audioManager?.dispatchMediaKeyEvent(KeyEvent(KeyEvent.ACTION_DOWN, keyCode))
            audioManager?.dispatchMediaKeyEvent(KeyEvent(KeyEvent.ACTION_UP, keyCode))
        } catch (e: Exception) {
            Log.e(TAG, "Failed to send media key event", e)
        }
    }

    private fun launchYouTubeMusic() {
        try {
            val intent = context.packageManager.getLaunchIntentForPackage(YT_MUSIC_PACKAGE)
            if (intent != null) {
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                context.startActivity(intent)
            } else {
                val market = Intent(Intent.ACTION_VIEW).apply {
                    data = android.net.Uri.parse("market://details?id=$YT_MUSIC_PACKAGE")
                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                }
                context.startActivity(market)
            }
        } catch (e: Exception) {
            Log.e(TAG, "Failed to launch YT Music", e)
        }
    }

    fun setEventSink(sink: EventChannel.EventSink?) {
        eventSink = sink
        if (sink != null) {
            emitState()
        }
    }

    private fun updateFromBestController() {
        val ctrl = controllers.firstOrNull { it.playbackState != null }
            ?: controllers.firstOrNull()
        activeController = ctrl
        emitState()
    }

    private fun emitState() {
        val data = buildStateMap()
        eventSink?.success(data)
    }

    private fun buildStateMap(): Map<String, Any?> {
        val ctrl = activeController
        if (ctrl == null) {
            return mapOf(
                "hasSession" to false,
                "title" to "",
                "artist" to "",
                "albumArtUrl" to null,
                "isPlaying" to false,
                "packageName" to null,
            )
        }
        val metadata = ctrl.metadata
        val isPlaying = ctrl.playbackState?.state == PlaybackState.STATE_PLAYING
        val packageName = ctrl.packageName
        val isYtMusic = packageName == YT_MUSIC_PACKAGE

        return mapOf(
            "hasSession" to true,
            "title" to (metadata?.getString(MediaMetadata.METADATA_KEY_TITLE) ?: ""),
            "artist" to (metadata?.getString(MediaMetadata.METADATA_KEY_ARTIST) ?: ""),
            "albumArtUrl" to null,
            "isPlaying" to isPlaying,
            "packageName" to packageName,
            "isYtMusic" to isYtMusic,
            "sourceName" to getAppName(packageName),
        )
    }

    private fun getAppName(packageName: String?): String {
        if (packageName == null) return ""
        return try {
            val pm = context.packageManager
            val ai = pm.getApplicationInfo(packageName, 0)
            pm.getApplicationLabel(ai).toString()
        } catch (_: Exception) {
            packageName
        }
    }
}
