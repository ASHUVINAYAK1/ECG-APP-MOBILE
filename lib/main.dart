import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/patient_home.dart';
import 'screens/doctor_home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ECG App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/patient': (context) => PatientHome(),
        '/doctor': (context) => DoctorHome(),
      },
    );
  }
}
