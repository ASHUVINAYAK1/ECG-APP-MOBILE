import 'package:flutter/material.dart';

/// A simplified version of the EcgPage for testing purposes.
/// This avoids the complex initialization of the real EcgPage.
class MockEcgPage extends StatelessWidget {
  const MockEcgPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ECG Monitor'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.bluetooth_disabled, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'Using simulated ECG data',
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                color: Colors.grey.shade200,
                child: const Center(
                  child: Text('ECG Chart Placeholder'),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.green.withOpacity(0.2),
            child: const Column(
              children: [
                Text(
                  'Diagnosis:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Normal sinus rhythm',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
