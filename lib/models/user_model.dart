import 'package:ecg_app/enums/user_role.dart';

/// Base class for all users.
class AppUser {
  final String uid;
  final String email;
  String? name;
  UserRole role;
  String? profileImageUrl;

  AppUser({
    required this.uid,
    required this.email,
    required this.role,
    this.name,
    this.profileImageUrl,
  });

  factory AppUser.fromMap(Map<String, dynamic> data, String uid) {
    return AppUser(
      uid: uid,
      email: data['email'] ?? '',
      name: data['name'],
      role: data['role'] == 'doctor' ? UserRole.doctor : UserRole.patient,
      profileImageUrl: data['profileImageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'role': role.toString().split('.').last,
      'profileImageUrl': profileImageUrl,
    };
  }
}

/// Patient-specific fields.
class Patient extends AppUser {
  String? phone;
  String? address;
  String? familyId; // If patient is part of a family
  List<String>? emergencyDoctorIds; // List of emergency contact doctor IDs
  List<Map<String, dynamic>>? medicalRecords; // List of medical records

  Patient({
    required String uid,
    required String email,
    String? name,
    String? profileImageUrl,
    required UserRole role, // Should be UserRole.patient
    this.phone,
    this.address,
    this.familyId,
    this.emergencyDoctorIds,
    this.medicalRecords,
  }) : super(
         uid: uid,
         email: email,
         role: role,
         name: name,
         profileImageUrl: profileImageUrl,
       );

  factory Patient.fromMap(Map<String, dynamic> data, String uid) {
    return Patient(
      uid: uid,
      email: data['email'] ?? '',
      name: data['name'],
      profileImageUrl: data['profileImageUrl'],
      role: UserRole.patient,
      phone: data['phone'],
      address: data['address'],
      familyId: data['familyId'],
      emergencyDoctorIds:
          data['emergencyDoctorIds'] != null
              ? List<String>.from(data['emergencyDoctorIds'])
              : null,
      medicalRecords:
          data['medicalRecords'] != null
              ? List<Map<String, dynamic>>.from(data['medicalRecords'])
              : [],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({
      'phone': phone,
      'address': address,
      'familyId': familyId,
      'emergencyDoctorIds': emergencyDoctorIds,
      'medicalRecords': medicalRecords,
    });
    return baseMap;
  }

  /// Adds a new medical record with a PDF URL.
  void addMedicalRecord({
    required String recordId,
    required String date,
    required String prescription,
    String? ecgResult,
    String? pdfUrl,
  }) {
    medicalRecords ??= [];

    medicalRecords!.add({
      'recordId': recordId,
      'date': date,
      'prescription': prescription,
      'ecgResult': ecgResult ?? 'Not Available',
      'pdf_url':
          pdfUrl ??
          'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', // Default PDF URL
    });
  }
}

/// Doctor-specific fields.
class Doctor extends AppUser {
  String? specialization;

  Doctor({
    required String uid,
    required String email,
    String? name,
    String? profileImageUrl,
    required UserRole role, // Should be UserRole.doctor
    this.specialization,
  }) : super(
         uid: uid,
         email: email,
         role: role,
         name: name,
         profileImageUrl: profileImageUrl,
       );

  factory Doctor.fromMap(Map<String, dynamic> data, String uid) {
    return Doctor(
      uid: uid,
      email: data['email'] ?? '',
      name: data['name'],
      profileImageUrl: data['profileImageUrl'],
      role: UserRole.doctor,
      specialization: data['specialization'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({'specialization': specialization});
    return baseMap;
  }
}
