package com.carlauncher.car_launcher_flutter

import android.content.ComponentName
import android.content.Context
import android.media.MediaMetadata
import android.media.session.MediaController
import android.media.session.MediaSessionManager
import android.media.session.PlaybackState
import android.os.Bundle
import android.util.Log
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MediaSessionHandler(private val context: Context) {

    companion object {
        const val CHANNEL = "com.carlauncher/media_session"
        const val EVENTS = "com.carlauncher/media_events"
        private const val TAG = "MediaSessionHandler"
    }

    private var mediaSessionManager: MediaSessionManager? = null
    private var activeController: MediaController? = null
    private val controllers = mutableListOf<MediaController>()
    private var eventSink: EventChannel.EventSink? = null

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
        override fun onSessionEvent(event: String?, extras: Bundle?) {
            emitState()
        }
    }

    fun start() {
        try {
            val cn = ComponentName(context, NotificationListenerService::class.java)
            mediaSessionManager = context.getSystemService(Context.MEDIA_SESSION_SERVICE) as? MediaSessionManager
            mediaSessionManager?.addOnActiveSessionsChangedListener(sessionListener, cn)
            mediaSessionManager?.getActiveSessions(cn)?.let { sessions ->
                controllers.addAll(sessions)
                controllers.forEach { it.registerCallback(controllerCallback) }
                updateFromBestController()
            }
            Log.d(TAG, "Media session tracking started")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to start media tracking", e)
        }
    }

    fun stop() {
        mediaSessionManager?.removeOnActiveSessionsChangedListener(sessionListener)
        controllers.forEach { it.unregisterCallback(controllerCallback) }
        controllers.clear()
        activeController = null
        mediaSessionManager = null
        eventSink = null
    }

    fun handleMethodCall(call: MethodChannel.MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "playPause" -> {
                val controller = activeController
                if (controller != null) {
                    val state = controller.playbackState?.state
                    if (state == PlaybackState.STATE_PLAYING) {
                        controller.transportControls.pause()
                    } else {
                        controller.transportControls.play()
                    }
                    result.success(true)
                } else {
                    result.success(false)
                }
            }
            "skipNext" -> {
                activeController?.transportControls?.skipToNext()
                result.success(true)
            }
            "skipPrevious" -> {
                activeController?.transportControls?.skipToPrevious()
                result.success(true)
            }
            "getState" -> {
                result.success(buildStateMap())
            }
            else -> result.notImplemented()
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
        return mapOf(
            "hasSession" to true,
            "title" to (metadata?.getString(MediaMetadata.METADATA_KEY_TITLE) ?: ""),
            "artist" to (metadata?.getString(MediaMetadata.METADATA_KEY_ARTIST) ?: ""),
            "albumArtUrl" to null,
            "isPlaying" to (ctrl.playbackState?.state == PlaybackState.STATE_PLAYING),
            "packageName" to ctrl.packageName,
        )
    }
}
