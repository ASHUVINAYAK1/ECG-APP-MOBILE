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

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        diagnosis = "Normal"; // This would come from your ECG/AI processing.
      });
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Navigate based on the selected index.
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
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text("Patient Name"),
              accountEmail: const Text("patient@test.com"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                  "https://via.placeholder.com/150",
                ),
              ),
              decoration: const BoxDecoration(color: Colors.blue),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () => Navigator.pushNamed(context, '/patient/profile'),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Appointments'),
              onTap: () => Navigator.pushNamed(context, '/patient/appointment'),
            ),
            ListTile(
              leading: const Icon(Icons.health_and_safety),
              title: const Text('Health & Prescription'),
              onTap: () => Navigator.pushNamed(context, '/patient/health'),
            ),
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('Chat'),
              onTap: () => Navigator.pushNamed(context, '/patient/chat'),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () => Navigator.pushNamed(context, '/patient/settings'),
            ),
            ListTile(
              leading: const Icon(Icons.family_restroom),
              title: const Text('Family'),
              onTap: () => Navigator.pushNamed(context, '/patient/family'),
            ),
          ],
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              height: 200,
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'ECG Graph Placeholder',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Diagnosis: $diagnosis',
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
