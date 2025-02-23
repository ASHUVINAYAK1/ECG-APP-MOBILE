import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

// Patient Screens
import 'screens/patient/home_screen.dart' as patient;
import 'screens/patient/profile_screen.dart';
import 'screens/patient/subscribe_screen.dart';
import 'screens/patient/appointment_booking_screen.dart';
import 'screens/patient/health_prescription_screen.dart';
import 'screens/patient/chat_screen.dart';
import 'screens/patient/settings_screen.dart';
import 'screens/patient/family_screen.dart';
import 'screens/patient/not_found_screen.dart';

// Doctor Screens
import 'screens/doctor/home_screen.dart' as doctor;
import 'screens/doctor/profile_screen.dart' as doctorProfile;
import 'screens/doctor/emergency_list_screen.dart';
import 'screens/doctor/health_prescription_screen.dart' as doctorHealth;
import 'screens/doctor/chat_screen.dart' as doctorChat;
import 'screens/doctor/appointment_screen.dart' as doctorAppointment;
import 'screens/doctor/settings_screen.dart' as doctorSettings;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ECG App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginScreen(),
      routes: {
        // Patient routes
        '/patient/home': (context) => const patient.HomeScreen(),
        '/patient/profile': (context) => const ProfileScreen(),
        '/patient/subscribe': (context) => const SubscribeScreen(),
        '/patient/appointment': (context) => const AppointmentBookingScreen(),
        '/patient/health': (context) => const HealthPrescriptionScreen(),
        '/patient/chat': (context) => const ChatScreen(),
        '/patient/settings': (context) => const SettingsScreen(),
        '/patient/family': (context) => const FamilyScreen(),
        // Doctor routes
        '/doctor/home': (context) => const doctor.HomeScreen(),
        '/doctor/profile':
            (context) =>
                const doctorProfile.ProfileScreen(), // Corrected: use ProfileScreen
        '/doctor/emergency': (context) => const EmergencyListScreen(),
        '/doctor/health':
            (context) => const doctorHealth.HealthPrescriptionScreen(),
        '/doctor/chat': (context) => const doctorChat.ChatScreen(),
        '/doctor/appointment':
            (context) => const doctorAppointment.AppointmentScreen(),
        '/doctor/settings': (context) => const doctorSettings.SettingsScreen(),
      },
      onUnknownRoute:
          (settings) =>
              MaterialPageRoute(builder: (context) => const NotFoundScreen()),
    );
  }
}
