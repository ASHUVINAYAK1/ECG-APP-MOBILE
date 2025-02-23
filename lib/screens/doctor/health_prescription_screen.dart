import 'package:flutter/material.dart';
import '../../widgets/doctor_scaffold.dart';

class HealthPrescriptionScreen extends StatelessWidget {
  const HealthPrescriptionScreen({super.key});

  final List<Map<String, String>> records = const [
    {
      "patient": "John Doe",
      "date": "2023-04-10",
      "prescription": "Medication A, 2 times a day",
      "notes": "Follow up in 2 weeks",
    },
    {
      "patient": "Jane Smith",
      "date": "2023-03-22",
      "prescription": "Medication B, once a day",
      "notes": "Monitor blood pressure",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DoctorScaffold(
      title: 'Health & Records',
      currentIndex: 3,
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
        itemCount: records.length,
        itemBuilder: (context, index) {
          final record = records[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text("Patient: ${record['patient']}"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Date: ${record['date']}"),
                  Text("Prescription: ${record['prescription']}"),
                  Text("Notes: ${record['notes']}"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
