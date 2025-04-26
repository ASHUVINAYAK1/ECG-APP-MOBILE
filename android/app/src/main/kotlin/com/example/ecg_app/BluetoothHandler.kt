package com.example.ecg_app

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothSocket
import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import io.flutter.plugin.common.MethodChannel
import java.io.IOException
import java.io.InputStream
import java.util.UUID
import kotlin.concurrent.thread

class BluetoothHandler(private val context: Context) {
    private val TAG = "BluetoothHandler"
    private val SPP_UUID = UUID.fromString("00001101-0000-1000-8000-00805F9B34FB")
    
    private var bluetoothAdapter: BluetoothAdapter? = BluetoothAdapter.getDefaultAdapter()
    private var bluetoothSocket: BluetoothSocket? = null
    private var inputStream: InputStream? = null
    private var isConnected = false
    private var readThread: Thread? = null
    
    fun connectToDevice(deviceName: String, result: MethodChannel.Result, timeout: Long) {
        if (bluetoothAdapter == null) {
            Log.e(TAG, "Bluetooth not supported on this device")
            result.error("BLUETOOTH_UNAVAILABLE", "Bluetooth is not available on this device", null)
            return
        }
        
        if (!bluetoothAdapter!!.isEnabled) {
            Log.e(TAG, "Bluetooth is not enabled")
            result.error("BLUETOOTH_DISABLED", "Bluetooth is not enabled", null)
            return
        }
        
        thread {
            try {
                // Find the device by name
                val pairedDevices = bluetoothAdapter!!.bondedDevices
                val device = pairedDevices.find { it.name == deviceName }
                
                if (device == null) {
                    Log.e(TAG, "Device $deviceName not found")
                    Handler(Looper.getMainLooper()).post {
                        result.error("DEVICE_NOT_FOUND", "Device $deviceName not found", null)
                    }
                    return@thread
                }
                
                // Connect to the device
                bluetoothSocket = device.createRfcommSocketToServiceRecord(SPP_UUID)
                bluetoothAdapter!!.cancelDiscovery()
                
                try {
                    // Set a timeout for the connection
                    val connectThread = thread {
                        try {
                            bluetoothSocket?.connect()
                        } catch (e: IOException) {
                            Log.e(TAG, "Connection failed", e)
                            bluetoothSocket?.close()
                            bluetoothSocket = null
                        }
                    }
                    
                    connectThread.join(timeout)
                    
                    if (bluetoothSocket?.isConnected != true) {
                        Log.e(TAG, "Connection timed out")
                        bluetoothSocket?.close()
                        bluetoothSocket = null
                        Handler(Looper.getMainLooper()).post {
                            result.error("CONNECTION_TIMEOUT", "Connection timed out", null)
                        }
                        return@thread
                    }
                    
                    // Get the input stream
                    inputStream = bluetoothSocket?.inputStream
                    isConnected = true
                    
                    // Start reading from the device
                    startReading()
                    
                    Handler(Looper.getMainLooper()).post {
                        result.success(true)
                    }
                } catch (e: IOException) {
                    Log.e(TAG, "Error connecting to device", e)
                    bluetoothSocket?.close()
                    bluetoothSocket = null
                    Handler(Looper.getMainLooper()).post {
                        result.error("CONNECTION_ERROR", e.message, null)
                    }
                }
            } catch (e: Exception) {
                Log.e(TAG, "Unexpected error", e)
                Handler(Looper.getMainLooper()).post {
                    result.error("UNEXPECTED_ERROR", e.message, null)
                }
            }
        }
    }
    
    private fun startReading() {
        if (readThread != null) {
            return
        }
        
        readThread = thread {
            val buffer = ByteArray(1024)
            var bytes: Int
            
            while (isConnected) {
                try {
                    bytes = inputStream?.read(buffer) ?: -1
                    
                    if (bytes > 0) {
                        val data = ByteArray(bytes)
                        System.arraycopy(buffer, 0, data, 0, bytes)
                        
                        // Send the data to Flutter
                        Handler(Looper.getMainLooper()).post {
                            MainActivity.methodChannel?.invokeMethod("onDataReceived", data)
                        }
                    }
                } catch (e: IOException) {
                    Log.e(TAG, "Error reading from device", e)
                    break
                }
            }
        }
    }
    
    fun disconnect() {
        isConnected = false
        readThread?.interrupt()
        readThread = null
        
        try {
            inputStream?.close()
            bluetoothSocket?.close()
        } catch (e: IOException) {
            Log.e(TAG, "Error closing connection", e)
        }
        
        inputStream = null
        bluetoothSocket = null
    }
}
