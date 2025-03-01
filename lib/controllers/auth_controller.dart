import '../enums/user_role.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Sign in with email and password.
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } catch (e) {
      rethrow;
    }
  }

  /// Register a new user with email and password.
  Future<User?> register({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(credential.user!.uid).set({
        'email': email,
        'role': role.toString().split('.').last,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return credential.user;
    } catch (e) {
      rethrow;
    }
  }

  /// Sign out user.
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
