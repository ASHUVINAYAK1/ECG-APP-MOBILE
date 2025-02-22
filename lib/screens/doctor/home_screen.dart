import 'package:flutter/material.dart';
import '../../widgets/app_scaffold.dart';

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
    // For now, use dummy navigation; add routes as needed.
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/doctor/home');
        break;
      // Add additional cases for doctor-specific routes.
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Doctor Home',
      currentIndex: _selectedIndex,
      onItemTapped: _onItemTapped,
      bottomNavItems: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: "Appointments",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
      ],
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Doctor Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {},
            ),
            // Add more doctor-specific menu items here.
          ],
        ),
      ),
      child: Center(
        child: const Text(
          'This is the Doctor Home Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
