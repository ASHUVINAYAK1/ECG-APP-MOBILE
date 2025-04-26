import 'package:flutter_test/flutter_test.dart';
import 'package:ecg_app/services/simulated_ecg_service.dart';

void main() {
  group('SimulatedEcgService Tests', () {
    late SimulatedEcgService service;
    
    setUp(() {
      service = SimulatedEcgService();
    });
    
    tearDown(() {
      service.disconnect();
    });
    
    test('connect() should always return true', () async {
      // Act
      final result = await service.connect();
      
      // Assert
      expect(result, true);
    });
    
    test('getEcgStream() should emit values within expected range', () async {
      // Arrange
      await service.connect();
      final stream = service.getEcgStream();
      
      // Act
      final values = await stream.take(100).toList();
      
      // Assert
      // Check that all values are within the expected range (-1.0 to +2.0)
      for (final value in values) {
        expect(value, greaterThanOrEqualTo(-1.0));
        expect(value, lessThanOrEqualTo(2.0));
      }
    });
    
    test('getEcgStream() should generate QRS spikes', () async {
      // Arrange
      await service.connect();
      final stream = service.getEcgStream();
      
      // Act
      // Collect a larger number of samples to ensure we capture spikes
      final values = await stream.take(200).toList();
      
      // Assert
      // Count values above the spike threshold (1.0)
      final spikeCount = values.where((value) => value > 1.0).length;
      
      // We should have at least a few spikes in 200 samples
      expect(spikeCount, greaterThan(0));
    });
  });
}
