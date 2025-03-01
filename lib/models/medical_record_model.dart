import 'package:cloud_firestore/cloud_firestore.dart';

class MedicalRecord {
  final String id;
  final String patientId;
  final String recordDetails;
  final DateTime date;

  MedicalRecord({
    required this.id,
    required this.patientId,
    required this.recordDetails,
    required this.date,
  });

  factory MedicalRecord.fromMap(Map<String, dynamic> data, String id) {
    return MedicalRecord(
      id: id,
      patientId: data['patientId'] ?? '',
      recordDetails: data['recordDetails'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'recordDetails': recordDetails,
      'date': date,
    };
  }
}
