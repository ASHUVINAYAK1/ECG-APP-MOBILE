import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../controllers/profile_controller.dart';
import '../../models/user_model.dart';

class OnboardingScreen extends StatefulWidget {
  final AppUser user;
  const OnboardingScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  final ProfileController _profileController = ProfileController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.name ?? "";
    // Optionally prefill other fields if available.
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      // Update the user's Firestore record with additional details.
      await _profileController.updateProfile(
        uid: widget.user.uid,
        name: _nameController.text.trim(),
        // Here you would also update phone, address, etc.
      );
      // After updating, navigate to the patient home screen.
      Navigator.pushReplacementNamed(context, '/patient/home');
    }
  }

  void _skip() {
    // Skip onboarding and navigate directly to home.
    Navigator.pushReplacementNamed(context, '/patient/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Complete Your Profile"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                "Welcome! Please complete your profile details.",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your name or press Skip";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Additional fields can be added here:
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: "Address",
                  border: OutlineInputBorder(),
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(onPressed: _skip, child: const Text("Skip")),
                  ElevatedButton(
                    onPressed: _submit,
                    child: const Text("Submit"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
