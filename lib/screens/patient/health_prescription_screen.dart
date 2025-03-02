import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HealthPrescriptionScreen extends StatelessWidget {
  const HealthPrescriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get current user UID dynamically.
    final String patientId = FirebaseAuth.instance.currentUser?.uid ?? "";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Health & Prescription'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Medical Records',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your health history and prescriptions',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('patients')
                      .doc(patientId)
                      .collection('medical_records')
                      .orderBy('date', descending: true)
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("Error loading records"));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) {
                  return const Center(child: Text("No records found"));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final Timestamp? timestamp = data['date'] as Timestamp?;
                    final DateTime recordDate =
                        timestamp?.toDate() ?? DateTime.now();
                    final String formattedDate =
                        "${recordDate.day}/${recordDate.month}/${recordDate.year}";
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.calendar_today,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      formattedDate,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Text(
                                      'Appointment Record',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Divider(height: 32),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.orange[50],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.medication,
                                    color: Colors.orange[700],
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Prescription',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        data['prescription'] ?? '',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color:
                                        data['ecg'] == "Normal"
                                            ? Colors.green[50]
                                            : Colors.red[50],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.favorite,
                                    color:
                                        data['ecg'] == "Normal"
                                            ? Colors.green[700]
                                            : Colors.red[700],
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'ECG Result',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              data['ecg'] == "Normal"
                                                  ? Colors.green[50]
                                                  : Colors.red[50],
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        child: Text(
                                          data['ecg'] ?? '',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                data['ecg'] == "Normal"
                                                    ? Colors.green[700]
                                                    : Colors.red[700],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to a new screen for adding a medical record.
          Navigator.pushNamed(context, '/patient/add_medical_record');
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
