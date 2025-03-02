import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../widgets/app_scaffold.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String diagnosis = "Processing...";
  String userName = "Patient";

  final String patientId =
      FirebaseAuth.instance.currentUser?.uid ?? "CURRENT_PATIENT_UID";

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('sensor_readings')
        .where('patientId', isEqualTo: patientId)
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots()
        .listen((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            final data = snapshot.docs.first.data() as Map<String, dynamic>;
            final reading = (data['readingValue'] as num?)?.toDouble() ?? 0.0;
            setState(() {
              diagnosis = reading < 1.0 ? "Normal" : "Abnormal";
            });
          }
        });
    // Load patient's name from the "patients" collection.
    FirebaseFirestore.instance.collection('patients').doc(patientId).get().then(
      (doc) {
        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          setState(() {
            userName = data['name'] ?? "Patient";
          });
        }
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/patient/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/patient/profile');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/patient/chat');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/patient/settings');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/patient/family');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Patient Home',
      currentIndex: _selectedIndex,
      onItemTapped: _onItemTapped,
      bottomNavItems: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        BottomNavigationBarItem(
          icon: Icon(Icons.family_restroom),
          label: "Family",
        ),
      ],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                userName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              accountEmail: const Text(
                "patient@test.com",
                style: TextStyle(fontSize: 14),
              ),
              currentAccountPicture: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const CircleAvatar(
                  backgroundImage: NetworkImage(
                    "https://via.placeholder.com/150",
                  ),
                ),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade700, Colors.blue.shade500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            _buildDrawerItem(
              icon: Icons.person,
              title: 'Profile',
              onTap: () => Navigator.pushNamed(context, '/patient/profile'),
            ),
            _buildDrawerItem(
              icon: Icons.calendar_today,
              title: 'Appointments',
              onTap: () => Navigator.pushNamed(context, '/patient/appointment'),
            ),
            _buildDrawerItem(
              icon: Icons.health_and_safety,
              title: 'Health & Prescription',
              onTap: () => Navigator.pushNamed(context, '/patient/health'),
            ),
            _buildDrawerItem(
              icon: Icons.chat,
              title: 'Chat',
              onTap: () => Navigator.pushNamed(context, '/patient/chat'),
            ),
            const Divider(),
            _buildDrawerItem(
              icon: Icons.settings,
              title: 'Settings',
              onTap: () => Navigator.pushNamed(context, '/patient/settings'),
            ),
            _buildDrawerItem(
              icon: Icons.family_restroom,
              title: 'Family',
              onTap: () => Navigator.pushNamed(context, '/patient/family'),
            ),
          ],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, $userName',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Last updated: ${DateTime.now().toString().substring(0, 16)}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            Container(
              height: 220,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.deepPurple.shade300,
                    Colors.deepPurple.shade100,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Opacity(
                        opacity: 0.1,
                        child: Image.network(
                          "https://via.placeholder.com/500",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'ECG Graph Placeholder',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    diagnosis == "Normal"
                        ? Colors.green.shade50
                        : Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      diagnosis == "Normal"
                          ? Colors.green.shade200
                          : Colors.orange.shade200,
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color:
                          diagnosis == "Normal"
                              ? Colors.green.shade100
                              : Colors.orange.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      diagnosis == "Normal"
                          ? Icons.check_circle
                          : Icons.access_time,
                      color:
                          diagnosis == "Normal"
                              ? Colors.green.shade700
                              : Colors.orange.shade700,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Diagnosis',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          diagnosis,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color:
                                diagnosis == "Normal"
                                    ? Colors.green.shade700
                                    : Colors.orange.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                _buildQuickActionCard(
                  context,
                  Icons.local_hospital,
                  "Medication",
                  Colors.red.shade100,
                  Colors.red.shade700,
                  () => Navigator.pushNamed(context, '/patient/health'),
                ),
                const SizedBox(width: 16),
                _buildQuickActionCard(
                  context,
                  Icons.calendar_today,
                  "Appointments",
                  Colors.blue.shade100,
                  Colors.blue.shade700,
                  () => Navigator.pushNamed(context, '/patient/appointment'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue.shade700),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context,
    IconData icon,
    String title,
    Color backgroundColor,
    Color iconColor,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, size: 32, color: iconColor),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: iconColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
