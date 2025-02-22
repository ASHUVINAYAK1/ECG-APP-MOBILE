import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final int currentIndex;
  final ValueChanged<int> onItemTapped;
  final List<BottomNavigationBarItem> bottomNavItems;
  final Widget? drawer;
  final String profileImageUrl;

  const AppScaffold({
    Key? key,
    required this.title,
    required this.child,
    required this.currentIndex,
    required this.onItemTapped,
    required this.bottomNavItems,
    this.drawer,
    this.profileImageUrl = "https://via.placeholder.com/150",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar with menu button at the left and profile picture at the right.
      appBar: AppBar(
        title: Text(title),
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(backgroundImage: NetworkImage(profileImageUrl)),
          ),
        ],
      ),
      drawer: drawer,
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black, // Dark background
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        currentIndex: currentIndex,
        onTap: onItemTapped,
        items: bottomNavItems,
      ),
    );
  }
}
