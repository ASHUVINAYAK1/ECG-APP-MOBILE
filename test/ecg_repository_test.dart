import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:ecg_app/repository/ecg_repository.dart';
import 'package:ecg_app/services/ecg_service.dart';
import 'package:ecg_app/services/real_ecg_service.dart';
import 'package:ecg_app/services/simulated_ecg_service.dart';

// Mock implementation of RealEcgService for testing
class MockRealEcgService implements RealEcgService {
  final bool shouldConnect;
  final bool shouldTimeout;
  final StreamController<double> _controller = StreamController<double>.broadcast();
  
  MockRealEcgService({this.shouldConnect = true, this.shouldTimeout = false});
  
  @override
  Future<bool> connect() async {
    if (shouldTimeout) {
      // Simulate a timeout by delaying longer than the test timeout
      await Future.delayed(const Duration(seconds: 10));
      return true;
    }
    return shouldConnect;
  }
  
  @override
  Stream<double> getEcgStream() {
    return _controller.stream;
  }
  
  @override
  void disconnect() {
    _controller.close();
  }
  
  void addValue(double value) {
    if (!_controller.isClosed) {
      _controller.add(value);
    }
  }
}

// Mock implementation of SimulatedEcgService for testing
class MockSimulatedEcgService implements SimulatedEcgService {
  final StreamController<double> _controller = StreamController<double>.broadcast();
  
  @override
  Future<bool> connect() async {
    return true;
  }
  
  @override
  Stream<double> getEcgStream() {
    return _controller.stream;
  }
  
  @override
  void disconnect() {
    _controller.close();
  }
  
  void addValue(double value) {
    if (!_controller.isClosed) {
      _controller.add(value);
    }
  }
}

void main() {
  group('EcgRepository Tests', () {
    late MockRealEcgService mockRealService;
    late MockSimulatedEcgService mockSimulatedService;
    late EcgRepository repository;
    
    setUp(() {
      mockRealService = MockRealEcgService();
      mockSimulatedService = MockSimulatedEcgService();
    });
    
    tearDown(() {
      repository.dispose();
    });
    
    test('Should use real service when connection succeeds', () async {
      // Arrange
      mockRealService = MockRealEcgService(shouldConnect: true);
      repository = EcgRepository(
        realService: mockRealService,
        simulatedService: mockSimulatedService,
      );
      
      // Act
      await repository.init();
      
      // Assert
      expect(repository.isUsingRealData, true);
    });
    
    test('Should fall back to simulated service when real service fails', () async {
      // Arrange
      mockRealService = MockRealEcgService(shouldConnect: false);
      repository = EcgRepository(
        realService: mockRealService,
        simulatedService: mockSimulatedService,
      );
      
      // Act
      await repository.init();
      
      // Assert
      expect(repository.isUsingRealData, false);
    });
    
    test('Should fall back to simulated service when real service times out', () async {
      // Arrange
      mockRealService = MockRealEcgService(shouldTimeout: true);
      repository = EcgRepository(
        realService: mockRealService,
        simulatedService: mockSimulatedService,
      );
      
      // Act & Assert
      // Use a shorter timeout for the test
      await repository.init().timeout(const Duration(milliseconds: 100), onTimeout: () {
        // This is expected, as we're testing the timeout handling
      });
      
      // The repository should have fallen back to the simulated service
      expect(repository.isUsingRealData, false);
    });
    
    test('Should forward values from active service to ecgStream', () async {
      // Arrange
      mockRealService = MockRealEcgService(shouldConnect: true);
      repository = EcgRepository(
        realService: mockRealService,
        simulatedService: mockSimulatedService,
      );
      
      // Act
      await repository.init();
      
      // Create a list to collect emitted values
      final emittedValues = <double>[];
      repository.ecgStream.listen(emittedValues.add);
      
      // Add test values to the mock service
      mockRealService.addValue(1.0);
      mockRealService.addValue(1.5);
      mockRealService.addValue(0.5);
      
      // Wait for the values to be processed
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Assert
      expect(emittedValues, [1.0, 1.5, 0.5]);
    });
  });
}
