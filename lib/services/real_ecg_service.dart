import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'ecg_service.dart';

/// Implementation of EcgService that connects to a real HC-05 Bluetooth device
/// to receive ECG data.
class RealEcgService implements EcgService {
  static const MethodChannel _channel = MethodChannel('com.example.ecg_app/bluetooth');
  
  StreamController<double>? _streamController;
  bool _isConnected = false;
  
  @override
  Future<bool> connect() async {
    try {
      // Try to connect to the HC-05 Bluetooth device
      final bool result = await _channel.invokeMethod('connectToDevice', {
        'deviceName': 'HC-05',
        'timeout': 5000, // 5 seconds timeout
      });
      
      if (result) {
        _isConnected = true;
        _setupDataStream();
        return true;
      }
      return false;
    } on PlatformException catch (e) {
      print('Failed to connect to Bluetooth device: ${e.message}');
      return false;
    }
  }
  
  @override
  Stream<double> getEcgStream() {
    if (_streamController == null) {
      _streamController = StreamController<double>.broadcast();
    }
    return _streamController!.stream;
  }
  
  @override
  void disconnect() {
    if (_isConnected) {
      _channel.invokeMethod('disconnectDevice');
      _isConnected = false;
    }
    
    _streamController?.close();
    _streamController = null;
  }
  
  void _setupDataStream() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onDataReceived') {
        final Uint8List data = call.arguments as Uint8List;
        final String dataString = utf8.decode(data);
        
        // Parse the data string to extract ECG value
        try {
          final double ecgValue = double.parse(dataString.trim());
          _streamController?.add(ecgValue);
        } catch (e) {
          print('Error parsing ECG data: $e');
        }
      }
    });
  }
}
