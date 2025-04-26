import 'dart:async';
import '../services/ecg_service.dart';
import '../services/real_ecg_service.dart';
import '../services/simulated_ecg_service.dart';

/// Repository that manages ECG data sources and provides a unified interface
/// for accessing ECG data.
class EcgRepository {
  final RealEcgService _realService;
  final SimulatedEcgService _simulatedService;
  
  EcgService? _activeService;
  StreamController<double>? _ecgStreamController;
  
  bool get isUsingRealData => _activeService == _realService;
  
  /// Creates a new EcgRepository with the specified services.
  EcgRepository({
    RealEcgService? realService,
    SimulatedEcgService? simulatedService,
  }) : _realService = realService ?? RealEcgService(),
       _simulatedService = simulatedService ?? SimulatedEcgService();
  
  /// Initializes the repository by attempting to connect to the real ECG service.
  /// If that fails or times out, falls back to the simulated service.
  Future<void> init() async {
    _ecgStreamController = StreamController<double>.broadcast();
    
    // Try to connect to the real ECG service with a timeout
    bool realConnected = false;
    try {
      realConnected = await _realService.connect()
          .timeout(const Duration(seconds: 5));
    } on TimeoutException {
      print('Connection to real ECG service timed out');
      realConnected = false;
    } catch (e) {
      print('Error connecting to real ECG service: $e');
      realConnected = false;
    }
    
    if (realConnected) {
      // Use real ECG service
      _activeService = _realService;
      print('Using real ECG service');
    } else {
      // Fall back to simulated ECG service
      await _simulatedService.connect();
      _activeService = _simulatedService;
      print('Using simulated ECG service');
    }
    
    // Forward data from the active service to our stream
    _activeService!.getEcgStream().listen((value) {
      if (!(_ecgStreamController?.isClosed ?? true)) {
        _ecgStreamController?.add(value);
      }
    });
  }
  
  /// Returns a stream of ECG readings from the active service.
  Stream<double> get ecgStream {
    if (_ecgStreamController == null) {
      throw StateError('EcgRepository not initialized. Call init() first.');
    }
    return _ecgStreamController!.stream;
  }
  
  /// Disposes of resources used by the repository.
  void dispose() {
    _realService.disconnect();
    _simulatedService.disconnect();
    _ecgStreamController?.close();
    _ecgStreamController = null;
  }
}
