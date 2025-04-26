package com.example.ecg_app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.ecg_app/bluetooth"
    private lateinit var bluetoothHandler: BluetoothHandler

    companion object {
        var methodChannel: MethodChannel? = null
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        bluetoothHandler = BluetoothHandler(context)

        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "connectToDevice" -> {
                    val deviceName = call.argument<String>("deviceName") ?: "HC-05"
                    val timeout = call.argument<Int>("timeout")?.toLong() ?: 5000L
                    bluetoothHandler.connectToDevice(deviceName, result, timeout)
                }
                "disconnectDevice" -> {
                    bluetoothHandler.disconnect()
                    result.success(null)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    override fun onDestroy() {
        bluetoothHandler.disconnect()
        super.onDestroy()
    }
}
