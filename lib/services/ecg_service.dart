import 'dart:async';

/// Abstract class defining the contract for ECG services.
/// This will be implemented by both real and simulated services.
abstract class EcgService {
  /// Attempts to connect to the ECG data source.
  /// Returns true if connection is successful, false otherwise.
  Future<bool> connect();

  /// Returns a stream of ECG readings.
  /// Each value represents a single ECG data point.
  Stream<double> getEcgStream();

  /// Disconnects from the ECG data source and cleans up resources.
  void disconnect();
}
