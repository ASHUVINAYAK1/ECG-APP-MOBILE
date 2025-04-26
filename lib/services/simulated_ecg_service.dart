import 'dart:async';
import 'dart:math';
import 'ecg_service.dart';

/// Implementation of EcgService that generates simulated ECG data.
/// This is used as a fallback when the real ECG device is not available.
class SimulatedEcgService implements EcgService {
  static const int _samplesPerSecond = 100; // 100 Hz sampling rate
  static const double _baselineValue = 0.0;
  static const double _amplitude = 0.5;
  static const double _spikeAmplitude = 1.5; // QRS spike amplitude
  
  final Random _random = Random();
  StreamController<double>? _streamController;
  Timer? _timer;
  int _sampleCount = 0;
  
  @override
  Future<bool> connect() async {
    // Simulated connection always succeeds
    _streamController = StreamController<double>.broadcast();
    _startGeneratingData();
    return true;
  }
  
  @override
  Stream<double> getEcgStream() {
    if (_streamController == null) {
      _streamController = StreamController<double>.broadcast();
      _startGeneratingData();
    }
    return _streamController!.stream;
  }
  
  @override
  void disconnect() {
    _timer?.cancel();
    _streamController?.close();
    _streamController = null;
  }
  
  void _startGeneratingData() {
    // Generate data at the specified sampling rate
    _timer = Timer.periodic(Duration(milliseconds: 1000 ~/ _samplesPerSecond), (timer) {
      if (_streamController?.isClosed ?? true) {
        timer.cancel();
        return;
      }
      
      _sampleCount++;
      
      // Generate a simulated ECG value
      double value = _generateEcgValue();
      _streamController?.add(value);
    });
  }
  
  double _generateEcgValue() {
    // Basic sine wave with random noise
    double baseSignal = _baselineValue + 
                        _amplitude * sin(2 * pi * _sampleCount / (_samplesPerSecond * 0.8));
    
    // Add small random noise
    double noise = _random.nextDouble() * 0.1 - 0.05;
    
    // Add QRS complex spike approximately once per second
    bool isQrsSpike = _sampleCount % _samplesPerSecond == 0;
    double qrsSpike = isQrsSpike ? _spikeAmplitude : 0.0;
    
    // Occasionally add an arrhythmia (higher spike) for realism
    if (_random.nextInt(500) == 0) {
      qrsSpike = 1.8; // Possible arrhythmia value > 1.2
    }
    
    // Combine all components
    double ecgValue = baseSignal + noise + qrsSpike;
    
    // Ensure values stay within the expected range (-1.0 to +2.0)
    return ecgValue.clamp(-1.0, 2.0);
  }
}
