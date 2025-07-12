class DoctorModel {
  final String name;
  final String subject;
  final String qualification;
  final String experience;
  final String specialization;
  final String teachingStyle;
  final List<String> achievements;
  final String profileImage;

  DoctorModel({
    required this.name,
    required this.subject,
    required this.qualification,
    required this.experience,
    required this.specialization,
    required this.teachingStyle,
    required this.achievements,
    required this.profileImage,
  });

  factory DoctorModel.fromMap(Map<String, dynamic> map) {
    return DoctorModel(
      name: map['name'] ?? '',
      subject: map['subject'] ?? '',
      qualification: map['qualification'] ?? '',
      experience: map['experience'] ?? '',
      specialization: map['specialization'] ?? '',
      teachingStyle: map['teachingStyle'] ?? '',
      profileImage: map['profileImage'] ?? '',
      achievements: List<String>.from(map['achievements'] ?? []),
    );
  }
}
