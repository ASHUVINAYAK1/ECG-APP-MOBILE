import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecg_app/screens/patient/pdf_viewer_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'pdf_viewer_screen.dart'; // Import the new PDF viewer screen

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
          _buildHeader(context),
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
                    return _buildPdfCard(context, data);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/patient/add_medical_record');
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
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
            'View your uploaded prescriptions',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPdfCard(BuildContext context, Map<String, dynamic> data) {
    final Timestamp? timestamp = data['date'] as Timestamp?;
    final DateTime recordDate = timestamp?.toDate() ?? DateTime.now();
    final String formattedDate =
        "${recordDate.day}/${recordDate.month}/${recordDate.year}";

    final String? pdfUrl = data['pdf_url']; // Get the PDF URL

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRecordHeader(context, formattedDate),
            const Divider(height: 32),

            // ✅ Show buttons only if pdf_url exists
            pdfUrl != null && pdfUrl.isNotEmpty
                ? _buildPdfButtons(context, pdfUrl)
                : Column(
                  children: [
                    const Text(
                      'No PDF available',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("No PDF uploaded for this record."),
                          ),
                        );
                      },
                      icon: const Icon(Icons.error, color: Colors.white),
                      label: const Text("No PDF"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordHeader(BuildContext context, String date) {
    return Row(
      children: [
        _buildIconContainer(
          context,
          icon: Icons.picture_as_pdf,
          backgroundColor: Theme.of(
            context,
          ).colorScheme.primary.withOpacity(0.1),
          iconColor: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              date,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Uploaded Prescription',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPdfButtons(BuildContext context, String pdfUrl) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () => _openPdf(pdfUrl),
          icon: const Icon(Icons.open_in_new, color: Colors.white),
          label: const Text('Open in Browser'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PdfViewerScreen(pdfUrl: pdfUrl),
              ),
            );
          },
          icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
          label: const Text('View in App'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openPdf(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }
}

Widget _buildIconContainer(
  BuildContext context, {
  required IconData icon,
  Color? backgroundColor,
  Color? iconColor,
}) {
  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: backgroundColor ?? Colors.grey[200],
      borderRadius: BorderRadius.circular(12),
    ),
    child: Icon(icon, color: iconColor ?? Colors.grey, size: 20),
  );
}

Future<void> _openPdf(String url) async {
  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $url';
  }
}
