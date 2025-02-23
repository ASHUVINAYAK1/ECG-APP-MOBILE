import 'package:flutter/material.dart';
import '../../widgets/doctor_scaffold.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
  }

  @override
  Widget build(BuildContext context) {
    return DoctorScaffold(
      title: 'Doctor Home',
      currentIndex: _selectedIndex,
      onItemTapped: _onItemTapped,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              height: 200,
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'Dashboard Analytics Placeholder',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Welcome, Dr. Smith!',
                style: const TextStyle(fontSize: 20),
              ),
            ),
            // Additional dashboard widgets can be added here.
          ],
        ),
      ),
    );
  }
}
