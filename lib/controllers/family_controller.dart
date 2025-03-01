import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/family_model.dart';

class FamilyController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new family.
  Future<String> createFamily({
    required String familyName,
    required String creatorId,
    required String doctorId,
  }) async {
    DocumentReference docRef = await _firestore.collection('families').add({
      'name': familyName,
      'familyDoctorId': doctorId,
      'memberIds': [creatorId],
    });
    // Optionally update the user document with the familyId.
    await _firestore.collection('users').doc(creatorId).update({
      'familyId': docRef.id,
    });
    return docRef.id;
  }

  // Join an existing family.
  Future<void> joinFamily({
    required String familyId,
    required String patientId,
  }) async {
    // Check if the patient is already part of a family.
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(patientId).get();
    if (userDoc.exists && userDoc.get('familyId') != null) {
      throw Exception("Patient already belongs to a family.");
    }
    // Add patient to family.
    await _firestore.collection('families').doc(familyId).update({
      'memberIds': FieldValue.arrayUnion([patientId]),
    });
    await _firestore.collection('users').doc(patientId).update({
      'familyId': familyId,
    });
  }

  // Add a doctor to family (for emergency or family doctor purposes).
  Future<void> addDoctorToFamily({
    required String familyId,
    required String doctorId,
  }) async {
    await _firestore.collection('families').doc(familyId).update({
      'familyDoctorId': doctorId,
    });
    // Optionally update user document for doctor if needed.
  }
}
