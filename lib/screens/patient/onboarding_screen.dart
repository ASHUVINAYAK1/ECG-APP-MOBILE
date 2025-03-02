import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/profile_controller.dart';
import '../../models/user_model.dart'; // Contains Patient

class OnboardingScreen extends StatefulWidget {
  final Patient patient; // Expecting a Patient instance
  const OnboardingScreen({Key? key, required this.patient}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  File? _profileImage;
  File? _medicalRecordFile;
  final ProfileController _profileController = ProfileController();
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Pre-fill fields with existing data.
    _nameController.text = widget.patient.name ?? "";
    _phoneController.text = widget.patient.phone ?? "";
    _addressController.text = widget.patient.address ?? "";
  }

  Future<void> _pickProfileImage() async {
    final XFile? picked = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (picked != null) {
      setState(() {
        _profileImage = File(picked.path);
      });
    }
  }

  Future<void> _pickMedicalRecord() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _medicalRecordFile = File(result.files.single.path!);
      });
    }
  }

  // Dummy function to simulate file upload.
  // Replace this with actual Firebase Storage upload logic.
  Future<String> _uploadMedicalRecord(String uid, File file) async {
    await Future.delayed(const Duration(seconds: 2));
    return "https://via.placeholder.com/150/medical_record.jpg";
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      String? medicalUrl;
      if (_medicalRecordFile != null) {
        medicalUrl = await _uploadMedicalRecord(
          widget.patient.uid,
          _medicalRecordFile!,
        );
        await _profileController.updateMedicalRecord(
          uid: widget.patient.uid,
          medicalRecordUrl: medicalUrl,
        );
      }
      await _profileController.updateProfile(
        uid: widget.patient.uid,
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        profileImage: _profileImage,
      );
      Navigator.pushReplacementNamed(context, '/patient/home');
    }
  }

  void _skip() {
    Navigator.pushReplacementNamed(context, '/patient/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Complete Your Profile"),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
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
              GestureDetector(
                onTap: _pickProfileImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[200],
                  backgroundImage:
                      _profileImage != null
                          ? FileImage(_profileImage!)
                          : widget.patient.profileImageUrl != null
                          ? NetworkImage(widget.patient.profileImageUrl!)
                          : null,
                  child:
                      _profileImage == null &&
                              widget.patient.profileImageUrl == null
                          ? const Icon(
                            Icons.camera_alt,
                            size: 40,
                            color: Colors.grey,
                          )
                          : null,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        (value == null || value.isEmpty)
                            ? "Please enter your name or press Skip"
                            : null,
              ),
              const SizedBox(height: 16),
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
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _pickMedicalRecord,
                icon: const Icon(Icons.file_upload),
                label: Text(
                  _medicalRecordFile == null
                      ? "Upload Medical Record"
                      : "Medical Record Selected",
                ),
              ),
              const SizedBox(height: 16),
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
