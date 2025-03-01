enum UserRole { patient, doctor }

class AppUser {
  final String uid;
  final String email;
  String? name;
  UserRole role;
  String? profileImageUrl;
  String? familyId; // if patient is part of a family
  List<String>? emergencyDoctorIds; // if any emergency contacts are set

  AppUser({
    required this.uid,
    required this.email,
    required this.role,
    this.name,
    this.profileImageUrl,
    this.familyId,
    this.emergencyDoctorIds,
  });

  factory AppUser.fromMap(Map<String, dynamic> data, String uid) {
    return AppUser(
      uid: uid,
      email: data['email'] ?? '',
      name: data['name'],
      role: data['role'] == 'doctor' ? UserRole.doctor : UserRole.patient,
      profileImageUrl: data['profileImageUrl'],
      familyId: data['familyId'],
      emergencyDoctorIds:
          data['emergencyDoctorIds'] != null
              ? List<String>.from(data['emergencyDoctorIds'])
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'role': role.toString().split('.').last,
      'profileImageUrl': profileImageUrl,
      'familyId': familyId,
      'emergencyDoctorIds': emergencyDoctorIds,
    };
  }
}
