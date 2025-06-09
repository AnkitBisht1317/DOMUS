class UserDetails {
  String fullName;
  String phoneNumber;
  String email;
  String gender;
  String dob;
  String country;
  String domicileState;
  String district;
  String? profilePhoto; // Added profilePhoto field with nullable type

  UserDetails({
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.gender,
    required this.dob,
    required this.country,
    required this.domicileState,
    required this.district,
    this.profilePhoto, // Optional parameter with default null value
  });
}
