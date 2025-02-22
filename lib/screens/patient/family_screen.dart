// lib/screens/patient/family_screen.dart
import 'package:flutter/material.dart';

class FamilyScreen extends StatefulWidget {
  const FamilyScreen({super.key});

  @override
  State<FamilyScreen> createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  final List<String> _familyMembers = ["Alice", "Bob", "Charlie"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Family')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Family Doctor:", style: TextStyle(fontSize: 18)),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Choose Family Doctor tapped'),
                      ),
                    );
                  },
                  child: const Text('Choose'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text("Family Members:", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _familyMembers.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(_familyMembers[index]),
                  );
                },
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Add Family Member tapped')),
                  );
                },
                child: const Text('Add Family Member'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
