import 'package:flutter/material.dart';
import 'app_scaffold.dart';

class DoctorScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final int currentIndex;
  final ValueChanged<int> onItemTapped;
  final String profileImageUrl;

  const DoctorScaffold({
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
            accountName: const Text("Doctor Name"),
            accountEmail: const Text("doctor@test.com"),
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
                    Navigator.pushReplacementNamed(context, '/doctor/profile'),
          ),
          ListTile(
            leading: const Icon(Icons.warning),
            title: const Text('Emergency List'),
            onTap:
                () => Navigator.pushReplacementNamed(
                  context,
                  '/doctor/emergency',
                ),
          ),
          ListTile(
            leading: const Icon(Icons.medical_services),
            title: const Text('Health & Records'),
            onTap:
                () => Navigator.pushReplacementNamed(context, '/doctor/health'),
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('Chat'),
            onTap:
                () => Navigator.pushReplacementNamed(context, '/doctor/chat'),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Appointments'),
            onTap:
                () => Navigator.pushReplacementNamed(
                  context,
                  '/doctor/appointment',
                ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap:
                () =>
                    Navigator.pushReplacementNamed(context, '/doctor/settings'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Doctor bottom nav items.
    final bottomNavItems = const [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      BottomNavigationBarItem(icon: Icon(Icons.warning), label: "Emergency"),
      BottomNavigationBarItem(
        icon: Icon(Icons.medical_services),
        label: "Records",
      ),
      BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
      BottomNavigationBarItem(
        icon: Icon(Icons.calendar_today),
        label: "Appointment",
      ),
      BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
    ];

    return AppScaffold(
      title: title,
      child: child,
      currentIndex: currentIndex,
      onItemTapped: onItemTapped,
      bottomNavItems: bottomNavItems,
      profileImageUrl: profileImageUrl,
      drawer: _buildDrawer(context),
    );
  }
}
