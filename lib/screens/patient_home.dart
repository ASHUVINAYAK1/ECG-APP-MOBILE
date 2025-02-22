import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

class PatientHome extends StatelessWidget {
  const PatientHome({Key? key}) : super(key: key);

  void _logout(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Patient Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome, Patient!', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            CustomButton(text: "Log Out", onPressed: () => _logout(context)),
          ],
        ),
      ),
    );
  }
}
