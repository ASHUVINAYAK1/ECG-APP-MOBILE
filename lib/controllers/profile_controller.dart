import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Update the patient profile in the 'patients' collection.
  Future<void> updateProfile({
    required String uid,
    required String name,
    required String phone,
    required String address,
    File? profileImage,
  }) async {
    String? profileImageUrl;
    if (profileImage != null) {
      // Upload the image to Firebase Storage.
      final ref = _storage.ref().child('profile_images').child(uid);
      await ref.putFile(profileImage);
      profileImageUrl = await ref.getDownloadURL();
    }

    // Update patient document.
    await _firestore.collection('patients').doc(uid).set({
      'name': name,
      'phone': phone,
      'address': address,
      if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
    }, SetOptions(merge: true));
  }

  /// Add or update a medical record in a subcollection "medical_records" under patient document.
  Future<void> addMedicalRecord({
    required String uid,
    required String prescription,
    required String ecg,
    File? documentFile,
  }) async {
    String? documentUrl;
    if (documentFile != null) {
      // Upload the file (e.g., PDF or image) to Firebase Storage.
      final ref = _storage
          .ref()
          .child('medical_records')
          .child(uid)
          .child(DateTime.now().millisecondsSinceEpoch.toString());
      await ref.putFile(documentFile);
      documentUrl = await ref.getDownloadURL();
    }
    // Create a new document in the "medical_records" subcollection for the patient.
    await _firestore
        .collection('patients')
        .doc(uid)
        .collection('medical_records')
        .add({
          'prescription': prescription,
          'ecg': ecg,
          'documentUrl': documentUrl,
          'date': FieldValue.serverTimestamp(),
        });
  }

  /// Update medical record URL separately if needed.
  Future<void> updateMedicalRecord({
    required String uid,
    required String medicalRecordUrl,
  }) async {
    // You can choose to store multiple records in a subcollection (recommended)
    // or update an array field in the patient document.
    // Here we assume a subcollection approach.
    await _firestore
        .collection('patients')
        .doc(uid)
        .collection('medical_records')
        .add({
          'documentUrl': medicalRecordUrl,
          'date': FieldValue.serverTimestamp(),
        });
  }
}
