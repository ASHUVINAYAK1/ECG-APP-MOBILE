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
  String? familyId; // if patient is part of a family
  List<String>? emergencyDoctorIds; // list of emergency contact doctor IDs

  Patient({
    required String uid,
    required String email,
    String? name,
    String? profileImageUrl,
    required UserRole role, // should be UserRole.patient
    this.phone,
    this.address,
    this.familyId,
    this.emergencyDoctorIds,
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
    });
    return baseMap;
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
    required UserRole role, // should be UserRole.doctor
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
