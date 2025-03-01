import 'package:cloud_firestore/cloud_firestore.dart';

class SensorReading {
  final String id;
  final String patientId;
  final double readingValue;
  final DateTime timestamp;

  SensorReading({
    required this.id,
    required this.patientId,
    required this.readingValue,
    required this.timestamp,
  });

  factory SensorReading.fromMap(Map<String, dynamic> data, String id) {
    return SensorReading(
      id: id,
      patientId: data['patientId'] ?? '',
      readingValue: data['readingValue']?.toDouble() ?? 0.0,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'readingValue': readingValue,
      'timestamp': timestamp,
    };
  }
}
