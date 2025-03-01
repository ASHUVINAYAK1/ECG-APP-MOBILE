import 'package:cloud_firestore/cloud_firestore.dart';

class Slot {
  final String id;
  final String doctorId;
  final DateTime startTime;
  final DateTime endTime;
  final int maxPatients;
  final int bookedCount; // you can update this as appointments are booked

  Slot({
    required this.id,
    required this.doctorId,
    required this.startTime,
    required this.endTime,
    required this.maxPatients,
    this.bookedCount = 0,
  });

  factory Slot.fromMap(Map<String, dynamic> data, String id) {
    return Slot(
      id: id,
      doctorId: data['doctorId'] ?? '',
      startTime: (data['startTime'] as Timestamp).toDate(),
      endTime: (data['endTime'] as Timestamp).toDate(),
      maxPatients: data['maxPatients'] ?? 0,
      bookedCount: data['bookedCount'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'doctorId': doctorId,
      'startTime': startTime,
      'endTime': endTime,
      'maxPatients': maxPatients,
      'bookedCount': bookedCount,
    };
  }
}
