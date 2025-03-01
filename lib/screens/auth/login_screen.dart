import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Needed to fetch user role
import '../../controllers/auth_controller.dart';
import '../../enums/user_role.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController =
      TextEditingController(); // using email
  final TextEditingController _passwordController = TextEditingController();
  final AuthController _authController = AuthController();

  // The role selected by the user at login.
  UserRole _selectedRole = UserRole.patient;

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      // Attempt sign-in via Firebase Auth.
      final user = await _authController.signIn(
        email: email,
        password: password,
      );
      if (!mounted) return;
      if (user != null) {
        // Fetch the stored user role from Firestore.
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();
        if (!userDoc.exists) {
          // If no user record exists, sign out and show an error.
          await _authController.signOut();
          _showErrorDialog("User record not found. Please contact support.");
          return;
        }
        // Get the role as a string from the document.
        final String? registeredRole = userDoc.get('role') as String?;
        if (registeredRole == null) {
          await _authController.signOut();
          _showErrorDialog("User role not found. Please contact support.");
          return;
        }
        // Check if the stored role matches the role selected during login.
        if (_selectedRole == UserRole.patient && registeredRole != "patient") {
          await _authController.signOut();
          _showErrorDialog(
            "This account is registered as a doctor and cannot be used to log in as a patient.",
          );
          return;
        } else if (_selectedRole == UserRole.doctor &&
            registeredRole != "doctor") {
          await _authController.signOut();
          _showErrorDialog(
            "This account is registered as a patient and cannot be used to log in as a doctor.",
          );
          return;
        }

        // If roles match, show a success dialog and then navigate.
        showDialog(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => AlertDialog(
                title: const Text('Login Successful'),
                content: Text('Logged in as $email'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // close the dialog
                      if (_selectedRole == UserRole.patient) {
                        Navigator.pushReplacementNamed(
                          context,
                          '/patient/home',
                        );
                      } else {
                        Navigator.pushReplacementNamed(context, '/doctor/home');
                      }
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      _showErrorDialog(e.message ?? 'An error occurred during login.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Login Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Radio<UserRole>(
                            value: UserRole.patient,
                            groupValue: _selectedRole,
                            onChanged: (UserRole? value) {
                              setState(() {
                                _selectedRole = value!;
                              });
                            },
                          ),
                          const Text('Patient'),
                          Radio<UserRole>(
                            value: UserRole.doctor,
                            groupValue: _selectedRole,
                            onChanged: (UserRole? value) {
                              setState(() {
                                _selectedRole = value!;
                              });
                            },
                          ),
                          const Text('Doctor'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter your email';
                          }
                          return null;
                        },
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
                          if (value == null || value.isEmpty) {
                            return 'Enter your password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _login();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/auth/register');
                        },
                        child: const Text("Don't have an account? Register"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
