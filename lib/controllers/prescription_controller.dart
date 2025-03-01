import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/prescription_model.dart';

class PrescriptionController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addPrescription({
    required String doctorId,
    required String patientId,
    required String details,
  }) async {
    await _firestore.collection('prescriptions').add({
      'doctorId': doctorId,
      'patientId': patientId,
      'details': details,
      'date': DateTime.now(),
    });
  }

  // Fetch prescriptions for a patient.
  Stream<List<Prescription>> getPrescriptions(String patientId) {
    return _firestore
        .collection('prescriptions')
        .where('patientId', isEqualTo: patientId)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map(
                    (doc) => Prescription.fromMap(
                      doc.data() as Map<String, dynamic>,
                      doc.id,
                    ),
                  )
                  .toList(),
        );
  }
}
