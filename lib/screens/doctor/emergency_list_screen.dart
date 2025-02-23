import 'package:flutter/material.dart';
import '../../widgets/doctor_scaffold.dart';

class EmergencyListScreen extends StatelessWidget {
  const EmergencyListScreen({super.key});

  final List<Map<String, String>> emergencyContacts = const [
    {"name": "Family A", "contact": "1234567890"},
    {"name": "Family B", "contact": "0987654321"},
    {"name": "Family C", "contact": "5555555555"},
  ];

  @override
  Widget build(BuildContext context) {
    return DoctorScaffold(
      title: 'Emergency List',
      currentIndex: 2,
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
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: emergencyContacts.length,
        itemBuilder: (context, index) {
          final contact = emergencyContacts[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.warning, color: Colors.red),
              title: Text(contact['name']!),
              subtitle: Text("Contact: ${contact['contact']}"),
            ),
          );
        },
      ),
    );
  }
}
