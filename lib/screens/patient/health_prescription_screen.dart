// lib/screens/patient/health_prescription_screen.dart
import 'package:flutter/material.dart';

class HealthPrescriptionScreen extends StatelessWidget {
  const HealthPrescriptionScreen({super.key});

  final List<Map<String, String>> records = const [
    {
      "date": "2023-01-15",
      "prescription": "Take 2 tablets of Aspirin",
      "ecg": "Normal",
    },
    {
      "date": "2023-03-20",
      "prescription": "Blood pressure medication prescribed",
      "ecg": "Irregular",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Health & Prescription')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: records.length,
        itemBuilder: (context, index) {
          final record = records[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text('Date: ${record["date"]}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Prescription: ${record["prescription"]}'),
                  Text('ECG: ${record["ecg"]}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
