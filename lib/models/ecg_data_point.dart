/// Represents a single ECG data point with a value and timestamp.
class EcgDataPoint {
  final double value;
  final DateTime timestamp;
  
  EcgDataPoint({
    required this.value,
    required this.timestamp,
  });
}
