import 'package:flutter/material.dart';
import '../../widgets/doctor_scaffold.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController(
    text: "Dr. Smith",
  );
  final TextEditingController _qualificationsController = TextEditingController(
    text: "MBBS, MD",
  );
  final TextEditingController _documentsController = TextEditingController();
  String? _profileImageUrl;

  void _uploadImage() {
    // Dummy upload logic; replace with real image picker.
    setState(() {
      _profileImageUrl = "https://via.placeholder.com/150";
    });
  }

  @override
  Widget build(BuildContext context) {
    return DoctorScaffold(
      title: 'Doctor Profile',
      currentIndex: 1,
      onItemTapped: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/doctor/home');
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/doctor/profile');
            break;
          case 2:
            Navigator.pushReplacementNamed(context, '/doctor/emergency');
            break;
          case 3:
            Navigator.pushReplacementNamed(context, '/doctor/health');
            break;
          case 4:
            Navigator.pushReplacementNamed(context, '/doctor/chat');
            break;
          case 5:
            Navigator.pushReplacementNamed(context, '/doctor/appointment');
            break;
          case 6:
            Navigator.pushReplacementNamed(context, '/doctor/settings');
            break;
        }
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _uploadImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage:
                    _profileImageUrl != null
                        ? NetworkImage(_profileImageUrl!)
                        : null,
                child:
                    _profileImageUrl == null
                        ? const Icon(Icons.camera_alt, size: 50)
                        : null,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _qualificationsController,
              decoration: const InputDecoration(
                labelText: 'Qualifications',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _documentsController,
              decoration: const InputDecoration(
                labelText: 'Upload Documents',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Dummy save action.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile updated')),
                );
              },
              child: const Text('Save Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
