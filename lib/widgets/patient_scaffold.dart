import 'package:flutter/material.dart';
import 'app_scaffold.dart';

class PatientScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final int currentIndex;
  final ValueChanged<int> onItemTapped;
  final String profileImageUrl;

  const PatientScaffold({
    Key? key,
    required this.title,
    required this.child,
    required this.currentIndex,
    required this.onItemTapped,
    this.profileImageUrl = "https://via.placeholder.com/150",
  }) : super(key: key);

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text("Patient Name"),
            accountEmail: const Text("patient@test.com"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(profileImageUrl),
            ),
            decoration: const BoxDecoration(color: Colors.blue),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap:
                () =>
                    Navigator.pushReplacementNamed(context, '/patient/profile'),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Appointments'),
            onTap:
                () => Navigator.pushReplacementNamed(
                  context,
                  '/patient/appointment',
                ),
          ),
          ListTile(
            leading: const Icon(Icons.health_and_safety),
            title: const Text('Health & Prescription'),
            onTap:
                () =>
                    Navigator.pushReplacementNamed(context, '/patient/health'),
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('Chat'),
            onTap:
                () => Navigator.pushReplacementNamed(context, '/patient/chat'),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap:
                () => Navigator.pushReplacementNamed(
                  context,
                  '/patient/settings',
                ),
          ),
          ListTile(
            leading: const Icon(Icons.family_restroom),
            title: const Text('Family'),
            onTap:
                () =>
                    Navigator.pushReplacementNamed(context, '/patient/family'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              // Navigate to login screen on logout.
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: title,
      child: child,
      currentIndex: currentIndex,
      onItemTapped: onItemTapped,
      profileImageUrl: profileImageUrl,
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
      drawer: _buildDrawer(context),
    );
  }
}
