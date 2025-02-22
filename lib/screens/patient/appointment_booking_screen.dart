// lib/screens/patient/appointment_booking_screen.dart
import 'package:flutter/material.dart';

class AppointmentBookingScreen extends StatelessWidget {
  const AppointmentBookingScreen({super.key});

  final List<Map<String, String>> doctors = const [
    {"name": "Dr. Smith", "specialty": "Cardiology"},
    {"name": "Dr. Johnson", "specialty": "General Physician"},
    {"name": "Dr. Williams", "specialty": "Pediatrics"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Doctor List')),
      body: ListView.builder(
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          final doctor = doctors[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(doctor['name']!),
              subtitle: Text(doctor['specialty']!),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => AppointmentDetailScreen(doctor: doctor),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class AppointmentDetailScreen extends StatefulWidget {
  final Map<String, String> doctor;
  const AppointmentDetailScreen({super.key, required this.doctor});

  @override
  State<AppointmentDetailScreen> createState() =>
      _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final TextEditingController _notesController = TextEditingController();

  Future<void> _pickDate() async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _submitAppointment() {
    if (_formKey.currentState!.validate() &&
        _selectedDate != null &&
        _selectedTime != null) {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text('Appointment Booked'),
              content: Text(
                'Your appointment with ${widget.doctor["name"]} is confirmed for ${_selectedDate!.toLocal().toString().split(' ')[0]} at ${_selectedTime!.format(context)}.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // close dialog
                    Navigator.popUntil(
                      context,
                      ModalRoute.withName('/patient/home'),
                    );
                  },
                  child: const Text('Go to Home'),
                ),
              ],
            ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Appointment with ${widget.doctor["name"]}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(
                  _selectedDate == null
                      ? 'Select Date'
                      : _selectedDate!.toLocal().toString().split(' ')[0],
                ),
                onTap: _pickDate,
              ),
              ListTile(
                leading: const Icon(Icons.access_time),
                title: Text(
                  _selectedTime == null
                      ? 'Select Time'
                      : _selectedTime!.format(context),
                ),
                onTap: _pickTime,
              ),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter notes';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitAppointment,
                child: const Text('Book Appointment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
