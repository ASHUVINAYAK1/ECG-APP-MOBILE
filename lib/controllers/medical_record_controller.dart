import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/medical_record_model.dart';

class MedicalRecordController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addMedicalRecord({
    required String patientId,
    required String recordDetails,
  }) async {
    await _firestore.collection('medical_records').add({
      'patientId': patientId,
      'recordDetails': recordDetails,
      'date': DateTime.now(),
    });
  }

  Stream<List<MedicalRecord>> getMedicalRecords(String patientId) {
    return _firestore
        .collection('medical_records')
        .where('patientId', isEqualTo: patientId)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map(
                    (doc) => MedicalRecord.fromMap(
                      doc.data() as Map<String, dynamic>,
                      doc.id,
                    ),
                  )
                  .toList(),
        );
  }
}
