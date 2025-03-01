import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Update user's name and profile image URL in Firestore.
  Future<void> updateProfile({
    required String uid,
    String? name,
    File? profileImage, // new image file if any
  }) async {
    Map<String, dynamic> updateData = {};

    if (name != null) {
      updateData['name'] = name;
    }

    if (profileImage != null) {
      // Upload image to Firebase Storage.
      final ref = _storage.ref().child('profile_images').child('$uid.jpg');
      await ref.putFile(profileImage);
      final url = await ref.getDownloadURL();
      updateData['profileImageUrl'] = url;
    }

    if (updateData.isNotEmpty) {
      await _firestore.collection('users').doc(uid).update(updateData);
    }
  }
}
