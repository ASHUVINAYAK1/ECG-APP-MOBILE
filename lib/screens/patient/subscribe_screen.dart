import 'package:flutter/material.dart';

class SubscribeScreen extends StatelessWidget {
  const SubscribeScreen({super.key});

  final List<Map<String, String>> plans = const [
    {
      "title": "Basic Plan",
      "price": "\$9.99/month",
      "description": "Access to basic features.",
    },
    {
      "title": "Premium Plan",
      "price": "\$19.99/month",
      "description": "All features unlocked.",
    },
    {
      "title": "Family Plan",
      "price": "\$29.99/month",
      "description": "Multiple user access.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Subscribe')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: plans.length,
        itemBuilder: (context, index) {
          final plan = plans[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(plan['title']!),
              subtitle: Text(plan['description']!),
              trailing: Text(plan['price']!),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Subscribed to ${plan['title']}')),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
