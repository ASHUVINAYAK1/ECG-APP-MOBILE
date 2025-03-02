import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../controllers/auth_controller.dart';
import 'package:ecg_app/enums/user_role.dart'; // Use this definition for UserRole.
import 'package:ecg_app/models/user_model.dart'
    hide UserRole; // Hide duplicate UserRole.
import 'package:ecg_app/screens/patient/onboarding_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final AuthController _authController = AuthController();
  UserRole _selectedRole = UserRole.patient;

  Future<void> _register() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }

    try {
      // Attempt to register the user.
      final User? firebaseUser = await _authController.register(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        role: _selectedRole,
      );

      if (firebaseUser != null) {
        // Determine the collection based on the role.
        final String collectionName =
            _selectedRole == UserRole.patient ? 'patients' : 'doctors';

        final DocumentReference docRef = FirebaseFirestore.instance
            .collection(collectionName)
            .doc(firebaseUser.uid);

        final DocumentSnapshot doc = await docRef.get();

        if (!doc.exists) {
          // Create a minimal record if one does not exist.
          if (_selectedRole == UserRole.patient) {
            // Create a minimal patient record.
            final Patient newPatient = Patient(
              uid: firebaseUser.uid,
              email: _emailController.text.trim(),
              role: UserRole.patient,
              name: "",
              phone: "",
              address: "",
              familyId: null,
              emergencyDoctorIds: [],
            );
            await docRef.set(newPatient.toMap());
            final DocumentSnapshot newDoc = await docRef.get();
            final Patient patient = Patient.fromMap(
              newDoc.data() as Map<String, dynamic>,
              firebaseUser.uid,
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => OnboardingScreen(patient: patient),
              ),
            );
          } else {
            // Create a minimal doctor record.
            final Doctor newDoctor = Doctor(
              uid: firebaseUser.uid,
              email: _emailController.text.trim(),
              role: UserRole.doctor,
              name: "",
              specialization: "",
            );
            await docRef.set(newDoctor.toMap());
            Navigator.pushReplacementNamed(context, '/doctor/home');
          }
        } else {
          // If record already exists, navigate accordingly.
          if (_selectedRole == UserRole.patient) {
            final Patient patient = Patient.fromMap(
              doc.data() as Map<String, dynamic>,
              firebaseUser.uid,
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => OnboardingScreen(patient: patient),
              ),
            );
          } else {
            Navigator.pushReplacementNamed(context, '/doctor/home');
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Registration error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Create Account',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Enter your email'
                            : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Enter your password';
                  if (value.length < 6)
                    return 'Password must be at least 6 characters';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Confirm your password'
                            : null,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio<UserRole>(
                    value: UserRole.patient,
                    groupValue: _selectedRole,
                    onChanged: (UserRole? value) {
                      setState(() => _selectedRole = value!);
                    },
                  ),
                  const Text('Patient'),
                  Radio<UserRole>(
                    value: UserRole.doctor,
                    groupValue: _selectedRole,
                    onChanged: (UserRole? value) {
                      setState(() => _selectedRole = value!);
                    },
                  ),
                  const Text('Doctor'),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _register();
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text('Register', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
