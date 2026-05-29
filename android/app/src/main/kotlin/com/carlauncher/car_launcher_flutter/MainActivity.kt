package com.carlauncher.car_launcher_flutter

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private lateinit var mediaSessionHandler: MediaSessionHandler
    private var eventSink: EventChannel.EventSink? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        mediaSessionHandler = MediaSessionHandler(this)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, MediaSessionHandler.CHANNEL)
            .setMethodCallHandler { call, result ->
                mediaSessionHandler.handleMethodCall(call, result)
            }

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, MediaSessionHandler.EVENTS)
            .setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventSink = events
                    mediaSessionHandler.setEventSink(events)
                }
                override fun onCancel(arguments: Any?) {
                    eventSink = null
                    mediaSessionHandler.setEventSink(null)
                }
            })

        mediaSessionHandler.start()
    }

    override fun onDestroy() {
        mediaSessionHandler.stop()
        super.onDestroy()
    }
}
