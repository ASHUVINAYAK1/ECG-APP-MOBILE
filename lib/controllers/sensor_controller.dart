import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/sensor_reading_model.dart';

class SensorController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Call this method periodically with new readings.
  Future<void> addSensorReading({
    required String patientId,
    required double readingValue,
  }) async {
    await _firestore.collection('sensor_readings').add({
      'patientId': patientId,
      'readingValue': readingValue,
      'timestamp': DateTime.now(),
    });
  }

  // Stream sensor readings for graphing.
  Stream<List<SensorReading>> getSensorReadings(String patientId) {
    return _firestore
        .collection('sensor_readings')
        .where('patientId', isEqualTo: patientId)
        .orderBy('timestamp')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map(
                    (doc) => SensorReading.fromMap(
                      doc.data() as Map<String, dynamic>,
                      doc.id,
                    ),
                  )
                  .toList(),
        );
  }
}
