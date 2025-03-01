class Family {
  final String id;
  final String name;
  final String familyDoctorId; // the doctor assigned as family doctor
  final List<String> memberIds; // list of user ids of family members

  Family({
    required this.id,
    required this.name,
    required this.familyDoctorId,
    required this.memberIds,
  });

  factory Family.fromMap(Map<String, dynamic> data, String id) {
    return Family(
      id: id,
      name: data['name'] ?? '',
      familyDoctorId: data['familyDoctorId'] ?? '',
      memberIds:
          data['memberIds'] != null ? List<String>.from(data['memberIds']) : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'familyDoctorId': familyDoctorId,
      'memberIds': memberIds,
    };
  }
}
