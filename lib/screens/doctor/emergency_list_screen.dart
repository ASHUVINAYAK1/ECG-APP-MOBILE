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
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.blue.shade50],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Text(
                'Emergency Contacts',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Quickly access important emergency contacts',
                style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: emergencyContacts.length,
                itemBuilder: (context, index) {
                  final contact = emergencyContacts[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.local_hospital_rounded,
                                color: Colors.red.shade700,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    contact['name']!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.phone,
                                        size: 16,
                                        color: Colors.grey.shade600,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        contact['contact']!,
                                        style: TextStyle(
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.call,
                                  color: Colors.green.shade700,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
