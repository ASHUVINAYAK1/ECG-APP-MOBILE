import 'package:flutter/material.dart';
import '../../widgets/doctor_scaffold.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DoctorScaffold(
      title: 'Doctor Settings',
      currentIndex: 6,
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
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Change Password'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Change Password tapped')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications tapped')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacy'),
            onTap: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Privacy tapped')));
            },
          ),
          // Add more settings options as needed.
        ],
      ),
    );
  }
}
