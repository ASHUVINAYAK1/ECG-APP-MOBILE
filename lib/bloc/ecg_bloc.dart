import 'dart:async';
import 'package:flutter/material.dart';
import '../models/ecg_data_point.dart';
import '../repository/ecg_repository.dart';

/// Represents the current state of the ECG data.
class EcgState {
  final List<EcgDataPoint> dataPoints;
  final String diagnosis;
  final bool isUsingRealData;
  
  EcgState({
    required this.dataPoints,
    required this.diagnosis,
    required this.isUsingRealData,
  });
  
  EcgState copyWith({
    List<EcgDataPoint>? dataPoints,
    String? diagnosis,
    bool? isUsingRealData,
  }) {
    return EcgState(
      dataPoints: dataPoints ?? this.dataPoints,
      diagnosis: diagnosis ?? this.diagnosis,
      isUsingRealData: isUsingRealData ?? this.isUsingRealData,
    );
  }
}

/// BLoC that manages ECG data processing and diagnosis.
class EcgBloc {
  final EcgRepository _repository;
  
  // Maximum number of data points to keep in memory
  static const int _maxDataPoints = 200;
  
  // Stream controllers
  final _stateController = StreamController<EcgState>.broadcast();
  
  // Current state
  EcgState _currentState = EcgState(
    dataPoints: [],
    diagnosis: 'Initializing...',
    isUsingRealData: false,
  );
  
  // Timer for periodic diagnosis updates
  Timer? _diagnosisTimer;
  
  /// Stream of ECG states.
  Stream<EcgState> get state => _stateController.stream;
  
  /// Creates a new EcgBloc with the specified repository.
  EcgBloc({required EcgRepository repository}) : _repository = repository {
    _init();
  }
  
  /// Initializes the BLoC.
  Future<void> _init() async {
    await _repository.init();
    
    // Update isUsingRealData based on repository
    _currentState = _currentState.copyWith(
      isUsingRealData: _repository.isUsingRealData,
    );
    
    // Listen to ECG data stream
    _repository.ecgStream.listen(_onNewEcgValue);
    
    // Set up timer for periodic diagnosis updates
    _diagnosisTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateDiagnosis();
    });
  }
  
  /// Handles a new ECG value from the repository.
  void _onNewEcgValue(double value) {
    // Create a new data point
    final dataPoint = EcgDataPoint(
      value: value,
      timestamp: DateTime.now(),
    );
    
    // Add to the list, keeping only the most recent points
    final updatedPoints = [..._currentState.dataPoints, dataPoint];
    if (updatedPoints.length > _maxDataPoints) {
      updatedPoints.removeAt(0);
    }
    
    // Update state
    _currentState = _currentState.copyWith(dataPoints: updatedPoints);
    _stateController.add(_currentState);
  }
  
  /// Updates the diagnosis based on recent ECG data.
  void _updateDiagnosis() {
    if (_currentState.dataPoints.isEmpty) {
      return;
    }
    
    // Check for values above the threshold in the last second
    final recentPoints = _currentState.dataPoints
        .where((point) => 
            point.timestamp.isAfter(
                DateTime.now().subtract(const Duration(seconds: 1))))
        .toList();
    
    if (recentPoints.isEmpty) {
      return;
    }
    
    // Check if any recent value is above the arrhythmia threshold
    bool hasArrhythmia = recentPoints.any((point) => point.value > 1.2);
    
    // Update diagnosis
    final diagnosis = hasArrhythmia 
        ? 'Possible arrhythmia detected'
        : 'Normal sinus rhythm';
    
    if (diagnosis != _currentState.diagnosis) {
      _currentState = _currentState.copyWith(diagnosis: diagnosis);
      _stateController.add(_currentState);
    }
  }
  
  /// Disposes of resources used by the BLoC.
  void dispose() {
    _diagnosisTimer?.cancel();
    _stateController.close();
    _repository.dispose();
  }
}
