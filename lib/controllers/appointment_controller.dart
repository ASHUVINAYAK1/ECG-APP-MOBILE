import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/appointment_model.dart';
import '../models/slot_model.dart';

class AppointmentController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Book an appointment for a given slot.
  Future<void> bookAppointment({
    required String doctorId,
    required String patientId,
    required DateTime appointmentDateTime,
    required String notes,
    required String slotId,
  }) async {
    // First, check slot availability.
    DocumentReference slotRef = _firestore.collection('slots').doc(slotId);
    DocumentSnapshot slotDoc = await slotRef.get();

    if (!slotDoc.exists) {
      throw Exception("Slot not found.");
    }

    Slot slot = Slot.fromMap(
      slotDoc.data() as Map<String, dynamic>,
      slotDoc.id,
    );
    if (slot.bookedCount >= slot.maxPatients) {
      throw Exception("This slot is full.");
    }

    // Create appointment record.
    DocumentReference appointmentRef = await _firestore
        .collection('appointments')
        .add({
          'doctorId': doctorId,
          'patientId': patientId,
          'dateTime': appointmentDateTime,
          'notes': notes,
        });

    // Increment the slot's booked count.
    await slotRef.update({'bookedCount': FieldValue.increment(1)});
  }

  // Optionally, you can add methods to fetch available slots.
}
