import 'package:cloud_firestore/cloud_firestore.dart';

class Prescription {
  final String id;
  final String doctorId;
  final String patientId;
  final String details;
  final DateTime date;

  Prescription({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.details,
    required this.date,
  });

  factory Prescription.fromMap(Map<String, dynamic> data, String id) {
    return Prescription(
      id: id,
      doctorId: data['doctorId'] ?? '',
      patientId: data['patientId'] ?? '',
      details: data['details'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'doctorId': doctorId,
      'patientId': patientId,
      'details': details,
      'date': date,
    };
  }
}
